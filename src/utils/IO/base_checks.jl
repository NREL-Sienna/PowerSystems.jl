function orderedlimits(limits::Union{NamedTuple{(:min, :max), Tuple{Float64, Float64}},
                                     Nothing},
                       limitsname::String)
    if isa(limits, Nothing)
        @info "'$limitsname' limits defined as nothing"
    else
        if limits.max < limits.min
            throw(DataFormatError("$limitsname limits not in ascending order"))
        end
    end

    return limits
end


function getresolution(ts::TimeSeries.TimeArray)

    tstamps = TimeSeries.timestamp(ts)
    timediffs = unique([tstamps[ix]-tstamps[ix-1] for ix in 2:length(tstamps)])

    res = []

    for timediff in timediffs
        if mod(timediff,Dates.Millisecond(Dates.Day(1))) == Dates.Millisecond(0) 
            push!(res,Dates.Day(timediff/Dates.Millisecond(Dates.Day(1))))
        elseif mod(timediff,Dates.Millisecond(Dates.Hour(1))) == Dates.Millisecond(0)
            push!(res,Dates.Hour(timediff/Dates.Millisecond(Dates.Hour(1))))
        elseif mod(timediff,Dates.Millisecond(Dates.Minute(1))) == Dates.Millisecond(0)
            push!(res,Dates.Minute(timediff/Dates.Millisecond(Dates.Minute(1))))
        elseif mod(timediff,Dates.Millisecond(Dates.Second(1))) == Dates.Millisecond(0)
            push!(res,Dates.Second(timediff/Dates.Millisecond(Dates.Second(1))))
        else
            throw(DataFormatError("cannot understand the resolution of the timeseries"))
        end
    end

    if length(res) > 1
        throw(DataFormatError("timeseries has non-uniform resolution: this is currently " \
                              "not supported"))
    end

    return res[1]
end
