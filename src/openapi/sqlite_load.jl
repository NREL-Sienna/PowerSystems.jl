# Hand-written (not generated): the loaders that carry document association rows into IS's
# two SQLite association stores (`IS.SupplementalAttributeAssociations`,
# `IS.TimeSeriesMetadataStore`). The document and IS's stores are the same shape except for
# id vs UUID, so this is the id⇄UUID bridge.
#
# WIRED into `from_openapi(::Type{System}, doc)` in `src/openapi/import_document.jl`, which
# calls `load_supplemental_attribute_associations!` and `load_time_series_associations!`
# (both this file) directly.
#
# Reuses, rather than duplicates, import_document.jl's per-type attribute conversion
# (the 2-arg `from_openapi(po, refs)` methods), group-index attach dispatch
# (`_attach_attribute!`), and
# service-membership dispatch (`_attach_service_membership!`), plus the time-series row
# dispatcher (`_resolve_time_series_type`/`_attach_time_series_row!`, which now covers every
# time-series type) and `has_ref`/`OpenAPIRefs` from `refs.jl`. These are module-private
# helpers, but this file is `include`d into the same `PowerSystems` module, so calling them
# is not an edit to the files that define them.

"""
Whether `owner` is a `Component` or a `SupplementalAttribute` — the two legal values of a
`TimeSeriesAssociation`'s `owner_category` — as a dispatch rather than an `isa` check, so
[`_check_owner_category_matches`](@ref) reads the answer off the resolved object instead of
trusting the document's string in isolation.
"""
_owner_category(::Component) = "Component"
_owner_category(::SupplementalAttribute) = "SupplementalAttribute"

"""Loud error naming `owner_id` when the document's declared `owner_category` is absent or
does not match what `owner_id` actually resolved to."""
function _check_owner_category_matches(owner, declared_category, owner_id)
    isnothing(declared_category) && error(
        "load_time_series_associations!: time series association referencing " *
        "owner_id=$owner_id has no owner_category",
    )
    actual = _owner_category(owner)
    declared_category == actual || error(
        "load_time_series_associations!: owner_id=$owner_id declares owner_category=" *
        "\"$declared_category\" but resolved to a $actual",
    )
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
function _group_index_by_pair(doc::PC.SystemDocument)
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
"""
function load_supplemental_attribute_associations!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PC.SystemDocument,
)
    attribute_rows = Dict{Int, Any}(
        Int(getproperty(attr, :id)) => attr for attr in doc.supplemental_attributes
    )
    converted = Dict{Int, SupplementalAttribute}()
    group_index_by_pair = _group_index_by_pair(doc)
    for assoc in doc.supplemental_attribute_associations
        attribute_id = Int(assoc.attribute_id)
        entity_id = Int(assoc.entity_id)
        has_ref(refs, entity_id) || error(
            "load_supplemental_attribute_associations!: association references " *
            "unresolved entity_id=$entity_id (attribute_id=$attribute_id)",
        )
        haskey(attribute_rows, attribute_id) || error(
            "load_supplemental_attribute_associations!: association references " *
            "unresolved attribute_id=$attribute_id (entity_id=$entity_id)",
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

"""
$(TYPEDSIGNATURES)

Attach every row of `doc.time_series_associations` into `sys`, going through
[`add_time_series!`](@ref) rather than the raw `time_series_associations` SQLite table, so
the manager's own duplicate-detection and owner-existence checks stay in force.

`owner_category` legally names either a `Component` or a `SupplementalAttribute` (both share
the document's one id counter, so resolving `owner_id` through `refs` is a single lookup
regardless of which). A `SupplementalAttribute` owner resolves only once
[`load_supplemental_attribute_associations!`](@ref) has registered it under its id — call
that function first for a document carrying both kinds of association.

A series referenced by more than one owner row is read off `time_series_storage_path` once,
via [`_materialize_time_series!`](@ref)'s `Base.UUID`-keyed cache, rather than once per row —
every owner row still gets its own attach call.

Requires `time_series_storage_path` whenever the document declares any association — no
silent loss of the document's time series. Errors, naming the association or id, on: an
unresolved `owner_id`, a declared `owner_category` absent or mismatched with what `owner_id`
actually resolved to, an unmapped `time_series_type` or `scaling_factor_multiplier` (from
the reused `_resolve_time_series_type`/`_attach_time_series_row!`), or associations present
with no storage path given.
"""
function load_time_series_associations!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PC.SystemDocument,
    time_series_storage_path,
)
    rows = doc.time_series_associations
    isempty(rows) && return nothing
    isnothing(time_series_storage_path) && error(
        "load_time_series_associations!: document declares $(length(rows)) " *
        "time_series_associations row(s) but no time_series_storage_path was given",
    )
    storage = IS.Hdf5TimeSeriesStorage(false; filename = String(time_series_storage_path))
    # Shared across every row in this call: a series referenced by N owner rows is read off
    # `storage` once via `_materialize_time_series!`, not N times.
    materialized = Dict{Base.UUID, TimeSeriesData}()
    for assoc in rows
        owner_id = Int(assoc.owner_id)
        has_ref(refs, owner_id) || error(
            "load_time_series_associations!: association \"$(assoc.name)\" references " *
            "unresolved owner_id=$owner_id",
        )
        owner = refs[owner_id]
        _check_owner_category_matches(owner, assoc.owner_category, owner_id)
        _attach_time_series_row!(
            _resolve_time_series_type(assoc),
            sys,
            materialized,
            storage,
            owner,
            assoc,
        )
    end
    return nothing
end
