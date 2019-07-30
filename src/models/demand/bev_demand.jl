# Demands like BEVs, where there is some flexbility, but also hard constraints.


# Import modules.
using Dates, MAT, TimeSeries


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
The "envelope" of minimum and maximum allowable demands at each time pont, with a location for the demand.

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

    for i in range(1,num_el)
        # Populating locations
        dim = size(full_data["locations"][i]["bus_id"])
        num = max(dim[1],dim[2])
        if workaround1
            num = parse(Int64, string(num))
        end

        loc_tuples = Array{Tuple{String,NamedTuple{(:ac, :dc),Tuple{Float64,Float64}}}}(undef,num)
        if workaround2
            for j in range(1,num)
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
                range(1,num)]
        time_stamp_loc = [Time(temp_time_loc[j][1],temp_time_loc[j][2]) for j in range(1,num)]
        locations = TimeArray(time_stamp_loc, loc_tuples)
        
        #Processing the data for consumption
        dim = size(full_data["consumptions"][1]["time_stamp"])
        num = max(dim[1],dim[2])
        temp_time = [fldmod(Int(ceil(full_data["consumptions"][i]["time_stamp"][j]*24*60)),60) for j in
                range(1,num)]
        time_stamp = [Time(temp_time[j][1],temp_time[j][2]) for j in range(1,num)]
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
