@inline function _get_system_base_power(c::Component)
    units_info = get_internal(c).units_info
    isnothing(units_info) && error("Component $(get_name(c)) is not attached to a system.")
    # Assert concrete type; units_info field is typed as abstract UnitsData.
    return (units_info::IS.SystemUnitsSettings).base_value
end

"""
Unitless device-base power (MVA). Fallback for components with no `base_power`
field: the device base equals the system base.
"""
_get_base_power(c::Component) = _get_system_base_power(c)

"""
Unit-aware `base_power` accessor returning a bare number. Unlike most field
accessors, storage is in MVA (natural units), not device-base per-unit — so
conversion is bespoke. For the unit-bearing value see [`get_base_power_unitful`](@ref).
"""
get_base_power(c::Component, u) = IS._strip_units(get_base_power_unitful(c, u))

"""
Unit-aware `base_power` accessor returning a unit-bearing quantity. See
[`get_base_power`](@ref) for a bare number.
"""
get_base_power_unitful(c::Component, ::NaturalUnit) = _get_base_power(c) * MVA
get_base_power_unitful(c::Component, u::Unitful.Units) =
    Unitful.uconvert(u, _get_base_power(c) * MVA)
get_base_power_unitful(c::Component, ::SystemBaseUnit) =
    (_get_base_power(c) / _get_system_base_power(c)) * SU
get_base_power_unitful(c::Component, ::DeviceBaseUnit) = 1.0 * DU

"""
Set `base_power` (stored as a bare MVA `Float64`).

Accepts:
- `Float64` — interpreted as MVA.
- `Unitful.Quantity` of power — converted to MW.
- [`RelativeQuantity`](@ref) in `SU` (system base) — multiplied by the system base.

Setting in device base (`DU`) is rejected: device base is, by definition,
`1.0 pu` of itself, so the value carries no information.
"""
set_base_power!(c::Component, val::Float64) = (c.base_power = val)
set_base_power!(c::Component, val::Unitful.Quantity) =
    (c.base_power = Unitful.ustrip(MVA, val))
set_base_power!(c::Component, val::RelativeQuantity{<:Any, SystemBaseUnit}) =
    (c.base_power = IS.ustrip(val) * _get_system_base_power(c))
set_base_power!(::Component, ::RelativeQuantity{<:Any, DeviceBaseUnit}) =
    error(
        "Setting base_power in device base (DU) is ambiguous: device base is " *
        "1.0 pu of itself by construction. Pass MVA, MW, or SU instead.",
    )

IS.display_units_arg(::typeof(get_base_power), ::Type{<:Component}) = NU
IS.display_units_arg(::typeof(get_base_power_unitful), ::Type{<:Component}) = NU
IS.display_units_arg(::typeof(set_base_power!), ::Type{<:Component}) = NU

# Make `_strip_units` work for Unitful quantities; IS doesn't depend on Unitful.
IS._strip_units(q::Unitful.Quantity) = Unitful.ustrip(q)

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
function get_value(c::Component, ::Val{T}, conversion_unit, units) where {T}
    value = Base.getproperty(c, T)
    return _convert_from_device_base(c, value, conversion_unit, units)
end

# ---- DU → natural power units ----
_convert_from_device_base(c::Component, value::Float64, ::Val{:mva}, ::typeof(MW)) =
    value * _get_base_power(c) * u"MW"

_convert_from_device_base(c::Component, value::Float64, ::Val{:mva}, ::typeof(Mvar)) =
    value * _get_base_power(c) * Mvar

function _convert_from_device_base(
    c::T, value::Number, ::Val{:ohm}, ::typeof(OHMS),
) where {T <: Branch}
    base_voltage = get_base_voltage(get_arc(c).from)
    isnothing(base_voltage) && error("Base voltage is not defined for $(summary(c)).")
    return value * (base_voltage^2 / _get_base_power(c)) * u"Ω"
end

function _convert_from_device_base(
    c::T, value::Number, ::Val{:ohm}, ::typeof(OHMS),
) where {T <: TwoWindingTransformer}
    base_voltage = get_base_voltage_primary(c)
    isnothing(base_voltage) && error("Base voltage is not defined for $(summary(c)).")
    return value * (base_voltage^2 / _get_base_power(c)) * u"Ω"
end

function _convert_from_device_base(
    c::T, value::Number, ::Val{:siemens}, ::typeof(SIEMENS),
) where {T <: Branch}
    base_voltage = get_base_voltage(get_arc(c).from)
    if isnothing(base_voltage)
        @warn "Base voltage is not set for $(c.name). Returning in device base units."
        return value * DU
    end
    return value * (_get_base_power(c) / base_voltage^2) * u"S"
end

function _convert_from_device_base(
    c::T, value::Number, ::Val{:siemens}, ::typeof(SIEMENS),
) where {T <: TwoWindingTransformer}
    base_voltage = get_base_voltage_primary(c)
    if isnothing(base_voltage)
        @warn "Base voltage is not set for $(c.name). Returning in device base units."
        return value * DU
    end
    return value * (_get_base_power(c) / base_voltage^2) * u"S"
end

# ---- DU → NU (route to the conversion_unit's natural Unitful unit) ----
_convert_from_device_base(c::Component, v::Float64, cu::Val{:mva}, ::NaturalUnit) =
    _convert_from_device_base(c, v, cu, MW)
_convert_from_device_base(c::Component, v::Number, cu::Val{:ohm}, ::NaturalUnit) =
    _convert_from_device_base(c, v, cu, OHMS)
_convert_from_device_base(c::Component, v::Number, cu::Val{:siemens}, ::NaturalUnit) =
    _convert_from_device_base(c, v, cu, SIEMENS)

# ---- DU → DU (identity; no system info needed) ----
_convert_from_device_base(::Component, value::Number, ::Val, ::DeviceBaseUnit) =
    value * DU

# ---- DU → SU (RelativeQuantity{Float64, SystemBaseUnit}) ----
function _convert_from_device_base(
    c::Component, value::Float64, ::Val{:mva}, ::SystemBaseUnit,
)
    return (value * (_get_base_power(c) / _get_system_base_power(c))) * SU
end

function _convert_from_device_base(
    c::T, value::Number, ::Val{:ohm}, ::SystemBaseUnit,
) where {T <: Branch}
    return (value * (_get_system_base_power(c) / _get_base_power(c))) * SU
end

function _convert_from_device_base(
    c::T, value::Number, ::Val{:siemens}, ::SystemBaseUnit,
) where {T <: Branch}
    return (value * (_get_base_power(c) / _get_system_base_power(c))) * SU
end

# ---- Generic fallback: any Unitful target for :mva ----
function _convert_from_device_base(
    c::Component, value::Float64, ::Val{:mva}, units::Unitful.Units,
)
    return Unitful.uconvert(units, value * _get_base_power(c) * u"MW")
end

# ---- Nothing passthrough ----
_convert_from_device_base(::Component, ::Nothing, ::Val, ::Any) = nothing

# ---- Compound field types ----
_convert_from_device_base(c::Component, v::MinMax, cu, u) = (
    min = _convert_from_device_base(c, v.min, cu, u),
    max = _convert_from_device_base(c, v.max, cu, u),
)

_convert_from_device_base(c::Component, v::UpDown, cu, u) = (
    up = _convert_from_device_base(c, v.up, cu, u),
    down = _convert_from_device_base(c, v.down, cu, u),
)

_convert_from_device_base(c::Component, v::FromTo_ToFrom, cu, u) = (
    from_to = _convert_from_device_base(c, v.from_to, cu, u),
    to_from = _convert_from_device_base(c, v.to_from, cu, u),
)

_convert_from_device_base(c::Component, v::FromTo, cu, u) = (
    from = _convert_from_device_base(c, v.from, cu, u),
    to = _convert_from_device_base(c, v.to, cu, u),
)

_convert_from_device_base(c::Component, v::StartUpShutDown, cu, u) = (
    startup = _convert_from_device_base(c, v.startup, cu, u),
    shutdown = _convert_from_device_base(c, v.shutdown, cu, u),
)

#######################################################
# set_value: accept Unitful.Quantity or RelativeQuantity; return DU scalar
#######################################################

# ---- From Unitful.Quantity (natural units) ----
function set_value(c::Component, field, val::Quantity, ::Val{:mva})
    return Unitful.ustrip(u"MW", val) / _get_base_power(c)
end

function set_value(
    c::T, field, val::Quantity, ::Val{:ohm},
) where {T <: Branch}
    base_voltage = get_base_voltage(get_arc(c).from)
    isnothing(base_voltage) && error("Base voltage is not defined for $(summary(c)).")
    return Unitful.ustrip(u"Ω", val) / (base_voltage^2 / _get_base_power(c))
end

function set_value(
    c::T, field, val::Quantity, ::Val{:siemens},
) where {T <: Branch}
    base_voltage = get_base_voltage(get_arc(c).from)
    isnothing(base_voltage) && error("Base voltage is not defined for $(summary(c)).")
    return Unitful.ustrip(u"S", val) / (_get_base_power(c) / base_voltage^2)
end

# ---- From RelativeQuantity in DU (trivial) ----
set_value(::Component, field, val::RelativeQuantity{<:Any, DeviceBaseUnit}, ::Val) =
    ustrip(val)

# ---- From RelativeQuantity in SU ----
function set_value(
    c::Component, field, val::RelativeQuantity{<:Any, SystemBaseUnit}, ::Val{:mva},
)
    return ustrip(val) / (_get_base_power(c) / _get_system_base_power(c))
end

function set_value(
    c::T, field, val::RelativeQuantity{<:Any, SystemBaseUnit}, ::Val{:ohm},
) where {T <: Branch}
    return ustrip(val) / (_get_system_base_power(c) / _get_base_power(c))
end

function set_value(
    c::T, field, val::RelativeQuantity{<:Any, SystemBaseUnit}, ::Val{:siemens},
) where {T <: Branch}
    return ustrip(val) / (_get_base_power(c) / _get_system_base_power(c))
end

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
            (c.$field = IS.ustrip(val) * _get_system_base_power(c))
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

# Units-aware get_value for three-winding transformers. Each winding pair carries
# its own MVA and kV base, so the component-wide `_get_base_power`/`get_base_voltage`
# used by the generic `Branch` conversion are wrong here. We route through the
# `convert_units` engine instead, passing the field as the winding token; the engine
# pulls the per-winding bases from the accessors below. Dispatch is on the requested
# `units` type (not the system's mutable unit setting), keeping the hot path type-stable.
function get_value(
    c::ThreeWindingTransformer,
    field::Val{T},
    conversion_unit::Val,
    units::IS.AbstractUnitSystem,
) where {T}
    return convert_units(
        c, Base.getproperty(c, T), _unit_category(conversion_unit), DU, units, field,
    )
end

# Physical category implied by a field's conversion unit.
_unit_category(::Val{:mva}) = POWER
_unit_category(::Val{:ohm}) = IMPEDANCE
_unit_category(::Val{:siemens}) = ADMITTANCE

# Per-winding base accessors consumed by `convert_units`. The field doubles as the
# winding token: it selects which winding's base power and base voltage apply.
_get_device_base_power(c::ThreeWindingTransformer, field::Val) =
    _get_winding_base_power(c, field)
get_base_voltage(c::ThreeWindingTransformer, field::Val) =
    _get_winding_base_voltage(c, field)
