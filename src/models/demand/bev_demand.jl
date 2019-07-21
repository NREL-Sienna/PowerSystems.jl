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
        x > 0 ? x / demand.efficiency.in : x * demand.efficiency.out
    end
    f
end


"""
The demand if charging takes place as early as possible.

    # Arguments
    - `demand :: BevDemand{T,L}`: the demand

    # Returns
    The demand over time.
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
    - `initial :: Float64`       : the battery level at the start

    # Returns
    - The demand over time.
    - The battery level at the last time.
"""
function earliestdemands(demand :: BevDemand{T,L}, initial :: Float64) :: Tuple{LocatedDemand{T,L},Float64} where L where T <: TimeType
    resolution = 1 / 60 / 60 / 100 # Resolve to the nearest millisecond.
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
        chargingac1 = min(b >= demand.capacity.max ? 0 : chargingac, demand.rate.ac.max)
        chargingdc1 = min(b >= demand.capacity.max ? 0 : chargingdc, demand.rate.dc.max)
        charging1 = max(chargingac1, chargingdc1)
        net = charging1 - consumption
        tcrit = net > 0 ? (demand.capacity.max - b) / net : Inf
        push!(zt, tnow)
        push!(zv, eff(charging1))
        if resolution < tcrit < tnext
            b = b + tcrit * net
            tnow = addhours(tnow, tcrit)
        else
            b = b + tnext * net
            tnow = xt[ix]
            ix = ix + 1
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
    - `final  :: Float64`       : the battery level at the start

    # Returns
    - The demand over time.
    - The battery level at the first time.
"""
function latestdemands(demand :: BevDemand{T,L}, final :: Float64) :: Tuple{LocatedDemand{T,L},Float64} where L where T <: TimeType
    resolution = 1 / 60 / 60 / 100 # Resolve to the nearest millisecond.
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
        chargingac1 = min(b >= demand.capacity.max ? min(chargingac, consumption) : chargingac, demand.rate.ac.max)
        chargingdc1 = min(b >= demand.capacity.max ? min(chargingdc, consumption) : chargingdc, demand.rate.dc.max)
        charging1 = max(chargingac1, chargingdc1)
        net = charging1 - consumption
        tcrit = net > 0 ? (demand.capacity.max - b) / net : Inf
        if resolution < tcrit < tnext
            b = b + tcrit * net
            tnow = addhours(tnow, - tcrit)
        else
            b = b + tnext * net
            tnow = xt[ix]
            ix = ix - 1
        end
        push!(zt, tnow)
        push!(zv, eff(charging1))
    end
    zt = reverse(zt)
    zv = reverse(zv)
    (
        aligntimes(map(v -> v[1], demand.locations), TimeArray(zt, zv)),
        b
    )
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
