# Hand-written (not generated): the document-level OpenAPI import path. Builds a `System`
# from an already-`JSON.parsefile`'d document by driving the per-component `from_openapi`
# methods (generated in `src/models/generated/`, hand-written in `src/openapi/import_handwritten.jl`)
# in dependency order, then attaches reserve membership, time series, and (where a
# converter exists) supplemental attributes.
#
# Export (`to_openapi(sys; ...)`) is a separate task and is not implemented here.

# ── Dependency-ordered component pass ───────────────────────────────────────────
# Topology first, then arcs and branches, then injectors, then reserves. `TransformerCircuit` is the one
# `addable = false` entry — a `DeviceParameter` embedded in `TwoWindingTransformer.circuit`
# or one of `ThreeWindingTransformer.{primary,secondary,tertiary}_circuit`, never a
# standalone System component, but still registered in `OpenAPIRefs` so the transformer
# that references it can resolve it. `TransmissionInterface` (a `Service`, membership
# carried by a `supplemental_attribute_associations` row like the reserves) is placed after
# them for that reason, though it has no forward references of its own.
const DOCUMENT_PLAN = [
    (po_type = PO.Area, psy_type = Area, key = "Area", addable = true),
    (po_type = PO.LoadZone, psy_type = LoadZone, key = "LoadZone", addable = true),
    (po_type = PO.ACBus, psy_type = ACBus, key = "ACBus", addable = true),
    (po_type = PO.Arc, psy_type = Arc, key = "Arc", addable = true),
    (po_type = PO.Line, psy_type = Line, key = "Line", addable = true),
    (
        po_type = PO.TransformerCircuit, psy_type = TransformerCircuit,
        key = "TransformerCircuit", addable = false,
    ),
    (
        po_type = PO.TwoWindingTransformer, psy_type = TwoWindingTransformer,
        key = "TwoWindingTransformer", addable = true,
    ),
    (
        po_type = PO.ThreeWindingTransformer, psy_type = ThreeWindingTransformer,
        key = "ThreeWindingTransformer", addable = true,
    ),
    # After Area: its only references are `from_area`/`to_area`.
    (
        po_type = PO.AreaInterchange, psy_type = AreaInterchange,
        key = "AreaInterchange",
        addable = true,
    ),
    (
        po_type = PO.ThermalStandard, psy_type = ThermalStandard,
        key = "ThermalStandard",
        addable = true,
    ),
    (po_type = PO.PowerLoad, psy_type = PowerLoad, key = "PowerLoad", addable = true),
    (
        po_type = PO.InterruptiblePowerLoad, psy_type = InterruptiblePowerLoad,
        key = "InterruptiblePowerLoad", addable = true,
    ),
    (
        po_type = PO.ShiftablePowerLoad, psy_type = ShiftablePowerLoad,
        key = "ShiftablePowerLoad", addable = true,
    ),
    (
        po_type = PO.FixedAdmittance, psy_type = FixedAdmittance,
        key = "FixedAdmittance",
        addable = true,
    ),
    (
        po_type = PO.HydroTurbine, psy_type = HydroTurbine, key = "HydroTurbine",
        addable = true,
    ),
    (
        po_type = PO.HydroReservoir, psy_type = HydroReservoir, key = "HydroReservoir",
        addable = true,
    ),
    (
        po_type = PO.HydroDispatch, psy_type = HydroDispatch, key = "HydroDispatch",
        addable = true,
    ),
    (
        po_type = PO.RenewableDispatch, psy_type = RenewableDispatch,
        key = "RenewableDispatch", addable = true,
    ),
    (
        po_type = PO.RenewableNonDispatch, psy_type = RenewableNonDispatch,
        key = "RenewableNonDispatch", addable = true,
    ),
    (
        po_type = PO.SynchronousCondenser, psy_type = SynchronousCondenser,
        key = "SynchronousCondenser", addable = true,
    ),
    (
        po_type = PO.EnergyReservoirStorage, psy_type = EnergyReservoirStorage,
        key = "EnergyReservoirStorage", addable = true,
    ),
    (
        po_type = PO.TwoTerminalGenericHVDCLine, psy_type = TwoTerminalGenericHVDCLine,
        key = "TwoTerminalGenericHVDCLine", addable = true,
    ),
    (
        po_type = PO.OnlineReserve, psy_type = OnlineReserve, key = "OnlineReserve",
        addable = true,
    ),
    (
        po_type = PO.OfflineReserve, psy_type = OfflineReserve, key = "OfflineReserve",
        addable = true,
    ),
    (
        po_type = PO.GroupReserve, psy_type = GroupReserve, key = "GroupReserve",
        addable = true,
    ),
    (
        po_type = PO.TransmissionInterface, psy_type = TransmissionInterface,
        key = "TransmissionInterface", addable = true,
    ),
]

"""
`DOCUMENT_PLAN`'s document-facing key must be unique — two entries sharing a key would make
[`_check_no_unconverted_component_types`](@ref)'s membership test and the dependency-ordered
component pass ambiguous about which converter owns that key. Checked with `allunique` before
being wrapped in a `Set` (rather than letting the `Set` construction silently collapse a
duplicate) so a future entry that copy-pastes an existing key errors, naming the offender,
instead of quietly losing one type's converter.
"""
function _document_plan_keys(plan)
    keys_in_order = [p.key for p in plan]
    if !allunique(keys_in_order)
        duplicate = first(k for k in keys_in_order if count(==(k), keys_in_order) > 1)
        error(
            "DOCUMENT_PLAN: duplicate key \"$duplicate\" — every entry must have a unique " *
            "document-facing key",
        )
    end
    return Set(keys_in_order)
end

const DOCUMENT_PLAN_KEYS = _document_plan_keys(DOCUMENT_PLAN)

"""
Whether a component type can be written to an OpenAPI document.

`false` for everything by default, and `true` only for the types [`DOCUMENT_PLAN`](@ref) names —
the methods below are generated from that list, so adding a converter there is the single edit
that makes a type exportable.

A trait rather than a membership test against a list of types, so the check dispatches and stays
extensible: a package adding its own converter adds its own method.

Used by [`warn_unexportable_components`](@ref) on the export path. Dynamic components are the
main `false` case today (dynamics is deferred, so no dynamic type has a converter) and their loss
on export is accepted for now — but it is reported rather than silent.
"""
is_document_exportable(::Component) = false

for (_po_type, psy_type, _key, _addable) in DOCUMENT_PLAN
    @eval is_document_exportable(::$psy_type) = true
end

function _unit_val(unit_system::AbstractString)
    unit_system == "NATURAL_UNITS" && return NU
    unit_system == "DEVICE_BASE" && return DU
    error(
        "from_openapi(System, doc): unmapped unit_system \"$unit_system\" — expected " *
        "NATURAL_UNITS or DEVICE_BASE",
    )
end

"""Error, naming every offending type, when the document declares a component type with
no registered `from_openapi` converter — psy6 forbids silently skipping unconverted
types."""
function _check_no_unconverted_component_types(components::AbstractDict)
    unconverted = sort([k for k in keys(components) if !(k in DOCUMENT_PLAN_KEYS)])
    isempty(unconverted) || error(
        "from_openapi(System, doc): document declares component type(s) with no " *
        "registered from_openapi converter: $(join(unconverted, ", ")) — every " *
        "component type present in the document must be converted, not skipped",
    )
    return nothing
end

# ── document `ext` ──────────────────────────────────────────────────────────────

"""
Error naming every `ext` key a document carries.

`ext` is a producer-side escape hatch for source columns no schema field claims. PowerSystems
has nowhere to put them, so a document handed to it must not carry any: a producer that cannot
map a column either grows the schema a field or keeps the value on its own side. Erroring here
means such data is refused at the boundary rather than silently discarded on the way in.
"""
function _check_ext_is_empty(doc::PC.SystemDocument)
    offenders = Dict{String, Int}()
    for (component_id, extras) in doc.ext
        for key in keys(extras)
            offenders[key] = component_id
        end
    end
    isempty(offenders) && return nothing
    listed = join(
        ("\"$k\" (component id $(offenders[k]))" for k in sort(collect(keys(offenders)))),
        ", ",
    )
    error(
        "from_openapi(System, doc): document ext carries key(s) PowerSystems has no field " *
        "for: $listed — add the field to the schema, or keep the value on the producer side. " *
        "Silently dropping source data is not an option.",
    )
end

# ── service membership dispatch ─────────────────────────────────────────────────
# (device-first `add_service!`, not re-adding the service). Service membership is now a row
# in the unified `supplemental_attribute_associations` table (D10) rather than its own table —
# `_attach_supplemental_attribute_associations!` below is what routes a row here — but the
# membership dispatch itself is unchanged, and stays dispatch rather than an `attribute_type`
# string comparison.

"""Device contributing to a (non-group) reserve or `TransmissionInterface`: attach via
the System-aware 3-arg `add_service!`, which validates both sides are already attached."""
_attach_service_membership!(entity::Device, service::Service, sys::System) =
    add_service!(entity, service, sys)

"""Service (e.g. an `OnlineReserve`) contributing to a `GroupReserve`: `add_service!` has
no overload for `GroupReserve`, so membership is recorded by pushing onto
`contributing_services` directly, mirroring the reference prototype."""
function _attach_service_membership!(entity::Service, group::GroupReserve, ::System)
    push!(get_contributing_services(group), entity)
    return nothing
end

function _attach_service_membership!(entity, service, ::System)
    error(
        "from_openapi(System, doc): unmapped service membership pair — entity=" *
        "$(typeof(entity)) service=$(typeof(service))",
    )
end

# ── Time series ingestion ───────────────────────────────────────────────────────

"""Scaling-factor multiplier names a document may carry, resolved to the PSY getter each
one names. The document field is a bare, unprefixed function name (confirmed against
real pointer files — the schema docstring's "PowerSystems.get_max_active_power"
module-qualified form does not occur in practice), so this is a literal table rather than
a runtime `getproperty(PowerSystems, Symbol(name))` dispatch — consistent with every
other document-string lookup in this package. An unmapped string errors loudly."""
const SCALING_FACTOR_MULTIPLIERS = Dict{String, Function}(
    "get_max_active_power" => get_max_active_power,
    "get_max_reactive_power" => get_max_reactive_power,
    "get_peak_active_power" => get_peak_active_power,
    "get_peak_reactive_power" => get_peak_reactive_power,
    "get_inflow" => get_inflow,
    "get_level_targets" => get_level_targets,
    "get_requirement" => get_requirement,
    "get_storage_capacity" => get_storage_capacity,
)

_resolve_scaling_factor_multiplier(::Nothing) = nothing
function _resolve_scaling_factor_multiplier(name::AbstractString)
    haskey(SCALING_FACTOR_MULTIPLIERS, name) || error(
        "from_openapi(System, doc): unmapped scaling_factor_multiplier \"$name\"",
    )
    return SCALING_FACTOR_MULTIPLIERS[name]
end

"""Only the `PT<seconds>S` shape is implemented; any other ISO 8601 duration form errors
loudly rather than attempting a general parse that is not needed yet."""
function _parse_iso8601_seconds(s::AbstractString)
    m = match(r"^PT(\d+)S$", s)
    isnothing(m) && error(
        "from_openapi(System, doc): unmapped resolution \"$s\" — only the PT<seconds>S " *
        "form is implemented",
    )
    return Dates.Second(parse(Int, m.captures[1]))
end

"""
Document `time_series_type` string → the PSY/IS type to reconstruct, dispatched on below
rather than branched on.
"""
const TIME_SERIES_TYPE_FROM_STRING = Dict{String, DataType}(
    "SingleTimeSeries" => SingleTimeSeries,
    "Deterministic" => Deterministic,
    "DeterministicSingleTimeSeries" => DeterministicSingleTimeSeries,
)

function _resolve_time_series_type(assoc::PC.TimeSeriesAssociation)
    haskey(TIME_SERIES_TYPE_FROM_STRING, assoc.time_series_type) || error(
        "from_openapi(System, doc): unmapped time_series_type=" *
        "\"$(assoc.time_series_type)\" for association \"$(assoc.name)\"",
    )
    return TIME_SERIES_TYPE_FROM_STRING[assoc.time_series_type]
end

"""Reconstruct one `IS.SingleTimeSeries` from its association row plus the HDF5 sidecar.
The HDF5 read API (`IS.deserialize_time_series`) requires a full `TimeSeriesMetadata`
object, not a bare UUID — the metadata is rebuilt here from the association row's own
fields (name, resolution, initial_timestamp, length) rather than read back out of the
HDF5 group, since the group stores only the raw array plus a `data_type` attribute."""
function _read_time_series(
    ::Type{SingleTimeSeries},
    storage::IS.Hdf5TimeSeriesStorage,
    assoc::PC.TimeSeriesAssociation,
)
    metadata = IS.SingleTimeSeriesMetadata(;
        name = assoc.name,
        resolution = _parse_iso8601_seconds(assoc.resolution),
        initial_timestamp = Dates.DateTime(assoc.initial_timestamp),
        time_series_uuid = Base.UUID(assoc.time_series_uuid),
        length = Int(assoc.length),
        scaling_factor_multiplier = _resolve_scaling_factor_multiplier(
            assoc.scaling_factor_multiplier,
        ),
    )
    return IS.deserialize_time_series(
        SingleTimeSeries, storage, metadata, 1:Int(assoc.length), 1:1,
    )
end

"""Build the shared `IS.DeterministicMetadata` for a `Deterministic`/`DeterministicSingleTimeSeries`
association row — IS has no dedicated metadata type for the latter."""
function _deterministic_metadata(assoc::PC.TimeSeriesAssociation, ::Type{T}) where {T}
    return IS.DeterministicMetadata(;
        name = assoc.name,
        resolution = _parse_iso8601_seconds(assoc.resolution),
        initial_timestamp = Dates.DateTime(assoc.initial_timestamp),
        interval = _parse_iso8601_seconds(assoc.interval),
        count = Int(assoc.window_count),
        time_series_uuid = Base.UUID(assoc.time_series_uuid),
        horizon = _parse_iso8601_seconds(assoc.horizon),
        time_series_type = T,
        scaling_factor_multiplier = _resolve_scaling_factor_multiplier(
            assoc.scaling_factor_multiplier,
        ),
    )
end

"""Reconstruct one `IS.Deterministic` from its association row plus the HDF5 sidecar.
`DeterministicSingleTimeSeries` does not go through this path — see
`_attach_deterministic_single_time_series!` below for why."""
function _read_time_series(
    ::Type{Deterministic},
    storage::IS.Hdf5TimeSeriesStorage,
    assoc::PC.TimeSeriesAssociation,
)
    metadata = _deterministic_metadata(assoc, Deterministic)
    rows = 1:length(metadata)
    columns = 1:IS.get_count(metadata)
    return IS.deserialize_time_series(Deterministic, storage, metadata, rows, columns)
end

"""Read a required structural field off `assoc`, erroring with the association's name and
the field when the document declares `time_series_type` but omits the field it needs. A
`Probabilistic` row with no `percentiles`, or a `Scenarios` row with no `scenario_count`, is
malformed input — never substitute a default."""
function _require_field(assoc::PC.TimeSeriesAssociation, field::Symbol)
    value = getproperty(assoc, field)
    isnothing(value) && error(
        "from_openapi(System, doc): time series association \"$(assoc.name)\" declares " *
        "time_series_type=\"$(assoc.time_series_type)\" but is missing $field",
    )
    return value
end

"""Build the `IS.ProbabilisticMetadata` for a `Probabilistic` association row."""
function _probabilistic_metadata(assoc::PC.TimeSeriesAssociation)
    return IS.ProbabilisticMetadata(;
        name = assoc.name,
        resolution = _parse_iso8601_seconds(assoc.resolution),
        initial_timestamp = Dates.DateTime(assoc.initial_timestamp),
        interval = _parse_iso8601_seconds(assoc.interval),
        count = Int(assoc.window_count),
        percentiles = Float64.(_require_field(assoc, :percentiles)),
        time_series_uuid = Base.UUID(assoc.time_series_uuid),
        horizon = _parse_iso8601_seconds(assoc.horizon),
        scaling_factor_multiplier = _resolve_scaling_factor_multiplier(
            assoc.scaling_factor_multiplier,
        ),
    )
end

"""Reconstruct one `IS.Probabilistic` from its association row plus the HDF5 sidecar."""
function _read_time_series(
    ::Type{Probabilistic},
    storage::IS.Hdf5TimeSeriesStorage,
    assoc::PC.TimeSeriesAssociation,
)
    metadata = _probabilistic_metadata(assoc)
    rows = 1:length(metadata)
    columns = 1:IS.get_count(metadata)
    return IS.deserialize_time_series(Probabilistic, storage, metadata, rows, columns)
end

"""Build the `IS.ScenariosMetadata` for a `Scenarios` association row."""
function _scenarios_metadata(assoc::PC.TimeSeriesAssociation)
    return IS.ScenariosMetadata(;
        name = assoc.name,
        resolution = _parse_iso8601_seconds(assoc.resolution),
        initial_timestamp = Dates.DateTime(assoc.initial_timestamp),
        interval = _parse_iso8601_seconds(assoc.interval),
        scenario_count = Int(_require_field(assoc, :scenario_count)),
        count = Int(assoc.window_count),
        time_series_uuid = Base.UUID(assoc.time_series_uuid),
        horizon = _parse_iso8601_seconds(assoc.horizon),
        scaling_factor_multiplier = _resolve_scaling_factor_multiplier(
            assoc.scaling_factor_multiplier,
        ),
    )
end

"""Reconstruct one `IS.Scenarios` from its association row plus the HDF5 sidecar."""
function _read_time_series(
    ::Type{Scenarios},
    storage::IS.Hdf5TimeSeriesStorage,
    assoc::PC.TimeSeriesAssociation,
)
    metadata = _scenarios_metadata(assoc)
    rows = 1:length(metadata)
    columns = 1:IS.get_count(metadata)
    return IS.deserialize_time_series(Scenarios, storage, metadata, rows, columns)
end

"""
Materialize (read off the HDF5 sidecar) the time series identified by `assoc`'s own
`time_series_uuid`, memoized in `materialized` so a series shared by N owner rows — e.g.
RTS's zone/area load fan-out, the same case `_export_time_series!`'s own `written::Set{
Base.UUID}` dedups on the export side (`src/openapi/export_document.jl`) — is read once
rather than N times. Every owner row still gets its own [`_attach_time_series_row!`](@ref)
call; only this read (and, for the ordinary dispatch, the downstream `add_time_series!`
re-serialize it feeds) is skipped on a cache hit.

`DeterministicSingleTimeSeries` shares its `time_series_uuid` with the wrapped
`SingleTimeSeries` it views, so a mix of rows for the same uuid (one `SingleTimeSeries` row
plus several `DeterministicSingleTimeSeries` rows) all resolve to the one cache entry
regardless of which row reads it first.
"""
function _materialize_time_series!(
    materialized::Dict{Base.UUID, TimeSeriesData},
    ::Type{T},
    storage::IS.Hdf5TimeSeriesStorage,
    assoc::PC.TimeSeriesAssociation,
) where {T}
    uuid = Base.UUID(assoc.time_series_uuid)
    return get!(materialized, uuid) do
        _read_time_series(T, storage, assoc)
    end
end
function _materialize_time_series!(
    materialized::Dict{Base.UUID, TimeSeriesData},
    ::Type{DeterministicSingleTimeSeries},
    storage::IS.Hdf5TimeSeriesStorage,
    assoc::PC.TimeSeriesAssociation,
)
    uuid = Base.UUID(assoc.time_series_uuid)
    return get!(materialized, uuid) do
        metadata = _deterministic_metadata(assoc, DeterministicSingleTimeSeries)
        single_metadata = IS.SingleTimeSeriesMetadata(;
            name = get_name(metadata),
            resolution = get_resolution(metadata),
            initial_timestamp = IS.get_initial_timestamp(metadata),
            time_series_uuid = IS.get_time_series_uuid(metadata),
            length = Int(assoc.length),
            scaling_factor_multiplier = IS.get_scaling_factor_multiplier(metadata),
        )
        IS.deserialize_time_series(
            SingleTimeSeries, storage, single_metadata, 1:Int(assoc.length), 1:1,
        )
    end
end

"""
Attach a `DeterministicSingleTimeSeries` association row directly to `entity`'s time-series
manager rather than through `add_time_series!`, given the already-materialized `single_ts`
it wraps ([`_materialize_time_series!`](@ref)).

`DeterministicSingleTimeSeries` has no `IS.get_data` method — it is a view over its wrapped
`SingleTimeSeries`, not an independently-materializable series — so `add_time_series!`'s
generic `check_time_series_data` step (which calls `get_data`) `MethodError`s on it. IS's own
`transform_single_time_series!` never goes through `add_time_series!` for this reason either:
it writes the wrapped array once (idempotent — a no-op if already present, e.g. from that
same series' own `SingleTimeSeries` association row) and registers an `IS.DeterministicMetadata`
row directly via `IS.add_metadata!`. This mirrors that.
"""
function _attach_deterministic_single_time_series!(
    entity,
    assoc::PC.TimeSeriesAssociation,
    single_ts::SingleTimeSeries,
)
    metadata = _deterministic_metadata(assoc, DeterministicSingleTimeSeries)
    IS.serialize_time_series!(IS.get_time_series_storage(entity), single_ts)
    IS.add_metadata!(
        IS.get_metadata_store(IS.get_time_series_manager(entity)), entity, metadata,
    )
    return nothing
end

"""Attach one `time_series_associations` row to `entity`. Dispatched on the resolved type —
every type but `DeterministicSingleTimeSeries` materializes via
[`_materialize_time_series!`](@ref) and the ordinary `add_time_series!`; see
`_attach_deterministic_single_time_series!` for why that one is different."""
function _attach_time_series_row!(
    ::Type{T},
    sys::System,
    materialized::Dict{Base.UUID, TimeSeriesData},
    storage::IS.Hdf5TimeSeriesStorage,
    entity,
    assoc::PC.TimeSeriesAssociation,
) where {T}
    add_time_series!(
        sys,
        entity,
        _materialize_time_series!(materialized, T, storage, assoc),
    )
    return nothing
end
function _attach_time_series_row!(
    ::Type{DeterministicSingleTimeSeries},
    ::System,
    materialized::Dict{Base.UUID, TimeSeriesData},
    storage::IS.Hdf5TimeSeriesStorage,
    entity,
    assoc::PC.TimeSeriesAssociation,
)
    single_ts = _materialize_time_series!(
        materialized, DeterministicSingleTimeSeries, storage, assoc,
    )
    _attach_deterministic_single_time_series!(entity, assoc, single_ts)
    return nothing
end

# ── Supplemental attributes ─────────────────────────────────────────────────────
# Per-type converters below exist for every attribute PSY hand-writes a constructor for
# AND that has a PO analogue: EmissionsData, GeometricDistributionForcedOutage,
# FixedForcedOutage, PlannedOutage, ThermalPowerPlant, HydroPowerPlant,
# RenewablePowerPlant, CombinedCycleBlock, CombinedCycleFractional, and the Core
# GeographicInfo. `Substation` (`src/substation.jl`) has neither a schema nor a generated
# PO model anywhere in SiennaSchemas/PowerOpenAPIModels — a real, reportable gap, not
# something to invent a converter for.
#
# None of these embed unit-converted fields, so unlike the per-component converters they
# take no `Val{unit_system}`; only the three `Outage` types need `refs`, to resolve
# document-id `monitored_components` into the UUIDs PSY stores.

const POLLUTANT_TYPE_FROM_STRING =
    Dict{String, PollutantType}(string(m) => m for m in instances(PollutantType))
const EMISSION_BASIS_FROM_STRING =
    Dict{String, EmissionBasis}(string(m) => m for m in instances(EmissionBasis))
const MASS_UNIT_FROM_STRING =
    Dict{String, MassUnit}(string(m) => m for m in instances(MassUnit))
const ENERGY_UNIT_FROM_STRING =
    Dict{String, EnergyUnit}(string(m) => m for m in instances(EnergyUnit))
const COMBINED_CYCLE_CONFIGURATION_FROM_STRING = Dict{String, CombinedCycleConfiguration}(
    string(m) => m for m in instances(CombinedCycleConfiguration)
)

function _enum_from_string(table, s, field_name)
    haskey(table, s) || error("from_openapi: unmapped $field_name=\"$s\"")
    return table[s]
end

"""Resolve document ids to UUIDs for an `Outage`'s `monitored_components`; `nothing`
means none declared and maps to an empty vector, matching the PSY constructors' own
default — not an error to guard against."""
function _monitored_component_uuids(refs::OpenAPIRefs, ids)
    if isnothing(ids)
        return Base.UUID[]
    end
    return Base.UUID[IS.get_uuid(refs[Int(id)]) for id in ids]
end

function from_openapi(::Type{EmissionsData}, po::PO.EmissionsData)
    return EmissionsData(;
        name = po.name,
        pollutant = _enum_from_string(
            POLLUTANT_TYPE_FROM_STRING,
            po.pollutant,
            "pollutant",
        ),
        emission_rate = convert_cost(po.emission_rate),
        basis = _enum_from_string(EMISSION_BASIS_FROM_STRING, po.basis, "basis"),
        start_up_adder = po.start_up_adder,
        mass_unit = _enum_from_string(MASS_UNIT_FROM_STRING, po.mass_unit, "mass_unit"),
        energy_unit = _enum_from_string(
            ENERGY_UNIT_FROM_STRING,
            po.energy_unit,
            "energy_unit",
        ),
        gwp = po.gwp,
        available = po.available,
    )
end

function from_openapi(
    ::Type{GeometricDistributionForcedOutage},
    po::PO.GeometricDistributionForcedOutage,
    refs::OpenAPIRefs,
)
    return GeometricDistributionForcedOutage(;
        mean_time_to_recovery = Float64(po.mean_time_to_recovery),
        outage_transition_probability = po.outage_transition_probability,
        monitored_components = _monitored_component_uuids(refs, po.monitored_components),
    )
end

function from_openapi(::Type{PlannedOutage}, po::PO.PlannedOutage, refs::OpenAPIRefs)
    return PlannedOutage(;
        outage_schedule = po.outage_schedule,
        monitored_components = _monitored_component_uuids(refs, po.monitored_components),
    )
end

function from_openapi(
    ::Type{FixedForcedOutage},
    po::PO.FixedForcedOutage,
    refs::OpenAPIRefs,
)
    return FixedForcedOutage(;
        outage_status = po.outage_status,
        monitored_components = _monitored_component_uuids(refs, po.monitored_components),
    )
end

from_openapi(::Type{ThermalPowerPlant}, po::PO.ThermalPowerPlant) =
    ThermalPowerPlant(; name = po.name)
from_openapi(::Type{HydroPowerPlant}, po::PO.HydroPowerPlant) =
    HydroPowerPlant(; name = po.name)
from_openapi(::Type{RenewablePowerPlant}, po::PO.RenewablePowerPlant) =
    RenewablePowerPlant(; name = po.name)

function from_openapi(::Type{CombinedCycleBlock}, po::PO.CombinedCycleBlock)
    return CombinedCycleBlock(;
        name = po.name,
        configuration = _enum_from_string(
            COMBINED_CYCLE_CONFIGURATION_FROM_STRING, po.configuration, "configuration",
        ),
        heat_recovery_to_steam_factor = po.heat_recovery_to_steam_factor,
    )
end

function from_openapi(::Type{CombinedCycleFractional}, po::PO.CombinedCycleFractional)
    return CombinedCycleFractional(;
        name = po.name,
        configuration = _enum_from_string(
            COMBINED_CYCLE_CONFIGURATION_FROM_STRING, po.configuration, "configuration",
        ),
    )
end

from_openapi(::Type{GeographicInfo}, po::PC.GeographicInfo) =
    GeographicInfo(; geo_json = po.geo_json)

"""
Convert one already-deserialized PO supplemental attribute to its PSY counterpart.

Dispatches on the concrete PO type rather than looking up an `attribute_type` string: the
document's flat `supplemental_attributes` array carries no per-row type, but
`PowerCoreOpenAPIModels` has already resolved each row through
`SupplementalAttributeAssociation.attribute_type` and its type registry, so the type is known
here and Julia's own dispatch replaces what used to be a parallel string table in this file.

Only the three `Outage` types need `refs`, to resolve `monitored_components`; the rest ignore
it, so every method takes the same shape and the arity split does not leak into the caller.
"""
_attribute_from_openapi(po::PO.EmissionsData, ::OpenAPIRefs) =
    from_openapi(EmissionsData, po)
_attribute_from_openapi(po::PO.GeometricDistributionForcedOutage, refs::OpenAPIRefs) =
    from_openapi(GeometricDistributionForcedOutage, po, refs)
_attribute_from_openapi(po::PO.FixedForcedOutage, refs::OpenAPIRefs) =
    from_openapi(FixedForcedOutage, po, refs)
_attribute_from_openapi(po::PO.PlannedOutage, refs::OpenAPIRefs) =
    from_openapi(PlannedOutage, po, refs)
_attribute_from_openapi(po::PO.ThermalPowerPlant, ::OpenAPIRefs) =
    from_openapi(ThermalPowerPlant, po)
_attribute_from_openapi(po::PO.HydroPowerPlant, ::OpenAPIRefs) =
    from_openapi(HydroPowerPlant, po)
_attribute_from_openapi(po::PO.RenewablePowerPlant, ::OpenAPIRefs) =
    from_openapi(RenewablePowerPlant, po)
_attribute_from_openapi(po::PO.CombinedCycleBlock, ::OpenAPIRefs) =
    from_openapi(CombinedCycleBlock, po)
_attribute_from_openapi(po::PO.CombinedCycleFractional, ::OpenAPIRefs) =
    from_openapi(CombinedCycleFractional, po)
_attribute_from_openapi(po::PC.GeographicInfo, ::OpenAPIRefs) =
    from_openapi(GeographicInfo, po)
_attribute_from_openapi(po::PO.Substation, ::OpenAPIRefs) = from_openapi(Substation, po)

"""Loud fallback: a PO attribute type with no converter is a gap to close, not a row to skip."""
function _attribute_from_openapi(po, ::OpenAPIRefs)
    error(
        "from_openapi(System, doc): no supplemental attribute converter for " *
        "$(nameof(typeof(po))) — every attribute in the document must be converted, " *
        "not skipped",
    )
end

# ── group_index dispatch (plant-family attributes) ──────────────────────────────
# `SupplementalAttributeAssociation.group_index` (D10) is the shaft/penstock/PCC/HRSG/
# exclusion-group number for the five `PowerPlant` subtypes, and absent (`nothing`) for
# everything else. Each plant type's `add_supplemental_attribute!` takes that number under
# its own keyword or position, so dispatch on the attribute type picks the right call —
# never an `attribute_type` string comparison.

"""No group index: the plain attribute path (`EmissionsData`, `GeographicInfo`, the `Outage`
types, ...), unchanged from before D10."""
_attach_attribute!(sys::System, component, attribute, ::Nothing) =
    add_supplemental_attribute!(sys, component, attribute)

_attach_attribute!(
    sys::System,
    component,
    attribute::ThermalPowerPlant,
    group_index::Integer,
) =
    add_supplemental_attribute!(sys, component, attribute; shaft_number = Int(group_index))
_attach_attribute!(
    sys::System,
    component,
    attribute::HydroPowerPlant,
    group_index::Integer,
) =
    add_supplemental_attribute!(sys, component, attribute, Int(group_index))
_attach_attribute!(
    sys::System,
    component,
    attribute::RenewablePowerPlant,
    group_index::Integer,
) =
    add_supplemental_attribute!(sys, component, attribute, Int(group_index))
_attach_attribute!(
    sys::System,
    component,
    attribute::CombinedCycleBlock,
    group_index::Integer,
) =
    add_supplemental_attribute!(sys, component, attribute; hrsg_number = Int(group_index))
function _attach_attribute!(
    sys::System,
    component,
    attribute::CombinedCycleFractional,
    group_index::Integer,
)
    return add_supplemental_attribute!(
        sys, component, attribute; exclusion_group = Int(group_index),
    )
end

"""Loud fallback: a `group_index` on an attribute type with no group-index dispatch is a
malformed document, not something to attach without it."""
function _attach_attribute!(::System, ::Any, attribute, group_index::Integer)
    error(
        "from_openapi(System, doc): $(nameof(typeof(attribute))) carries " *
        "group_index=$group_index but has no group-index dispatch — only " *
        "ThermalPowerPlant, HydroPowerPlant, RenewablePowerPlant, CombinedCycleBlock, " *
        "and CombinedCycleFractional accept one",
    )
end

# ── Document-level entry point ──────────────────────────────────────────────────

"""Apply one optional document metadata field, dispatching on presence rather than
branching: a field the document omits leaves `System`'s own value untouched."""
_apply_metadata_field!(::Any, ::System, ::Nothing) = nothing
_apply_metadata_field!(setter, sys::System, value) = setter(sys, value)

"""
Carry the document's system-level metadata onto `sys`.

`base_power` and `unit_system` are consumed by the caller when constructing the `System`, so
only `name` and `description` are applied here. `frequency` is deliberately not applied:
`System`'s own default stands, and a document that omits it must not silently reset it.
"""
function _apply_document_metadata!(sys::System, doc::PC.SystemDocument)
    _apply_metadata_field!(set_name!, sys, PC.get_name(doc))
    _apply_metadata_field!(set_description!, sys, PC.get_description(doc))
    return nothing
end

"""
$(TYPEDSIGNATURES)

Build a `System` from a `PowerCoreOpenAPIModels.SystemDocument`.

Takes the typed container, not JSON: reading a file belongs to
`PowerCoreOpenAPIModels.read_document`, which [`from_file`](@ref) drives.

Converts every component in dependency order ([`DOCUMENT_PLAN`](@ref), verified against
dependency order), attaches reserve membership and supplemental
attributes from the unified `supplemental_attribute_associations` table (D10), and — when
`time_series_storage_path` is given — ingests `time_series_associations` from the document
plus its HDF5 sidecar.

Errors loudly (naming the offending type, id, or field) rather than silently skipping:
a component type with no registered converter, an unresolved supplemental-attribute
association (attribute/service or entity), or time-series owner reference, an unmapped
time-series type, scaling-factor multiplier, or supplemental `attribute_type` (see
[`_attach_supplemental_attribute_associations!`](@ref)), and a document that declares time
series but supplies no `time_series_storage_path`.

Stores the id↔UUID round-trip ledger (`store_ledger!`) so a later
`to_openapi(sys; unit_system = :original)` can reproduce the document's ids and unit
convention.

`system_kwargs` pass straight through to the fresh `System(base_power; system_kwargs...)`
this builds (e.g. `time_series_in_memory`, `time_series_directory`, `time_series_read_only`,
`runchecks` — `System`'s own `SYSTEM_KWARGS`); an unsupported key still errors, from
`System`'s own constructor.
"""
function from_openapi(
    ::Type{System},
    doc::PC.SystemDocument;
    time_series_storage_path = nothing,
    system_kwargs...,
)
    base_power = PC.get_base_power(doc)
    unit_system = PC.get_unit_system(doc)
    unit_val = _unit_val(unit_system)

    _check_no_unconverted_component_types(doc.components)
    _check_ext_is_empty(doc)

    sys = System(base_power; system_kwargs...)
    _apply_document_metadata!(sys, doc)

    refs = OpenAPIRefs(unit_system, base_power)

    for (po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for po in PC.get_components(doc, key)
            component = from_openapi(psy_type, po, refs, unit_val)
            if addable
                add_component!(sys, component)
            end
            refs[Int(po.id)] = component
        end
    end

    # Attributes first: a supplemental attribute that owns time series must be attached and
    # registered in `refs` before the time-series pass can resolve its `owner_id`.
    load_supplemental_attribute_associations!(sys, refs, doc)
    load_time_series_associations!(sys, refs, doc, time_series_storage_path)

    store_ledger!(sys, refs)
    return sys
end
