function get_system_base_power(c::Component)
    return get_internal(c).units_info.base_value
end

"""
Default behavior of a component. If there is no base_power field, assume is in the system's base power.
"""
get_base_power(c::Component) = get_system_base_power(c)

_get_multiplier(c::T, conversion_unit) where {T <: Component} =
    _get_multiplier(c, get_internal(c).units_info, conversion_unit)

_get_multiplier(::T, ::Nothing, conversion_unit) where {T <: Component} =
    1.0
_get_multiplier(
    c::T,
    setting::IS.SystemUnitsSettings,
    conversion_unit,
) where {T <: Component} =
    _get_multiplier(c, setting, Val(setting.unit_system), conversion_unit)

# PERF: dispatching on the UnitSystem values instead of comparing with if/else avoids the
# performance hit associated with consulting the dictionary that backs the @scoped_enum --
# i.e., IS.UnitSystem.NATURAL_UNITS by itself isn't treated as a constant, it's a dictionary
# lookup each time.
_get_multiplier(
    ::T,
    ::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.DEVICE_BASE},
    ::Any,
) where {T <: Component} =
    1.0
###############
#### Power ####
###############
_get_multiplier(
    c::T,
    setting::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.SYSTEM_BASE},
    ::Val{:mva},
) where {T <: Component} =
    get_base_power(c) / setting.base_value
_get_multiplier(
    c::T,
    ::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.NATURAL_UNITS},
    ::Val{:mva},
) where {T <: Component} =
    get_base_power(c)

###############
#### Ohms #####
###############
# Z_device / Z_sys = (V_device^2 / S_device) / (V_device^2 / S_sys) = S_sys / S_device 
_get_multiplier(
    c::T,
    setting::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.SYSTEM_BASE},
    ::Val{:ohm},
) where {T <: Branch} =
    setting.base_value / get_base_power(c)
function _get_multiplier(
    c::T,
    ::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.NATURAL_UNITS},
    ::Val{:ohm},
) where {T <: Branch}
    base_voltage = get_base_voltage(get_arc(c).from)
    if isnothing(base_voltage)
        error("Base voltage is not defined for $(c.name).")
    end
    return get_base_voltage(get_arc(c).from)^2 / get_base_power(c)
end

##################
#### Siemens #####
##################
# Y_device / Y_sys = (S_device / V_device^2) / (S_sys / S_sys^2) = S_device / S_sys 
_get_multiplier(
    c::T,
    setting::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.SYSTEM_BASE},
    ::Val{:siemens},
) where {T <: Branch} =
    get_base_power(c) / setting.base_value
function _get_multiplier(
    c::T,
    ::IS.SystemUnitsSettings,
    ::Val{IS.UnitSystem.NATURAL_UNITS},
    ::Val{:siemens},
) where {T <: Branch}
    base_voltage = get_base_voltage(get_arc(c).from)
    if isnothing(base_voltage)
        @warn "Base voltage is not set for $(c.name). Returning in DEVICE_BASE units."
        return 1.0
    end
    return get_base_power(c) / get_base_voltage(get_arc(c).from)^2
end

_get_multiplier(::T, ::IS.SystemUnitsSettings, _, _) where {T <: Component} =
    error("Undefined Conditional")

function get_value(c::Component, ::Val{T}, conversion_unit) where {T}
    value = Base.getproperty(c, T)
    return _get_value(c, value, conversion_unit)
end

function _get_value(c::Component, value::Float64, conversion_unit)::Float64
    return _get_multiplier(c, conversion_unit) * value
end

function _get_value(c::Component, value::MinMax, conversion_unit)::MinMax
    m = _get_multiplier(c, conversion_unit)
    return (min = value.min * m, max = value.max * m)
end

function _get_value(
    c::Component,
    value::StartUpShutDown,
    conversion_unit,
)::StartUpShutDown
    m = _get_multiplier(c, conversion_unit)
    return (startup = value.startup * m, shutdown = value.shutdown * m)
end

function _get_value(c::Component, value::UpDown, conversion_unit)::UpDown
    m = _get_multiplier(c, conversion_unit)
    return (up = value.up * m, down = value.down * m)
end

function _get_value(c::Component, value::FromTo_ToFrom, conversion_unit)::FromTo_ToFrom
    m = _get_multiplier(c, conversion_unit)
    return (from_to = value.from_to * m, to_from = value.to_from * m)
end

function _get_value(c::Component, value::FromTo, conversion_unit)::FromTo
    m = _get_multiplier(c, conversion_unit)
    return (from = value.from * m, to = value.to * m)
end

function _get_value(::Component, ::Nothing, _)
    return nothing
end

function _get_value(::T, value::V, _) where {T <: Component, V}
    @warn("conversion not implemented for $(V) in component $(T)")
    return value::V
end

function _get_value(::Nothing, _, _)
    return
end

function set_value(c::Component, ::Val{T}, conversion_unit) where {T}
    value = Base.getproperty(c, T)
    return _set_value(c, value, conversion_unit)
end

function _set_value(c::Component, value::Float64, conversion_unit)::Float64
    return (1 / _get_multiplier(c, conversion_unit)) * value
end

function _set_value(c::Component, value::MinMax, conversion_unit)::MinMax
    m = 1 / _get_multiplier(c, conversion_unit)
    return (min = value.min * m, max = value.max * m)
end

function _set_value(
    c::Component,
    value::StartUpShutDown,
    conversion_unit,
)::StartUpShutDown
    m = 1 / _get_multiplier(c, conversion_unit)
    return (startup = value.startup * m, shutdown = value.shutdown * m)
end

function _set_value(c::Component, value::UpDown, conversion_unit)::UpDown
    m = 1 / _get_multiplier(c, conversion_unit)
    return (up = value.up * m, down = value.down * m)
end

function _set_value(c::Component, value::FromTo_ToFrom, conversion_unit)::FromTo_ToFrom
    m = 1 / _get_multiplier(c, conversion_unit)
    return (from_to = value.from_to * m, to_from = value.to_from * m)
end

function _set_value(c::Component, value::FromTo, conversion_unit)::FromTo
    m = 1 / _get_multiplier(c, conversion_unit)
    return (from = value.from * m, to_from = value.to * m)
end

function _set_value(::Component, ::Nothing, _)
    return nothing
end

function _set_value(c::T, value::V, _) where {T <: Component, V}
    @warn("conversion not implemented for $(V) in component $(T)")
    return value::V
end

function _set_value(::Nothing, _, _)
    return
end
