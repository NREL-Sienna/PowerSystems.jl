function orderedlimits(limits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing},limsname::String)
    if isa(limits,Nothing)
        @info "'$limsname' limits defined as nothing"
    else
        if limits.max < limits.min @error "'$limsname' limits not in ascending order" else limits end
    end
    return limits
end
