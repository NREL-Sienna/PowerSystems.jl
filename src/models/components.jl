@inline function _get_system_base_power(c::Component)
    base_value = IS.get_base_value(c)
    isnothing(base_value) && error("Component $(get_name(c)) is not attached to a system.")
    return base_value
end

"""
Unitless device-base power (MVA). Fallback for components with no `base_power`
field: the device base equals the system base.
"""
_get_base_power(c::Component) = _get_system_base_power(c)

# Holy trait distinguishing components whose `base_power` field is a genuine,
# independently-set device base (generators, loads, storage, ...) from the dozen
# arc/area-ish types below whose `base_power` field only exists because the
# schema records the system base per-component "in lieu of a system-level table"
# (see SiennaSchemas). `add_component!` uses this trait to keep that field in
# sync with the system's base power; it must never be set independently.
abstract type BasePowerKind end
struct DeviceBasePower <: BasePowerKind end
struct SystemBasePower <: BasePowerKind end

base_power_kind(::Component) = DeviceBasePower()
base_power_kind(::Area) = SystemBasePower()
base_power_kind(::AreaInterchange) = SystemBasePower()
base_power_kind(::DiscreteControlledACBranch) = SystemBasePower()
base_power_kind(::GenericArcImpedance) = SystemBasePower()
base_power_kind(::Line) = SystemBasePower()
base_power_kind(::LoadZone) = SystemBasePower()
base_power_kind(::MonitoredLine) = SystemBasePower()
base_power_kind(::TModelHVDCLine) = SystemBasePower()
base_power_kind(::TransmissionInterface) = SystemBasePower()
base_power_kind(::TwoTerminalGenericHVDCLine) = SystemBasePower()
base_power_kind(::TwoTerminalLCCLine) = SystemBasePower()
base_power_kind(::TwoTerminalVSCLine) = SystemBasePower()

"""
Write the system's base power onto `component.base_power` for `SystemBasePower`
types; a no-op for genuine device-base types. Called from `add_component!` so
the field never drifts from the system it is recorded against.
"""
_sync_base_power!(::DeviceBasePower, component, system_base_power) = nothing
function _sync_base_power!(::SystemBasePower, component, system_base_power)
    component.base_power = system_base_power
    return
end

# `_get_base_power` is the single read path for a component's base power, and it reads
# straight from the field for both kinds. A detached component keeps whatever base its
# producer stated, which is real data and must not be discarded; no guard belongs here,
# because the units engine already errors on SU/NU for an unattached component.

# Conversion-engine component interface (see src/units/conversions.jl): the
# engine resolves bases through these three functions, so every getter and
# setter shares one base-power/base-voltage choice per component type.
_get_device_base_power(c::Component) = _get_base_power(c)

# TransformerCircuit is a self-contained explicit-units base provider (defined
# in models/transformer_circuits.jl, included earlier): it carries its own
# base_power/base_voltage_primary/base_value and does not need a component to
# delegate to (Base.summary(w) is defined alongside the struct).
_get_device_base_power(w::TransformerCircuit) = w.base_power
function _get_system_base_power(w::TransformerCircuit)
    base_value = IS.get_base_value(w)
    isnothing(base_value) && error(
        "TransformerCircuit is not attached to a System; cannot convert to/from system base",
    )
    return base_value
end

# The circuit's impedance is per-unit referenced to its primary base voltage, so
# the conversion engine's generic base-voltage resolver reads
# base_voltage_primary.
get_base_voltage(w::TransformerCircuit) = get_base_voltage_primary(w)

const UnitsBearer = Union{Component, TransformerCircuit}

get_base_voltage(c::Branch) = get_base_voltage(get_arc(c).from)

# TwoWindingTransformer has no `arc` field of its own (the arc lives on its
# TransformerCircuit); delegate the generic Branch interface (get_arc, set_arc!)
# to the circuit so that check_component_addition/check_attached_buses/
# _handle_branch_addition_common! and get_from_bus/get_to_bus (all defined
# generically over `Branch` in terms of get_arc) work unmodified.
get_arc(c::TwoWindingTransformer) = get_arc(get_circuit(c))
set_arc!(c::TwoWindingTransformer, arc::Arc) = set_arc!(get_circuit(c), arc)

# 2W: device base voltage is the primary (circuit) side
get_base_voltage(c::TwoWindingTransformer) = get_base_voltage(get_circuit(c))
get_base_voltage(c::ThreeWindingTransformer) = error(
    "Three-winding transformers have per-circuit base voltages; use " *
    "get_base_voltage(get_primary_circuit(t))/get_base_voltage(get_secondary_circuit(t))/" *
    "get_base_voltage(get_tertiary_circuit(t)).",
)

# `base_power` is always stored and reported in natural units (MVA). It is the
# anchor that every other field's per-unitization is defined against, so
# expressing it in a per-unit base (`SU`/`DU`) is circular. Unlike every other
# field accessor, `get_base_power`/`set_base_power!` therefore need *no* units
# argument; an explicit one is accepted only when it denotes natural units —
# `NU`, or a power-dimensioned `Unitful` unit such as `MW`/`MVA`.

"""
Get a component's `base_power` as a bare `Float64` in natural units (MVA).

`get_base_power(c)` returns the stored MVA value. An optional units argument is
accepted but must denote natural units: `NU`, or a power-dimensioned `Unitful`
unit (e.g. `MW`, `MVA`). Per-unit bases (`SU`, `DU`) and non-power units error —
`base_power` is only meaningful in absolute power. See
[`get_base_power_unitful`](@ref) for the unit-bearing value.
"""
get_base_power(c::Component) = _get_base_power(c)
get_base_power(c::Component, u) = IS._strip_units(get_base_power_unitful(c, u))

"""
`base_power` as a unit-bearing quantity (MVA). See [`get_base_power`](@ref).
"""
get_base_power_unitful(c::Component) = _get_base_power(c) * MVA
get_base_power_unitful(c::Component, ::NaturalUnit) = _get_base_power(c) * MVA
# Any power-dimensioned Unitful unit: `uconvert` does the scaling and throws a
# `Unitful.DimensionError` for non-power units, so wrong units error for free.
get_base_power_unitful(c::Component, u::Unitful.Units) =
    Unitful.uconvert(u, _get_base_power(c) * MVA)
# Relative per-unit markers (`SU`, `DU`) are not natural units.
get_base_power_unitful(::Component, u::AbstractRelativeUnit) =
    _base_power_units_error(u)

"""
Set a component's `base_power` (stored as a bare MVA `Float64`).

Accepts a bare `Float64` (interpreted as MVA) or a power-dimensioned
`Unitful.Quantity` (e.g. `80.0 * MW`, `90.0 * MVA`). Per-unit inputs (`SU`, `DU`)
and non-power units error: `base_power` is only meaningful in absolute power.
"""
set_base_power!(c::Component, val::Float64) = _set_base_power!(base_power_kind(c), c, val)
# `ustrip(MVA, val)` converts power units and throws for non-power units.
set_base_power!(c::Component, val::Unitful.Quantity) =
    _set_base_power!(base_power_kind(c), c, Unitful.ustrip(MVA, val))
set_base_power!(::Component, ::RelativeQuantity{<:Any, U}) where {U} =
    _base_power_units_error(U())

_set_base_power!(::DeviceBasePower, c, val::Float64) = (c.base_power = val)
function _set_base_power!(::SystemBasePower, c, ::Float64)
    error(
        "$(typeof(c)) has no independent base_power: it always equals the system's " *
        "base power. Change the system's base power instead of setting this field " *
        "directly.",
    )
end

"""
Reject any attempt to read/write `base_power` in non-natural units.
"""
function _base_power_units_error(u)
    throw(
        ArgumentError(
            "base_power is always in natural units (MVA). Pass no units, `NU`, " *
            "or a power-dimensioned Unitful unit such as `MW` or `MVA`; got `$u`. " *
            "Per-unit bases (`SU`, `DU`) are not valid for base_power.",
        ),
    )
end

IS.display_units_arg(::typeof(get_base_power), ::Type{<:Component}) = NU
IS.display_units_arg(::typeof(get_base_power_unitful), ::Type{<:Component}) = NU
IS.display_units_arg(::typeof(set_base_power!), ::Type{<:Component}) = NU

# Make `_strip_units` work for Unitful quantities; IS doesn't depend on Unitful.
IS._strip_units(q::Unitful.Quantity) = Unitful.ustrip(q)

# Units passed to 2-arg scaling-factor multipliers during time-series retrieval
# when the caller does not specify them: system base, matching what
# simulation/optimization consumers expect.
IS.default_units(::Component) = SU

#######################################################
# Units-aware get_value / set_value
#
# Fields are stored internally in device base (DU); `get_value` converts from
# DU to a requested target (e.g., MW, SU).
#######################################################

"""
    get_value(c::Component, field::Val, conversion_unit::Val, units) -> value

Get `c`'s field value, converting from device-base storage to `units`.
Returns a `RelativeQuantity` (for DU/SU targets) or a `Unitful.Quantity` (for
natural units like MW). Public getters wrap this in `_strip_units` for the
bare-number form, with `_unitful` companions returning the wrapped value.
"""
function get_value(c::UnitsBearer, field::Val{T}, conversion_unit, units::UnitArg) where {T}
    value = Base.getproperty(c, T)
    return _convert_from_device_base(
        _conversion_base(c, field),
        value,
        conversion_unit,
        units,
    )
end

# Base provider for the conversion engine: which object carries the bases for a
# given field. Components (and `TransformerCircuit`, which is its own base
# provider) are their own provider. Multi-winding transformers delegate to their
# per-circuit `TransformerCircuit` objects, which are themselves `UnitsBearer`s.
_conversion_base(c::UnitsBearer, ::Any) = c

# ---- DU → requested units: one delegation to the conversion engine. The
# field's conversion-unit token picks the physical category; the engine
# resolves bases through the component interface above. ----
_convert_from_device_base(base, value::Number, cu::Val, units::UnitArg) =
    convert_units(base, value, _unit_category(cu), DU, units)

# ---- Nothing passthrough ----
_convert_from_device_base(base, ::Nothing, ::Val, ::Any) = nothing

# ---- Compound field types ----
_convert_from_device_base(base, v::MinMax, cu, u) = (
    min = _convert_from_device_base(base, v.min, cu, u),
    max = _convert_from_device_base(base, v.max, cu, u),
)

_convert_from_device_base(base, v::UpDown, cu, u) = (
    up = _convert_from_device_base(base, v.up, cu, u),
    down = _convert_from_device_base(base, v.down, cu, u),
)

_convert_from_device_base(base, v::FromTo_ToFrom, cu, u) = (
    from_to = _convert_from_device_base(base, v.from_to, cu, u),
    to_from = _convert_from_device_base(base, v.to_from, cu, u),
)

_convert_from_device_base(base, v::FromTo, cu, u) = (
    from = _convert_from_device_base(base, v.from, cu, u),
    to = _convert_from_device_base(base, v.to, cu, u),
)

_convert_from_device_base(base, v::StartUpShutDown, cu, u) = (
    startup = _convert_from_device_base(base, v.startup, cu, u),
    shutdown = _convert_from_device_base(base, v.shutdown, cu, u),
)

#######################################################
# set_value: accept Unitful.Quantity or RelativeQuantity; return DU scalar
#######################################################

# ---- From Unitful.Quantity (natural units): inverse engine conversion ----
set_value(c::UnitsBearer, field, val::Quantity, cu::Val) = IS._strip_units(
    convert_units(_conversion_base(c, field), val, _unit_category(cu), NU, DU),
)

# ---- From RelativeQuantity in DU (trivial) ----
set_value(::UnitsBearer, field, val::RelativeQuantity{<:Any, DeviceBaseUnit}, ::Val) =
    ustrip(val)

# ---- From RelativeQuantity in SU ----
set_value(c::UnitsBearer, field, val::RelativeQuantity{<:Any, SystemBaseUnit}, cu::Val) =
    IS._strip_units(
        convert_units(_conversion_base(c, field), ustrip(val), _unit_category(cu), SU, DU),
    )

# ---- Bare Float64 is rejected: callers must attach units explicitly ----
set_value(::UnitsBearer, ::Any, ::Float64, ::Val) = throw(
    ArgumentError(
        "setter requires explicit units (e.g. `val * SU`, `val * DU`, `val * MW`)",
    ),
)

# ---- Compound field types for setters ----
_to_device_base(c::UnitsBearer, val, cu) = set_value(c, nothing, val, cu)

set_value(c::UnitsBearer, field, val::NamedTuple{(:min, :max)}, cu::Val) = (
    min = _to_device_base(c, val.min, cu),
    max = _to_device_base(c, val.max, cu),
)

set_value(c::UnitsBearer, field, val::NamedTuple{(:up, :down)}, cu::Val) = (
    up = _to_device_base(c, val.up, cu),
    down = _to_device_base(c, val.down, cu),
)

set_value(c::UnitsBearer, field, val::NamedTuple{(:from_to, :to_from)}, cu::Val) = (
    from_to = _to_device_base(c, val.from_to, cu),
    to_from = _to_device_base(c, val.to_from, cu),
)

set_value(c::UnitsBearer, field, val::NamedTuple{(:from, :to)}, cu::Val) = (
    from = _to_device_base(c, val.from, cu),
    to = _to_device_base(c, val.to, cu),
)

set_value(c::UnitsBearer, field, val::NamedTuple{(:startup, :shutdown)}, cu::Val) = (
    startup = _to_device_base(c, val.startup, cu),
    shutdown = _to_device_base(c, val.shutdown, cu),
)

# ---- Nothing passthrough ----
set_value(::UnitsBearer, _, ::Nothing, ::Val) = nothing

######################################
########### Transformer 3W ###########
######################################

# Per-winding base powers for the three-winding transformer. The generator emits
# the private `_get_base_power_XX` field accessors (`base_power_*` are
# exclude_getter fields); these plain public accessors expose them. Circuit-aware
# unit conversion is handled through the per-circuit `TransformerCircuit` objects.
get_base_power_12(t::ThreeWindingTransformer) = t.base_power_12
get_base_power_23(t::ThreeWindingTransformer) = t.base_power_23
get_base_power_31(t::ThreeWindingTransformer) = t.base_power_31
set_base_power_12!(t::ThreeWindingTransformer, v::Union{Float64, Nothing}) =
    t.base_power_12 = v
set_base_power_23!(t::ThreeWindingTransformer, v::Union{Float64, Nothing}) =
    t.base_power_23 = v
set_base_power_31!(t::ThreeWindingTransformer, v::Union{Float64, Nothing}) =
    t.base_power_31 = v

# A TwoWindingTransformer's series electrical data lives entirely on its circuit.
# Forward the base-power accessors to the circuit so the units engine's device-base
# resolution and downstream base-power reads/writes keep working. The value-typed
# setter variants mirror the generic Component ones (natural units only) so no
# ambiguity arises with `set_base_power!(::Component, ...)`.
_get_base_power(t::TwoWindingTransformer) = get_base_power(get_circuit(t))
set_base_power!(t::TwoWindingTransformer, val::Float64) =
    set_base_power!(get_circuit(t), val)
set_base_power!(t::TwoWindingTransformer, val::Unitful.Quantity) =
    set_base_power!(get_circuit(t), Unitful.ustrip(MVA, val))
set_base_power!(::TwoWindingTransformer, ::RelativeQuantity{<:Any, U}) where {U} =
    _base_power_units_error(U())

# The series impedance r/x lives on the circuit. These forwarding accessors keep
# dispatch on the parent working (e.g. PowerNetworkMatrices reads get_r/get_x on
# the TwoWindingTransformer during Ybus assembly) by delegating to the circuit's
# explicit-units accessors. `magnetizing_shunt` is a parent field, so its
# accessors are generated directly on the transformer and need no forwarding.
get_r(t::TwoWindingTransformer, units) = get_r(get_circuit(t), units)
get_r_unitful(t::TwoWindingTransformer, units) = get_r_unitful(get_circuit(t), units)
set_r!(t::TwoWindingTransformer, val) = set_r!(get_circuit(t), val)
get_x(t::TwoWindingTransformer, units) = get_x(get_circuit(t), units)
get_x_unitful(t::TwoWindingTransformer, units) = get_x_unitful(get_circuit(t), units)
set_x!(t::TwoWindingTransformer, val) = set_x!(get_circuit(t), val)

# Physical category implied by a field's conversion unit.
_unit_category(::Val{:mva}) = POWER
_unit_category(::Val{:ohm}) = IMPEDANCE
_unit_category(::Val{:siemens}) = ADMITTANCE

# Base provider for the pairwise impedance fields of a ThreeWindingTransformer.
# Convention: Z_ij is pu on base_power_ij referenced to the first-index circuit's
# base voltage (PSS/E CZ = 1): r_12/x_12 -> primary, r_23/x_23 -> secondary,
# r_31/x_31 -> tertiary (R3-1 references NOMV3, the tertiary winding). The
# transformer-level `magnetizing_shunt` is pu on the primary circuit's own
# `base_power` referenced to the primary circuit's base voltage (it converts
# directly on the primary `TransformerCircuit`, not through a `PairBase`).
struct PairBase{T <: ThreeWindingTransformer}
    transformer::T
    base_power::Union{Nothing, Float64}
    base_voltage::Union{Nothing, Float64}
end

function _get_device_base_power(p::PairBase)
    isnothing(p.base_power) && error(
        "The pairwise PSS/E fields (r_12/x_12/r_23/x_23/r_31/x_31 and base_power_12/23/31) " *
        "of $(summary(p.transformer)) are not set; cannot convert pairwise values",
    )
    return p.base_power
end
_get_system_base_power(p::PairBase) = _get_system_base_power(p.transformer)
get_base_voltage(p::PairBase) = p.base_voltage
Base.summary(p::PairBase) = "PairBase($(summary(p.transformer)))"

_conversion_base(c::ThreeWindingTransformer, ::Union{Val{:r_12}, Val{:x_12}}) =
    PairBase(c, get_base_power_12(c), get_base_voltage(get_primary_circuit(c)))
_conversion_base(c::ThreeWindingTransformer, ::Union{Val{:r_23}, Val{:x_23}}) =
    PairBase(c, get_base_power_23(c), get_base_voltage(get_secondary_circuit(c)))
_conversion_base(c::ThreeWindingTransformer, ::Union{Val{:r_31}, Val{:x_31}}) =
    PairBase(c, get_base_power_31(c), get_base_voltage(get_tertiary_circuit(c)))
_conversion_base(c::ThreeWindingTransformer, ::Val{:magnetizing_shunt}) =
    get_primary_circuit(c)
