# Demands like BEVs, where there is some flexbility, but also hard constraints.


# Import modules.
using Dates, JuMP, TimeSeries


"""
Detailed representation of a flexible, mobile demand.  Typically, this may represent single or multiple battery-electric vehicles.

This records the location of the demand and its consumption of its stored energy (i.e., its battery) as a function of time, along with physical parameters and constraints: storage capacity, charge/discharge effiency, maximum charge/discharge rate, and temporal boundary conditions.  Charging represents grid-to-vehicle transfer of energy and discharging represents vehicle-to-grid transfer.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Fields
- `locations`          : time/event series of locations of the vehicle, and their maximum charging rate [energy/time]
- `consumptions`       : time/event series of consumption rate of the vehicle [energy/time]
- `batterymin`         : constraint on minimum battery level [energy]
- `batterymax`         : constraint on maximum battery level [energy]
- `timeboundary`       : `nothing` for cyclic boundary conditions in time, or a tuple of minimum and maximum battery level allowed at the time boundaries [energy]
- `chargeratemax`      : constraint on maximum charging rate of the battery [energy/time]
- `dischargeratemax`   : constraint on maximum discharge rate of the battery, for V2G [energy/time]
- `chargeefficiency`   : efficiency of charging the battery [energy/energy], applied to computations before the charging rate
- `dischargeefficiency`: efficiency of discharging the battery, for V2G [energy/energy]

# Example
```
example = BevDemand(
    TimeArray(
        [Time(0)          , Time(8)         , Time(9)              , Time(17)       , Time(18)         , Time(23,59,59)   ], # [h]
        [("Home #23", 1.4), ("Road #14", 0.), ("Workplace #3", 7.7), ("Road #9", 0.), ("Home #23", 1.4), ("Home #23", 1.4)]  # [kW]
    ),
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18), Time(23,59,59)], # [h]
        [     0.,     10.,      0.,      11.,       0.,             0.]  # [kW]
    ),
    0., 40., # [kWh]
    nothing,
    6.6, 0., # [kW]
    0.90, 0. # [kWh/kWh]
)
```
"""
struct BevDemand{T,L} <: FlexibleDemand{T,L}
    locations           :: MobileDemand{T,Tuple{L,Float64}}
    consumptions        :: TemporalDemand{T}
    batterymin          :: Float64
    batterymax          :: Float64
    timeboundary        :: Union{Tuple{Float64,Float64},Nothing}
    chargeratemax       :: Float64
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
        d -> (d[1][1], d[2][1], d[2][2]),
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
        ((_, charging), consumption) = xv[ix-1]
        charging1 = min(b >= demand.batterymax ? 0 : charging, demand.chargeratemax)
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
        ((_, charging), consumption) = xv[ix]
        charging1 = min(b >= demand.batterymax ? min(charging, consumption) : charging, demand.chargeratemax)
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
Represent demand constraints for a BEV as a JuMP model.

# Arguments
- `demand :: BevDemand{T,L}`: the BEV demand

# Returns
- `locations :: TimeArray{T,L}`   : location of the BEV during each time interval
- `model :: JuMP.Model`           : a JuMP model containing the constraints, where
                                    `charge` is the kWh charge during the time
                                    interval and `battery` is the batter level at
                                    the start of the interval and where the start
                                    of the intervals are given by `locations`
- `result() :: LocatedDemand{T,}` : a function that results the located demand,
                                    but which can only be called after the model
                                    has been solved
"""
function demandconstraints(demand :: BevDemand{T,L}) where L where T <: TimeType
    pricing = map(v -> 1., demand.consumptions)
    demandconstraints(demand, pricing)
end


"""
Represent demand constraints for a BEV as a JuMP model, minimizing the price paid.

# Arguments
- `demand :: BevDemand{T,L}`: the BEV demand
- `prices :: TimeArray{T}`  : the electricity prices

# Returns
- `locations :: TimeArray{T,L}`   : location of the BEV during each time interval
- `model :: JuMP.Model`           : a JuMP model containing the constraints, where
                                    `charge` is the kWh charge during the time
                                    interval and `battery` is the batter level at
                                    the start of the interval and where the start
                                    of the intervals are given by `locations`
- `result() :: LocatedDemand{T,}` : a function that results the located demand,
                                    but which can only be called after the model
                                    has been solved

# Example
```
using Dates, Clp, JuMP, TimeSeries

example = BevDemand(
    TimeArray(
        [Time(0)          , Time(8)         , Time(9)              , Time(17)       , Time(18)         , Time(23,59,59)   ], # [h]
        [("Home #23", 1.4), ("Road #14", 0.), ("Workplace #3", 7.7), ("Road #9", 0.), ("Home #23", 1.4), ("Home #23", 1.4)]  # [kW]
    ),
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18), Time(23,59,59)], # [h]
        [     0.,     10.,      0.,      11.,       0.,             0.]  # [kW]
    ),
    0., 40., # [kWh]
    nothing,
    6.6, 0., # [kW]
    0.90, 0. # [kWh/kWh]
)

pricing = TimeArray([Time(0), Time(12)], [10., 3.])

constraints = demandconstraints(example, pricing)
constraints.model.solver = ClpSolver()
solve(constraints.model)
locateddemands = constraints.result()
```
"""
function demandconstraints(demand :: BevDemand{T,L}, prices :: TimeArray{Float64,1,T,Array{Float64,1}}) where L where T <: TimeType

    eff = applyefficiencies(demand)

    onehour = Time(1) - Time(0)
    eff = applyefficiencies(demand)
    x = aligntimes(aligntimes(demand.locations, demand.consumptions), prices)
    xt = timestamp(x)
    xv = values(x)

    NT = length(x)
    NP = NT - 1
    hour = map(t -> t.instant / onehour, xt)
    location = map(v -> v[1][1][1], xv)
    duration = (xt[2:NT] - xt[1:NP]) / onehour
    chargemin = duration .* map(v -> min(v[1][1][2], - demand.dischargeratemax), xv[1:NP])
    chargemax = duration .* map(v -> min(v[1][1][2],   demand.chargeratemax)   , xv[1:NP])
    consumption = duration .* map(v -> v[1][2], xv[1:NP])
    price = map(v -> v[2], xv[1:NP])

    model = Model()

    @variable(model, charge[1:NP])
    @constraint(model, chargeconstraint[   i=1:NP], charge[i] <= chargemax[i])
    @constraint(model, dischargeconstraint[i=1:NP], charge[i] >= chargemin[i])

    @variable(model, demand.batterymin <= battery[1:NT] <= demand.batterymax)
    if demand.timeboundary == nothing
        @constraint(model, boundaryconstraint, battery[1] == battery[NT])
    else
        @constraint(model, boundaryleftconstraint , demand.timeboundary[1] <= battery[1 ] <= demand.timeboundary[1])
        @constraint(model, boundaryrightconstraint, demand.timeboundary[2] <= battery[NT] <= demand.timeboundary[2])
    end

    @constraint(model, balanceconstraint[i=1:NP], battery[i+1] == battery[i] + charge[i] - consumption[i])

    @objective(model, Min, sum(price[i] * charge[i] for i = 1:NP))

    # FIXME: This is a workaround for lazy initialization of model fields.
    getname(model, 1)

    function result() :: LocatedDemand{T,L}
        TimeArray(
            xt,
            collect(
                zip(
                    location,
                    vcat(
                        eff.(model.colVal[1:NP] ./ duration),
                        NaN
                    )
                )
            )
        )
    end

    (
        locations=TimeArray(xt, location),
        model=model,
        result=result
    )

end
