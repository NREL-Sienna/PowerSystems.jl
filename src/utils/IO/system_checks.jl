
### Utility Functions needed for the construction of the Power System, mostly used for consistency checking ####

## Check that all the buses have a type defintion ##

function buscheck(buses)
    for b in buses
        if isnothing(b.bustype)
            @warn "Bus/Nodes data does not contain information to build an a network"
        end
    end
end

## Slack Bus Definition ##

function slack_bus_check(buses)
    slack = -9
    for b in buses
        if b.bustype == BusTypes.REF
            slack = b.number
            break
        end
    end
    if slack == -9
        @error "Model doesn't contain a slack bus"
    end
end

# TODO: Check for islanded Buses

# check for minimum timediff
function minimumtimestep(forecasts::Array{T}) where {T <: Forecast}
    if length(forecasts[1].data) > 1
        timeseries = forecasts[1].data
        n = length(timeseries) - 1
        ts = []
        for i in 1:n
            push!(
                ts,
                TimeSeries.timestamp(timeseries)[n + 1] -
                TimeSeries.timestamp(timeseries)[n],
            )
        end
        return minimum(ts)
    else
        ts = Dates.Dates.Minute(1)
        return ts
    end
end

function critical_components_check(sys::System)
    missing_critical_components = false
    critical_component_types = [Bus, Generator, ElectricLoad]
    for component_type in critical_component_types
        components = get_components(component_type, sys)
        if length(components) == 0
            missing_critical_components = true
            @error("There are no $(component_type) Components in the System")
        end
    end
    missing_critical_components &&
        throw(IS.InvalidValue("Critical Components are not present."))
end

"""
    adequacy_check(sys::System)

Checks the system for sum(generator ratings) >= sum(load ratings).

# Arguments
- `sys::System`: system
"""
function adequacy_check(sys::System)
    gen = total_generation_rating(sys)
    load = total_load_rating(sys)
    load > gen &&
        @warn "System peak load ($load) exceeds total generation capability ($gen)."
end

"""
    total_load_rating(sys::System)

Checks the system for sum(generator ratings) >= sum(load ratings).

# Arguments
- `sys::System`: system
"""
function total_load_rating(sys::System)
    basepower = get_basepower(sys)
    controllable_loads = get_components(ControllableLoad, sys)
    cl = isempty(controllable_loads) ? 0.0 :
        sum(get_maxactivepower.(controllable_loads)) * basepower
    @debug "System has $cl MW of ControllableLoad"
    static_loads = get_components(StaticLoad, sys)
    sl = isempty(static_loads) ? 0.0 : sum(get_maxactivepower.(static_loads)) * basepower
    @debug "System has $sl MW of StaticLoad"
    # Total load calculation assumes  P = Real(V^2/Y) assuming V=1.0
    fa_loads = get_components(FixedAdmittance, sys)
    fa = isempty(fa_loads) ? 0.0 :
        sum(real.(get_basevoltage.(get_bus.(fa_loads)) .^ 2 ./ get_Y.(fa_loads)))
    @debug "System has $fa MW of FixedAdmittance assuming admittancce values are in P.U."
    total_load = cl + sl + fa
    @debug "Total System Load: $total_load"
    return total_load
end

"""
    total_generation_rating(sys::System)

Total sum of system generator ratings.

# Arguments
- `sys::System`: system
"""
function total_generation_rating(sys::System)
    gen = sum(get_rating.(get_components(Generator, sys))) * get_basepower(sys)
    @debug "Total System Generation: $gen"
    return gen
end
