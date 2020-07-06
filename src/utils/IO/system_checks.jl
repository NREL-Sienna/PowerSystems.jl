
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
    critical_component_types = [Bus, Generator, ElectricLoad]
    for component_type in critical_component_types
        components = get_components(component_type, sys)
        if length(components) == 0
            @warn "There are no $(component_type) Components in the System"
        end
    end
end

"""
    adequacy_check(sys::System)

Checks the system for sum(generator ratings) >= sum(load ratings).

# Arguments
- `sys::System`: system
"""
function adequacy_check(sys::System)
    gen = total_capacity_rating(sys)
    load = total_load_rating(sys)
    load > gen && @warn "System peak load ($load) exceeds total capacity capability ($gen)."
end

"""
    total_load_rating(sys::System)

Checks the system for sum(generator ratings) >= sum(load ratings).

# Arguments
- `sys::System`: system
"""
function total_load_rating(sys::System)
    base_power = get_base_power(sys)
    controllable_loads = get_components(ControllableLoad, sys)
    cl = isempty(controllable_loads) ? 0.0 :
        sum(get_maxactivepower.(controllable_loads)) * base_power
    @debug "System has $cl MW of ControllableLoad"
    static_loads = get_components(StaticLoad, sys)
    sl = isempty(static_loads) ? 0.0 : sum(get_maxactivepower.(static_loads)) * base_power
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
    total_capacity_rating(sys::System)

Sum of system generator and storage ratings.

# Arguments
- `sys::System`: system
"""
function total_capacity_rating(sys::System)
    total = 0
    for component_type in (Generator, Storage)
        components = get_components(Generator, sys)
        if !isempty(components)
            component_total = sum(get_rating.(components)) * get_base_power(sys)
            @debug "total rating for $component_type = $component_total"
            total += component_total
        end
    end

    @debug "Total System capacity: $total"
    return total
end
