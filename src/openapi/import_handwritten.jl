# `from_openapi` methods for the PO/PSY type pairs the IS generator cannot emit. Each was tried
# through the generator first; what blocks each one:
#
#   Arc                          abstract `Bus` field type; PO names `from_id`/`to_id` differ
#   Area, LoadZone               peak power is schema-fixed-natural, not unit-system-dependent
#   TransmissionInterface        `direction_mapping::Dict{String, Int}` unclassifiable
#   Line                         `r`/`x`/`b`/`g` need a `base_voltage` the struct does not carry
#   TwoTerminalGenericHVDCLine   `loss` is a Union of two curve types, not `Union{Nothing, X}`
#   TransformerCircuit           PSY field `α` vs PO field `alpha`
#   TwoWindingTransformer        `magnetizing_shunt::Complex{Float64}` unclassifiable
#   ThreeWindingTransformer      same, plus three `TransformerCircuit` references
#   FixedAdmittance              `Y::Complex{Float64}` unclassifiable
#   HydroReservoir               `Vector{HydroUnit}`/`Vector{Device}` fields; fraction conversion
#   EnergyReservoirStorage       `efficiency` spelled out instead of the `InOut` alias
#   Online/Offline/GroupReserve  parametric structs, which the generator rejects outright

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

"""Resolve a component's own per-unitization `base_power` from the document, falling back to
the document-level system base when the producer omits it. `Area`/`LoadZone`/
`TransmissionInterface`/`Line`/`TwoTerminalGenericHVDCLine` each carry their own `base_power`
and it is schema-`required` going forward, but a producer may still omit it; for these five
types the system base is numerically identical by construction. Do not weaken this to a
general nothing-skip guard elsewhere."""
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

function from_openapi(po::PO.Arc, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return Arc(; from = refs[po.from_id], to = refs[po.to_id])
end

function from_openapi(po::PO.Arc, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(po, refs, DU)
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

function from_openapi(po::PO.Area, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return Area(;
        name = po.name,
        peak_active_power = po.peak_active_power / get_base_power(refs),
        peak_reactive_power = po.peak_reactive_power / get_base_power(refs),
        load_response = po.load_response,
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(po::PO.Area, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(po, refs, DU)
end

function from_openapi(po::PO.LoadZone, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return LoadZone(;
        name = po.name,
        peak_active_power = po.peak_active_power / get_base_power(refs),
        peak_reactive_power = po.peak_reactive_power / get_base_power(refs),
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(po::PO.LoadZone, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(po, refs, DU)
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
    po::PO.TransmissionInterface,
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
    po::PO.TransmissionInterface,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(po, refs, DU)
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

function from_openapi(po::PO.Line, refs::OpenAPIRefs, ::DeviceBaseUnit)
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

function from_openapi(po::PO.Line, refs::OpenAPIRefs, ::NaturalUnit)
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

# ── MonitoredLine ───────────────────────────────────────────────────────────────
# Same posture as `Line` directly above, field for field, plus `flow_limits`: `r`/`x`/`b`/`g`
# are already pu on the line's base and pass through in both methods (no `base_voltage` to
# build Zbase from), the MVA/MW fields divide by `_resolve_base_power`, and `angle_limits` is
# radians with no conversion. `flow_limits` is the one field `Line` does not have — a
# `FromTo_ToFrom` of natural MVA, so it scales with the same base as `rating`.

_fromto_toframe(m) = (from_to = Float64(m.from_to), to_from = Float64(m.to_from))
_fromto_toframe_du(m, base) =
    (from_to = Float64(m.from_to) / base, to_from = Float64(m.to_from) / base)

function from_openapi(po::PO.MonitoredLine, refs::OpenAPIRefs, ::DeviceBaseUnit)
    return MonitoredLine(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow,
        reactive_power_flow = po.reactive_power_flow,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        b = _fromto(po.b),
        flow_limits = _fromto_toframe(po.flow_limits),
        rating = po.rating,
        angle_limits = _minmax(po.angle_limits),
        rating_b = po.rating_b,
        rating_c = po.rating_c,
        g = _fromto(po.g),
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(po::PO.MonitoredLine, refs::OpenAPIRefs, ::NaturalUnit)
    sbp = _resolve_base_power(refs, po.base_power)
    return MonitoredLine(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow / sbp,
        reactive_power_flow = po.reactive_power_flow / sbp,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        b = _fromto(po.b),
        flow_limits = _fromto_toframe_du(po.flow_limits, sbp),
        rating = po.rating / sbp,
        angle_limits = _minmax(po.angle_limits),
        rating_b = _scale_optional(po.rating_b, sbp),
        rating_c = _scale_optional(po.rating_c, sbp),
        g = _fromto(po.g),
        base_power = sbp,
    )
end

# ── GenericArcImpedance ─────────────────────────────────────────────────────────
# `r`/`x` pass through for the same reason as `Line`'s: the descriptor tags them `:ohm` for
# the general getter/setter machinery, but the type carries no `base_voltage` to build Zbase
# from. Unlike `Line`, this type states the basis it was written in rather than leaving it
# implicit, so the discriminator is checked instead of assumed — "DEVICE_BASE" is the only
# basis with arithmetic here, and any other value errors rather than being silently treated
# as pu.

const GENERIC_ARC_PARAM_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

_check_generic_arc_param_units(po) = _check_unit_basis(
    po.parameter_units,
    GENERIC_ARC_PARAM_UNITS_IMPLEMENTED,
    "GenericArcImpedance.parameter_units",
    " for $(po.name)",
)

function from_openapi(po::PO.GenericArcImpedance, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_generic_arc_param_units(po)
    return GenericArcImpedance(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow,
        reactive_power_flow = po.reactive_power_flow,
        max_flow = po.max_flow,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(po::PO.GenericArcImpedance, refs::OpenAPIRefs, ::NaturalUnit)
    _check_generic_arc_param_units(po)
    sbp = _resolve_base_power(refs, po.base_power)
    return GenericArcImpedance(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow / sbp,
        reactive_power_flow = po.reactive_power_flow / sbp,
        max_flow = po.max_flow / sbp,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        base_power = sbp,
    )
end

# ── DiscreteControlledACBranch ───────────────────────────────────────────────────
# Same posture as `Line`: the PSY descriptor tags `r`/`x` `needs_conversion`/`:ohm` for the
# general SU/DU/NU getter/setter machinery, but neither the struct nor the document carries a
# companion `base_voltage` to compute Zbase from — the PO field's own docstring says `r`/`x`
# are already "per-unit on base_power" — so, like `Line`, both pass through unconverted here
# regardless of unit_system. `base_power` on this type is documented as "System base power ...
# recorded per component in lieu of a system-level table" — the same schema pattern as
# `Line`/`Area`/`LoadZone`/`TwoTerminalGenericHVDCLine`, not a genuine per-device rating — so
# `active_power_flow`/`reactive_power_flow`/`rating` divide by `_resolve_base_power`
# (falling back to the document system base if a producer omits the field) exactly like Line,
# rather than trusting `po.base_power` blindly.

function from_openapi(
    po::PO.DiscreteControlledACBranch,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    return DiscreteControlledACBranch(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow,
        reactive_power_flow = po.reactive_power_flow,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        rating = po.rating,
        discrete_branch_type = DiscreteControlledBranchType(po.discrete_branch_type),
        branch_status = DiscreteControlledBranchStatus(po.branch_status),
        normal_branch_status = DiscreteControlledBranchStatus(po.normal_branch_status),
        base_power = _resolve_base_power(refs, po.base_power),
    )
end

function from_openapi(
    po::PO.DiscreteControlledACBranch,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    bp = _resolve_base_power(refs, po.base_power)
    return DiscreteControlledACBranch(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow / bp,
        reactive_power_flow = po.reactive_power_flow / bp,
        arc = refs[po.arc],
        r = po.r,
        x = po.x,
        rating = po.rating / bp,
        discrete_branch_type = DiscreteControlledBranchType(po.discrete_branch_type),
        branch_status = DiscreteControlledBranchStatus(po.branch_status),
        normal_branch_status = DiscreteControlledBranchStatus(po.normal_branch_status),
        base_power = bp,
    )
end

# ── TransformerCircuit ──────────────────────────────────────────────────────────
# `r`/`x` are pu on `base_power` when `parameter_units == "DEVICE_BASE"` — the only basis
# implemented; `NATURAL_UNITS` errors loudly rather than silently guessing at ohms-to-pu
# arithmetic. `rating`/`rating_b`/`rating_c`/`active_power_flow`/`reactive_power_flow` divide
# by the circuit's own `base_power` only under `NaturalUnit`, as for every other device-based
# type.
const CIRCUIT_PARAM_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

"""One guard for every per-field unit-basis discriminator with no implemented arithmetic:
error loudly naming the field, value, and the implemented set, rather than silently guessing
(psy6 rule). `owner` is `" for <name>"` where the PO type has a name."""
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
    po::PO.TransformerCircuit,
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
        control_objective = TransformerControlObjective(po.control_objective),
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
    po::PO.TransformerCircuit,
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
        control_objective = TransformerControlObjective(po.control_objective),
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
    po::PO.TwoWindingTransformer,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    _check_shunt_admittance_units(po)
    return TwoWindingTransformer(;
        name = po.name,
        circuit = refs[po.circuit],
        magnetizing_shunt = _complex_number(po.magnetizing_shunt),
        shunt_location = TwoWindingTransformerShuntLocation(po.shunt_location),
    )
end

function from_openapi(
    po::PO.TwoWindingTransformer,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(po, refs, DU)
end

# ── ThreeWindingTransformer ──────────────────────────────────────────────────────
# `magnetizing_shunt` follows TwoWindingTransformer's pattern exactly (pu on the primary
# circuit's `base_power`, `admittance_units` discriminator restricted to "DEVICE_BASE",
# identity in both document unit systems). The pairwise impedances r_12/x_12/r_23/x_23/
# r_31/x_31 have their own `parameter_units` discriminator (mirrors TransformerCircuit's) —
# also restricted to "DEVICE_BASE", under which PSY stores them exactly as pu, so they pass
# through unconverted; `base_power_12`/`_23`/`_31` are base values themselves, not
# unit-converted quantities, and also pass through directly. All are nullable together
# (`check_pairwise_impedance_block`), but DEVICE_BASE performs no arithmetic on them so no
# nothing-guard is needed. `primary_circuit`/`secondary_circuit`/`tertiary_circuit`/`star_bus`
# resolve through `refs`, matching `TwoWindingTransformer.circuit`.

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
    po::PO.ThreeWindingTransformer,
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
        shunt_location = ThreeWindingTransformerShuntLocation(po.shunt_location),
    )
end

function from_openapi(
    po::PO.ThreeWindingTransformer,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(po, refs, DU)
end

# ── FixedAdmittance ───────────────────────────────────────────────────────────────
# `Y`'s basis is the per-field `admittance_units` discriminator, independent of the
# document's own unit_system — same pattern as TwoWindingTransformer.magnetizing_shunt
# above. A shunt has no device MVA rating of its own, so `ShuntAdmittanceUnitBasis` is
# `NATURAL_UNITS`/`DEVICE_MVAR` only. `DEVICE_MVAR` is MVAr at unity voltage and divides by
# the document-level `refs.base_power`, the same fallback Area/LoadZone peaks and reserve
# requirements use, to land on PSY's system-base pu storage. `NATURAL_UNITS` (physical
# siemens, needing the bus's own `Z_base`) is not implemented, same posture as
# `SHUNT_ADMITTANCE_UNITS_IMPLEMENTED` above.
const FIXED_ADMITTANCE_UNITS_IMPLEMENTED = Set(["DEVICE_MVAR"])

_check_fixed_admittance_units(po) = _check_unit_basis(
    po.admittance_units,
    FIXED_ADMITTANCE_UNITS_IMPLEMENTED,
    "FixedAdmittance.admittance_units",
    " for $(po.name)",
)

_fixed_admittance_pu(po, refs::OpenAPIRefs) =
    _complex_number(po.Y) / get_base_power(refs)

function from_openapi(po::PO.FixedAdmittance, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_fixed_admittance_units(po)
    return FixedAdmittance(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        Y = _fixed_admittance_pu(po, refs),
    )
end

function from_openapi(
    po::PO.FixedAdmittance,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(po, refs, DU)
end

# ── SwitchedAdmittance ────────────────────────────────────────────────────────────
# `Y`/`Y_increase` are the same fixed-natural DEVICE_MVAR-on-system-base quantity as
# `FixedAdmittance.Y` (device_base.jl's `_DEVICEBASE_INSTANCE_DISPATCHED` lists both
# `:skip`, identical treatment) — divided by the document's system base regardless of
# `unit_system`, so the `NaturalUnit` method delegates to `DeviceBaseUnit` exactly like
# `FixedAdmittance`. `admittance_limits` is a dimensionless multiplier bound on `Y`
# (default `(min=1, max=1)`), not a raw admittance, and `initial_status`/`number_of_steps`
# are per-block integer counts — none of the three need a unit conversion.
const SWITCHED_ADMITTANCE_UNITS_IMPLEMENTED = Set(["DEVICE_MVAR"])

_check_switched_admittance_units(po) = _check_unit_basis(
    po.admittance_units,
    SWITCHED_ADMITTANCE_UNITS_IMPLEMENTED,
    "SwitchedAdmittance.admittance_units",
    " for $(po.name)",
)

_switched_admittance_y_increase(values, base_power) =
    [_complex_number(v) / base_power for v in values]

function from_openapi(po::PO.SwitchedAdmittance, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_switched_admittance_units(po)
    base_power = get_base_power(refs)
    return SwitchedAdmittance(;
        name = po.name,
        available = po.available,
        bus = resolve_ref(refs, po.bus),
        Y = _complex_number(po.Y) / base_power,
        initial_status = po.initial_status,
        number_of_steps = po.number_of_steps,
        Y_increase = _switched_admittance_y_increase(po.Y_increase, base_power),
        admittance_limits = _minmax(po.admittance_limits),
        control_mode = SwitchedAdmittanceControlMode(po.control_mode),
        regulated_bus_number = po.regulated_bus_number,
    )
end

function from_openapi(
    po::PO.SwitchedAdmittance,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    return from_openapi(po, refs, DU)
end

# ── FACTSControlDevice ────────────────────────────────────────────────────────────
# `base_power` is a first-class field on this type (like `PowerLoad`'s), giving it an explicit
# per-unitization base instead of silently borrowing the System's. The schema does not yet
# carry it, so import falls back to the document's own system base via `get_base_power(refs)`;
# once a document declares one, this reads `po.base_power` directly, same as `PowerLoad`.
# `max_shunt_current`/`max_reactive_power` (both MVA, declared `SU` on the PSY side) divide by
# whatever base is resolved. `voltage_setpoint` is pu on system base per PSY's own docstring;
# only `voltage_setpoint_units == "DEVICE_BASE"` is implemented — `NATURAL_UNITS` (kV) would
# need a bus base-voltage conversion no current producer exercises, so it errors loudly rather
# than guessing. `reactive_power_required` (a dimensionless 0-1 fraction per the PO schema) and
# `control_mode`/`shunt_control_type` (enums) pass through / map without scaling.

const FACTS_VOLTAGE_SETPOINT_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

_check_facts_voltage_setpoint_units(po) = _check_unit_basis(
    po.voltage_setpoint_units,
    FACTS_VOLTAGE_SETPOINT_UNITS_IMPLEMENTED,
    "FACTSControlDevice.voltage_setpoint_units",
    " for $(po.name)",
)

function from_openapi(po::PO.FACTSControlDevice, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_facts_voltage_setpoint_units(po)
    base_power = get_base_power(refs)
    return FACTSControlDevice(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        control_mode = if isnothing(po.control_mode)
            nothing
        else
            FACTSOperationModes(po.control_mode)
        end,
        voltage_setpoint = po.voltage_setpoint,
        max_shunt_current = po.max_shunt_current / base_power,
        max_reactive_power = po.max_reactive_power / base_power,
        shunt_control_type = FACTSShuntControlType(po.shunt_control_type),
        regulated_bus_number = po.regulated_bus_number,
        reactive_power_required = po.reactive_power_required,
    )
end

function from_openapi(po::PO.FACTSControlDevice, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(po, refs, DU)
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

function from_openapi(po::PO.HydroReservoir, refs::OpenAPIRefs, ::DeviceBaseUnit)
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
        level_data_type = ReservoirDataType(po.level_data_type),
    )
end

function from_openapi(po::PO.HydroReservoir, refs::OpenAPIRefs, ::NaturalUnit)
    return from_openapi(po, refs, DU)
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
    po::PO.EnergyReservoirStorage,
    refs::OpenAPIRefs,
    ::DeviceBaseUnit,
)
    _check_energy_units(po)
    return EnergyReservoirStorage(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        prime_mover_type = PrimeMovers(po.prime_mover_type),
        storage_technology_type = StorageTech(po.storage_technology_type),
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
    po::PO.EnergyReservoirStorage,
    refs::OpenAPIRefs,
    ::NaturalUnit,
)
    _check_energy_units(po)
    dbp = po.base_power
    return EnergyReservoirStorage(;
        name = po.name,
        available = po.available,
        bus = refs[po.bus],
        prime_mover_type = PrimeMovers(po.prime_mover_type),
        storage_technology_type = StorageTech(po.storage_technology_type),
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

# A `oneOf` field holds its member wrapped only after deserialization; a document built in
# memory assigns the member directly. Unwrap by dispatch, the way `convert_cost` does
# (`cost_conversion.jl`), so both shapes read the same.
_unwrap_oneof(x::OpenAPI.OneOfAPIModel) = _unwrap_oneof(x.value)
_unwrap_oneof(x) = x

_linear_curve_from_function_data(fd::PC.LinearFunctionData) =
    LinearCurve(fd.proportional_term, fd.constant_term)
_linear_curve_from_function_data(fd) =
    error("unmapped TwoTerminalLoss FunctionData variant: $(typeof(fd))")

_hvdc_loss_curve(c::PC.InputOutputCurve) =
    _linear_curve_from_function_data(_unwrap_oneof(c.function_data))
_hvdc_loss_curve(c) = error("unmapped TwoTerminalLoss variant: $(typeof(c))")

_hvdc_loss(l::PC.TwoTerminalLoss) = _hvdc_loss_curve(_unwrap_oneof(l))

function from_openapi(
    po::PO.TwoTerminalGenericHVDCLine,
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
    po::PO.TwoTerminalGenericHVDCLine,
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

# ── TwoTerminalLCCLine ────────────────────────────────────────────────────────────
# `parameter_units`/`dc_voltage_units` are always "NATURAL_UNITS" for every current producer
# (fixed ohm/kV regardless of the document's overall unit_system, the mirror image of
# TwoWindingTransformer's always-"DEVICE_BASE" fields) — only
# that basis is implemented; "DEVICE_BASE" errors loudly rather than guessing. Because that
# representation is fixed, `r`/`rectifier_rc`/`rectifier_xc`/`rectifier_capacitor_reactance`/
# `inverter_rc`/`inverter_xc`/`inverter_capacitor_reactance`/`compounding_resistance` need the
# SAME ohm-to-pu conversion in BOTH `DeviceBaseUnit`/`NaturalUnit` methods (the Area/LoadZone
# pattern above) — only the genuinely document-unit-system-governed power fields
# (`active_power_flow`, `active_power_limits_*`, `reactive_power_limits_*`, and
# `transfer_setpoint` when `power_mode` selects its `ActivePower` branch) differ between them.
#
# PROVISIONAL, per explicit direction (2026-08-10) — may need revision: `r` and
# `compounding_resistance` are DC-line quantities with no dedicated DC base voltage field to
# compute Zbase from (unlike the rectifier/inverter AC-side trios, which clearly belong to
# `rectifier_base_voltage`/`inverter_base_voltage`). The schema carries
# `scheduled_dc_voltage` (kV) and `r` (ohms) with no documented transformation between them;
# this uses `Zbase = scheduled_dc_voltage^2 / base_power` as the best available convention.
# Revisit if a canonical formula for this specific pair surfaces later.
#
# `scheduled_dc_voltage`/`switch_mode_voltage`/`min_compounding_voltage`/
# `rectifier_base_voltage`/`inverter_base_voltage` are stored as physical kV on the PSY side
# (docstrings say "in kV" directly, no pu machinery) and pass through unconverted. Angles,
# bridge counts, tap ratios/settings/limits/steps, and `power_mode` are dimensionless/radians
# and pass through in both methods. `loss` reuses `TwoTerminalGenericHVDCLine`'s helper — same
# PSY field type.

const TWO_TERMINAL_LCC_PARAMETER_UNITS_IMPLEMENTED = Set(["NATURAL_UNITS"])
const TWO_TERMINAL_LCC_DC_VOLTAGE_UNITS_IMPLEMENTED = Set(["NATURAL_UNITS"])

_check_lcc_parameter_units(po) = _check_unit_basis(
    po.parameter_units,
    TWO_TERMINAL_LCC_PARAMETER_UNITS_IMPLEMENTED,
    "TwoTerminalLCCLine.parameter_units",
    " for $(po.name)",
)

_check_lcc_dc_voltage_units(po) = _check_unit_basis(
    po.dc_voltage_units,
    TWO_TERMINAL_LCC_DC_VOLTAGE_UNITS_IMPLEMENTED,
    "TwoTerminalLCCLine.dc_voltage_units",
    " for $(po.name)",
)

"""Ohms → pu via `Zbase = base_voltage^2 / base_power` (`base_voltage` in kV, `base_power` in
MVA)."""
_lcc_ohm_to_pu(ohms, base_voltage, base_power) = ohms / (base_voltage^2 / base_power)

"""`transfer_setpoint` follows `power_mode`: MW (`ActivePower`, divides like every sibling
power field) when `true`, Amperes (`CurrentFlow`, no power-base conversion exists) when
`false`."""
_lcc_transfer_setpoint(transfer_setpoint, ::Val{true}, base_power) =
    transfer_setpoint / base_power
_lcc_transfer_setpoint(transfer_setpoint, ::Val{false}, _base_power) = transfer_setpoint

function from_openapi(po::PO.TwoTerminalLCCLine, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_lcc_parameter_units(po)
    _check_lcc_dc_voltage_units(po)
    base_power = po.base_power
    return TwoTerminalLCCLine(;
        name = po.name,
        available = po.available,
        arc = refs[po.arc],
        active_power_flow = po.active_power_flow,
        r = _lcc_ohm_to_pu(po.r, po.scheduled_dc_voltage, base_power),
        transfer_setpoint = po.transfer_setpoint,
        scheduled_dc_voltage = po.scheduled_dc_voltage,
        rectifier_bridges = po.rectifier_bridges,
        rectifier_delay_angle_limits = _minmax(po.rectifier_delay_angle_limits),
        rectifier_rc = _lcc_ohm_to_pu(
            po.rectifier_rc,
            po.rectifier_base_voltage,
            base_power,
        ),
        rectifier_xc = _lcc_ohm_to_pu(
            po.rectifier_xc,
            po.rectifier_base_voltage,
            base_power,
        ),
        rectifier_base_voltage = po.rectifier_base_voltage,
        inverter_bridges = po.inverter_bridges,
        inverter_extinction_angle_limits = _minmax(po.inverter_extinction_angle_limits),
        inverter_rc = _lcc_ohm_to_pu(po.inverter_rc, po.inverter_base_voltage, base_power),
        inverter_xc = _lcc_ohm_to_pu(po.inverter_xc, po.inverter_base_voltage, base_power),
        inverter_base_voltage = po.inverter_base_voltage,
        power_mode = po.power_mode,
        switch_mode_voltage = po.switch_mode_voltage,
        compounding_resistance = _lcc_ohm_to_pu(
            po.compounding_resistance, po.scheduled_dc_voltage, base_power,
        ),
        min_compounding_voltage = po.min_compounding_voltage,
        rectifier_transformer_ratio = po.rectifier_transformer_ratio,
        rectifier_tap_setting = po.rectifier_tap_setting,
        rectifier_tap_limits = _minmax(po.rectifier_tap_limits),
        rectifier_tap_step = po.rectifier_tap_step,
        rectifier_delay_angle = po.rectifier_delay_angle,
        rectifier_capacitor_reactance = _lcc_ohm_to_pu(
            po.rectifier_capacitor_reactance, po.rectifier_base_voltage, base_power,
        ),
        inverter_transformer_ratio = po.inverter_transformer_ratio,
        inverter_tap_setting = po.inverter_tap_setting,
        inverter_tap_limits = _minmax(po.inverter_tap_limits),
        inverter_tap_step = po.inverter_tap_step,
        inverter_extinction_angle = po.inverter_extinction_angle,
        inverter_capacitor_reactance = _lcc_ohm_to_pu(
            po.inverter_capacitor_reactance, po.inverter_base_voltage, base_power,
        ),
        active_power_limits_from = _minmax(po.active_power_limits_from),
        active_power_limits_to = _minmax(po.active_power_limits_to),
        reactive_power_limits_from = _minmax(po.reactive_power_limits_from),
        reactive_power_limits_to = _minmax(po.reactive_power_limits_to),
        loss = _hvdc_loss(po.loss),
        base_power = base_power,
    )
end

function from_openapi(po::PO.TwoTerminalLCCLine, refs::OpenAPIRefs, ::NaturalUnit)
    _check_lcc_parameter_units(po)
    _check_lcc_dc_voltage_units(po)
    base_power = po.base_power
    return TwoTerminalLCCLine(;
        name = po.name,
        available = po.available,
        arc = refs[po.arc],
        active_power_flow = po.active_power_flow / base_power,
        r = _lcc_ohm_to_pu(po.r, po.scheduled_dc_voltage, base_power),
        transfer_setpoint = _lcc_transfer_setpoint(
            po.transfer_setpoint, Val(po.power_mode), base_power,
        ),
        scheduled_dc_voltage = po.scheduled_dc_voltage,
        rectifier_bridges = po.rectifier_bridges,
        rectifier_delay_angle_limits = _minmax(po.rectifier_delay_angle_limits),
        rectifier_rc = _lcc_ohm_to_pu(
            po.rectifier_rc,
            po.rectifier_base_voltage,
            base_power,
        ),
        rectifier_xc = _lcc_ohm_to_pu(
            po.rectifier_xc,
            po.rectifier_base_voltage,
            base_power,
        ),
        rectifier_base_voltage = po.rectifier_base_voltage,
        inverter_bridges = po.inverter_bridges,
        inverter_extinction_angle_limits = _minmax(po.inverter_extinction_angle_limits),
        inverter_rc = _lcc_ohm_to_pu(po.inverter_rc, po.inverter_base_voltage, base_power),
        inverter_xc = _lcc_ohm_to_pu(po.inverter_xc, po.inverter_base_voltage, base_power),
        inverter_base_voltage = po.inverter_base_voltage,
        power_mode = po.power_mode,
        switch_mode_voltage = po.switch_mode_voltage,
        compounding_resistance = _lcc_ohm_to_pu(
            po.compounding_resistance, po.scheduled_dc_voltage, base_power,
        ),
        min_compounding_voltage = po.min_compounding_voltage,
        rectifier_transformer_ratio = po.rectifier_transformer_ratio,
        rectifier_tap_setting = po.rectifier_tap_setting,
        rectifier_tap_limits = _minmax(po.rectifier_tap_limits),
        rectifier_tap_step = po.rectifier_tap_step,
        rectifier_delay_angle = po.rectifier_delay_angle,
        rectifier_capacitor_reactance = _lcc_ohm_to_pu(
            po.rectifier_capacitor_reactance, po.rectifier_base_voltage, base_power,
        ),
        inverter_transformer_ratio = po.inverter_transformer_ratio,
        inverter_tap_setting = po.inverter_tap_setting,
        inverter_tap_limits = _minmax(po.inverter_tap_limits),
        inverter_tap_step = po.inverter_tap_step,
        inverter_extinction_angle = po.inverter_extinction_angle,
        inverter_capacitor_reactance = _lcc_ohm_to_pu(
            po.inverter_capacitor_reactance, po.inverter_base_voltage, base_power,
        ),
        active_power_limits_from = _minmax_du(po.active_power_limits_from, base_power),
        active_power_limits_to = _minmax_du(po.active_power_limits_to, base_power),
        reactive_power_limits_from = _minmax_du(po.reactive_power_limits_from, base_power),
        reactive_power_limits_to = _minmax_du(po.reactive_power_limits_to, base_power),
        loss = _hvdc_loss(po.loss),
        base_power = base_power,
    )
end

# ── TwoTerminalVSCLine ──────────────────────────────────────────────────────────
# `converter_loss_from`/`converter_loss_to::Union{LinearCurve, QuadraticCurve}` is the same
# Union-of-two-concrete-curves shape that keeps `TwoTerminalGenericHVDCLine`/`TwoTerminalLCCLine`
# hand-written, and `dc_setpoint_*`/`ac_setpoint_*` change meaning with a sibling enum field,
# which no generator rule expresses.
#
# `admittance_units`/`voltage_units` follow `TwoTerminalLCCLine`'s posture: only "NATURAL_UNITS"
# (every current producer's value, and the schema default) is implemented, and anything else
# errors rather than being guessed at. Because that basis is fixed, `g` needs the SAME siemens →
# pu conversion in BOTH methods; only the document-unit-system-governed power fields
# (`active_power_flow`, `rating`, `rating_from`/`to`, `reactive_power_from`/`to`,
# `active_power_limits_*`, `reactive_power_limits_*`, and `dc_setpoint_*` when `dc_control_*`
# selects its `DC_POWER` branch) differ between them — the `transfer_setpoint` rule LCC already
# sets for a mode-switched power field.
#
# `rated_dc_voltage` is the DC-side base its own docstring declares it to be, so it is the base
# for `g` and for the DC-voltage `dc_setpoint_*` branches. `0.0` means "unspecified", which is
# fine while nothing needs the base and unrecoverable once something does — hence
# `_vsc_dc_base_voltage`, which errors only when a non-zero value actually has to be converted
# rather than quietly producing a `0`/`Inf`.
#
# Deliberately NOT converted, each for a stated reason rather than by omission:
#   voltage_limits_*      the descriptor does not mark it convertible, the PSY `to`-side
#                         docstring states no unit at all, and its `(0.0, 999.9)` default is a
#                         no-limit sentinel that a kV → pu division would turn into noise —
#                         the `Line.r`/`DiscreteControlledACBranch.r` passthrough precedent.
#   dc_voltage_droop_*    pu on both sides.
#   dc_current,           amperes on both sides; no power base applies.
#   max_dc_current_*
#   rmpct_*,              dimensionless on both sides.
#   power_factor_weighting_fraction_*
#   rated_dc_voltage      kV on both sides.
#
# `ac_setpoint_*`'s `AC_VOLTAGE` branch is the one branch with no faithful conversion: the
# document carries kV, PSY wants per-unit of the converter's AC-side base voltage, and neither
# this struct nor the document records that base, so it errors rather than guessing.

const TWO_TERMINAL_VSC_ADMITTANCE_UNITS_IMPLEMENTED = Set(["NATURAL_UNITS"])
const TWO_TERMINAL_VSC_VOLTAGE_UNITS_IMPLEMENTED = Set(["NATURAL_UNITS"])

_check_vsc_admittance_units(po) = _check_unit_basis(
    po.admittance_units,
    TWO_TERMINAL_VSC_ADMITTANCE_UNITS_IMPLEMENTED,
    "TwoTerminalVSCLine.admittance_units",
    " for $(po.name)",
)

_check_vsc_voltage_units(po) = _check_unit_basis(
    po.voltage_units,
    TWO_TERMINAL_VSC_VOLTAGE_UNITS_IMPLEMENTED,
    "TwoTerminalVSCLine.voltage_units",
    " for $(po.name)",
)

"""
`rated_dc_voltage` when it can serve as a base, erroring when `value` needs a base the
document declined to give. `0.0` is the schema's "unspecified", not a usable base.
"""
function _vsc_dc_base_voltage(po, value, field::AbstractString)
    rated = po.rated_dc_voltage
    if !iszero(rated)
        return rated
    end
    if iszero(value)
        return one(rated)
    end
    return error(
        "TwoTerminalVSCLine \"$(po.name)\": $field is $value but rated_dc_voltage is 0.0, " *
        "so there is no DC voltage base to convert it against — set rated_dc_voltage",
    )
end

"""Siemens → pu via `Ybase = base_power / rated_dc_voltage^2` (kV, MVA)."""
function _vsc_siemens_to_pu(po, base_power)
    base_voltage = _vsc_dc_base_voltage(po, po.g, "g")
    return po.g * (base_voltage^2 / base_power)
end

"""
`converter_loss_*` restricted to the two curve shapes the PSY field's Union admits, so a
piecewise document curve is named here rather than surfacing as a `MethodError` from the
`TwoTerminalVSCLine` constructor.
"""
_vsc_converter_loss(curve::InputOutputCurve{LinearFunctionData}) = curve
_vsc_converter_loss(curve::InputOutputCurve{QuadraticFunctionData}) = curve
_vsc_converter_loss(curve) = error(
    "TwoTerminalVSCLine converter_loss must be a LINEAR or QUADRATIC InputOutputCurve, got " *
    "InputOutputCurve{$(typeof(get_function_data(curve)))}",
)

"""
`dc_setpoint_*` follows `dc_control_*`: MW under `DC_POWER` (a power field, so it divides
with its siblings only under `NaturalUnit`), and kV under either DC-voltage-regulating mode,
which PSY stores as per-unit of `rated_dc_voltage` in both methods.
"""
_vsc_dc_setpoint(
    po,
    setpoint,
    ::Val{VSCDCControlModes.DC_POWER},
    base_power,
    ::NaturalUnit,
) =
    setpoint / base_power
_vsc_dc_setpoint(
    _po, setpoint, ::Val{VSCDCControlModes.DC_POWER}, _base_power, ::DeviceBaseUnit,
) = setpoint
function _vsc_dc_setpoint(po, setpoint, ::Val{VSCDCControlModes.DC_VOLTAGE}, _bp, _unit)
    return setpoint / _vsc_dc_base_voltage(po, setpoint, "dc_setpoint")
end
function _vsc_dc_setpoint(
    po, setpoint, ::Val{VSCDCControlModes.DC_VOLTAGE_DROOP}, _bp, _unit,
)
    return setpoint / _vsc_dc_base_voltage(po, setpoint, "dc_setpoint")
end

"""
`ac_setpoint_*` follows `ac_control_*`: a dimensionless power factor under
`AC_REACTIVE_POWER`, and an AC-side voltage under `AC_VOLTAGE` — kV in the document, per-unit
of a converter AC base voltage in PSY, which neither side records. That branch errors instead
of storing a kV magnitude in a per-unit field.
"""
_vsc_ac_setpoint(_po, setpoint, ::Val{VSCACControlModes.AC_REACTIVE_POWER}) = setpoint
_vsc_ac_setpoint(po, _setpoint, ::Val{VSCACControlModes.AC_VOLTAGE}) = error(
    "TwoTerminalVSCLine \"$(po.name)\": ac_control is AC_VOLTAGE, whose ac_setpoint is kV in " *
    "the document and per-unit of the converter's AC base voltage in PowerSystems — neither " *
    "the component nor the document carries that base, so the value cannot be converted",
)

"""The shared body of both unit-system methods; only `unit` and `base_power` differ."""
function _two_terminal_vsc_line(po, refs::OpenAPIRefs, base_power, unit)
    _check_vsc_admittance_units(po)
    _check_vsc_voltage_units(po)
    dc_control_from = VSCDCControlModes(po.dc_control_from)
    dc_control_to = VSCDCControlModes(po.dc_control_to)
    ac_control_from = VSCACControlModes(po.ac_control_from)
    ac_control_to = VSCACControlModes(po.ac_control_to)
    return TwoTerminalVSCLine(;
        name = po.name,
        available = po.available,
        arc = refs[po.arc],
        active_power_flow = _vsc_power(po.active_power_flow, base_power, unit),
        rating = _vsc_power(po.rating, base_power, unit),
        active_power_limits_from = _vsc_minmax(
            po.active_power_limits_from,
            base_power,
            unit,
        ),
        active_power_limits_to = _vsc_minmax(po.active_power_limits_to, base_power, unit),
        g = _vsc_siemens_to_pu(po, base_power),
        dc_current = po.dc_current,
        reactive_power_from = _vsc_power(po.reactive_power_from, base_power, unit),
        dc_control_from = dc_control_from,
        ac_control_from = ac_control_from,
        dc_setpoint_from = _vsc_dc_setpoint(
            po, po.dc_setpoint_from, Val(dc_control_from), base_power, unit,
        ),
        ac_setpoint_from = _vsc_ac_setpoint(po, po.ac_setpoint_from, Val(ac_control_from)),
        converter_loss_from = _vsc_converter_loss(convert_cost(po.converter_loss_from)),
        max_dc_current_from = po.max_dc_current_from,
        rating_from = _vsc_power(po.rating_from, base_power, unit),
        reactive_power_limits_from = _vsc_minmax(
            po.reactive_power_limits_from, base_power, unit,
        ),
        power_factor_weighting_fraction_from = po.power_factor_weighting_fraction_from,
        voltage_limits_from = _minmax(po.voltage_limits_from),
        dc_voltage_droop_from = po.dc_voltage_droop_from,
        reactive_power_to = _vsc_power(po.reactive_power_to, base_power, unit),
        dc_control_to = dc_control_to,
        ac_control_to = ac_control_to,
        dc_setpoint_to = _vsc_dc_setpoint(
            po, po.dc_setpoint_to, Val(dc_control_to), base_power, unit,
        ),
        ac_setpoint_to = _vsc_ac_setpoint(po, po.ac_setpoint_to, Val(ac_control_to)),
        converter_loss_to = _vsc_converter_loss(convert_cost(po.converter_loss_to)),
        max_dc_current_to = po.max_dc_current_to,
        rating_to = _vsc_power(po.rating_to, base_power, unit),
        reactive_power_limits_to = _vsc_minmax(
            po.reactive_power_limits_to,
            base_power,
            unit,
        ),
        power_factor_weighting_fraction_to = po.power_factor_weighting_fraction_to,
        voltage_limits_to = _minmax(po.voltage_limits_to),
        dc_voltage_droop_to = po.dc_voltage_droop_to,
        rated_dc_voltage = po.rated_dc_voltage,
        remote_bus_control_from = po.remote_bus_control_from,
        remote_bus_control_to = po.remote_bus_control_to,
        rmpct_from = po.rmpct_from,
        rmpct_to = po.rmpct_to,
        base_power = base_power,
    )
end

"""MVA/MW/MVAr divided by the system base only when the document declares natural units."""
_vsc_power(value, base_power, ::NaturalUnit) = value / base_power
_vsc_power(value, _base_power, ::DeviceBaseUnit) = value

_vsc_minmax(m, base_power, ::NaturalUnit) = _minmax_du(m, base_power)
_vsc_minmax(m, _base_power, ::DeviceBaseUnit) = _minmax(m)

function from_openapi(
    po::PO.TwoTerminalVSCLine,
    refs::OpenAPIRefs,
    unit::DeviceBaseUnit,
)
    return _two_terminal_vsc_line(po, refs, _resolve_base_power(refs, po.base_power), unit)
end

function from_openapi(po::PO.TwoTerminalVSCLine, refs::OpenAPIRefs, unit::NaturalUnit)
    return _two_terminal_vsc_line(po, refs, _resolve_base_power(refs, po.base_power), unit)
end

# ── Source ──────────────────────────────────────────────────────────────────────
# A genuine device base: `base_power` is the unit's own rating, not the denormalized system
# base, so the MVA/MW fields divide by `po.base_power` rather than `_resolve_base_power`.
# `R_th`/`X_th` carry no `needs_conversion` in the descriptor — they are pu on the source's
# own base already — but the document states which basis it wrote them in, so the
# discriminator is checked rather than assumed. `base_voltage` is a plain kV passthrough.

const SOURCE_PARAM_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

_check_source_param_units(po) = _check_unit_basis(
    po.parameter_units,
    SOURCE_PARAM_UNITS_IMPLEMENTED,
    "Source.parameter_units",
    " for $(po.name)",
)

function from_openapi(po::PO.Source, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_source_param_units(po)
    return Source(;
        name = po.name,
        available = po.available,
        bus = resolve_ref(refs, po.bus, ACBus),
        active_power = po.active_power,
        reactive_power = po.reactive_power,
        active_power_limits = _minmax(po.active_power_limits),
        reactive_power_limits = _opt_minmax(po.reactive_power_limits),
        R_th = po.R_th,
        X_th = po.X_th,
        internal_voltage = po.internal_voltage,
        internal_angle = po.internal_angle,
        base_power = po.base_power,
        base_voltage = po.base_voltage,
        operation_cost = convert_cost(po.operation_cost)::OperationalCost,
    )
end

function from_openapi(po::PO.Source, refs::OpenAPIRefs, ::NaturalUnit)
    _check_source_param_units(po)
    dbp = po.base_power
    return Source(;
        name = po.name,
        available = po.available,
        bus = resolve_ref(refs, po.bus, ACBus),
        active_power = po.active_power / dbp,
        reactive_power = po.reactive_power / dbp,
        active_power_limits = _minmax_du(po.active_power_limits, dbp),
        reactive_power_limits = _minmax_du(po.reactive_power_limits, dbp),
        R_th = po.R_th,
        X_th = po.X_th,
        internal_voltage = po.internal_voltage,
        internal_angle = po.internal_angle,
        base_power = dbp,
        base_voltage = po.base_voltage,
        operation_cost = convert_cost(po.operation_cost)::OperationalCost,
    )
end

# ── TModelHVDCLine ──────────────────────────────────────────────────────────────
# The cable exception. This type carries no `base_power` at all — its anchor is
# `base_current` (A), which per-unitizes `l`/`c` and, under "DEVICE_BASE", `r`. It therefore
# falls through `base_power_kind`'s `DeviceBasePower()` default to `_get_base_power(c::
# Component) = _get_system_base_power(c)`, so the MW fields per-unitize on the *system* base
# exactly like `Line`'s do — `base_current` never enters that arithmetic. Getting this
# backwards (dividing MW by `base_current`) would be dimensionally meaningless, which is why
# it is spelled out here.

const TMODEL_PARAM_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

_check_tmodel_param_units(po) = _check_unit_basis(
    po.parameter_units,
    TMODEL_PARAM_UNITS_IMPLEMENTED,
    "TModelHVDCLine.parameter_units",
    " for $(po.name)",
)

function from_openapi(po::PO.TModelHVDCLine, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_tmodel_param_units(po)
    return TModelHVDCLine(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow,
        arc = resolve_ref(refs, po.arc, Arc),
        r = po.r,
        l = po.l,
        c = po.c,
        active_power_limits_from = _minmax(po.active_power_limits_from),
        active_power_limits_to = _minmax(po.active_power_limits_to),
        base_current = po.base_current,
    )
end

function from_openapi(po::PO.TModelHVDCLine, refs::OpenAPIRefs, ::NaturalUnit)
    _check_tmodel_param_units(po)
    sbp = get_base_power(refs)
    return TModelHVDCLine(;
        name = po.name,
        available = po.available,
        active_power_flow = po.active_power_flow / sbp,
        arc = resolve_ref(refs, po.arc, Arc),
        r = po.r,
        l = po.l,
        c = po.c,
        active_power_limits_from = _minmax_du(po.active_power_limits_from, sbp),
        active_power_limits_to = _minmax_du(po.active_power_limits_to, sbp),
        base_current = po.base_current,
    )
end

# ── InterconnectingConverter ────────────────────────────────────────────────────
# Another genuine device base: every MVA/MW/A-rated field divides by the converter's own
# `base_power`, including `dc_current`/`max_dc_current`, which the descriptor tags `:mva`
# rather than a current unit. `remote_bus_control` is a bus *number*, not a component
# reference — `Union{Nothing, Int}` in PSY — so it passes through rather than resolving.
# `loss_function` reuses the `TwoTerminalVSCLine` guard: the PSY field admits only the linear
# and quadratic shapes, so a piecewise document curve is named here rather than surfacing as
# a constructor `MethodError`.

const IC_VOLTAGE_SETPOINT_UNITS_IMPLEMENTED = Set(["DEVICE_BASE"])

_check_ic_voltage_setpoint_units(po) = _check_unit_basis(
    po.voltage_setpoint_units,
    IC_VOLTAGE_SETPOINT_UNITS_IMPLEMENTED,
    "InterconnectingConverter.voltage_setpoint_units",
    " for $(po.name)",
)

function from_openapi(po::PO.InterconnectingConverter, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _check_ic_voltage_setpoint_units(po)
    return InterconnectingConverter(;
        name = po.name,
        available = po.available,
        bus = resolve_ref(refs, po.bus, ACBus),
        dc_bus = resolve_ref(refs, po.dc_bus, DCBus),
        active_power = po.active_power,
        rating = po.rating,
        active_power_limits = _minmax(po.active_power_limits),
        base_power = po.base_power,
        reactive_power_limits = _opt_minmax(po.reactive_power_limits),
        dc_current = po.dc_current,
        max_dc_current = po.max_dc_current,
        loss_function = _vsc_converter_loss(convert_cost(po.loss_function)),
        dc_control = VSCDCControlModes(po.dc_control),
        ac_control = VSCACControlModes(po.ac_control),
        dc_setpoint = po.dc_setpoint,
        ac_setpoint = po.ac_setpoint,
        dc_voltage_droop = po.dc_voltage_droop,
        remote_bus_control = po.remote_bus_control,
        rmpct = po.rmpct,
        power_factor_weighting_fraction = po.power_factor_weighting_fraction,
        voltage_limits = _minmax(po.voltage_limits),
    )
end

function from_openapi(po::PO.InterconnectingConverter, refs::OpenAPIRefs, ::NaturalUnit)
    _check_ic_voltage_setpoint_units(po)
    dbp = po.base_power
    return InterconnectingConverter(;
        name = po.name,
        available = po.available,
        bus = resolve_ref(refs, po.bus, ACBus),
        dc_bus = resolve_ref(refs, po.dc_bus, DCBus),
        active_power = po.active_power / dbp,
        rating = po.rating / dbp,
        active_power_limits = _minmax_du(po.active_power_limits, dbp),
        base_power = dbp,
        reactive_power_limits = _minmax_du(po.reactive_power_limits, dbp),
        dc_current = po.dc_current / dbp,
        max_dc_current = po.max_dc_current / dbp,
        loss_function = _vsc_converter_loss(convert_cost(po.loss_function)),
        dc_control = VSCDCControlModes(po.dc_control),
        ac_control = VSCACControlModes(po.ac_control),
        dc_setpoint = po.dc_setpoint,
        ac_setpoint = po.ac_setpoint,
        dc_voltage_droop = po.dc_voltage_droop,
        remote_bus_control = po.remote_bus_control,
        rmpct = po.rmpct,
        power_factor_weighting_fraction = po.power_factor_weighting_fraction,
        voltage_limits = _minmax(po.voltage_limits),
    )
end

# ── HybridSystem ────────────────────────────────────────────────────────────────
# Four of its fields reference *abstract* PSY types — `ThermalGen`, `ElectricLoad`,
# `Storage`, `RenewableGen` — which is what keeps this hand-written: the generator's
# `:reference` kind resolves a concrete struct name, and these name a supertype whose
# concrete member is whatever the document registered under that id. `resolve_ref`'s type
# argument still applies, an abstract bound being a perfectly good assert.
#
# `base_power` is required rather than derived. The schema calls it "commonly the same as
# `interconnection_rating`", and *commonly* is not *always* — silently substituting the PCC
# rating for a missing base would rescale every other field on the device against a number
# the producer never stated. A document that omits it is malformed, and says so.
#
# `interconnection_impedance` is pu and passes through; `interconnection_efficiency` is a
# dimensionless `InOut` fraction, likewise.

function _hybrid_base_power(po)
    isnothing(po.base_power) && error(
        "HybridSystem $(po.name): base_power is required and the document omits it. It is " *
        "commonly equal to interconnection_rating but is not derived from it — every " *
        "per-unit field on this device resolves against it, so substituting the PCC rating " *
        "would rescale them against a value the producer never stated.",
    )
    return Float64(po.base_power)
end

"""`(in, out)` passed through unconverted, or `nothing` when absent."""
_opt_inout(::Nothing) = nothing
_opt_inout(m) = _inout(m)

function from_openapi(po::PO.HybridSystem, refs::OpenAPIRefs, ::DeviceBaseUnit)
    _hybrid_base_power(po)
    return HybridSystem(;
        name = po.name,
        available = po.available,
        status = po.status,
        bus = resolve_ref(refs, po.bus, ACBus),
        active_power = po.active_power,
        reactive_power = po.reactive_power,
        base_power = po.base_power,
        operation_cost = convert_cost(po.operation_cost)::MarketBidCost,
        thermal_unit = resolve_ref(refs, po.thermal_unit, ThermalGen),
        electric_load = resolve_ref(refs, po.electric_load, ElectricLoad),
        storage = resolve_ref(refs, po.storage, Storage),
        renewable_unit = resolve_ref(refs, po.renewable_unit, RenewableGen),
        interconnection_impedance = _complex_number(po.interconnection_impedance),
        interconnection_rating = po.interconnection_rating,
        input_active_power_limits = _opt_minmax(po.input_active_power_limits),
        output_active_power_limits = _opt_minmax(po.output_active_power_limits),
        reactive_power_limits = _opt_minmax(po.reactive_power_limits),
        interconnection_efficiency = _opt_inout(po.interconnection_efficiency),
    )
end

function from_openapi(po::PO.HybridSystem, refs::OpenAPIRefs, ::NaturalUnit)
    dbp = _hybrid_base_power(po)
    return HybridSystem(;
        name = po.name,
        available = po.available,
        status = po.status,
        bus = resolve_ref(refs, po.bus, ACBus),
        active_power = po.active_power / dbp,
        reactive_power = po.reactive_power / dbp,
        base_power = dbp,
        operation_cost = convert_cost(po.operation_cost)::MarketBidCost,
        thermal_unit = resolve_ref(refs, po.thermal_unit, ThermalGen),
        electric_load = resolve_ref(refs, po.electric_load, ElectricLoad),
        storage = resolve_ref(refs, po.storage, Storage),
        renewable_unit = resolve_ref(refs, po.renewable_unit, RenewableGen),
        interconnection_impedance = _complex_number(po.interconnection_impedance),
        interconnection_rating = _scale_optional(po.interconnection_rating, dbp),
        input_active_power_limits = _minmax_du(po.input_active_power_limits, dbp),
        output_active_power_limits = _minmax_du(po.output_active_power_limits, dbp),
        reactive_power_limits = _minmax_du(po.reactive_power_limits, dbp),
        interconnection_efficiency = _opt_inout(po.interconnection_efficiency),
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

function from_openapi(po::PO.OnlineReserve, refs::OpenAPIRefs, ::DeviceBaseUnit)
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

function from_openapi(po::PO.OnlineReserve, refs::OpenAPIRefs, ::NaturalUnit)
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

function from_openapi(po::PO.OfflineReserve, refs::OpenAPIRefs, ::DeviceBaseUnit)
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

function from_openapi(po::PO.OfflineReserve, refs::OpenAPIRefs, ::NaturalUnit)
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

function from_openapi(po::PO.GroupReserve, refs::OpenAPIRefs, ::DeviceBaseUnit)
    direction = _resolve_reserve_direction(po.reserve_direction, po.name)
    return GroupReserve{direction}(;
        name = po.name,
        available = po.available,
        requirement = po.requirement,
    )
end

function from_openapi(po::PO.GroupReserve, refs::OpenAPIRefs, ::NaturalUnit)
    direction = _resolve_reserve_direction(po.reserve_direction, po.name)
    return GroupReserve{direction}(;
        name = po.name,
        available = po.available,
        requirement = po.requirement / get_base_power(refs),
    )
end
