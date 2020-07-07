function get_value(c::Component, value::Symbol)
    return getfield(c, value)
end
