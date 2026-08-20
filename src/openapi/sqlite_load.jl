# Hand-written (not generated): the loader that carries the document's supplemental
# attribute, plant, combined-cycle, and service association rows into IS.
#
# WIRED into `from_openapi(::Type{System}, doc)` in `src/openapi/import_document.jl`, which
# calls `load_supplemental_attribute_associations!` directly. Time series are not loaded
# here — the sidecar store is adopted whole; see the time series note in import_document.jl.
#
# Reuses, rather than duplicates, import_document.jl's per-type attribute conversion
# (the 2-arg `from_openapi(po, refs)` methods), group-index attach dispatch
# (`_attach_attribute!`), service-membership dispatch (`_attach_service_membership!`), and
# `has_ref`/`OpenAPIRefs` from `refs.jl`. These are module-private helpers, but this file is
# `include`d into the same `PowerSystems` module, so calling them is not an edit to the files
# that define them.

"""
Per-`(component id, attribute type)` FIFO of the raw attribute ids already recorded in `sys`'s
adopted store.

Only meaningful for a read-only import: the adopted store keeps every association row the
exporting `System` wrote, keyed by that system's own attribute ids — ids the document does
NOT carry. A component's document id is its own store id by construction, but an attribute's
document id is assigned fresh from the document's shared counter (see
`_export_supplemental_attributes` in export_document.jl), so it cannot be read off the
document; it has to be recovered from the store the document's sidecar actually adopted. One
list per `(component_id, attribute_type)` because that is the closest the store rows come to
a stable key without the document's own id — a component normally carries at most one
attribute of a given type, so the FIFO is a singleton list in the common case, and only a
plant-family attribute shared by several components explains a key answering more than once.
"""
function _stale_association_id_queues(sys::System)
    queues = Dict{Tuple{Int, String}, Vector{Int}}()
    for row in IS.list_supplemental_attribute_association_rows(sys.data)
        key = (Int(row.component_id), row.attribute_type)
        push!(get!(() -> Int[], queues, key), Int(row.attribute_id))
    end
    for ids in values(queues)
        sort!(ids)
    end
    return queues
end

"""Pop the next raw attribute id the adopted store recorded for `component_id`/
`attribute_type`. Errors, naming both the component and the document's own `attribute_id`,
when the store has no such row left — a document association with nothing behind it in the
sidecar is a corrupt bundle, not something to paper over."""
function _next_stale_attribute_id!(
    queues::Dict{Tuple{Int, String}, Vector{Int}},
    component_id::Int,
    attribute_type::AbstractString,
    doc_attribute_id::Int,
)
    queue = get(queues, (component_id, String(attribute_type)), nothing)
    (isnothing(queue) || isempty(queue)) && error(
        "load_supplemental_attribute_associations!: read-only import found no adopted " *
        "store row for component_id=$component_id attribute_type=\"$attribute_type\" " *
        "(document attribute_id=$doc_attribute_id) — the sidecar does not match its " *
        "document",
    )
    return popfirst!(queue)
end

# ── read-only group-index dispatch ───────────────────────────────────────────────
# The group-index side effect (recording a component's shaft/penstock/PCC/HRSG/exclusion
# number on the shared plant-family attribute) has to happen in read-only mode exactly as it
# does in the writable one — but every `add_supplemental_attribute!` overload in
# plant_attribute.jl ends in `IS.add_supplemental_attribute!`, which would try, and fail, to
# write an association row into the read-only store. These mirror only the group-map half of
# those overloads; duplicated rather than reused for that reason. `PowerSystems`-internal
# private helpers (`_push_to_group_map!`) are reused unqualified since this file is
# `include`d into the same module that defines them.

"""No group index: the plain attribute path needs no map update."""
_push_group_index_readonly!(component, attribute, ::Nothing) = nothing

function _push_group_index_readonly!(
    component,
    attribute::ThermalPowerPlant,
    group_index::Integer,
)
    _push_to_group_map!(attribute.shaft_map, IS.get_id(component), Int(group_index))
    return nothing
end
function _push_group_index_readonly!(
    component,
    attribute::HydroPowerPlant,
    group_index::Integer,
)
    _push_to_group_map!(attribute.penstock_map, IS.get_id(component), Int(group_index))
    return nothing
end
function _push_group_index_readonly!(
    component,
    attribute::RenewablePowerPlant,
    group_index::Integer,
)
    _push_to_group_map!(attribute.pcc_map, IS.get_id(component), Int(group_index))
    return nothing
end
function _push_group_index_readonly!(
    component::ThermalGen,
    attribute::CombinedCycleBlock,
    group_index::Integer,
)
    uuid = IS.get_id(component)
    prime_mover = get_prime_mover_type(component)
    if prime_mover === PrimeMovers.CT
        _push_to_group_map!(attribute.hrsg_ct_map, uuid, Int(group_index))
    elseif prime_mover === PrimeMovers.CA
        _push_to_group_map!(attribute.hrsg_ca_map, uuid, Int(group_index))
    else
        error(
            "load_supplemental_attribute_associations!: CombinedCycleBlock read-only " *
            "replay found prime mover $prime_mover on $(get_name(component)) — only CT " *
            "and CA are valid",
        )
    end
    return nothing
end
function _push_group_index_readonly!(
    component,
    attribute::CombinedCycleFractional,
    group_index::Integer,
)
    _push_to_group_map!(
        attribute.operation_exclusion_map, IS.get_id(component), Int(group_index),
    )
    return nothing
end
function _push_group_index_readonly!(::Any, attribute, group_index::Integer)
    error(
        "load_supplemental_attribute_associations!: $(nameof(typeof(attribute))) carries " *
        "group_index=$group_index but has no read-only group-index dispatch — only " *
        "ThermalPowerPlant, HydroPowerPlant, RenewablePowerPlant, CombinedCycleBlock, " *
        "and CombinedCycleFractional accept one",
    )
end

"""
Read-only counterpart of the main replay loop in
[`load_supplemental_attribute_associations!`](@ref): builds and attaches each attribute
exactly as the writable path does, but never writes an association row, since a read-only
store cannot accept one and the adopted store already holds every row this document
describes (see the read-only note on [`_system_with_sidecar`](@ref) in import_document.jl).

Attaches into the manager via `IS._attach_attribute!` — the internal
`IS.add_supplemental_attribute!` itself calls before writing the association row — rather
than through `add_supplemental_attribute!`, whose only path to the object graph runs through
that write. This is a deliberate, narrow reach into an IS-internal: no public IS surface
exists today for "attach this object without recording its association," and adding one is
an IS-side change out of scope here.

Each row's true store id is recovered via [`_stale_association_id_queues`](@ref)/
[`_next_stale_attribute_id!`](@ref) rather than assumed, since only a component's document id
is guaranteed to equal its store id — an attribute's is not (see that function's docstring).
The first row seen for a given document `attribute_id` fixes the id the built object is given
(`IS.set_id!`); every later row sharing that `attribute_id` (a plant-family attribute spanning
several components) must resolve to the SAME id, or the store disagrees with itself about
what this document describes, which errors loudly rather than silently keeping one guess.
"""
function _replay_supplemental_attribute_associations_readonly!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PD.SystemDocument,
    attribute_rows::Dict{Int, Any},
    converted::Dict{Int, SupplementalAttribute},
    group_index_by_pair::Dict{Tuple{Int, Int}, Int},
)
    mgr = sys.data.supplemental_attribute_manager
    stale_queues = _stale_association_id_queues(sys)
    established_ids = Dict{Int, Int}()
    for assoc in doc.supplemental_attribute_associations
        attribute_id = Int(assoc.attribute_id)
        entity_id = Int(assoc.component_id)
        has_ref(refs, entity_id) || error(
            "load_supplemental_attribute_associations!: association references " *
            "unresolved component_id=$entity_id (attribute_id=$attribute_id)",
        )
        haskey(attribute_rows, attribute_id) || error(
            "load_supplemental_attribute_associations!: association references " *
            "unresolved attribute_id=$attribute_id (component_id=$entity_id)",
        )
        real_id = _next_stale_attribute_id!(
            stale_queues, entity_id, assoc.attribute_type, attribute_id,
        )
        if haskey(established_ids, attribute_id)
            established_ids[attribute_id] == real_id || error(
                "load_supplemental_attribute_associations!: attribute_id=$attribute_id " *
                "resolved to store id $real_id for component_id=$entity_id, but store id " *
                "$(established_ids[attribute_id]) for an earlier entity of this same " *
                "attribute — the adopted store does not agree with itself",
            )
        else
            established_ids[attribute_id] = real_id
        end
        attribute = get!(converted, attribute_id) do
            built = from_openapi(attribute_rows[attribute_id], refs)
            _check_resolved_type_matches(built, assoc.attribute_type, attribute_id)
            IS.set_id!(built, real_id)
            refs[attribute_id] = built
            return built
        end
        IS._attach_attribute!(mgr, attribute)
        IS.set_shared_system_references!(
            attribute,
            IS.SharedSystemReferences(;
                supplemental_attribute_manager = mgr,
                time_series_manager = sys.data.time_series_manager,
            ),
        )
        group_index = get(group_index_by_pair, (attribute_id, entity_id), nothing)
        _push_group_index_readonly!(refs[entity_id], attribute, group_index)
    end
    return nothing
end

"""Loud error naming `id` when the document's declared `attribute_type` is absent or does
not match `nameof(typeof(resolved))`."""
function _check_resolved_type_matches(resolved, declared_type, id)
    isnothing(declared_type) && error(
        "load_supplemental_attribute_associations!: association referencing id=$id has " *
        "no attribute_type",
    )
    actual = string(nameof(typeof(resolved)))
    declared_type == actual || error(
        "load_supplemental_attribute_associations!: id=$id declares attribute_type=" *
        "\"$declared_type\" but resolved to a $actual",
    )
    return nothing
end

"""
Every group index a (plant_id, entity_id) pair carries, from `doc.plant_associations` and
`doc.combined_cycle_associations` (whose `hrsg_index` fills the same role). The two tables
never name the same pair — a plant is either a `PlantAssociation`-shaped plant or a
`CombinedCycleBlock`, never both — so one merged map is unambiguous.
"""
function _group_index_by_pair(doc::PD.SystemDocument)
    indices = Dict{Tuple{Int, Int}, Int}(
        (Int(a.plant_id), Int(a.entity_id)) => Int(a.group_index) for
        a in doc.plant_associations
    )
    for a in doc.combined_cycle_associations
        key = (Int(a.plant_id), Int(a.entity_id))
        haskey(indices, key) && error(
            "load_supplemental_attribute_associations!: plant_id=$(key[1]) " *
            "entity_id=$(key[2]) appears in both plant_associations and " *
            "combined_cycle_associations",
        )
        indices[key] = Int(a.hrsg_index)
    end
    return indices
end

"""
$(TYPEDSIGNATURES)

Attach every row of `doc.supplemental_attribute_associations` and `doc.service_associations`
into `sys`, going through [`add_supplemental_attribute!`](@ref)/[`add_service!`](@ref) rather
than the raw SQLite tables — that API already de-duplicates the association and derives
`component_type` from the component's own type, so this function does no SQL of its own.

One PSY attribute object per `attribute_id`: a `attribute_id` shared by several rows
is converted once, memoized, and attached to every entity that references it — never
copied per row. A plant-family attribute's group number for a given entity comes from the
matching `plant_associations`/`combined_cycle_associations` row (there always is one — see
[`_group_index_by_pair`](@ref)); every other attribute passes `nothing`.

Extends the id→UUID resolution map: the first time an `attribute_id` is converted, the new
object is registered into `refs` under that id (`refs[attribute_id] = attribute`), so
[`resolve_uuid`](@ref)/`refs[id]` covers supplemental attributes exactly the way it already
covers components from the dependency-ordered component pass.

Errors, naming the id, when: an association's `entity_id`/`attribute_id`/`service_id` does
not resolve, or an attribute's `attribute_type` is absent or does not match what the id
actually resolved to. No silent skip.

`read_only` selects which half writes: `false` runs the batch-and-attach path above through
`add_supplemental_attribute!`/`IS.begin_association_batch`, same as always. `true` means `sys`
adopted its sidecar store read-only (see `_system_with_sidecar` in import_document.jl, which
also could not clear the exporting system's stale association rows for the same reason), so
this instead runs [`_replay_supplemental_attribute_associations_readonly!`](@ref), which
attaches every attribute and its group-index side effects without writing any association
row — the adopted store already has one for each row this document describes.
"""
function load_supplemental_attribute_associations!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PD.SystemDocument,
    read_only::Bool,
)
    attribute_rows = Dict{Int, Any}(
        Int(getproperty(attr, :id)) => attr for attr in doc.supplemental_attributes
    )
    converted = Dict{Int, SupplementalAttribute}()
    group_index_by_pair = _group_index_by_pair(doc)
    if read_only
        _replay_supplemental_attribute_associations_readonly!(
            sys, refs, doc, attribute_rows, converted, group_index_by_pair,
        )
    else
        # One store write for the whole table instead of two round trips per row (a
        # `has_association` probe plus the insert). The probe still answers correctly inside
        # the batch, so a document naming the same pair twice is still rejected by name here
        # rather than by the store at flush; the per-attribute dispatch below is untouched.
        IS.begin_association_batch(sys.data) do
            for assoc in doc.supplemental_attribute_associations
                attribute_id = Int(assoc.attribute_id)
                entity_id = Int(assoc.component_id)
                has_ref(refs, entity_id) || error(
                    "load_supplemental_attribute_associations!: association references " *
                    "unresolved component_id=$entity_id (attribute_id=$attribute_id)",
                )
                haskey(attribute_rows, attribute_id) || error(
                    "load_supplemental_attribute_associations!: association references " *
                    "unresolved attribute_id=$attribute_id (component_id=$entity_id)",
                )
                attribute = get!(converted, attribute_id) do
                    built = from_openapi(attribute_rows[attribute_id], refs)
                    _check_resolved_type_matches(built, assoc.attribute_type, attribute_id)
                    refs[attribute_id] = built
                    return built
                end
                group_index = get(group_index_by_pair, (attribute_id, entity_id), nothing)
                _attach_attribute!(sys, refs[entity_id], attribute, group_index)
            end
        end
    end
    for assoc in doc.service_associations
        service_id = Int(assoc.service_id)
        entity_id = Int(assoc.entity_id)
        has_ref(refs, service_id) || error(
            "load_supplemental_attribute_associations!: service_associations row " *
            "references unresolved service_id=$service_id (entity_id=$entity_id)",
        )
        has_ref(refs, entity_id) || error(
            "load_supplemental_attribute_associations!: service_associations row " *
            "references unresolved entity_id=$entity_id (service_id=$service_id)",
        )
        _attach_service_membership!(refs[entity_id], refs[service_id], sys)
    end
    return nothing
end
