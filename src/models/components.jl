function get_value(::Type{Float64}, c::Component, value::Symbol)
    return getfield(c, value)::Float64
end

function get_value(::Type{Min_Max}, c::Component, value::Symbol)
    return getfield(c, value)::Min_Max
end

function get_value(::Type{T}, c::Component, value::Symbol) where T
    return getfield(c, value)::T
end
