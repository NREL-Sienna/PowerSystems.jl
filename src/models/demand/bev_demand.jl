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
- `locations`          : time/event series of locations of the vehicle, and their maximum AC and DC charging rates [energy/time]
- `consumptions`       : time/event series of consumption rate of the vehicle [energy/time]
- `batterymin`         : constraint on minimum battery level [energy]
- `batterymax`         : constraint on maximum battery level [energy]
- `timeboundary`       : `nothing` for cyclic boundary conditions in time, or a tuple of minimum and maximum battery level allowed at the time boundaries [energy]
- `chargerateacmax`    : constraint on maximum AC charging rate of the battery [energy/time]
- `chargeratedcmax`    : constraint on maximum DC charging rate of the battery [energy/time]
- `dischargeratemax`   : constraint on maximum discharge rate of the battery, for V2G [energy/time]
- `chargeefficiency`   : efficiency of charging the battery [energy/energy], applied to computations before the charging rate
- `dischargeefficiency`: efficiency of discharging the battery, for V2G [energy/energy]

# Example
```
example = BevDemand(
    TimeArray(
        [Time(0)          , Time(8)         , Time(9)              , Time(17)       , Time(18)         , Time(23,59,59)   ], # [h]
        [("Home #23", 1.4, 0.), ("Road #14", 0., 0.), ("Workplace #3", 7.7, 0.), ("Road #9", 0., 0.), ("Home #23", 1.4, 0.), ("Home #23", 1.4, 0.)]  # [kW]
    ),
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18), Time(23,59,59)], # [h]
        [     0.,     10.,      0.,      11.,       0.,             0.]  # [kW]
    ),
    0., 40., # [kWh]
    nothing,
    20., 50., 0., # [kW]
    0.90, 0. # [kWh/kWh]
)
```
"""
struct BevDemand{T,L} <: FlexibleDemand{T,L}
    locations           :: MobileDemand{T,Tuple{L,Float64,Float64}}
    consumptions        :: TemporalDemand{T}
    batterymin          :: Float64
    batterymax          :: Float64
    timeboundary        :: Union{Tuple{Float64,Float64},Nothing}
    chargerateacmax     :: Float64
    chargeratedcmax     :: Float64
    dischargeratemax    :: Float64
    chargeefficiency    :: Float64 # FIXME: Technically, this is a joint property of the EVSE and the BEV.
    dischargeefficiency :: Float64
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
        x > 0 ? x / demand.chargeefficiency : x * demand.dischargeefficiency
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
        b = earliestdemands(demand, demand.batterymax)[2]
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
    eff = applyefficiencies(demand)
    onehour = Time(1) - Time(0)
    x = aligntimes(demand.locations, demand.consumptions)
    xt = timestamp(x)
    xv = values(x)
    zt = Array{T,1}()
    zv = Array{Float64,1}()
    b = initial
    ix = 2
    tnow = xt[ix-1]
    while ix <= length(x)
        tnext = (xt[ix] - tnow) / onehour
        ((_, chargingac, chargingdc), consumption) = xv[ix-1]
        chargingac1 = min(b >= demand.batterymax ? 0 : chargingac, demand.chargerateacmax)
        chargingdc1 = min(b >= demand.batterymax ? 0 : chargingdc, demand.chargeratedcmax)
        charging1 = max(chargingac1, chargingdc1)
        net = charging1 - consumption
        tcrit = net > 0 ? (demand.batterymax - b) / net : Inf
        push!(zt, tnow)
        push!(zv, eff(charging1))
        if 0 < tcrit < tnext
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
        b = latestdemands(demand, demand.batterymin)[2]
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
    eff = applyefficiencies(demand)
    onehour = Time(1) - Time(0)
    x = aligntimes(demand.locations, demand.consumptions)
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
        ((_, chargingac, chargingdc), consumption) = xv[ix]
        chargingac1 = min(b >= demand.batterymax ? min(chargingac, consumption) : chargingac, demand.chargerateacmax)
        chargingdc1 = min(b >= demand.batterymax ? min(chargingdc, consumption) : chargingdc, demand.chargeratedcmax)
        charging1 = max(chargingac1, chargingdc1)
        net = charging1 - consumption
        tcrit = net > 0 ? (demand.batterymax - b) / net : Inf
        if 0 < tcrit < tnext
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
    (
        aligntimes(map(v -> v[1], demand.locations), TimeArray(zt, zv)),
        b
    )
end

"""
Function to populate an array of BevDemand structs. Receives location of ".mat" file as string input.

# Arguments
- `data_location :: String`: the path of the file containing the BEV data
"""
function populate_BEV_demand(data_location :: String) :: Array{BevDemand{Time,String}}
    full_data = matread(data_location)["FlexibleDemand"]

    dim = size(full_data["chargeratemax"])
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
        loc_tuples = Array{Tuple{String,Float64}}(undef,num)
        if workaround2
            for j in range(1,num)
                loc = string("bus id #",full_data["locations"][i]["bus_id"][j])
                cha = parse(Float64, string(full_data["locations"][i]["max_charging_rate"][j]))
                loc_tuples[j] = (loc, cha)
            end
        else
            loc_tuples = [(string("bus id #",full_data["locations"][i]["bus_id"][j]),
                    full_data["locations"][i]["max_charging_rate"][j]) for j in range(1,num)]
        end

        #Processing the time stamp for the locations
        dim = size(full_data["locations"][i]["time_stamp"])
        num = max(dim[1],dim[2])

        temp_time_loc = [fldmod(Int(ceil(full_data["consumptions"][i]["time_stamp"][j]*24*60)),60) for j in
                range(1,num)]
        time_stamp_loc = [Time(temp_time_loc[j][1],temp_time_loc[j][2]) for j in range(1,num)]
        locations = TimeArray(time_stamp_loc, loc_tuples)

        #Processing the data for consumption
        dim = size(full_data["consumptions"][i]["time_stamp"])
        num = max(dim[1],dim[2])
        temp_time = [fldmod(Int(ceil(full_data["consumptions"][i]["time_stamp"][j]*24*60)),60) for j in
                range(1,num)]
        time_stamp = [Time(temp_time[j][1],temp_time[j][2]) for j in range(1,num)]
        cons_val = [full_data["consumptions"][i]["consumptions_rates"][k] for k in (1:288)]
        consumptions = TimeArray(time_stamp,
            cons_val)

        batterymin = full_data["storagemin"][i]
        batterymax = full_data["storagemax"][i]
        timeboundary = nothing
        chargeratemax = full_data["chargeratemax"][i]
        dischargeratemax = full_data["dischargeratemax"][i]
        chargeefficiency = full_data["chargeEfficiency"][i]
        dischargeefficiency = full_data["dischargeEfficiency"][i]

        # Adding created BevDemand struct in array
        populated_BEV_demand[i] = BevDemand(locations, consumptions, batterymin, batterymax, timeboundary, chargeratemax,
            dischargeratemax, chargeefficiency, dischargeefficiency)
    end

    return populated_BEV_demand
end
