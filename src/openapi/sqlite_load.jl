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
#
# Mode-independent by construction: D1 unified the component/supplemental-attribute id
# stream in IS, so an attribute's document id is its IS id exactly like a component's, and
# `_attach_attribute!` (import_document.jl) decides per row, by probing the store, whether
# the association already exists (an adopted sidecar from `to_openapi`/`to_file` carries it)
# or must be written fresh (a hand-built document with no sidecar). There is no read-only
# replay path any more: a read-only store is never asked to write in the first place, since
# every row it holds after `to_openapi` was already there before import opened it.

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
$(TYPEDSIGNATURES)

Attach every row of `doc.supplemental_attribute_associations` and `doc.service_associations`
into `sys`.

One PSY attribute object per `attribute_id`, memoized in `converted`: the first time an
`attribute_id` is seen, its document id is set onto the built object with `IS.set_id!`
before it is ever attached — mirroring how a component is set to its document id before
`add_component!` in `import_document.jl`, and safe under D1's unified id stream, which
guarantees an attribute's document id can never collide with a component's. The object is
then registered into `refs` under that id, so [`resolve_uuid`](@ref)/`refs[id]` covers
supplemental attributes exactly the way it already covers components from the
dependency-ordered component pass.

Every attach goes through [`_attach_attribute!`](@ref) (`import_document.jl`), which decides
per row whether the association needs writing; see that function for the mode-independent
mechanics. A plant-family attribute's group number for a given entity comes from the
matching `plant_associations`/`combined_cycle_associations` row (there always is one — see
[`_group_index_by_pair`](@ref)); every other attribute passes `nothing`.

Errors, naming the id, when: an association's `entity_id`/`attribute_id`/`service_id` does
not resolve, or an attribute's `attribute_type` is absent or does not match what the id
actually resolved to. No silent skip.
"""
function load_supplemental_attribute_associations!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PD.SystemDocument,
)
    attribute_rows = Dict{Int, Any}(
        Int(getproperty(attr, :id)) => attr for attr in doc.supplemental_attributes
    )
    converted = Dict{Int, SupplementalAttribute}()
    group_index_by_pair = _group_index_by_pair(doc)
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
            IS.set_id!(built, attribute_id)
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
