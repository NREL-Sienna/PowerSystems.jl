# Hand-written (not generated): `from_openapi` methods for PO/PSY type pairs the IS generator
# cannot emit. Each was attempted through the generator first (annotating the descriptor with
# `openapi_type` and regenerating); every one below failed or would have silently miscompiled,
# for one of these reasons:
#
#   - Arc:                       PSY's own field type is the ABSTRACT `Bus`, not a struct_name
#                                the generator's reference-kind check can match, AND the PO
#                                field names (`from_id`/`to_id`) differ from PSY's own
#                                (`from`/`to`) — the generator assumes identical names.
#   - Area / LoadZone:           `peak_active_power`/`peak_reactive_power` are schema-fixed-natural
#                                (the document always carries MW/MVAr, not document-unit-system-
#                                dependent) — a semantic the generator's default :power conversion
#                                cannot express. Both structs gained their own `base_power` field
#                                to close the missing-anchor gap.
#   - TransmissionInterface:     `direction_mapping::Dict{String, Int}` is not a scalar, compound
#                                alias, component reference, or enum — unclassifiable. Also gained
#                                its own `base_power` for the same reason as Area/LoadZone;
#                                `active_power_flow_limits` has the same fixed-natural semantic.
#   - Line:                      `r`/`x`/`b`/`g` need `base_voltage` (impedance/admittance
#                                conversion) which the struct does not carry — `TransformerCircuit`
#                                is the pattern for a device that does. Gained its own `base_power`
#                                for its `:mva` fields, which are now generator-shaped — `r`/`x`/
#                                `b`/`g` are what still block `openapi_type`.
#   - TwoTerminalGenericHVDCLine:
#                                `loss::Union{LinearCurve, PiecewiseIncrementalCurve}` is a Union
#                                of two concrete curve types, not the generator's `Union{Nothing,
#                                X}` nullable pattern — unclassifiable. Gained its own `base_power`;
#                                every other field is now generator-shaped.
#   - TransformerCircuit:        PSY's field is named `α`; the PO field is named `alpha`. The
#                                generator assumes identical names and would silently emit
#                                `po.α`, which does not exist on the PO struct — a silent
#                                runtime defect, not a generation-time error.
#   - TwoWindingTransformer:     `magnetizing_shunt::Complex{Float64}` is not a scalar, compound
#                                alias, component reference, or enum — unclassifiable.
#   - ThreeWindingTransformer:   same `magnetizing_shunt::Complex{Float64}` issue as
#                                TwoWindingTransformer, plus three `TransformerCircuit`
#                                references (`primary_circuit`/`secondary_circuit`/
#                                `tertiary_circuit`) instead of the generator's single-reference
#                                assumption.
#   - FixedAdmittance:           `Y::Complex{Float64}` is not a scalar, compound alias, component
#                                reference, or enum — unclassifiable, same reason as
#                                TwoWindingTransformer.magnetizing_shunt above.
#   - HydroReservoir:            `upstream_turbines`/`downstream_turbines`/`upstream_reservoirs`
#                                are `Vector{HydroUnit}`/`Vector{Device}` — unclassifiable; also
#                                needs the semantic (not unit) absolute-to-fraction conversion
#                                for `initial_level`/`level_targets` (see `_level_fraction`).
#   - EnergyReservoirStorage:    `efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}`
#                                is written out in full rather than as the `InOut` compound
#                                alias, so the generator's alias lookup does not match it —
#                                unclassifiable.
#   - OnlineReserve/OfflineReserve/GroupReserve:
#                                parametric (`ReserveDirection`/`ReserveDirection, U`); the
#                                generator explicitly rejects any `openapi_type` on a struct
#                                carrying `parametric`.
#
# Semantics throughout are adapted to this package's `OpenAPIRefs`/`DeviceBaseUnit`/
# `NaturalUnit` dispatch so the document reader can call every converter — generated
# or hand-written — uniformly.

"""Named tuple of `(min, max)` from a PO `MinMax`-shaped struct."""
_minmax(m) = (min = Float64(m.min), max = Float64(m.max))

"""Named tuple of `(from, to)` from a PO `FromTo`-shaped struct."""
_fromto(m) = (from = Float64(m.from), to = Float64(m.to))

# Optional PO fields map nothing -> nothing (the PSY kwargs accept it); handled as
# `::Nothing` method pairs, the same idiom cost_conversion.jl already uses.

"""`(min, max)` passed through unconverted, or `nothing` when absent."""
_opt_minmax(::Nothing) = nothing
_opt_minmax(m) = _minmax(m)

"""`(min, max)` divided by `base`, or `nothing` when absent."""
_minmax_du(::Nothing, base) = nothing
_minmax_du(m, base) = (min = Float64(m.min) / base, max = Float64(m.max) / base)

"""`(up, down)` divided by `base`, or `nothing` when absent."""
_updown_du(::Nothing, base) = nothing
_updown_du(m, base) = (up = Float64(m.up) / base, down = Float64(m.down) / base)

"""`(up, down)` passed through unconverted, or `nothing` when absent."""
_opt_updown(::Nothing) = nothing
_opt_updown(m) = (up = Float64(m.up), down = Float64(m.down))

"""`v` divided by `base`, or `nothing` when absent."""
_scale_optional(::Nothing, base) = nothing
_scale_optional(v, base) = Float64(v) / base

"""Resolve a component's own per-unitization `base_power` from the document, falling back
to the document-level system base when the producer omits it. `Area`/`LoadZone`/
`TransmissionInterface`/`Line`/`TwoTerminalGenericHVDCLine` all gained their own `base_power`
field to close the missing-anchor gap, and it is schema-`required` going forward, but
PowerTableDataParser does not emit it for these five types yet — an omitted field arrives as
`nothing`, not a schema violation this pass should error on, since the document-level system
base is exactly what these types used before the field existed and remains numerically
identical by construction. Do not weaken this to a general nothing-skip guard elsewhere."""
_resolve_base_power(refs::OpenAPIRefs, ::Nothing) = get_base_power(refs)
_resolve_base_power(::OpenAPIRefs, base_power) = Float64(base_power)

"""Reservoir level fields arrive absolute (per `level_data_type`'s units); PSY wants them
as a fraction of `storage_level_limits.max`. Semantic, not a unit conversion — same in
both `DeviceBaseUnit`/`NaturalUnit` methods."""
_level_fraction(::Nothing, max_level) = nothing
_level_fraction(v, max_level) = v / max_level

_complex_number(c) = Complex(c.real, c.imag)

"""`(in, out)` from a PO `InOut`-shaped struct. Inverse of export's `_inout_po`."""
_inout(m) = (in = m.in, out = m.out)

"""Resolve upstream/downstream `HydroUnit` ids to components; `nothing` means no
association (a reservoir can legitimately have zero upstream/downstream turbines) and
maps to an empty vector, matching `HydroReservoir`'s own `upstream_turbines`/
`downstream_turbines` default — not an error to guard against."""
_hydro_units(::OpenAPIRefs, ::Nothing) = HydroUnit[]
_hydro_units(refs::OpenAPIRefs, ids) = HydroUnit[refs[id] for id in ids]

"""Resolve upstream reservoir ids to components; `nothing` means no association and maps
to an empty vector, matching `HydroReservoir.upstream_reservoirs`'s own default."""
_reservoir_devices(::OpenAPIRefs, ::Nothing) = Device[]
_reservoir_devices(refs::OpenAPIRefs, ids) = Device[refs[id] for id in ids]

const TRANSFORMERCONTROLOBJECTIVE_FROM_STRING =
    Dict{String, TransformerControlObjective}(
        string(m) => m for m in instances(TransformerControlObjective)
    )
const TWOWINDINGTRANSFORMERSHUNTLOCATION_FROM_STRING =
    Dict{String, TwoWindingTransformerShuntLocation}(
        string(m) => m for m in instances(TwoWindingTransformerShuntLocation)
    )
const RESERVOIRDATATYPE_FROM_STRING = Dict{String, ReservoirDataType}(
    string(m) => m for m in instances(ReservoirDataType)
)
const STORAGETECH_FROM_STRING =
    Dict{String, StorageTech}(string(m) => m for m in instances(StorageTech))

"""`ReserveDirection` is a type parameter, not an enum instance, so this is a literal table
(mirrors the reference) rather than an `instances(...)`-derived one."""
const RESERVE_DIRECTION = Dict(
    "UP" => ReserveUp,
    "DOWN" => ReserveDown,
    "SYMMETRIC" => ReserveSymmetric,
)

function _resolve_reserve_direction(reserve_direction, name)
    direction = get(RESERVE_DIRECTION, reserve_direction, nothing)
    if isnothing(direction)
        error("unmapped reserve_direction=$reserve_direction on reserve $name")
    end
    return direction
end

# ── Arc ─────────────────────────────────────────────────────────────────────────
# PO field names (`from_id`/`to_id`) differ from PSY's (`from`/`to`); no unit-converted
# fields, so both unit-system methods are identical.

function from_openapi(::Type{Arc}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return Arc(; from = refs[po.from_id], to = refs[po.to_id])
end

function from_openapi(::Type{Arc}, po, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(Arc, po, refs, DU)
end

# ── Area / LoadZone ─────────────────────────────────────────────────────────────
# SiennaSchemas Operations/Topology/{Area,LoadZone}.json declare `peak_active_power`
# (x-unit MW) / `peak_reactive_power` (x-unit MVAr) as FIXED natural units — the document
# carries them in MW/MVAr regardless of its declared unit_system, exactly like a reserve's
# `requirement` (x-unit MW). PSY's descriptor marks both `needs_conversion: true,
# conversion_unit: ":mva"`, so the divisor is `get_base_power(refs)` (the document-level
# system base) in BOTH unit-system methods — the schema unit is fixed, not document-unit-
# system-dependent, which is what still keeps this hand-written: a generated converter would
# divide only under `NATURAL_UNITS`, not both. `Area.load_response` (x-unit MW/Hz) has no
# `conversion_unit` in the PSY descriptor and passes through unconverted in both methods.
# The new `base_power` kwarg reads the document's own field via `_resolve_base_power`,
# falling back to `get_base_power(refs)` when a producer omits it — same fallback the
# pre-existing conversion arithmetic already used.

function from_openapi(::Type{Area}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return Area(;
        name = po.name,
        peak_active_power = po.peak_active_power / get_base_power(refs),
        peak_reactive_power = po.peak_reactive_power / get_base_power(refs),
        load_response = po.load_response,
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(::Type{Area}, po, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(Area, po, refs, DU)
end

function from_openapi(::Type{LoadZone}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return LoadZone(;
        name = po.name,
        peak_active_power = po.peak_active_power / get_base_power(refs),
        peak_reactive_power = po.peak_reactive_power / get_base_power(refs),
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(::Type{LoadZone}, po, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(LoadZone, po, refs, DU)
end

# ── TransmissionInterface ───────────────────────────────────────────────────────
# SiennaSchemas Operations/Service/TransmissionInterface.json declares
# `active_power_flow_limits` (x-unit MW) as FIXED natural units — same shape as Area/
# LoadZone's peak fields above, divided by `get_base_power(refs)` in BOTH unit-system
# methods. `direction_mapping::Dict{String, Int}` is unclassifiable to the generator
# (not scalar/compound/reference/enum), which is what keeps this hand-written.
# `violation_penalty` has no `conversion_unit` and passes through unconverted in both.
# The new `base_power` kwarg mirrors Area/LoadZone's `_resolve_base_power` fallback.

function from_openapi(
    ::Type{TransmissionInterface},
    po,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    return TransmissionInterface(;
        name = po.name,
        available = po.available,
        active_power_flow_limits = _minmax_du(
            po.active_power_flow_limits,
            get_base_power(refs),
        ),
        violation_penalty = po.violation_penalty,
        direction_mapping = po.direction_mapping,
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(
    ::Type{TransmissionInterface},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(TransmissionInterface, po, refs, DU)
end

# ── Line ────────────────────────────────────────────────────────────────────────
# `r`/`x`/`b`/`g` are pu on system base in the document already (identity in both methods,
# matching every other schema-declared-pu field) — they need `base_voltage` for an
# impedance/admittance conversion, which `Line` does not carry (`TransformerCircuit` is the
# pattern for a device that does), and that is what keeps this hand-written now.
# `rating`/`rating_b`/`rating_c`/`active_power_flow`/`reactive_power_flow` are natural MVA/MW
# divided by the line's own `base_power`, now a real PSY field — only under `NaturalUnit`;
# `_resolve_base_power` falls back to `get_base_power(refs)` when a producer omits the field,
# same as Area/LoadZone/TransmissionInterface above.

function from_openapi(::Type{Line}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return Line(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow,
        reactive_power_flow = po.reactive_power_flow,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        b = _fromto(po.b),
        rating = po.rating,
        angle_limits = _minmax(po.angle_limits),
        rating_b = po.rating_b,
        rating_c = po.rating_c,
        g = _fromto(po.g),
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(::Type{Line}, po, refs::OpenAPIRefs, ::NaturalUnit)
    sbp = _resolve_base_power(refs, po.base_power)
    return Line(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow / sbp,
        reactive_power_flow = po.reactive_power_flow / sbp,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        b = _fromto(po.b),
        rating = po.rating / sbp,
        angle_limits = _minmax(po.angle_limits),
        rating_b = _scale_optional(po.rating_b, sbp),
        rating_c = _scale_optional(po.rating_c, sbp),
        g = _fromto(po.g),
        base_power = sbp,
    )
end

# ── TransformerCircuit ──────────────────────────────────────────────────────────
# `r`/`x` are pu on `base_power` when `parameter_units == "DEVICE_BASE"` — the only basis
# implemented, matching the reference; `NATURAL_UNITS` errors loudly rather than silently
# guessing at ohms-to-pu arithmetic this pass does not need.
# `rating`/`rating_b`/`rating_c`/`active_power_flow`/`reactive_power_flow` divide by the
# circuit's own `base_power` only under `NaturalUnit` (identical to what the
# generator produces for every other device-based type — verified by generating this field
# set for TransformerCircuit before the `α`/`alpha` mismatch was found).
const CIRCUIT_PARAM_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

"""One guard for every per-field unit-basis discriminator this pass has not implemented
arithmetic for: error loudly naming the field, value, and the implemented set, rather than
silently guessing (psy6 rule). `owner` is `" for <name>"` where the PO type has a name."""
function _check_unit_basis(value, implemented, field::AbstractString, owner::AbstractString)
    if value in implemented
        return nothing
    end
    error(
        "unmapped $field=$value$owner — only " *
        "$(join(sort!(collect(implemented)), " and ")) implemented",
    )
end

_check_circuit_param_units(po) = _check_unit_basis(
    po.parameter_units,
    CIRCUIT_PARAM_UNITS_IMPLEMENTED,
    "TransformerCircuit.parameter_units",
    "",
)

function from_openapi(
    ::Type{TransformerCircuit},
    po,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    _check_circuit_param_units(po)
    return TransformerCircuit(;
        available = po.available,
        arc = refs[po.arc],
        tap = po.tap,
        α = po.alpha,
        r = po.r,
        x = po.x,
        control_objective = TRANSFORMERCONTROLOBJECTIVE_FROM_STRING[po.control_objective],
        regulated_bus_number = po.regulated_bus_number,
        control_limits = _minmax(po.control_limits),
        controlled_quantity_limits = _minmax(po.controlled_quantity_limits),
        number_of_tap_positions = po.number_of_tap_positions,
        rating = po.rating,
        rating_b = po.rating_b,
        rating_c = po.rating_c,
        active_power_flow = po.active_power_flow,
        reactive_power_flow = po.reactive_power_flow,
        base_power = po.base_power,
        base_voltage_primary = po.base_voltage_primary,
        base_voltage_secondary = po.base_voltage_secondary,
    )
end

function from_openapi(
    ::Type{TransformerCircuit},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    _check_circuit_param_units(po)
    dbp = po.base_power
    return TransformerCircuit(;
        available = po.available,
        arc = refs[po.arc],
        tap = po.tap,
        α = po.alpha,
        r = po.r,
        x = po.x,
        control_objective = TRANSFORMERCONTROLOBJECTIVE_FROM_STRING[po.control_objective],
        regulated_bus_number = po.regulated_bus_number,
        control_limits = _minmax(po.control_limits),
        controlled_quantity_limits = _minmax(po.controlled_quantity_limits),
        number_of_tap_positions = po.number_of_tap_positions,
        rating = _scale_optional(po.rating, dbp),
        rating_b = _scale_optional(po.rating_b, dbp),
        rating_c = _scale_optional(po.rating_c, dbp),
        active_power_flow = po.active_power_flow / dbp,
        reactive_power_flow = po.reactive_power_flow / dbp,
        base_power = dbp,
        base_voltage_primary = po.base_voltage_primary,
        base_voltage_secondary = po.base_voltage_secondary,
    )
end

# ── TwoWindingTransformer ───────────────────────────────────────────────────────
# `magnetizing_shunt` is pu on the circuit's `base_power` when
# `admittance_units == "DEVICE_BASE"` — the only basis implemented, independent of the
# document's overall unit system (mirrors the reference and `TransformerCircuit`'s
# `parameter_units` guard above).
const SHUNT_ADMITTANCE_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

_check_shunt_admittance_units(po) = _check_unit_basis(
    po.admittance_units,
    SHUNT_ADMITTANCE_UNITS_IMPLEMENTED,
    "TwoWindingTransformer.admittance_units",
    " for $(po.name)",
)

function from_openapi(
    ::Type{TwoWindingTransformer},
    po,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    _check_shunt_admittance_units(po)
    return TwoWindingTransformer(;
        name = po.name,
        circuit = refs[po.circuit],
        magnetizing_shunt = _complex_number(po.magnetizing_shunt),
        shunt_location = TWOWINDINGTRANSFORMERSHUNTLOCATION_FROM_STRING[po.shunt_location],
    )
end

function from_openapi(
    ::Type{TwoWindingTransformer},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(TwoWindingTransformer, po, refs, DU)
end

# ── ThreeWindingTransformer ──────────────────────────────────────────────────────
# `magnetizing_shunt` follows TwoWindingTransformer's pattern exactly (pu on the primary
# circuit's `base_power`, `admittance_units` discriminator restricted to "DEVICE_BASE",
# identity in both document unit systems). The pairwise impedances r_12/x_12/r_23/x_23/
# r_31/x_31 have their own `parameter_units` discriminator (mirrors TransformerCircuit's) —
# also restricted to "DEVICE_BASE", under which PSY stores them exactly as pu, so they pass
# through unconverted; `base_power_12`/`_23`/`_31` are base values themselves, not
# unit-converted quantities, and also pass through directly. All are nullable together
# (`check_psse_pairwise_block`), but DEVICE_BASE performs no arithmetic on them so no
# nothing-guard is needed. `primary_circuit`/`secondary_circuit`/`tertiary_circuit`/`star_bus`
# resolve through `refs`, matching `TwoWindingTransformer.circuit`.
const THREEWINDINGTRANSFORMERSHUNTLOCATION_FROM_STRING =
    Dict{String, ThreeWindingTransformerShuntLocation}(
        string(m) => m for m in instances(ThreeWindingTransformerShuntLocation)
    )

const THREEWINDING_PARAM_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])
_check_three_winding_param_units(po) = _check_unit_basis(
    po.parameter_units,
    THREEWINDING_PARAM_UNITS_IMPLEMENTED,
    "ThreeWindingTransformer.parameter_units",
    " for $(po.name)",
)

const THREEWINDING_SHUNT_ADMITTANCE_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])
_check_three_winding_shunt_admittance_units(po) = _check_unit_basis(
    po.admittance_units,
    THREEWINDING_SHUNT_ADMITTANCE_UNITS_IMPLEMENTED,
    "ThreeWindingTransformer.admittance_units",
    " for $(po.name)",
)

function from_openapi(
    ::Type{ThreeWindingTransformer},
    po,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    _check_three_winding_param_units(po)
    _check_three_winding_shunt_admittance_units(po)
    return ThreeWindingTransformer(;
        name = po.name,
        primary_circuit = refs[po.primary_circuit],
        secondary_circuit = refs[po.secondary_circuit],
        tertiary_circuit = refs[po.tertiary_circuit],
        star_bus = refs[po.star_bus],
        r_12 = po.r_12,
        x_12 = po.x_12,
        r_23 = po.r_23,
        x_23 = po.x_23,
        r_31 = po.r_31,
        x_31 = po.x_31,
        base_power_12 = po.base_power_12,
        base_power_23 = po.base_power_23,
        base_power_31 = po.base_power_31,
        magnetizing_shunt = _complex_number(po.magnetizing_shunt),
        shunt_location = THREEWINDINGTRANSFORMERSHUNTLOCATION_FROM_STRING[po.shunt_location],
    )
end

function from_openapi(
    ::Type{ThreeWindingTransformer},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(ThreeWindingTransformer, po, refs, DU)
end

# ── FixedAdmittance ───────────────────────────────────────────────────────────────
# `Y`'s basis is the per-field `admittance_units` discriminator, independent of the
# document's own unit_system — same pattern as TwoWindingTransformer.magnetizing_shunt
# above. A shunt has no device MVA rating of its own, so `ShuntAdmittanceUnitBasis` is
# `NATURAL_UNITS`/`DEVICE_MVAR` only. `DEVICE_MVAR` (PSS/E RAW native — the RTS-GMLC-0.2.3
# real-world convention, and what PowerTableDataParser emits) is MVAr at unity voltage and
# divides by the document-level `refs.base_power`, the same fallback Area/LoadZone peaks and
# reserve requirements use, to land on PSY's system-base pu storage. `NATURAL_UNITS`
# (physical siemens, needing the bus's own `Z_base`) is not implemented — no RTS-scope case
# needs it, same posture as `SHUNT_ADMITTANCE_UNITS_IMPLEMENTED` above.
const FIXED_ADMITTANCE_UNITS_IMPLEMENTED = Set(["DEVICE_MVAR"])

_check_fixed_admittance_units(po) = _check_unit_basis(
    po.admittance_units,
    FIXED_ADMITTANCE_UNITS_IMPLEMENTED,
    "FixedAdmittance.admittance_units",
    " for $(po.name)",
)

_fixed_admittance_pu(po, refs::OpenAPIRefs) =
    _complex_number(po.Y) / get_base_power(refs)

function from_openapi(::Type{FixedAdmittance}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_fixed_admittance_units(po)
    return FixedAdmittance(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        Y = _fixed_admittance_pu(po, refs),
    )
end

function from_openapi(
    ::Type{FixedAdmittance},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(FixedAdmittance, po, refs, DU)
end

# ── HydroReservoir ──────────────────────────────────────────────────────────────
# Volumetric/energy fields (`inflow`, `outflow`, `storage_level_limits`) have no
# `display_units_arg`/`get_value` machinery on the PSY side and pass through in whatever
# unit `level_data_type` declares — identical in both unit-system methods.
# `initial_level`/`level_targets` are the one real conversion: absolute on that same basis
# in the document, fraction-of-`storage_level_limits.max` in PSY — semantic, not a unit
# conversion, so also identical in both methods.
# `operation_cost` is converted via `convert_cost`, rather than fabricated as a placeholder
# when missing.

function from_openapi(::Type{HydroReservoir}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    max_level = po.storage_level_limits.max
    return HydroReservoir(;
        name = po.name,
        available = po.available,
        storage_level_limits = _minmax(po.storage_level_limits),
        initial_level = _level_fraction(po.initial_level, max_level),
        spillage_limits = _opt_minmax(po.spillage_limits),
        inflow = po.inflow,
        outflow = po.outflow,
        level_targets = _level_fraction(po.level_targets, max_level),
        intake_elevation = po.intake_elevation,
        head_to_volume_factor = convert_cost(po.head_to_volume_factor),
        evaporative_loss = po.evaporative_loss,
        upstream_turbines = _hydro_units(refs, po.upstream_turbines),
        downstream_turbines = _hydro_units(refs, po.downstream_turbines),
        upstream_reservoirs = _reservoir_devices(refs, po.upstream_reservoirs),
        operation_cost = convert_cost(po.operation_cost),
        level_data_type = RESERVOIRDATATYPE_FROM_STRING[po.level_data_type],
    )
end

function from_openapi(::Type{HydroReservoir}, po, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(HydroReservoir, po, refs, DU)
end

# ── EnergyReservoirStorage ──────────────────────────────────────────────────────
# `storage_capacity` is energy (MWh when `energy_units == "MWH"`, the only basis
# implemented) but still divides by `base_power` under `NaturalUnit` — the
# duration-in-hours convention PSY documents for this field, same rule as every other
# `:mva`-tagged field. `storage_level_limits`, `initial_storage_capacity_level`,
# `efficiency`, `conversion_factor`, `storage_target`, `self_discharge` are dimensionless
# ratios and pass through in both methods.
const ENERGY_UNITS_IMPLEMENTED = Set(["MWH"])

_check_energy_units(po) = _check_unit_basis(
    po.energy_units,
    ENERGY_UNITS_IMPLEMENTED,
    "EnergyReservoirStorage.energy_units",
    " for $(po.name)",
)

function from_openapi(
    ::Type{EnergyReservoirStorage},
    po,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    _check_energy_units(po)
    return EnergyReservoirStorage(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        prime_mover_type = PRIME_MOVERS_FROM_STRING[po.prime_mover_type],
        storage_technology_type = STORAGETECH_FROM_STRING[po.storage_technology_type],
        storage_capacity = po.storage_capacity,
        storage_level_limits = _minmax(po.storage_level_limits),
        initial_storage_capacity_level = po.initial_storage_capacity_level,
        rating = po.rating,
        active_power = po.active_power,
        input_active_power_limits = _minmax(po.input_active_power_limits),
        output_active_power_limits = _minmax(po.output_active_power_limits),
        efficiency = _inout(po.efficiency),
        reactive_power = po.reactive_power,
        reactive_power_limits = _opt_minmax(po.reactive_power_limits),
        base_power = po.base_power,
        operation_cost = convert_cost(po.operation_cost),
        conversion_factor = po.conversion_factor,
        storage_target = po.storage_target,
        cycle_limits = po.cycle_limits,
        ramp_limits = _opt_updown(po.ramp_limits),
        self_discharge = po.self_discharge,
        standing_loss = po.standing_loss,
    )
end

function from_openapi(
    ::Type{EnergyReservoirStorage},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    _check_energy_units(po)
    dbp = po.base_power
    return EnergyReservoirStorage(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        prime_mover_type = PRIME_MOVERS_FROM_STRING[po.prime_mover_type],
        storage_technology_type = STORAGETECH_FROM_STRING[po.storage_technology_type],
        storage_capacity = po.storage_capacity / dbp,
        storage_level_limits = _minmax(po.storage_level_limits),
        initial_storage_capacity_level = po.initial_storage_capacity_level,
        rating = po.rating / dbp,
        active_power = po.active_power / dbp,
        input_active_power_limits = _minmax_du(po.input_active_power_limits, dbp),
        output_active_power_limits = _minmax_du(po.output_active_power_limits, dbp),
        efficiency = _inout(po.efficiency),
        reactive_power = po.reactive_power / dbp,
        reactive_power_limits = _minmax_du(po.reactive_power_limits, dbp),
        base_power = dbp,
        operation_cost = convert_cost(po.operation_cost),
        conversion_factor = po.conversion_factor,
        storage_target = po.storage_target,
        cycle_limits = po.cycle_limits,
        ramp_limits = _updown_du(po.ramp_limits, dbp),
        self_discharge = po.self_discharge,
        standing_loss = po.standing_loss / dbp,
    )
end

# ── TwoTerminalGenericHVDCLine ──────────────────────────────────────────────────
# `loss::Union{LinearCurve, PiecewiseIncrementalCurve}` is a Union of two concrete curve
# types, not the generator's `Union{Nothing, X}` nullable pattern — unclassifiable, and what
# keeps this hand-written. The struct gained its own `base_power` field. `_resolve_base_power`
# falls back to `get_base_power(refs)` when a producer omits the new field, same as Area/LoadZone/
# TransmissionInterface/Line above. `loss` has no `display_units_arg`/`get_value` machinery
# on the PSY side (its docstring gives the constant term in physical MW directly) and passes
# through unconverted in both methods.

_linear_curve_from_function_data(fd::PC.LinearFunctionData) =
    LinearCurve(fd.proportional_term, fd.constant_term)
_linear_curve_from_function_data(fd) =
    error("unmapped TwoTerminalLoss FunctionData variant: $(typeof(fd))")

_hvdc_loss_curve(c::PC.InputOutputCurve) =
    _linear_curve_from_function_data(c.function_data.value)
_hvdc_loss_curve(c) = error("unmapped TwoTerminalLoss variant: $(typeof(c))")

_hvdc_loss(l::PC.TwoTerminalLoss) = _hvdc_loss_curve(l.value)

function from_openapi(
    ::Type{TwoTerminalGenericHVDCLine},
    po,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    return TwoTerminalGenericHVDCLine(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow,
        arc = refs[po.arc],
        active_power_limits_from = _minmax(po.active_power_limits_from),
        active_power_limits_to = _minmax(po.active_power_limits_to),
        reactive_power_limits_from = _minmax(po.reactive_power_limits_from),
        reactive_power_limits_to = _minmax(po.reactive_power_limits_to),
        loss = _hvdc_loss(po.loss),
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(
    ::Type{TwoTerminalGenericHVDCLine},
    po,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    sbp = _resolve_base_power(refs, po.base_power)
    return TwoTerminalGenericHVDCLine(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow / sbp,
        arc = refs[po.arc],
        active_power_limits_from = _minmax_du(po.active_power_limits_from, sbp),
        active_power_limits_to = _minmax_du(po.active_power_limits_to, sbp),
        reactive_power_limits_from = _minmax_du(po.reactive_power_limits_from, sbp),
        reactive_power_limits_to = _minmax_du(po.reactive_power_limits_to, sbp),
        loss = _hvdc_loss(po.loss),
        base_power = sbp,
    )
end

# ── Reserves: OnlineReserve, OfflineReserve, GroupReserve ───────────────────────
# The parametric case: `reserve_direction` is a document enum property while PSY encodes it
# as a type parameter, resolved through a literal table (direction is not a codegen case).
# `requirement` is the one converted field: MW in the document, system-base pu in PSY,
# divided by the document-level `refs.base_power` — a reserve has no device base of its own,
# same fallback `TwoTerminalGenericHVDCLine` uses. `variable` (the Operating Reserve Demand
# Curve) goes through `convert_reserve_variable` (already handles the `nothing` →
# `ZERO_OFFER_CURVE` default).

function from_openapi(::Type{OnlineReserve}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    direction = _resolve_reserve_direction(po.reserve_direction, po.name)
    return OnlineReserve{direction}(;
        name = po.name,
        available = po.available,
        time_frame = po.time_frame,
        requirement = po.requirement,
        variable = convert_reserve_variable(po.variable),
        sustained_time = po.sustained_time,
        max_output_fraction = po.max_output_fraction,
        max_participation_factor = po.max_participation_factor,
        deployed_fraction = po.deployed_fraction,
    )
end

function from_openapi(::Type{OnlineReserve}, po, refs::OpenAPIRefs, ::NaturalUnit)
    direction = _resolve_reserve_direction(po.reserve_direction, po.name)
    return OnlineReserve{direction}(;
        name = po.name,
        available = po.available,
        time_frame = po.time_frame,
        requirement = po.requirement / get_base_power(refs),
        variable = convert_reserve_variable(po.variable),
        sustained_time = po.sustained_time,
        max_output_fraction = po.max_output_fraction,
        max_participation_factor = po.max_participation_factor,
        deployed_fraction = po.deployed_fraction,
    )
end

function from_openapi(::Type{OfflineReserve}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return OfflineReserve(;
        name = po.name,
        available = po.available,
        time_frame = po.time_frame,
        requirement = po.requirement,
        variable = convert_reserve_variable(po.variable),
        sustained_time = po.sustained_time,
        max_output_fraction = po.max_output_fraction,
        max_participation_factor = po.max_participation_factor,
        deployed_fraction = po.deployed_fraction,
    )
end

function from_openapi(::Type{OfflineReserve}, po, refs::OpenAPIRefs, ::NaturalUnit)
    return OfflineReserve(;
        name = po.name,
        available = po.available,
        time_frame = po.time_frame,
        requirement = po.requirement / get_base_power(refs),
        variable = convert_reserve_variable(po.variable),
        sustained_time = po.sustained_time,
        max_output_fraction = po.max_output_fraction,
        max_participation_factor = po.max_participation_factor,
        deployed_fraction = po.deployed_fraction,
    )
end

function from_openapi(::Type{GroupReserve}, po, refs::OpenAPIRefs, ::DeviceBaseUnit)
    direction = _resolve_reserve_direction(po.reserve_direction, po.name)
    return GroupReserve{direction}(;
        name = po.name,
        available = po.available,
        requirement = po.requirement,
    )
end

function from_openapi(::Type{GroupReserve}, po, refs::OpenAPIRefs, ::NaturalUnit)
    direction = _resolve_reserve_direction(po.reserve_direction, po.name)
    return GroupReserve{direction}(;
        name = po.name,
        available = po.available,
        requirement = po.requirement / get_base_power(refs),
    )
end
