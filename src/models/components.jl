function _get_multiplier(c::T) where T <: Component
    setting = get_internal(c).units_info
    if setting.unit_system == IS.DEVICE_BASE
        return 1.0
    elseif setting.unit_system == IS.SYSTEM_BASE
        numerator = hasfield(T, :base_power) ? setting.base_value : get_base_power(c)
        denominator = setting.base_value
    elseif setting.unit_system == IS.NATURAL_UNITS
        numerator = hasfield(T, :base_power) ? setting.base_value : get_base_power(c)
        denominator = 1.0
    else
        @assert false
    end
    return numerator/denominator
end

function get_value(c::Component, value::Float64)
    return _get_multiplier(c)*value
end

function get_value(c::Component, value::Min_Max)
    m = _get_multiplier(c)
    return (min = value.min*m, max = value.max*m)
end

function get_value(c::T, value::V) where {T <: Component, V}
    @warn("conversion not implemented for $(V) in component $(T)")
    return value::V
end
