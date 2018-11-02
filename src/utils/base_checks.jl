function orderedlimits(limits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing},limsname::String)
    if isa(limits,Nothing)
        @info "'$limsname' limits defined as nothing"
    else
        if limits.max < limits.min @error "'$limsname' limits not in ascending order" else limits end
    end
    return limits
end


function getresolution(ts::TimeSeries.TimeArray)

    tstamps = timestamp(ts)
    timediffs = unique([tstamps[ix]-tstamps[ix-1] for ix in 2:length(tstamps)])

    res = []

    for timediff in timediffs
        if mod(timediff,Millisecond(Day(1))) == Millisecond(0) 
            push!(res,Day(timediff/Millisecond(Day(1))))
        elseif mod(timediff,Millisecond(Hour(1))) == Millisecond(0)
            push!(res,Hour(timediff/Millisecond(Hour(1))))
        elseif mod(timediff,Millisecond(Minute(1))) == Millisecond(0)
            push!(res,Minute(timediff/Millisecond(Minute(1))))
        elseif mod(timediff,Millisecond(Second(1))) == Millisecond(0)
            push!(res,Second(timediff/Millisecond(Second(1))))
        else
            @error "I can't understand the resolution of the timeseries"
        end
    end

    if length(res) > 1
        @warn "Timeseries has non-uniform resolution: this is currently not supported"
    else
        resolution = res[1]
    end
    
    return resolution
end