function get_system_base_power(c::Component)
    return get_internal(c).units_info.base_value
end

"""
Default behavior of a component. If there is no base_power field, assume is in the system's base power.
"""
get_base_power(c::Component) = get_system_base_power(c)

_get_multiplier(c::T) where {T <: Component} =
    _get_multiplier(c, get_internal(c).units_info)

_get_multiplier(::T, ::Nothing) where {T <: Component} =
    1.0
_get_multiplier(c::T, setting::IS.SystemUnitsSettings) where {T <: Component} =
    _get_multiplier(c, setting, Val(setting.unit_system))

# PERF: dispatching on the UnitSystem values instead of comparing with if/else avoids the
# performance hit associated with consulting the dictionary that backs the @scoped_enum --
# i.e., IS.UnitSystem.NATURAL_UNITS by itself isn't treated as a constant, it's a dictionary
# lookup each time.
_get_multiplier(
    ::T,
    ::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.DEVICE_BASE},
) where {T <: Component} =
    1.0
_get_multiplier(
    c::T,
    setting::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.SYSTEM_BASE},
) where {T <: Component} =
    get_base_power(c) / setting.base_value
_get_multiplier(
    c::T,
    ::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.NATURAL_UNITS},
) where {T <: Component} =
    get_base_power(c)
_get_multiplier(::T, ::IS.SystemUnitsSettings, ::Val) where {T <: Component} =
    error("Undefined Conditional")

function get_value(c::Component, value::Float64, unit::Val = Val{:mva})
    return _get_multiplier(c) * value
end

function get_value(c::Component, value::MinMax, unit::Val = Val{:mva})
    m = _get_multiplier(c)
    return (min = value.min * m, max = value.max * m)
end

function get_value(c::Component, value::StartUpShutDown, unit::Val = Val{:mva})
    m = _get_multiplier(c)
    return (startup = value.startup * m, shutdown = value.shutdown * m)
end

function get_value(c::Component, value::UpDown, unit::Val = Val{:mva})
    m = _get_multiplier(c)
    return (up = value.up * m, down = value.down * m)
end

function get_value(c::Component, value::FromTo_ToFrom, unit::Val = Val{:mva})
    m = _get_multiplier(c)
    return (from_to = value.from_to * m, to_from = value.to_from * m)
end

function get_value(c::Component, value::FromTo, unit::Val = Val{:mva})
    m = _get_multiplier(c)
    return (from = value.from * m, to = value.to * m)
end

function get_value(c::Component, value::Nothing, unit::Val = Val{:mva})
    return value
end

function get_value(c::T, value::V, ::Val) where {T <: Component, V}
    @warn("conversion not implemented for $(V) in component $(T)")
    return value::V
end

function get_value(::Nothing, _, _)
    return
end

function set_value(c::Component, value::Float64, unit::Val = Val{:mva})
    return (1 / _get_multiplier(c)) * value
end

function set_value(c::Component, value::MinMax, unit::Val = Val{:mva})
    m = 1 / _get_multiplier(c)
    return (min = value.min * m, max = value.max * m)
end

function set_value(c::Component, value::StartUpShutDown, unit::Val = Val{:mva})
    m = 1 / _get_multiplier(c)
    return (startup = value.startup * m, shutdown = value.shutdown * m)
end

function set_value(c::Component, value::UpDown, unit::Val = Val{:mva})
    m = 1 / _get_multiplier(c)
    return (up = value.up * m, down = value.down * m)
end

function set_value(c::Component, value::FromTo_ToFrom, unit::Val = Val{:mva})
    m = 1 / _get_multiplier(c)
    return (from_to = value.from_to * m, to_from = value.to_from * m)
end

function set_value(c::Component, value::FromTo, unit::Val = Val{:mva})
    m = 1 / _get_multiplier(c)
    return (from = value.from * m, to_from = value.to * m)
end

function set_value(c::Component, value::Nothing, ::Val)
    return value
end

function set_value(c::T, value::V, ::Val = Val{:mva}) where {T <: Component, V}
    @warn("conversion not implemented for $(V) in component $(T)")
    return value::V
end

function set_value(::Nothing, _, _)
    return
end
