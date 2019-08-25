# Demands like BEVs, where there is some flexbility, but also hard constraints.


# Import modules.
using DataFrames, Dates, MAT, TimeSeries


"""
Segment of a charging plan for a BEV.

# Type parameters
- `L`            : network location

# Fields:
- `location        :: L`       : network location
-  duration        :: Float64` : duration [time] of the time interval
-  load            :: Float64` : average load [energy/time] on the power system
-  chargerate      :: Float64` : average charging rate [energy/time] of the battery, accounting for the charging efficiency
- `maxchargerate   :: Float64` : maximum allowable charging rate [energy/time] for the battery [energy/time]
- `consumptionrate :: Float64` : average discharge rate [energy/time] of the battery due to driving
- `batterylevel`   :: Float64` : the battery level [energy] at the beginning of the time interval
"""
const ChargingSegment{L} = NamedTuple{(:location, :duration, :load, :chargerate, :maxchargerate, :consumptionrate, :batterylevel), Tuple{L, Float64, Float64, Float64, Float64, Float64, Float64}}


"""
Charging plan for a BEV.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location
"""
const ChargingPlan{T <: TimeType, L} = TimeArray{ChargingSegment{L},1,T,Vector{ChargingSegment{L}}}


"""
Convert a charging plan to a data frame.
"""
function convert(::Type{DataFrame}, plan :: ChargingPlan{T, L}) where T where L
    insertcols!(DataFrame(values(plan)), 1, :timestamp => timestamp(plan))
end


"""
Extract the locations from a charging plan.
"""
function locations(plan :: ChargingPlan{T,L}) :: TimeArray{L,1,T,Vector{L}} where T where L
    map(x -> x.location, plan)
end


"""
Extract the duration [time] of the time interval from a charging plan.
"""
function durations(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.duration, plan)
end


"""
Extract the located demand from a charging plan.
"""
function locateddemand(plan :: ChargingPlan{T,L}) :: LocatedDemand{T,L} where T where L
    map(x -> (x.location, x.load), plan)
end


"""
Extract the average system load [energy/time] from a charging plan.
"""
function loads(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.load, plan)
end


"""
Extract the average charge rate [energy/time] of the battery, accounting for the charging efficiency, from a charging plan.
"""
function chargerates(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.chargerate, plan)
end


"""
Extract the charge amount [energy] during the time interval from a charging plan.
"""
function chargeamounts(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.duration * x.chargerate, plan)
end


"""
Extract the maximum charge rate [energy/time] from a charging plan.
"""
function maxchargerates(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.maxchargerate, plan)
end


"""
Extract the average consumption rate [energy/time], the average discharge rate of the battery due to driving, from a charging plan.
"""
function consumptionrates(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.consumptionrate, plan)
end


"""
Extract the consumption amount [energy], the dicharge of the battery due to driving during the time interval, from a charging plan.
"""
function consumptionamounts(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.duration * x.consumptionrate, plan)
end


"""
Extract the battery level [energy] at the beginning of the time interval from a charging plan.
"""
function batterylevels(plan :: ChargingPlan{T,L}) :: TimeArray{Float64,1,T,Vector{Float64}} where T where L
    map(x -> x.batterylevel, plan)
end


"""
Detailed representation of a flexible, mobile demand.  Typically, this may represent single or multiple battery-electric vehicles.

This records the location of the demand and its consumption of its stored energy (i.e., its battery) as a function of time, along with physical parameters and constraints: storage capacity, charge/discharge effiency, maximum charge/discharge rate, and temporal boundary conditions.  Charging represents grid-to-vehicle transfer of energy and discharging represents vehicle-to-grid transfer.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Fields
- `locations`    : time/event series of locations of the vehicle, and their maximum AC and DC charging rates [energy/time]
- `power`        : time/event series of consumption rate of the vehicle [energy/time]
- `capacity`     : constraint on minimum and maximum battery level [energy]
- `rate`         : constraint on minimum and maximum AC and DC charging rates of the battery [energy/time]
- `efficiency`   : efficiency of charging the battery [energy/energy], applied to computations before the charging rate
- `timeboundary` : `nothing` for cyclic boundary conditions in time, or a tuple of minimum and maximum battery level allowed at the time boundaries [energy]

# Example
```
example = BevDemand(
    TimeArray(
        [Time(0)          , Time(8)         , Time(9)              , Time(17)       , Time(18)         , Time(23,59,59)   ], # [h]
        [("Home #23", (ac=1.4, dc=0.)), ("Road #14", (ac=0., dc=0.)), ("Workplace #3", (ac=7.7, dc=0.)), ("Road #9", (ac=0., dc=0.)), ("Home #23", (ac=1.4, dc=0.)), ("Home #23", (ac=1.4, dc=0.))]  # [kW]
    ),
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18), Time(23,59,59)], # [h]
        [     0.,     10.,      0.,      11.,       0.,             0.]  # [kW]
    ),
    (min=0., max=40.), # [kWh]
    (ac=(min=0., max=20.), dc=(min=0., max=50.)), # [kW]
    (in=0.90, out=0.), # [kWh/kWh]
    nothing,
)
```
"""
struct BevDemand{T,L} <: FlexibleDemand{T,L}
    locations    :: MobileDemand{T,Tuple{L,NamedTuple{(:ac, :dc),Tuple{Float64,Float64}}}}
    power        :: TemporalDemand{T}
    capacity     :: NamedTuple{(:min, :max),Tuple{Float64,Float64}}
    rate         :: NamedTuple{(:ac, :dc),Tuple{NamedTuple{(:min, :max),Tuple{Float64,Float64}},NamedTuple{(:min, :max),Tuple{Float64,Float64}}}}
    efficiency   :: NamedTuple{(:in, :out),Tuple{Float64,Float64}}
    timeboundary :: Union{Tuple{Float64,Float64},Nothing}
end


"""
The "envelope" of minimum and maximum allowable demands at each time point, with a location for the demand.

# Arguments
- `demand :: BevDemand{T,L}`: the demand
"""
function envelope(demand :: BevDemand{T,L}) :: LocatedEnvelope{T,L} where L where T <: TimeType
    map(
        d -> (d[1][1], d[2][1][2], d[2][2][2]),
        aligntimes(
            demand.locations,
            aligntimes(
                earliestdemands(demand),
                latestdemands(demand)
            )
        )
    )
end


"""
Apply efficiency factors to relate energy at the vehicle to energy at the charger.

# Arguments
- `demand :: BevDemand{T,L}`: the demand

# Returns
- a function that converts energy at the vehicle to energy at the charger
"""
function applyefficiencies(demand :: BevDemand{T,L}) where L where T <: TimeType
    function f(x)
        if x == 0
            0.
        elseif x > 0
            x / demand.efficiency.in
        else
            x * demand.efficiency.out
        end
    end
    f
end


"""
Apply efficiency factors to relate energy at the vehicle to energy at the charger.

# Arguments
- `demand :: BevDemand{T,L}`: the demand

# Returns
- a function that converts energy at the charger to energy at the vehicle
"""
function applyefficienciesinverse(demand :: BevDemand{T,L}) where L where T <: TimeType
    function f(x)
        if x == 0
            0.
        elseif x > 0
            x * demand.efficiency.in
        else
            x / demand.efficiency.out
        end
    end
    f
end


"""
The demand if charging takes place as early as possible.

# Arguments
- `demand :: BevDemand{T,L}`: the demand

# Returns
the demand over time
"""
function earliestdemands(demand :: BevDemand{T,L}) :: LocatedDemand{T,L} where L where T <: TimeType
    if demand.timeboundary == nothing
        b = earliestdemands(demand, demand.capacity.max)[2]
        earliestdemands(demand, b)[1]
    else
        earliestdemands(demand, demand.timeboundary[2])[1]
    end
end


"""
The demand if charging takes place as early as possible.

# Arguments
- `demand  :: BevDemand{T,L}`: the demand
- `initial :: Float64`       : the battery level at the first time

# Returns
- the demand over time
- the battery level at the last time
"""
function earliestdemands(demand :: BevDemand{T,L}, initial :: Float64) :: Tuple{LocatedDemand{T,L},Float64} where L where T <: TimeType
    resolution = 1 / 60 / 60 / 1000 # Resolve to the nearest millisecond.
    eff = applyefficiencies(demand)
    onehour = Time(1) - Time(0)
    x = aligntimes(demand.locations, demand.power)
    xt = timestamp(x)
    xv = values(x)
    zt = Array{T,1}()
    zv = Array{Float64,1}()
    b = initial
    ix = 2
    tnow = xt[ix-1]
    while ix <= length(x)
        tnext = (xt[ix] - tnow) / onehour
        ((_, (chargingac, chargingdc)), consumption) = xv[ix-1]
        chargingac1 = min(b < demand.capacity.max ? chargingac : 0, demand.rate.ac.max)
        chargingdc1 = min(b < demand.capacity.max ? chargingdc : 0, demand.rate.dc.max)
        charging1 = max(chargingac1, chargingdc1)
        net = charging1 - consumption
        tcrit = net > 0 ? (demand.capacity.max - b) / net : Inf
        if tcrit < resolution
            b = demand.capacity.max
        else
            push!(zt, tnow)
            push!(zv, eff(charging1))
            if tcrit < tnext
                b = b + tcrit * net
                tnow = addhours(tnow, tcrit)
            else
                b = b + tnext * net
                tnow = xt[ix]
                ix = ix + 1
            end
        end
    end
    push!(zt, tnow)
    push!(zv, NaN)
    (
        aligntimes(map(v -> v[1], demand.locations), TimeArray(zt, zv)),
        b
    )
end


"""
The demand if charging takes place as late as possible.

# Arguments
- `demand :: BevDemand{T,L}`: the demand

# Returns
- the demand over time
"""
function latestdemands(demand :: BevDemand{T,L}) :: LocatedDemand{T,L} where L where T <: TimeType
    if demand.timeboundary == nothing
        b = latestdemands(demand, demand.capacity.min)[2]
        latestdemands(demand, b)[1]
    else
        latestdemands(demand, demand.timeboundary[2])[1]
    end
end


"""
The demand if charging takes place as late as possible.

# Arguments
- `demand :: BevDemand{T,L}`: the demand
- `final  :: Float64`       : the battery level at the last time

# Returns
- the demand over time
- the battery level at the first time
"""
function latestdemands(demand :: BevDemand{T,L}, final :: Float64) :: Tuple{LocatedDemand{T,L},Float64} where L where T <: TimeType
    resolution = 1 / 60 / 60 / 1000 # Resolve to the nearest millisecond.
    eff = applyefficiencies(demand)
    onehour = Time(1) - Time(0)
    x = aligntimes(demand.locations, demand.power)
    xt = timestamp(x)
    xv = values(x)
    zt = Array{T,1}()
    zv = Array{Float64,1}()
    b = final
    ix = length(x) - 1
    tnow = xt[ix+1]
    push!(zt, tnow)
    push!(zv, NaN)
    while ix >= 1
        tnext = (tnow - xt[ix]) / onehour
        ((_, (chargingac, chargingdc)), consumption) = xv[ix]
        chargingac1 = min(b > demand.capacity.min ? chargingac : 0, demand.rate.ac.max)
        chargingdc1 = min(b > demand.capacity.min ? chargingdc : 0, demand.rate.dc.max)
        charging1 = max(chargingac1, chargingdc1)
        net = charging1 - consumption
        tcrit = net > 0 ? (b - demand.capacity.min) / net : Inf
        if tcrit < resolution
            b = demand.capacity.min
        else
            if tcrit < tnext
                b = b - tcrit * net
                tnow = addhours(tnow, - tcrit)
            else
                b = b - tnext * net
                tnow = xt[ix]
                ix = ix - 1
            end
            push!(zt, tnow)
            push!(zv, eff(charging1))
        end
    end
    zt = reverse(zt)
    zv = reverse(zv)
    (
        aligntimes(map(v -> v[1], demand.locations), TimeArray(zt, zv)),
        b
    )
end


"""
Procedural approach for BEV Greedy charging scenario, maximizing the BEV's battery level.

# Arguments
- `demand :: BevDemand{T,L}`: the BEV demand
- `prices :: TimeArray{T}`  : the electricity prices

# Returns
- `ChargingPlan{T,L}` : the charging plan
"""
function greedydemands(demand :: BevDemand{T,L}) where L where T <: TimeType
    pricing = map(v -> 1., demand.power)
    greedydemands(demand, pricing)
end


"""
Procedural approach for BEV Greedy charging scenario, maximizing the BEV's battery level.

# Arguments
- `demand :: BevDemand{T,L}`: the BEV demand
- `prices :: TimeArray{T}`  : the electricity prices

# Returns
- `ChargingPlan{T,L}` : the charging plan
"""
function greedydemands(demand :: BevDemand{T,L}, prices :: TimeArray{Float64,1,T,Vector{Float64}}) :: ChargingPlan{T,L} where L where T <: TimeType
    @warn "`PowerSystems.greedydemands` fails some tests."
    eff = applyefficiencies(demand)

    onehour = Time(1) - Time(0)
    eff = applyefficiencies(demand)
    x = aligntimes(aligntimes(demand.locations, demand.power), prices)
    xt = timestamp(x)
    xv = values(x)

    NT = length(x)
    NP = NT - 1

    hour = map(t -> t.instant / onehour, xt)
    location = map(v -> v[1][1][1], xv)
    duration = (xt[2:NT] - xt[1:NP]) / onehour
    chargemin = duration .* map(v -> min(v[1][1][2].ac, demand.rate.ac.min), xv[1:NP])
    chargemax = duration .* map(v -> min(v[1][1][2].ac, demand.rate.ac.max), xv[1:NP])
    consumption = duration .* map(v -> v[1][2], xv[1:NP])

    #Find value of greatest consumption in back-to-back time interval
    consumpMax = [0.0]
    consumpCompare = [0.0]
    for i in 1:NP
        if i == 1
            if consumption[1] > 0
                consumpCompare[1] += consumption[1]
            end
        else
            if consumption[i] > 0 && consumption[i-1] == 0
                consumpCompare[1] += consumption[i]
            elseif consumption[i] > 0 && consumption[i-1] > 0
                consumpCompare[1] += consumption[i]
            elseif consumption[i] == 0
                consumpMax[1] = max(consumpMax[1], consumpCompare[1])
                consumpCompare[1] = 0
            end
        end
    end

    ##Attempt greedy charging procedure with inital battery level at maximum capacity

    #Initialize battery levels
    battery = [demand.capacity.max] #Initial and final battery values?
    charge = []

    for i in 1:NP
        if (battery[i] < demand.capacity.max) && (chargemax[i] > 0)
            if (battery[i] + chargemax[i]) > demand.capacity.max
                append!(battery, demand.capacity.max)
                append!(charge, (demand.capacity.max - battery[i]))
            else
                append!(battery, battery[i] + chargemax[i])
                append!(charge, chargemax[i])
            end
        elseif (battery[i] == demand.capacity.max) && (consumption[i] == 0)
            append!(battery, battery[i])
            append!(charge, 0.0)
        elseif (chargemax[i] == 0.0) && (consumption[i] == 0)
            append!(battery, battery[i])
            append!(charge, 0.0)
        elseif consumption[i] > 0
            append!(battery, battery[i] - consumption[i])
            append!(charge, 0.0)
        end
    end

    if length(battery[battery .< 0]) > 0
        battery = []
        for i in 1:NT
            append!(battery, NaN)
        end

        charge = []
        for i in 1:NP
            append!(charge, NaN)
        end

    elseif (sum(consumption) > sum(chargemax)) && (length(battery[battery .< 0]) == 0)
        battery = []
        for i in 1:NT
            append!(battery, NaN)
        end

        charge = []
        for i in 1:NP
            append!(charge, NaN)
        end

#   elseif (battery[96] < demand.capacity.max) && length(battery[battery .< 0]) == 0 && sum(consumption) <= sum(chargemax)
    elseif (battery[NT] < demand.capacity.max) && length(battery[battery .< 0]) == 0 && sum(consumption) <= sum(chargemax)
        #Create curve ignoring maximum battery capacity
        battery = [demand.capacity.max]
        charge = []
        for i in 1:NP
            if chargemax[i] > 0
                append!(battery, battery[i] + chargemax[i])
                append!(charge, chargemax[i])
            elseif consumption[i] > 0
                append!(battery, battery[i] - consumption[i])
                append!(charge, 0.0)
            elseif (chargemax[i] == 0.0) && (consumption[i] == 0)
                append!(battery, battery[i])
                append!(charge, 0.0)
            end
        end

        #Check if there is a starting charge value for which the ending charge value can be equal.
        if consumpMax[1] > (demand.capacity.max - demand.capacity.min)
            battery = []
            for i in 1:NT
                append!(battery, NaN)
            end

            charge = []
            for i in 1:NP
                append!(charge, NaN)
            end

        elseif battery[NT] >= battery[1] && consumpMax[1] <= (demand.capacity.max - demand.capacity.min)
            #Shift data down such that the maximum battery level lies along the
            #maximum battery capacity line.
            shift1 = minimum(battery) - demand.capacity.min
            for i in 1:NT
                battery[i] -= shift1
            end
            if(maximum(battery) > demand.capacity.max)
                shift = maximum(battery) - demand.capacity.max
            else
                shift = 0
            end
            battery = [battery[NT] - shift]
            charge = []


            #Apply greedy charging procedure with new inital battery level
            for i in 1:NP
                if (battery[i] < demand.capacity.max) && (chargemax[i] > 0)
                    if (battery[i] + chargemax[i]) > demand.capacity.max
                        append!(battery, demand.capacity.max)
                        append!(charge, (demand.capacity.max - battery[i]))
                    else
                        append!(battery, battery[i] + chargemax[i])
                        append!(charge, chargemax[i])
                    end
                elseif (battery[i] == demand.capacity.max) && (consumption[i] == 0)
                    append!(battery, battery[i])
                    append!(charge, 0.0)
                elseif (chargemax[i] == 0.0) && (consumption[i] == 0)
                    append!(battery, battery[i])
                    append!(charge, 0.0)
                elseif consumption[i] > 0
                    append!(battery, battery[i] - consumption[i])
                    append!(charge, 0.0)
                end
            end
        end
    end

    convert(Array{Float64}, battery)
    convert(Array{Float64}, charge)
    #Contains optimization charging results with charging rate from charger during each time interval

    TimeArray(
        xt,
        vcat(
            [(
                location        = location[i]                 ,
                duration        = duration[i]                 ,
                load            = eff(charge[i] / duration[i]),
                chargerate      = charge[i] / duration[i]     ,
                maxchargerate   = chargemax[i]                ,
                consumptionrate = consumption[i]              ,
                batterylevel    = battery[i]                  ,
            ) for i in 1:NP],
            (
                location        = location[NT]                ,
                duration        = NaN                         ,
                load            = NaN                         ,
                chargerate      = NaN                         ,
                maxchargerate   = NaN                         ,
                consumptionrate = NaN                         ,
                batterylevel    = battery[NT]                 ,
            )
        )
    )

end


"""
Check the validity of a charging plan.

# Arguments
- `demand    :: BevDemand{T,L}`        : the BEV demand demand
- `charging  :: LocatedDemand{T,L}`    : the charging plan
- `tolerance :: Float64`               : tolerance for testing limits
- `message   :: Union{String,Nothing}` : the prefix of the warning messages, or `nothing` if no messages are to be logged

# Returns
- whether charging does not differ from consumption
- whether charging rates do not exceed limits
- whether battery levels do not exceed limits
"""
function verify(demand :: BevDemand{T,L}, charging :: LocatedDemand{T,L}; tolerance :: Float64 = 1e-5, message :: Union{String,Nothing} = nothing) :: NamedTuple{(:balance, :rates, :battery),Tuple{Bool,Bool,Bool}} where L where T <: TimeType
    verbose = !isnothing(message)
    the_shortfall = shortfall(demand, charging)
    check_shortfall = abs(the_shortfall) <= tolerance
    if verbose && !check_shortfall
        @warn string(message, " has charging shortfall of ", the_shortfall, " kWh.")
    end
    check_rates     = verifylimits(demand, charging, tolerance=tolerance)
    if verbose && !check_rates
        @warn string(message, " violates charging limits.")
    end
    check_battery   = verifybattery(demand, charging, tolerance=tolerance)
    if verbose && !check_battery
        @warn string(message, " violates battery limits.")
    end
    (
        balance = check_shortfall,
        rates   = check_rates    ,
        battery = check_battery  ,
    )
end


"""
Compute the discrepancy between the BEV constraints and the charging plan.

# Arguments
- `demand   :: BevDemand{T,L}`     : the BEV demand demand
- `charging :: LocatedDemand{T,L}` : the charging plan

# Returns
- the shortfall of the charging plan's meeting of the demand demand
"""
function shortfall(demand :: BevDemand{T,L}, charging :: LocatedDemand{T,L}) :: Float64 where L where T <: TimeType
    onehour = Time(1) - Time(0)
    function durations(x)
        xt = timestamp(x)
        (xt[2:end] - xt[1:end-1]) / onehour
    end
    function rates(x)
        xv = map(y -> y[end], values(x))
        xv[1:end-1]
    end
    function levels(x)
        durations(x) .* rates(x)
    end
    function total(x)
        sum(levels(x))
    end
    total(demand.power) / demand.efficiency.in - total(charging)
end


"""
Verify charging limits.

# Arguments
- `demand    :: BevDemand{T,L}`     : the BEV demand demand
- `charging  :: LocatedDemand{T,L}` : the charging plan
- `tolerance :: Float64`            : tolerance for testing limits

# Returns
- whether the charging limits are satisfied
"""
function verifylimits(demand :: BevDemand{T,L}, charging :: LocatedDemand{T,L}; tolerance :: Float64 = 1e-5) :: Bool where L where T <: TimeType
    onehour = Time(1) - Time(0)
    eff = applyefficienciesinverse(demand)
    x = aligntimes(demand.locations, charging)
    xv = values(x[1:end-1])
    powers = eff.(map(v -> v[2][2], xv))
    limits = map(v -> max(min(v[1][2].ac, demand.rate.ac.max), min(v[1][2].dc, demand.rate.dc.max)), xv)
    all(powers .<= limits .+ tolerance)
end


"""
Compute battery levels.

# Arguments
- `demand    :: BevDemand{T,L}`     : the BEV demand demand
- `charging  :: LocatedDemand{T,L}` : the charging plan

# Returns
- the battery levels
"""
function chargelevels(demand :: BevDemand{T,L}, charging :: LocatedDemand{T,L}) :: TemporalDemand{T} where L where T <: TimeType
    onehour = Time(1) - Time(0)
    eff = applyefficienciesinverse(demand)
    x = aligntimes(demand.power, charging)
    xt = timestamp(x)
    durations = (xt[2:end] - xt[1:end-1]) ./ onehour
    xv = values(x[1:end-1])
    nets = (eff.(map(v -> v[2][2], xv)) .- map(v -> v[1], xv)) .* durations
    nets = prepend!(nets, [0.])
    nets = cumsum(nets)
    nets = nets .- minimum(nets) .+ demand.capacity.min
    TimeArray(xt, nets)
end


"""
Verify battery levels.

# Arguments
- `demand    :: BevDemand{T,L}`     : the BEV demand demand
- `charging  :: LocatedDemand{T,L}` : the charging plan
- `tolerance :: Float64`            : tolerance for testing limits

# Returns
- whether the battery level constraints are satisfied
"""
function verifybattery(demand :: BevDemand{T,L}, charging :: LocatedDemand{T,L}; tolerance :: Float64 = 1e-5) :: Bool where L where T <: TimeType
    levels = values(chargelevels(demand, charging))
    maxokay = maximum(levels) <= demand.capacity.max + tolerance
    if isnothing(demand.timeboundary)
        boundaryokay = abs(levels[1] - levels[end]) <= tolerance
    else
        boundaryokay  = demand.timeboundary[1] - tolerance <= levels[1  ] <= demand.timeboundary[2] + tolerance
        boundaryokay &= demand.timeboundary[1] - tolerance <= levels[end] <= demand.timeboundary[2] + tolerance
    end
    maxokay && boundaryokay
end


"""
Function to populate an array of BevDemand structs. Receives location of ".mat" file as string input.
The ".mat" file is output from EVI-Pro tool.

# Arguments
- `data_location :: String`: the path of the file containing the BEV data
"""
function populate_BEV_demand(data_location :: String) :: Array{BevDemand{Time,String}}
    full_data = matread(data_location)["FlexibleDemand"]
    
    dim = size(full_data["AC_chargeratemax"])
    num_el = max(dim[1],dim[2])

    populated_BEV_demand = Array{BevDemand}(undef,num_el)

    # FIXME: These two flags are for workarounds to illegal instruction errors resulting from the use of MAT to read data.
    workaround1 = true
    workaround2 = true

    for i in range(1,stop=num_el)
        # Populating locations
        dim = size(full_data["locations"][i]["bus_id"])
        num = max(dim[1],dim[2])
        if workaround1
            num = parse(Int64, string(num))
        end

        loc_tuples = Array{Tuple{String,NamedTuple{(:ac, :dc),Tuple{Float64,Float64}}}}(undef,num)
        if workaround2
            for j in range(1,stop=num)
                loc = string("bus id #",full_data["locations"][i]["bus_id"][j])
                a_ch = parse(Float64, string(full_data["locations"][i]["max_ac_charging_rate"][j]))
                d_ch = parse(Float64, string(full_data["locations"][i]["max_dc_charging_rate"][j]))
                loc_tuples[j] = (loc,(ac=a_ch,dc=d_ch))
            end
        else
            loc_tuples = [(string("bus id #",full_data["locations"][i]["bus_id"][j]),
                    (full_data["locations"][i]["max_ac_charging_rate"][j],
                        full_data["locations"][i]["max_dc_charging_rate"][j])) for j in range(1,num)]
        end

        #Processing the time stamp for the locations
        dim = size(full_data["locations"][i]["time_stamp"])
        num = max(dim[1],dim[2])

        temp_time_loc = [fldmod(Int(ceil(full_data["consumptions"][i]["time_stamp"][j]*24*60)),60) for j in
                range(1,stop=num)]
        time_stamp_loc = [Time(temp_time_loc[j][1],temp_time_loc[j][2]) for j in range(1,stop=num)]
        locations = TimeArray(time_stamp_loc, loc_tuples)
        
        #Processing the data for consumption
        dim = size(full_data["consumptions"][1]["time_stamp"])
        num = max(dim[1],dim[2])
        temp_time = [fldmod(Int(ceil(full_data["consumptions"][i]["time_stamp"][j]*24*60)),60) for j in
                range(1,stop=num)]
        time_stamp = [Time(temp_time[j][1],temp_time[j][2]) for j in range(1,stop=num)]
        cons_val = [full_data["consumptions"][i]["consumptions_rates"][k] for k in (1:num)]
        consumptions = TimeArray(time_stamp,cons_val)
        
        # Adding remaining attributes
        capacity = (min=full_data["storagemin"][i],max =full_data["storagemax"][i])
        rate = (ac=(min= 0.0, max = full_data["AC_chargeratemax"][i]), 
            dc=(min=0.0,max=full_data["DC_chargeratemax"][i])) 
        efficiency = (in=full_data["chargeEfficiency"][i],out=full_data["dischargeEfficiency"][i])
        timeboundary = nothing

        # Adding created BevDemand struct in array
        populated_BEV_demand[i] = BevDemand(locations, consumptions, capacity, rate,efficiency, timeboundary)
    end

    return populated_BEV_demand
end
