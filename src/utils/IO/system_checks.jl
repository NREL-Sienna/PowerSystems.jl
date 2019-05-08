
### Utility Functions needed for the construction of the Power System, mostly used for consistency checking ####

## Time Series Length ##

function timeseriescheckforecast(forecasts::Dict{Symbol,Array{C,1} where C<:Forecast})
    for (key,v) in forecasts
        t = length(unique([length(f.data) for f in v]))
        if t > 1
            @error "$key forecast array contains $t different time series lengths"
        end
    end
end

## Check that all the buses have a type defintion ##

function buscheck(buses::Array{Bus})
    for b in buses
        if b.bustype == nothing
            @warn "Bus/Nodes data does not contain information to build an a network"
        end
    end

    check_ascending_order([x.number for x in buses], "Bus")
end

## Slack Bus Definition ##

function slackbuscheck(buses::Array{Bus})
    slack = -9
    for b in buses
        if b.bustype == "SF"
            slack = b.number
        end
    end
    if slack == -9
        @error "Model doesn't contain a slack bus"
    end
end

### PV Bus Check ###

function pvbuscheck(buses::Array{Bus}, generators::Array{T}) where {T<:Generator}
    pv_list = -1*ones(Int64, length(generators))
    for (ix,g) in enumerate(generators)
        bus(g).bustype == "PV" ? pv_list[ix] = bus(g).number : continue
    end

    for b in buses
        if b.bustype == "PV"
            b.number in pv_list ? continue : 0 #@warn "The bus ", b.number, " is declared as PV without a generator connected to it"
        else
            continue
        end
    end
end

# TODO: Check for islanded Buses

# check for minimum timediff
function minimumtimestep(forecasts::Array{T})where {T<:Forecast}
    if length(forecasts[1].data) > 1
        timeseries = forecasts[1].data
        n = length(timeseries)-1
        ts = []
        for i in 1:n
            push!(ts,TimeSeries.timestamp(timeseries)[n+1]-TimeSeries.timestamp(timeseries)[n])
        end
        return minimum(ts)
    else
        ts =Dates.Dates.Minute(1)
        return ts
    end
end
