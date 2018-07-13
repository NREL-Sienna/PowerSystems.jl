function orderedlimits(limits::Union{@NT(max::Float64, min::Float64),@NT(min::Float64, max::Float64),Nothing},limsname::String)
    if isa(limits,Nothing)
        info("'$limsname' limits defined as nothing")
    else
        limits.max <= limits.min ? warn("'$limsname' limits not in ascending order") : limits
    end
    return limits
end
