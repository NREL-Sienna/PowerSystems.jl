function get_value(c::Component, value::Float64)
    return value
end

function get_value(c::Component, value::Min_Max)
    return value
end

function get_value(c::Component, value::T) where {T}
    return value::T
end
