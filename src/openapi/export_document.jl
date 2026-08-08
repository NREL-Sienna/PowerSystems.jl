# Hand-written (not generated): the document-level OpenAPI export path. Mirrors
# src/openapi/import_document.jl's structure in reverse: same `DOCUMENT_PLAN` type enumeration,
# same supplemental-attribute / service-membership / time-series machinery, inverted.
#
# Export (`to_openapi(sys; ...)`) assembles a `PowerCoreOpenAPIModels.SystemDocument` — the
# same container PTDP adopts in place of its own `OpenAPISystem`, so PTDP- and PSY-produced
# documents are interchangeable by construction rather than by matching two hand-built shapes.
# Writing it to disk is `write_document`'s job, driven by `to_file` in src/openapi/file_io.jl.

# ── Supplemental attribute reverse converters ───────────────────────────────────
# Mirrors src/openapi/import_document.jl's per-type `from_openapi` methods. Dispatches directly on
# the PSY attribute's concrete type (Julia multiple dispatch) rather than a runtime
# string -> function table — export does not need one, since the *type* is already known;
# only the *emitted* `attribute_type` string (read by `add_supplemental_attribute!` on the way
# back in) is derived from it, via `string(nameof(typeof(attr)))`, matching
# PowerTableDataParser.jl/src/openapi/container.jl's own convention exactly.

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

# ── ext guard (R6) ───────────────────────────────────────────────────────────────
# `Arc`/`TransformerCircuit`/`TransmissionInterface` carry no `ext` field at all — nothing
# to lose, so the check is a no-op for them rather than an error about a missing getter.

_collect_dropped_ext!(::Dict{String, Int}, ::Arc) = nothing
_collect_dropped_ext!(::Dict{String, Int}, ::TransformerCircuit) = nothing
_collect_dropped_ext!(::Dict{String, Int}, ::TransmissionInterface) = nothing

"""
Tally the `ext` keys on `component` that the document will not carry.

Component `ext` is deliberately not written: PowerSystems refuses a document that carries any
`ext` on the way in (`_check_ext_is_empty`), so writing it would create a field that cannot be
read back. PowerFlowFileParser's `ext`
is a pass-through of raw pm-dict records that nothing downstream reads from the document either.

This is a tally-and-warn rather than an error because raising would make every
PowerFlowFileParser-sourced system unserializable — PFFP puts PSS/E record fields such as
`ARNAME`/`PTOL` on `Area.ext` — which blocks using documents as PowerSystemCaseBuilder's
cache format. The loss is reported per export instead of being silent.
"""
function _collect_dropped_ext!(dropped::Dict{String, Int}, component)
    for key in keys(get_ext(component))
        dropped[key] = get(dropped, key, 0) + 1
    end
    return nothing
end

function _warn_dropped_ext(dropped::Dict{String, Int})
    isempty(dropped) && return nothing
    listed = join(("$k ($(dropped[k]))" for k in sort(collect(keys(dropped)))), ", ")
    @warn "to_openapi: dropping component ext key(s) — a document does not carry component " *
          "ext, so these will not survive a round trip: $listed"
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
        return get(uuid_to_id, IS.get_uuid(component)) do
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
    uuid_to_id::AbstractDict{Base.UUID, Int},
)
    refs = OpenAPIRefs(unit_system_string, get_base_power(sys))
    start_id = if isempty(uuid_to_id)
        1
    else
        maximum(values(uuid_to_id)) + 1
    end
    next_id = Ref(start_id)
    # Tallied across the whole walk and reported once, rather than one warning per component:
    # a PFFP-sourced system puts the same handful of pm-dict keys on every Area.
    dropped_ext = Dict{String, Int}()
    for (po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            _collect_dropped_ext!(dropped_ext, c)
            refs[_export_id!(next_id, uuid_to_id, c)] = c
        end
    end
    _warn_dropped_ext(dropped_ext)
    return refs
end

function _ledger_uuid_to_id(ledger)
    return Dict{Base.UUID, Int}(
        Base.UUID(uuid_str) => parse(Int, id_str) for
        (id_str, uuid_str) in ledger["id_to_uuid"]
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
    for (po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            PC.add_component!(doc, to_openapi(c, refs, val))
        end
    end
    return nothing
end

# ── service membership (reverse of the service-membership branch in
# _attach_supplemental_attribute_associations!) ───────────────────────────────────
# D10: service membership is a row in the unified `supplemental_attribute_associations`
# table, not its own `ServiceAssociation` table. `attribute_id` names the service (a
# component, not a supplemental attribute) and `attribute_type` its type name; neither
# `group_index` nor `role` applies to a membership row.

function _export_service_associations(refs::OpenAPIRefs, sys::System)
    rows = PC.SupplementalAttributeAssociation[]
    for device in get_components(Device, sys)
        supports_services(device) || continue
        for service in get_services(device)
            push!(
                rows,
                PC.SupplementalAttributeAssociation(;
                    attribute_id = component_id(refs, service),
                    entity_id = component_id(refs, device),
                    attribute_type = string(nameof(typeof(service))),
                ),
            )
        end
    end
    for group in get_components(GroupReserve, sys)
        for contributing in get_contributing_services(group)
            push!(
                rows,
                PC.SupplementalAttributeAssociation(;
                    attribute_id = component_id(refs, group),
                    entity_id = component_id(refs, contributing),
                    attribute_type = string(nameof(typeof(group))),
                ),
            )
        end
    end
    return rows
end

# ── supplemental attributes (reverse of _attach_supplemental_attribute_associations!) ──

# `group_index`/`role` (D10) are the reverse of the plant-family `_attach_attribute!` dispatch
# on import: the shaft/penstock/PCC/HRSG/exclusion-group number an entity holds within a
# `PowerPlant`, read back out of the attribute's own reverse map rather than tracked
# separately. `nothing` for both is correct for a plain attribute (`EmissionsData`,
# `GeographicInfo`, the `Outage` types), which is why this dispatches on the attribute type,
# not on some separate "has a group" flag.
_group_index_and_role(::SupplementalAttribute, ::Any) = (nothing, nothing)
_group_index_and_role(attr::ThermalPowerPlant, entity) =
    (get(get_reverse_shaft_map(attr), IS.get_uuid(entity), nothing), nothing)
_group_index_and_role(attr::HydroPowerPlant, entity) =
    (get(get_reverse_penstock_map(attr), IS.get_uuid(entity), nothing), nothing)
_group_index_and_role(attr::RenewablePowerPlant, entity) =
    (get(get_reverse_pcc_map(attr), IS.get_uuid(entity), nothing), nothing)
_group_index_and_role(attr::CombinedCycleFractional, entity) =
    (get(get_inverse_operation_exclusion_map(attr), IS.get_uuid(entity), nothing), nothing)

"""A CT/CA can feed more than one HRSG (`ct_hrsg_map`/`ca_hrsg_map` are `Vector{Int}`-valued),
but IS attaches a `CombinedCycleBlock` to a component once regardless — so only the first HRSG
number is representable per association row. Known limitation: no index survived a document at
all before the plant-attribute feature was added."""
function _group_index_and_role(attr::CombinedCycleBlock, entity)
    uuid = IS.get_uuid(entity)
    ct_hrsgs = get(get_ct_hrsg_map(attr), uuid, nothing)
    isnothing(ct_hrsgs) || return (first(ct_hrsgs), "CT")
    ca_hrsgs = get(get_ca_hrsg_map(attr), uuid, nothing)
    isnothing(ca_hrsgs) || return (first(ca_hrsgs), "CA")
    return (nothing, nothing)
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
    uuid_to_component = Dict{Base.UUID, Any}(
        IS.get_uuid(c) => c for c in values(refs.by_id) if _has_own_uuid(c)
    )
    attribute_rows = Any[]
    association_rows = PC.SupplementalAttributeAssociation[]
    attr_ids = Dict{Base.UUID, Int}()
    for (entity_id, entity) in sorted_refs
        _has_own_uuid(entity) || continue
        for attr in get_supplemental_attributes(entity)
            attr_uuid = IS.get_uuid(attr)
            attr_id = get!(attr_ids, attr_uuid) do
                id = PC.next_id!(doc)
                push!(
                    attribute_rows,
                    _to_openapi_attribute(attr, refs, uuid_to_component, id),
                )
                return id
            end
            group_index, role = _group_index_and_role(attr, entity)
            push!(
                association_rows,
                PC.SupplementalAttributeAssociation(;
                    attribute_id = attr_id,
                    entity_id = entity_id,
                    attribute_type = string(nameof(typeof(attr))),
                    group_index = group_index,
                    role = role,
                ),
            )
        end
    end
    return attribute_rows, association_rows
end

# ── time series (reverse of _attach_time_series!) ───────────────────────────────

const SCALING_FACTOR_MULTIPLIER_TO_STRING =
    Dict(v => k for (k, v) in SCALING_FACTOR_MULTIPLIERS)

_scaling_factor_multiplier_to_string(::Nothing) = nothing
function _scaling_factor_multiplier_to_string(f::Function)
    haskey(SCALING_FACTOR_MULTIPLIER_TO_STRING, f) || error(
        "to_openapi: unmapped scaling_factor_multiplier function $f — no reverse string " *
        "registered in SCALING_FACTOR_MULTIPLIER_TO_STRING",
    )
    return SCALING_FACTOR_MULTIPLIER_TO_STRING[f]
end

"""ISO 8601 duration, the reverse of `_parse_iso8601_seconds` (src/openapi/import_document.jl) and
matching `PowerTableDataParser.jl/src/openapi/time_series.jl`'s `_iso_duration`."""
_iso8601_duration(period::Dates.Period) =
    string("PT", Dates.value(Dates.Second(period)), "S")

# ── per-type time series export (dispatch, not a type-string branch) ────────────
#
# `TimeSeriesAssociation` carries every forecast column (`horizon`, `interval`,
# `window_count`). `Probabilistic` and `Scenarios` are not supported: each needs a structural
# field the document has no home for (percentile identity, scenario count), so they error
# loudly here rather than exporting a row that silently loses it.

"""The series whose UUID identifies the HDF5 payload and the association row.
`DeterministicSingleTimeSeries` has no UUID of its own — IS.get_uuid has no method for it — it
is a view over its wrapped `SingleTimeSeries`, which is what actually gets serialized."""
_hdf5_series(ts::TimeSeriesData) = ts
_hdf5_series(ts::DeterministicSingleTimeSeries) = IS.get_single_time_series(ts)

"""`(horizon, interval, window_count)` document columns. `nothing` for all three on a
`SingleTimeSeries` — it is not a forecast."""
_forecast_columns(::SingleTimeSeries) = (nothing, nothing, nothing)
function _forecast_columns(ts::Union{Deterministic, DeterministicSingleTimeSeries})
    return (
        _iso8601_duration(get_horizon(ts)),
        _iso8601_duration(IS.get_interval(ts)),
        get_count(ts),
    )
end

"""`length` document column. For `SingleTimeSeries`, a plain series' own length. A real
`Deterministic`'s shape is fully described by
`horizon`/`interval`/`window_count`, so it carries none — but `DeterministicSingleTimeSeries`
is a view over a wrapped `SingleTimeSeries` with no association row of its own to carry
*that* series' length (it may have none, if the original was removed after transforming), so
this row is its only carrier; import needs it to reread the wrapped array
(`_attach_deterministic_single_time_series!`)."""
_document_length(ts::SingleTimeSeries) = length(ts)
_document_length(::Deterministic) = nothing
_document_length(ts::DeterministicSingleTimeSeries) = length(IS.get_single_time_series(ts))

"""
Emit one `PC.TimeSeriesAssociation` row per time series attached to `entity` (document id
`entity_id`) — every [`TimeSeriesData`](@ref) subtype IS ships, dispatched per type rather
than branched on a string. Writes each series' data to the HDF5 `storage` the first time its
UUID is seen — a series shared by multiple owners (e.g. RTS's zone/area load fan-out) must
not be written twice.
"""
function _export_time_series!(
    rows::Vector{PC.TimeSeriesAssociation},
    written::Set{Base.UUID},
    storage::Union{Nothing, IS.Hdf5TimeSeriesStorage},
    entity,
    entity_id::Int,
    owner_type::AbstractString,
)
    IS.supports_time_series(entity) || return nothing
    for ts in get_time_series_multiple(entity; type = nothing)
        hdf5_series = _hdf5_series(ts)
        uuid = IS.get_uuid(hdf5_series)
        if !(uuid in written)
            isnothing(storage) && error(
                "to_openapi: $(summary(entity)) carries time series \"$(get_name(ts))\" " *
                "but no time_series_storage_path was given — cannot write the HDF5 sidecar",
            )
            IS.serialize_time_series!(storage, hdf5_series)
            push!(written, uuid)
        end
        horizon, interval, window_count = _forecast_columns(ts)
        push!(
            rows,
            PC.TimeSeriesAssociation(;
                id = length(rows) + 1,
                time_series_uuid = string(uuid),
                time_series_type = string(nameof(typeof(ts))),
                initial_timestamp = TimeZones.ZonedDateTime(
                    IS.get_initial_timestamp(ts), TimeZones.tz"UTC",
                ),
                resolution = _iso8601_duration(get_resolution(ts)),
                horizon = horizon,
                interval = interval,
                window_count = window_count,
                length = _document_length(ts),
                name = get_name(ts),
                owner_id = entity_id,
                owner_type = owner_type,
                owner_category = "Component",
                features = Dict{String, PC.FeatureValue}[],
                scaling_factor_multiplier = _scaling_factor_multiplier_to_string(
                    IS.get_scaling_factor_multiplier(ts),
                ),
            ),
        )
    end
    return nothing
end

function _export_all_time_series(sorted_refs, time_series_storage_path)
    storage = if isnothing(time_series_storage_path)
        nothing
    else
        IS.Hdf5TimeSeriesStorage(true; filename = String(time_series_storage_path))
    end
    rows = PC.TimeSeriesAssociation[]
    written = Set{Base.UUID}()
    for (id, component) in sorted_refs
        _has_own_uuid(component) || continue
        _export_time_series!(
            rows, written, storage, component, id, string(nameof(typeof(component))),
        )
    end
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

Errors loudly rather than silently dropping data: a non-empty `ext` on any component,
a time series with no `time_series_storage_path` given, or an unmapped
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
        Dict{Base.UUID, Int}()
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
    supplemental_attributes, supplemental_attribute_associations =
        _export_supplemental_attributes(sorted_refs, refs, doc)
    append!(doc.supplemental_attributes, supplemental_attributes)
    append!(doc.supplemental_attribute_associations, supplemental_attribute_associations)
    append!(
        doc.supplemental_attribute_associations,
        _export_service_associations(refs, sys),
    )
    append!(
        doc.time_series_associations,
        _export_all_time_series(sorted_refs, time_series_storage_path),
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
