function orderedlimits(limits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing},limsname::String)
    if isa(limits,Nothing)
        @info "'$limsname' limits defined as nothing"
    else
        limits.max < limits.min ? @warn("'$limsname' limits not in ascending order") : limits
    end
    return limits
end
