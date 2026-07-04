@inline function _get_system_base_power(c::Component)
    units_info = IS.get_units_info(get_internal(c))
    isnothing(units_info) && error("Component $(get_name(c)) is not attached to a system.")
    return units_info.base_value
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
get_base_voltage(c::Branch) = get_base_voltage(get_arc(c).from)
get_base_voltage(c::TwoWindingTransformer) = get_base_voltage_primary(c)
get_base_voltage(c::ThreeWindingTransformer) = error(
    "Three-winding transformers have per-winding base voltages; use " *
    "get_base_voltage_primary/secondary/tertiary.",
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
function get_value(c::Component, field::Val{T}, conversion_unit, units) where {T}
    value = Base.getproperty(c, T)
    return _convert_from_device_base(
        _conversion_base(c, field),
        value,
        conversion_unit,
        units,
    )
end

# Base provider for the conversion engine: which object carries the bases for
# a given field. Components are their own provider; multi-winding components
# substitute a per-winding view (see `WindingBase` below). This single hook is
# what makes the generic getter/setter paths winding-aware — no per-type
# method mirrors.
_conversion_base(c::Component, ::Any) = c
_conversion_base(c::ThreeWindingTransformer, field::Val) = WindingBase(c, field)

# ---- DU → requested units: one delegation to the conversion engine. The
# field's conversion-unit token picks the physical category; the engine
# resolves bases through the component interface above. ----
_convert_from_device_base(base, value::Number, cu::Val, units) =
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
set_value(c::Component, field, val::Quantity, cu::Val) = IS._strip_units(
    convert_units(_conversion_base(c, field), val, _unit_category(cu), NU, DU),
)

# ---- From RelativeQuantity in DU (trivial) ----
set_value(::Component, field, val::RelativeQuantity{<:Any, DeviceBaseUnit}, ::Val) =
    ustrip(val)

# ---- From RelativeQuantity in SU ----
set_value(c::Component, field, val::RelativeQuantity{<:Any, SystemBaseUnit}, cu::Val) =
    IS._strip_units(
        convert_units(_conversion_base(c, field), ustrip(val), _unit_category(cu), SU, DU),
    )

# ---- Bare Float64 is rejected: callers must attach units explicitly ----
set_value(::Component, ::Any, ::Float64, ::Val) = throw(
    ArgumentError(
        "setter requires explicit units (e.g. `val * SU`, `val * DU`, `val * MW`)",
    ),
)

# ---- Compound field types for setters ----
_to_device_base(c::Component, val, cu) = set_value(c, nothing, val, cu)

set_value(c::Component, field, val::NamedTuple{(:min, :max)}, cu::Val) = (
    min = _to_device_base(c, val.min, cu),
    max = _to_device_base(c, val.max, cu),
)

set_value(c::Component, field, val::NamedTuple{(:up, :down)}, cu::Val) = (
    up = _to_device_base(c, val.up, cu),
    down = _to_device_base(c, val.down, cu),
)

set_value(c::Component, field, val::NamedTuple{(:from_to, :to_from)}, cu::Val) = (
    from_to = _to_device_base(c, val.from_to, cu),
    to_from = _to_device_base(c, val.to_from, cu),
)

set_value(c::Component, field, val::NamedTuple{(:from, :to)}, cu::Val) = (
    from = _to_device_base(c, val.from, cu),
    to = _to_device_base(c, val.to, cu),
)

set_value(c::Component, field, val::NamedTuple{(:startup, :shutdown)}, cu::Val) = (
    startup = _to_device_base(c, val.startup, cu),
    shutdown = _to_device_base(c, val.shutdown, cu),
)

# ---- Nothing passthrough ----
set_value(::Component, _, ::Nothing, ::Val) = nothing

######################################
########### Transformer 3W ###########
######################################

PrimaryImpedances = Union{
    Val{:r_primary},
    Val{:x_primary},
    Val{:r_12},
    Val{:x_12},
}

PrimaryAdmittances = Union{
    Val{:g},
    Val{:b},
}

PrimaryPower = Union{
    Val{:active_power_flow_primary},
    Val{:reactive_power_flow_primary},
    Val{:rating},
    Val{:rating_primary},
}

SecondaryImpedances = Union{
    Val{:r_secondary},
    Val{:x_secondary},
    Val{:r_23},
    Val{:x_23},
}

SecondaryPower = Union{
    Val{:active_power_flow_secondary},
    Val{:reactive_power_flow_secondary},
    Val{:rating_secondary},
}

TertiaryImpedances = Union{
    Val{:r_tertiary},
    Val{:x_tertiary},
    Val{:r_13},
    Val{:x_13},
}

TertiaryPower = Union{
    Val{:active_power_flow_tertiary},
    Val{:reactive_power_flow_tertiary},
    Val{:rating_tertiary},
}

###### Multipliers ######

_get_winding_base_power(
    c::ThreeWindingTransformer,
    ::Union{PrimaryImpedances, PrimaryAdmittances, PrimaryPower},
) = _get_base_power_12(c)
_get_winding_base_power(
    c::ThreeWindingTransformer,
    ::Union{SecondaryImpedances, SecondaryPower},
) =
    _get_base_power_23(c)
_get_winding_base_power(
    c::ThreeWindingTransformer,
    ::Union{TertiaryImpedances, TertiaryPower},
) =
    _get_base_power_13(c)

# Public unit-aware winding base_power accessors for ThreeWindingTransformer.
# Bare-number `$pub` plus unit-bearing `$pub_unitful` companion.
for (pub, priv, field) in (
    (:get_base_power_12, :_get_base_power_12, :base_power_12),
    (:get_base_power_23, :_get_base_power_23, :base_power_23),
    (:get_base_power_13, :_get_base_power_13, :base_power_13),
)
    pub_unitful = Symbol(pub, :_unitful)
    setter = Symbol(:set_, field, :!)
    @eval begin
        $pub(c::ThreeWindingTransformer, u) = IS._strip_units($pub_unitful(c, u))

        $pub_unitful(c::ThreeWindingTransformer, ::NaturalUnit) = $priv(c) * MVA
        $pub_unitful(c::ThreeWindingTransformer, u::Unitful.Units) =
            Unitful.uconvert(u, $priv(c) * MVA)
        $pub_unitful(c::ThreeWindingTransformer, ::SystemBaseUnit) =
            ($priv(c) / _get_system_base_power(c)) * SU
        $pub_unitful(c::ThreeWindingTransformer, ::DeviceBaseUnit) = 1.0 * DU

        $setter(c::ThreeWindingTransformer, val::Float64) = (c.$field = val)
        $setter(c::ThreeWindingTransformer, val::Unitful.Quantity) =
            (c.$field = Unitful.ustrip(u"MW", val))
        $setter(c::ThreeWindingTransformer, val::RelativeQuantity{<:Any, SystemBaseUnit}) =
            (c.$field = ustrip(val) * _get_system_base_power(c))
        $setter(::ThreeWindingTransformer, ::RelativeQuantity{<:Any, DeviceBaseUnit}) =
            error(
                "Setting " * $(string(field)) * " in device base (DU) is ambiguous: " *
                "device base is 1.0 pu of itself by construction. Pass MVA, MW, or SU instead.",
            )

        IS.display_units_arg(::typeof($pub), ::Type{<:ThreeWindingTransformer}) = NU
        IS.display_units_arg(::typeof($pub_unitful), ::Type{<:ThreeWindingTransformer}) = NU
        IS.display_units_arg(::typeof($setter), ::Type{<:ThreeWindingTransformer}) = NU
    end
end

function _get_winding_base_voltage(
    c::ThreeWindingTransformer,
    ::Union{PrimaryImpedances, PrimaryAdmittances},
)
    base_voltage = get_base_voltage_primary(c)
    if isnothing(base_voltage)
        error("Base voltage is not defined for $(summary(c)).")
    end
    return base_voltage
end

function _get_winding_base_voltage(
    c::ThreeWindingTransformer,
    ::SecondaryImpedances,
)
    base_voltage = get_base_voltage_secondary(c)
    if isnothing(base_voltage)
        error("Base voltage is not defined for $(summary(c)).")
    end
    return base_voltage
end

function _get_winding_base_voltage(
    c::ThreeWindingTransformer,
    ::TertiaryImpedances,
)
    base_voltage = get_base_voltage_tertiary(c)
    if isnothing(base_voltage)
        error("Base voltage is not defined for $(summary(c)).")
    end
    return base_voltage
end

# Each winding pair carries its own MVA and kV base, so the component-wide
# `_get_base_power`/`get_base_voltage` used by the generic conversion are wrong
# here. `WindingBase` is a lightweight per-winding *base provider*: it
# implements the conversion-engine component interface with the winding's
# bases (the field doubles as the winding token), so the entire 5-arg
# `convert_units` engine — getters and setters alike — works per-winding.
struct WindingBase{T <: ThreeWindingTransformer, F <: Val}
    component::T
    field::F
end

_get_device_base_power(w::WindingBase) = _get_winding_base_power(w.component, w.field)
_get_system_base_power(w::WindingBase) = _get_system_base_power(w.component)
get_base_voltage(w::WindingBase) = _get_winding_base_voltage(w.component, w.field)
Base.summary(w::WindingBase) = summary(w.component)

# Physical category implied by a field's conversion unit.
_unit_category(::Val{:mva}) = POWER
_unit_category(::Val{:ohm}) = IMPEDANCE
_unit_category(::Val{:siemens}) = ADMITTANCE
