# Hand-written (not generated): the document-level OpenAPI export path. Mirrors
# src/openapi/import_document.jl's structure in reverse: same `DOCUMENT_PLAN` type enumeration,
# same supplemental-attribute / service-membership / time-series machinery, inverted.
#
# Export (`to_openapi(sys; ...)`) assembles a `PowerCoreOpenAPIModels.SystemDocument`. Writing
# it to disk is `write_document`'s job, driven by `to_file` in src/openapi/file_io.jl.

# ── Supplemental attribute reverse converters ───────────────────────────────────
# Dispatches on the PSY attribute's concrete type rather than a runtime string → function
# table: export already knows the type. Only the emitted `attribute_type` string, read by
# `add_supplemental_attribute!` on the way back in, is derived from it.

const POLLUTANT_TYPE_TO_STRING = Dict(v => k for (k, v) in POLLUTANT_TYPE_FROM_STRING)
const EMISSION_BASIS_TO_STRING = Dict(v => k for (k, v) in EMISSION_BASIS_FROM_STRING)
const MASS_UNIT_TO_STRING = Dict(v => k for (k, v) in MASS_UNIT_FROM_STRING)
const ENERGY_UNIT_TO_STRING = Dict(v => k for (k, v) in ENERGY_UNIT_FROM_STRING)
const COMBINED_CYCLE_CONFIGURATION_TO_STRING =
    Dict(v => k for (k, v) in COMBINED_CYCLE_CONFIGURATION_FROM_STRING)

"""Resolve monitored-component UUIDs (an `Outage`'s own storage) back to document ids via
`uuid_to_component` (built once per export from every already-registered component) plus
`component_id(refs, ...)`. Empty means no association and reverses to `nothing`, the inverse of
`_monitored_component_uuids`'s own `nothing` -> empty-vector default."""
function _monitored_component_ids(
    refs::OpenAPIRefs,
    uuid_to_component::AbstractDict,
    uuids,
)
    if isempty(uuids)
        return nothing
    end
    return Int[component_id(refs, uuid_to_component[u]) for u in uuids]
end

function to_openapi(attr::EmissionsData, id::Int)
    return PO.EmissionsData(;
        id = id,
        name = get_name(attr),
        pollutant = POLLUTANT_TYPE_TO_STRING[get_pollutant(attr)],
        emission_rate = PC.ValueCurve(convert_cost_to_openapi(get_emission_rate(attr))),
        basis = EMISSION_BASIS_TO_STRING[get_basis(attr)],
        start_up_adder = get_start_up_adder(attr),
        mass_unit = MASS_UNIT_TO_STRING[get_mass_unit(attr)],
        energy_unit = ENERGY_UNIT_TO_STRING[get_energy_unit(attr)],
        gwp = get_gwp(attr),
        available = get_available(attr),
    )
end

function to_openapi(
    outage::GeometricDistributionForcedOutage,
    refs::OpenAPIRefs,
    uuid_to_component::AbstractDict,
    id::Int,
)
    return PO.GeometricDistributionForcedOutage(;
        id = id,
        mean_time_to_recovery = Int(round(get_mean_time_to_recovery(outage))),
        outage_transition_probability = get_outage_transition_probability(outage),
        monitored_components = _monitored_component_ids(
            refs, uuid_to_component, get_monitored_components(outage),
        ),
    )
end

function to_openapi(
    outage::PlannedOutage,
    refs::OpenAPIRefs,
    uuid_to_component::AbstractDict,
    id::Int,
)
    return PO.PlannedOutage(;
        id = id,
        outage_schedule = get_outage_schedule(outage),
        monitored_components = _monitored_component_ids(
            refs, uuid_to_component, get_monitored_components(outage),
        ),
    )
end

function to_openapi(
    outage::FixedForcedOutage,
    refs::OpenAPIRefs,
    uuid_to_component::AbstractDict,
    id::Int,
)
    return PO.FixedForcedOutage(;
        id = id,
        outage_status = get_outage_status(outage),
        monitored_components = _monitored_component_ids(
            refs, uuid_to_component, get_monitored_components(outage),
        ),
    )
end

to_openapi(plant::ThermalPowerPlant, id::Int) =
    PO.ThermalPowerPlant(; id = id, name = get_name(plant))
to_openapi(plant::HydroPowerPlant, id::Int) =
    PO.HydroPowerPlant(; id = id, name = get_name(plant))
to_openapi(plant::RenewablePowerPlant, id::Int) =
    PO.RenewablePowerPlant(; id = id, name = get_name(plant))

function to_openapi(block::CombinedCycleBlock, id::Int)
    return PO.CombinedCycleBlock(;
        id = id,
        name = get_name(block),
        configuration = COMBINED_CYCLE_CONFIGURATION_TO_STRING[get_configuration(block)],
        heat_recovery_to_steam_factor = get_heat_recovery_to_steam_factor(block),
    )
end

function to_openapi(frac::CombinedCycleFractional, id::Int)
    return PO.CombinedCycleFractional(;
        id = id,
        name = get_name(frac),
        configuration = COMBINED_CYCLE_CONFIGURATION_TO_STRING[get_configuration(frac)],
    )
end

to_openapi(geo::GeographicInfo, id::Int) =
    PC.GeographicInfo(; id = id, geo_json = get_geo_json(geo))

const WINDINGCATEGORY_TO_STRING = Dict(v => k for (k, v) in WINDINGCATEGORY_FROM_STRING)
const IMPEDANCECORRECTIONTRANSFORMERCONTROLMODE_TO_STRING =
    Dict(v => k for (k, v) in IMPEDANCECORRECTIONTRANSFORMERCONTROLMODE_FROM_STRING)

function to_openapi(attr::ImpedanceCorrectionData, id::Int)
    return PO.ImpedanceCorrectionData(;
        id = id,
        table_number = get_table_number(attr),
        impedance_correction_curve = convert_cost_to_openapi(
            get_impedance_correction_curve(attr),
        ),
        transformer_winding = WINDINGCATEGORY_TO_STRING[get_transformer_winding(attr)],
        transformer_control_mode = IMPEDANCECORRECTIONTRANSFORMERCONTROLMODE_TO_STRING[get_transformer_control_mode(
            attr,
        )],
    )
end

"""Dispatch helper: the three `Outage` subtypes need `refs`/`uuid_to_component` to resolve
`monitored_components`; every other supplemental attribute type does not. Absorbs that arity
split here (mirroring `_attribute_from_openapi` on import) so the walk below can call one
signature uniformly."""
_to_openapi_attribute(attr, ::OpenAPIRefs, ::AbstractDict, id::Int) = to_openapi(attr, id)
_to_openapi_attribute(
    attr::Union{GeometricDistributionForcedOutage, PlannedOutage, FixedForcedOutage},
    refs::OpenAPIRefs,
    uuid_to_component::AbstractDict,
    id::Int,
) = to_openapi(attr, refs, uuid_to_component, id)

# ── component `ext` ──────────────────────────────────────────────────────────────
# Written through to `doc.ext[component_id]` verbatim, the reverse of `_merge_doc_ext!` in
# import_document.jl. `ext` is producer-side passthrough: PowerSystems stores it and never
# reads it, so it is neither validated nor mapped onto fields in either direction.
#
# `Arc`/`TransformerCircuit`/`TransmissionInterface` carry no `ext` field at all — nothing to
# write, so those overloads are no-ops rather than an error about a missing getter.

_export_ext!(::PC.SystemDocument, ::Int, ::Arc) = nothing
_export_ext!(::PC.SystemDocument, ::Int, ::TransformerCircuit) = nothing
_export_ext!(::PC.SystemDocument, ::Int, ::TransmissionInterface) = nothing

function _export_ext!(doc::PC.SystemDocument, id::Int, component)
    PC.set_ext!(doc, id, get_ext(component))
    return nothing
end

# ── unexportable components ─────────────────────────────────────────────────────

"""
Warn, naming each type and how many of it, when `sys` holds components no converter covers.

Those components are omitted from the document. This is accepted for now since dynamics is
deferred, so no dynamic type has a converter and a dynamics-bearing system cannot round-trip
through a document — but it is reported on every export rather than left silent, so a consumer
of the document knows what is not in it.

Warns rather than errors: blocking would make the document unusable as a cache format for
systems that carry dynamics, and dynamics is not going to production on this line yet. When a
converter is added to [`DOCUMENT_PLAN`](@ref), its type drops out of this warning automatically.
"""
function warn_unexportable_components(sys::System)
    counts = Dict{String, Int}()
    for component in get_components(Component, sys)
        if !is_document_exportable(component)
            name = string(nameof(typeof(component)))
            counts[name] = get(counts, name, 0) + 1
        end
    end
    isempty(counts) && return nothing
    listed = join(("$k ($(counts[k]))" for k in sort(collect(keys(counts)))), ", ")
    @warn "to_openapi: omitting component type(s) with no OpenAPI converter — they will not " *
          "be in the document and will not survive a round trip: $listed"
    return nothing
end

# ── unit_system resolution ──────────────────────────────────────────────────────

"""Resolve the `unit_system` kwarg to `(document_unit_system_string, ledger_or_nothing)`.
`:original` reads the round-trip ledger (`load_ledger` itself raises when absent);
`:device_base`/`:natural_units` force that convention explicitly and require no ledger."""
function _resolve_export_unit_system(sys::System, unit_system::Symbol)
    if unit_system === :original
        ledger = load_ledger(sys)
        return String(ledger["unit_system"]), ledger
    elseif unit_system === :device_base
        return "DEVICE_BASE", nothing
    elseif unit_system === :natural_units
        return "NATURAL_UNITS", nothing
    else
        error(
            "to_openapi(sys; unit_system=$unit_system): unmapped — expected :original, " *
            ":device_base, or :natural_units",
        )
    end
end

# ── id assignment ────────────────────────────────────────────────────────────────
# Builds an `OpenAPIRefs` and populates it via `refs[id] = component`, walking components in
# `DOCUMENT_PLAN` order (buses before the branches that reference them, etc. — the same order
# import uses; export does not need the ordering for resolution, since ids already exist or are
# assigned fresh, but keeping it identical simplifies testing and mirrors import 1:1).
#
# Ids come from the ledger's `id_to_uuid` when a component's UUID is listed there (an
# `:original` export, reproducing the document's ids); anything absent from the ledger —
# every component when there is no ledger, or `TransformerCircuit` always
# (`store_ledger!` skips it via `_has_own_uuid`, so it never has a ledger-backed id to
# reproduce) — gets a fresh id from a counter that starts *after* the ledger's highest id, so
# fresh and ledger-derived ids never collide.

"""Enumerate the live instances of a `DOCUMENT_PLAN` type. `TransformerCircuit` is a
`DeviceParameter` embedded in its owning transformer, never a standalone System component,
so it enumerates through the owners — both `TwoWindingTransformer` (one circuit) and
`ThreeWindingTransformer` (three, via `get_circuits`)."""
_plan_components(sys::System, ::Type{T}) where {T} = get_components(T, sys)
function _plan_components(sys::System, ::Type{TransformerCircuit})
    two_winding = (get_circuit(twt) for twt in get_components(TwoWindingTransformer, sys))
    three_winding = (
        c for t3w in get_components(ThreeWindingTransformer, sys) for
        c in get_circuits(t3w)
    )
    return Iterators.flatten((two_winding, three_winding))
end

"""Ledger id when the component's UUID is listed there; otherwise the next fresh id.
Components with no UUID of their own (`_has_own_uuid` false — `TransformerCircuit`) are
never in the ledger, so they always get a fresh id."""
function _export_id!(next_id::Base.RefValue{Int}, uuid_to_id, component)
    if _has_own_uuid(component)
        return get(uuid_to_id, IS.get_id(component)) do
            fresh = next_id[]
            next_id[] += 1
            return fresh
        end
    end
    fresh = next_id[]
    next_id[] += 1
    return fresh
end

function _build_export_refs(
    sys::System,
    unit_system_string::AbstractString,
    uuid_to_id::AbstractDict{Int, Int},
)
    refs = OpenAPIRefs(unit_system_string, get_base_power(sys))
    start_id = if isempty(uuid_to_id)
        1
    else
        maximum(values(uuid_to_id)) + 1
    end
    next_id = Ref(start_id)
    for (_po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            refs[_export_id!(next_id, uuid_to_id, c)] = c
        end
    end
    return refs
end

function _ledger_uuid_to_id(ledger)
    return Dict{Int, Int}(
        component_id => parse(Int, doc_id_str) for
        (doc_id_str, component_id) in ledger["id_to_uuid"]
    )
end

# ── component pass ───────────────────────────────────────────────────────────────

"""
Convert every component in [`DOCUMENT_PLAN`](@ref) order and add it to `doc`.

`add_component!` buckets by the PO type's own name and keeps each bucket concretely typed, so
the document's `components` map needs no key bookkeeping here.
"""
function _export_components!(
    doc::PC.SystemDocument,
    refs::OpenAPIRefs,
    sys::System,
    val::IS.AbstractUnitSystem,
)
    for (_po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            PC.add_component!(doc, to_openapi(c, refs, val))
            _export_ext!(doc, component_id(refs, c), c)
        end
    end
    return nothing
end

# ── service membership (reverse of the service-membership branch in
# _attach_supplemental_attribute_associations!) ───────────────────────────────────
# Service membership is a row in its own `ServiceAssociation` table: `service_id` and
# `entity_id` both name components, so no `attribute_type` discriminator is needed.

function _export_service_associations(refs::OpenAPIRefs, sys::System)
    rows = PO.ServiceAssociation[]
    for device in get_components(Device, sys)
        supports_services(device) || continue
        for service in get_services(device)
            push!(
                rows,
                PO.ServiceAssociation(;
                    service_id = component_id(refs, service),
                    entity_id = component_id(refs, device),
                ),
            )
        end
    end
    for group in get_components(GroupReserve, sys)
        for contributing in get_contributing_services(group)
            push!(
                rows,
                PO.ServiceAssociation(;
                    service_id = component_id(refs, group),
                    entity_id = component_id(refs, contributing),
                ),
            )
        end
    end
    return rows
end

# ── supplemental attributes (reverse of _attach_supplemental_attribute_associations!) ──

# A plant-family attribute (`ThermalPowerPlant`, `HydroPowerPlant`, `RenewablePowerPlant`,
# `CombinedCycleFractional`, `CombinedCycleBlock`) gets both a plain
# `SupplementalAttributeAssociation` row (for type resolution, like any other attribute) and
# an additional `PlantAssociation`/`CombinedCycleAssociation` row recording the group: the
# reverse of the plant-family `_attach_attribute!` dispatch on import. A plain attribute
# (`EmissionsData`, `GeographicInfo`, the `Outage` types) gets no group row at all, which is
# why this dispatches on the attribute type rather than on some separate "has a group" flag.
# `_group_indices` is used rather than the public reverse-map getters, which build a whole
# dict per call and would make this walk quadratic.
_group_association!(::Vector, ::Vector, ::SupplementalAttribute, ::Any, ::Int, ::Int) =
    nothing
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::ThermalPowerPlant,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(plant_rows, get_shaft_map(attr), entity, attr_id, entity_id)
    return nothing
end
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::HydroPowerPlant,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(plant_rows, get_penstock_map(attr), entity, attr_id, entity_id)
    return nothing
end
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::RenewablePowerPlant,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(plant_rows, get_pcc_map(attr), entity, attr_id, entity_id)
    return nothing
end
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::CombinedCycleFractional,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(
        plant_rows,
        get_operation_exclusion_map(attr),
        entity,
        attr_id,
        entity_id,
    )
    return nothing
end

"""Push a `PlantAssociation` row for `entity`'s single group in `group_map`, or nothing when
it holds none — the shape `group_index` takes in the document."""
function _push_plant_association!(plant_rows, group_map, entity, attr_id::Int, entity_id::Int)
    indices = _group_indices(group_map, IS.get_id(entity))
    isempty(indices) && return nothing
    push!(
        plant_rows,
        PO.PlantAssociation(;
            plant_id = attr_id,
            entity_id = entity_id,
            group_index = only(indices),
        ),
    )
    return nothing
end

"""A CT/CA can feed more than one HRSG, but IS attaches a `CombinedCycleBlock` to a component
once regardless — so only the lowest HRSG number is representable per association row. Known
limitation: no index survived a document at all before the plant-attribute feature was added."""
function _group_association!(
    ::Vector,
    cc_rows::Vector{PO.CombinedCycleAssociation},
    attr::CombinedCycleBlock,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    uuid = IS.get_id(entity)
    ct_hrsgs = _group_indices(get_hrsg_ct_map(attr), uuid)
    if !isempty(ct_hrsgs)
        push!(
            cc_rows,
            PO.CombinedCycleAssociation(;
                plant_id = attr_id,
                entity_id = entity_id,
                role = "CT",
                hrsg_index = first(ct_hrsgs),
            ),
        )
        return nothing
    end
    ca_hrsgs = _group_indices(get_hrsg_ca_map(attr), uuid)
    if !isempty(ca_hrsgs)
        push!(
            cc_rows,
            PO.CombinedCycleAssociation(;
                plant_id = attr_id,
                entity_id = entity_id,
                role = "CA",
                hrsg_index = first(ca_hrsgs),
            ),
        )
    end
    return nothing
end

"""
Emit the attribute rows and their associations, drawing attribute ids from `doc`'s counter.

Ids come from the document's single counter, not a private one: SiennaGridDB's `entities` table
keys a row by id without its type, so an id must mean exactly one thing across components *and*
supplemental attributes. Sharing the counter is what makes that true by construction — a
private counter here previously handed out attribute id 1 alongside component id 1.
"""
function _export_supplemental_attributes(
    sorted_refs,
    refs::OpenAPIRefs,
    doc::PC.SystemDocument,
)
    uuid_to_component = Dict{Int, Any}(
        IS.get_id(c) => c for c in values(refs.by_id) if _has_own_uuid(c)
    )
    attribute_rows = Any[]
    association_rows = PC.SupplementalAttributeAssociation[]
    plant_association_rows = PO.PlantAssociation[]
    combined_cycle_association_rows = PO.CombinedCycleAssociation[]
    attr_ids = Dict{Int, Int}()
    for (entity_id, entity) in sorted_refs
        _has_own_uuid(entity) || continue
        for attr in get_supplemental_attributes(entity)
            attr_uuid = IS.get_id(attr)
            attr_id = get!(attr_ids, attr_uuid) do
                id = PC.next_id!(doc)
                push!(
                    attribute_rows,
                    _to_openapi_attribute(attr, refs, uuid_to_component, id),
                )
                return id
            end
            push!(
                association_rows,
                PC.SupplementalAttributeAssociation(;
                    attribute_id = attr_id,
                    entity_id = entity_id,
                    attribute_type = string(nameof(typeof(attr))),
                ),
            )
            _group_association!(
                plant_association_rows,
                combined_cycle_association_rows,
                attr,
                entity,
                attr_id,
                entity_id,
            )
        end
    end
    return attribute_rows,
    association_rows,
    plant_association_rows,
    combined_cycle_association_rows
end

# ── time series ────────────────────────────────────────────────────────────────
#
# The mirror of import's store adoption: the System's InfraStore *is* the sidecar, so export
# serializes it rather than walking series and emitting a metadata row each. The catalog it
# writes keys every series by (owner id, name, type, resolution/interval, features) — the
# same tuple `TimeSeriesAssociation` carries — so no `time_series_associations` rows are
# emitted. PowerTableDataParser writes its documents the same way.
#
# The catalog's owner ids are IS component ids, while the document's ids come from
# `_export_id!`. `_check_time_series_ids_match` below refuses to write a pair whose ids
# disagree, since the result would be a document whose sidecar no importer could resolve.

"""
Error unless every time-series-owning component's document id equals its IS component id.

Import resolves a series' owner by looking the sidecar catalog's owner id up as a document
id, so the two must agree. They do for a `System` built by `from_openapi` (the ledger
reproduces the original ids) and for one whose ids were never reassigned. They can diverge
for a hand-built `System` exported with `unit_system = :device_base`/`:natural_units`, where
`_export_id!` hands out fresh ids — hence a loud error rather than a silently unloadable pair.

A supplemental attribute owning time series is rejected outright rather than id-checked.
Export assigns attribute document ids fresh from the document's counter instead of
reproducing them, so its catalog rows could never resolve on the way back in. Nothing this
package produces hits it today (no producer attaches series to an attribute), and supporting
it means teaching the ledger to carry attribute ids too — so it errors rather than writing a
pair that reads back short.
"""
function _check_time_series_ids_match(sorted_refs)
    for (doc_id, entity) in sorted_refs
        _has_own_uuid(entity) || continue
        IS.supports_time_series(entity) || continue
        has_time_series(entity) || continue
        if entity isa SupplementalAttribute
            error(
                "to_openapi: $(summary(entity)) carries time series, which is not supported " *
                "on export — attribute document ids are assigned fresh rather than " *
                "reproduced, so the sidecar catalog could not be resolved on import",
            )
        end
        entity_id = IS.get_id(entity)
        entity_id == doc_id || error(
            "to_openapi: $(summary(entity)) carries time series but its document id " *
            "($doc_id) differs from its component id ($entity_id) — the sidecar catalog " *
            "keys series by component id, so the document could not be read back. Export " *
            "with unit_system = :original from a from_openapi-built System, or drop the " *
            "time series before exporting.",
        )
    end
    return nothing
end

"""
Write the System's time series store to `time_series_storage_path`, returning the (always
empty) `time_series_associations` rows — the store's own catalog carries the metadata.
"""
function _export_all_time_series(sys::System, sorted_refs, time_series_storage_path)
    rows = PC.TimeSeriesAssociation[]
    store = sys.data.time_series_manager.data_store
    IS.isempty(store) && return rows
    isnothing(time_series_storage_path) && error(
        "to_openapi: $(IS.get_num_time_series(store)) time series are attached but no " *
        "time_series_storage_path was given — cannot write the sidecar",
    )
    _check_time_series_ids_match(sorted_refs)
    IS.serialize(store, String(time_series_storage_path))
    return rows
end

# ── document-level entry point ──────────────────────────────────────────────────

"""
$(TYPEDSIGNATURES)

Build a `PowerCoreOpenAPIModels.SystemDocument` from `sys`, the reverse of
`from_openapi(::Type{System}, doc)`.

Returns the typed container, not JSON: writing it to disk belongs to
`PowerCoreOpenAPIModels.write_document`, which [`to_file`](@ref) drives. Every id in the result
— components and supplemental attributes alike — comes from the document's single counter, since
consumers key a row by id without its type.

`unit_system`: `:original` (default) reproduces the document `sys` was read from — requires an
OpenAPI round-trip ledger (`from_openapi`-built `System`s carry one; [`load_ledger`](@ref)
raises when absent). `:device_base`/`:natural_units` force that convention explicitly and need
no ledger, so a `System` built directly via `add_component!` is exportable too.

Walks components in [`DOCUMENT_PLAN`](@ref) order (symmetry with import, not a resolution
requirement — every id already exists or is assigned fresh before it is ever read). Emits
`PO.Line.base_power` (and the equivalent on every system-base-denormalized type) as
`get_base_power(sys)` exactly — not reconstructed.

Component `ext` is written through verbatim to `doc.ext`. Errors loudly rather than silently
dropping data: a time series with no `time_series_storage_path` given, or an unmapped
`scaling_factor_multiplier` function.
"""
function to_openapi(
    sys::System;
    unit_system::Symbol = :original,
    time_series_storage_path = nothing,
)
    warn_unexportable_components(sys)
    unit_system_string, ledger = _resolve_export_unit_system(sys, unit_system)
    uuid_to_id = if isnothing(ledger)
        Dict{Int, Int}()
    else
        _ledger_uuid_to_id(ledger)
    end
    refs = _build_export_refs(sys, unit_system_string, uuid_to_id)
    val = _unit_val(unit_system_string)

    doc = PC.SystemDocument(
        get_base_power(sys);
        unit_system = unit_system_string,
        name = get_name(sys),
        description = get_description(sys),
        frequency = sys.frequency,
        time_series_storage_file = _sidecar_basename(time_series_storage_path),
    )
    # Component ids are already assigned (from the ledger or fresh); tell the document so its
    # counter continues past them instead of reissuing one to a supplemental attribute.
    _reserve_component_ids!(doc, refs)

    _export_components!(doc, refs, sys, val)
    # One id-ordered snapshot of the registry, shared by both document-order-sensitive
    # walks below rather than each re-collecting and re-sorting it.
    sorted_refs = sort(collect(refs.by_id); by = first)
    supplemental_attributes,
    supplemental_attribute_associations,
    plant_associations,
    combined_cycle_associations = _export_supplemental_attributes(sorted_refs, refs, doc)
    append!(doc.supplemental_attributes, supplemental_attributes)
    append!(doc.supplemental_attribute_associations, supplemental_attribute_associations)
    append!(doc.plant_associations, plant_associations)
    append!(doc.combined_cycle_associations, combined_cycle_associations)
    append!(doc.service_associations, _export_service_associations(refs, sys))
    append!(
        doc.time_series_associations,
        _export_all_time_series(sys, sorted_refs, time_series_storage_path),
    )

    PC.validate_document(doc)
    return doc
end

_sidecar_basename(::Nothing) = nothing
_sidecar_basename(path) = basename(String(path))

function _reserve_component_ids!(doc::PC.SystemDocument, refs::OpenAPIRefs)
    if isempty(refs.by_id)
        return nothing
    end
    PC.reserve_ids!(doc, maximum(keys(refs.by_id)))
    return nothing
end
