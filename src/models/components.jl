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

# Conversion-engine component interface (see src/units/conversions.jl): the
# engine resolves bases through these three functions, so every getter and
# setter shares one base-power/base-voltage choice per component type.
_get_device_base_power(c::Component) = _get_base_power(c)

# TransformerWinding is a self-contained explicit-units base provider (defined
# in models/transformer_windings.jl, included earlier): it carries its own
# base_power/base_voltage/units_info and does not need a component to delegate
# to (get_base_voltage(w) and Base.summary(w) are defined alongside the struct).
_get_device_base_power(w::TransformerWinding) = w.base_power
function _get_system_base_power(w::TransformerWinding)
    isnothing(w.units_info) && error(
        "TransformerWinding is not attached to a System; cannot convert to/from system base",
    )
    return w.units_info.base_value
end

const UnitsBearer = Union{Component, TransformerWinding}

get_base_voltage(c::Branch) = get_base_voltage(get_arc(c).from)

# TwoWindingTransformer has no `arc` field of its own (the arc lives on its
# TransformerWinding); delegate the generic Branch interface (get_arc, set_arc!)
# to the winding so that check_component_addition/check_attached_buses/
# _handle_branch_addition_common! and get_from_bus/get_to_bus (all defined
# generically over `Branch` in terms of get_arc) work unmodified.
get_arc(c::TwoWindingTransformer) = get_arc(get_winding(c))
set_arc!(c::TwoWindingTransformer, arc::Arc) = set_arc!(get_winding(c), arc)

# 2W: device base voltage is the primary (winding) side
get_base_voltage(c::TwoWindingTransformer) = get_base_voltage(get_winding(c))
get_base_voltage(c::ThreeWindingTransformer) = error(
    "Three-winding transformers have per-winding base voltages; use " *
    "get_base_voltage(get_primary_winding(t))/get_base_voltage(get_secondary_winding(t))/" *
    "get_base_voltage(get_tertiary_winding(t)).",
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
set_base_power!(c::Component, val::Float64) = (c.base_power = val)
# `ustrip(MVA, val)` converts power units and throws for non-power units.
set_base_power!(c::Component, val::Unitful.Quantity) =
    (c.base_power = Unitful.ustrip(MVA, val))
set_base_power!(::Component, ::RelativeQuantity{<:Any, U}) where {U} =
    _base_power_units_error(U())

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
# Fields are stored internally in device base (DU). The 4-arg `get_value`
# converts from DU to a requested target (e.g., MW, SU). The 3-arg form
# delegates to the 4-arg with DEFAULT_UNITS (= SU, a RelativeQuantity
# carrying its unit in its type).
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
# given field. Components (and `TransformerWinding`, which is its own base
# provider) are their own provider. Multi-winding transformers delegate to their
# per-winding `TransformerWinding` objects, which are themselves `UnitsBearer`s.
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
# exclude_getter fields); these plain public accessors expose them. Winding-aware
# unit conversion is handled through the per-winding `TransformerWinding` objects
# (see Tasks 5-6).
get_base_power_12(t::ThreeWindingTransformer) = t.base_power_12
get_base_power_23(t::ThreeWindingTransformer) = t.base_power_23
get_base_power_13(t::ThreeWindingTransformer) = t.base_power_13
set_base_power_12!(t::ThreeWindingTransformer, v::Float64) = t.base_power_12 = v
set_base_power_23!(t::ThreeWindingTransformer, v::Float64) = t.base_power_23 = v
set_base_power_13!(t::ThreeWindingTransformer, v::Float64) = t.base_power_13 = v

# Physical category implied by a field's conversion unit.
_unit_category(::Val{:mva}) = POWER
_unit_category(::Val{:ohm}) = IMPEDANCE
_unit_category(::Val{:siemens}) = ADMITTANCE

# Base provider for the pairwise impedance/shunt fields of a ThreeWindingTransformer.
# Convention: Z_ij is pu on base_power_ij referenced to the first-index winding's
# base voltage (PSS/E CZ = 1).
struct PairBase{T <: ThreeWindingTransformer}
    transformer::T
    base_power::Float64
    base_voltage::Union{Nothing, Float64}
end

_get_device_base_power(p::PairBase) = p.base_power
_get_system_base_power(p::PairBase) = _get_system_base_power(p.transformer)
get_base_voltage(p::PairBase) = p.base_voltage
Base.summary(p::PairBase) = "PairBase($(summary(p.transformer)))"

_conversion_base(
    c::ThreeWindingTransformer,
    ::Union{Val{:r_12}, Val{:x_12}, Val{:magnetizing_shunt}},
) = PairBase(c, get_base_power_12(c), get_base_voltage(get_primary_winding(c)))
_conversion_base(c::ThreeWindingTransformer, ::Union{Val{:r_23}, Val{:x_23}}) =
    PairBase(c, get_base_power_23(c), get_base_voltage(get_secondary_winding(c)))
_conversion_base(c::ThreeWindingTransformer, ::Union{Val{:r_13}, Val{:x_13}}) =
    PairBase(c, get_base_power_13(c), get_base_voltage(get_primary_winding(c)))
