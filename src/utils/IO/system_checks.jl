
### Utility Functions needed for the construction of the Power System, mostly used for consistency checking ####

## Check that all the buses have a type defintion and that bus types are consistent with generator connections ##

function buscheck(sys::System)
    buses = get_components(ACBus, sys)
    bus_to_pv_device_map = Dict((i, Set{String}()) for i in get_number.(buses))
    for gen in get_components(StaticInjection, sys)
        if !get_available(gen) || typeof(gen) == ElectricLoad
            continue
        end
        bus_number = get_number(get_bus(gen))
        gen_name = get_name(gen)
        push!(get!(bus_to_pv_device_map, bus_number, Set{String}()), gen_name)
    end
    for hvdc in get_components(TwoTerminalHVDC, sys)
        if !get_available(hvdc)
            continue
        end
        from_bus_number = get_number(get_from(get_arc(hvdc)))
        to_bus_number = get_number(get_to(get_arc(hvdc)))
        hvdc_name = get_name(hvdc)
        push!(
            get!(bus_to_pv_device_map, from_bus_number, Set{String}()),
            hvdc_name,
        )
        push!(
            get!(bus_to_pv_device_map, to_bus_number, Set{String}()),
            hvdc_name,
        )
    end
    for b in buses
        b_type = get_bustype(b)
        b_number = get_number(b)
        if isnothing(b_type)
            @warn "Bus/Nodes data does not contain information to build an a network" maxlog =
                10
        elseif b_type ∈ [ACBusTypes.PV, ACBusTypes.SLACK]
            bus_pv_device_count = length(bus_to_pv_device_map[b_number])
            if bus_pv_device_count == 0
                @error "no active generators found at bus $(summary(b)) with type $(b_type), consider checking your data inputs." maxlog =
                    PS_MAX_LOG
            end
        end
    end
    return
end

## Slack Bus Definition ##

function slack_bus_check(buses)
    slack = -9
    for b in buses
        if b.bustype == ACBusTypes.REF
            slack = b.number
            break
        end
    end
    if slack == -9
        @error "Model doesn't contain a slack bus"
    end
    return
end

# TODO: Check for islanded Buses

# check for minimum timediff
function minimumtimestep(time_series::Array{T}) where {T <: TimeSeriesData}
    if length(time_series[1].data) > 1
        timeseries = time_series[1].data
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
    critical_component_types = [ACBus, Generator, ElectricLoad]
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
    return
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
    cl =
        if isempty(controllable_loads)
            0.0
        else
            sum(get_max_active_power.(controllable_loads)) * base_power
        end
    @debug "System has $cl MW of ControllableLoad" _group = IS.LOG_GROUP_SYSTEM_CHECKS
    static_loads = get_components(StaticLoad, sys)
    sl = isempty(static_loads) ? 0.0 : sum(get_max_active_power.(static_loads)) * base_power
    @debug "System has $sl MW of StaticLoad" _group = IS.LOG_GROUP_SYSTEM_CHECKS
    # Total load calculation assumes  P = Real(V^2/Y) assuming V=1.0
    fa_loads = get_components(FixedAdmittance, sys)
    fa =
        if isempty(fa_loads)
            0.0
        else
            sum(real.(get_base_voltage.(get_bus.(fa_loads)) .^ 2 ./ get_Y.(fa_loads)))
        end
    @debug "System has $fa MW of FixedAdmittance assuming admittance values are in P.U." _group =
        IS.LOG_GROUP_SYSTEM_CHECKS
    total_load = cl + sl + fa
    @debug "Total System Load: $total_load" _group = IS.LOG_GROUP_SYSTEM_CHECKS
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
        components = get_components(component_type, sys)
        if !isempty(components)
            component_total = sum(get_rating.(components)) * get_base_power(sys)
            @debug "total rating for $component_type = $component_total" _group =
                IS.LOG_GROUP_SYSTEM_CHECKS
            total += component_total
        end
    end

    @debug "Total System capacity: $total" _group = IS.LOG_GROUP_SYSTEM_CHECKS
    return total
end
