
get_aggregation_topology_accessor(::Type{Area}) = get_area
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

set_load_zone!(bus::Bus, load_zone::LoadZone) = bus.load_zone = load_zone
set_area!(bus::Bus, area::Area) = bus.area = area

"""
    removes the aggregation topology in a Bus
"""
_remove_aggregration_topology!(bus::Bus, ::LoadZone) = bus.load_zone = nothing
_remove_aggregration_topology!(bus::Bus, ::Area) = bus.area = nothing

function set_dynamic_injector!(
    static_injector::T,
    dynamic_injector::U,
) where {
    T <: Union{
        GenericBattery,
        HydroDispatch,
        HydroEnergyReservoir,
        InterruptibleLoad,
        PowerLoad,
        RenewableDispatch,
        RenewableFix,
        ThermalStandard,
    },
    U <: Union{Nothing, DynamicInjection},
}
    current_dynamic_injector = get_dynamic_injector(static_injector)
    if !isnothing(current_dynamic_injector) && !isnothing(dynamic_injector)
        throw(ArgumentError("cannot assign a dynamic injector on a device that already has one"))
    end

    # All of these types implement this field.
    static_injector.dynamic_injector = dynamic_injector
end

function set_static_injector!(
    dynamic_injector::T,
    static_injector::U,
) where {
    T <: Union{DynamicGenerator, DynamicInverter},
    U <: Union{Nothing, StaticInjection},
}
    current_static_injector = get_static_injector(dynamic_injector)
    if !isnothing(current_static_injector) && !isnothing(static_injector)
        throw(ArgumentError("cannot assign a static injector on a device that already has one"))
    end

    # All of these types implement this field.
    dynamic_injector.static_injector = static_injector
end
