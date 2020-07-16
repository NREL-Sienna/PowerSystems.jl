"""
    Default behavior of a component. If there is no base_power field, assume is in the system's base power.
"""
function get_base_power(c::Component)
    return get_internal(c).units_info.base_value
end

function _get_multiplier(c::T) where {T <: Component}
    setting = get_internal(c).units_info
    if isnothing(setting)
        return 1.0
    elseif setting.unit_system == IS.DEVICE_BASE
        return 1.0
    elseif setting.unit_system == IS.SYSTEM_BASE
        numerator = get_base_power(c)
        denominator = setting.base_value
    elseif setting.unit_system == IS.NATURAL_UNITS
        numerator = get_base_power(c)
        denominator = 1.0
    else
        error("Undefined Conditional")
    end
    return numerator / denominator
end

function get_value(c::Component, value::Float64)
    return _get_multiplier(c) * value
end

function get_value(c::Component, value::Min_Max)
    m = _get_multiplier(c)
    return (min = value.min * m, max = value.max * m)
end

function get_value(c::T, value::V) where {T <: Component, V}
    @warn("conversion not implemented for $(V) in component $(T)")
    return value::V
end

function has_forecasts(d::Component)
    return IS.has_forecasts(d)
end
