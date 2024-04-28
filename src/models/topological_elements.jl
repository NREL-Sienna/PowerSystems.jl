"""
Abstract type to represent the structure and interconnectedness of the system
"""
abstract type Topology <: Component end

"""
Represents a geographical region of system components.

All subtypes must implement the method `get_aggregation_topology_accessor`.
"""
abstract type AggregationTopology <: Topology end

supports_time_series(::AggregationTopology) = true

"""
Abstract type to represent any type of Bus, AC or DC.
"""
abstract type Bus <: Topology end

"""
Return the method to be called on a ACBus to get its AggregationTopology value for this type.
"""
function get_aggregation_topology_accessor(::Type{T}) where {T <: AggregationTopology}
    error("get_aggregation_topology_accessor must be implemented for $T")
    return
end

function check_bus_params(
    number,
    name,
    bustype,
    angle,
    voltage,
    voltage_limits,
    base_voltage,
    area,
    load_zone,
    ext,
    internal,
)
    if !isnothing(bustype)
        if bustype == ACBusTypes.SLACK
            bustype = ACBusTypes.REF
            @debug "Changed bus type from SLACK to" _group = IS.LOG_GROUP_SYSTEM bustype
            #elseif bustype == BusTypes.ISOLATED
            #    throw(DataFormatError("isolated buses are not supported; name=$name"))
        end
    end

    return number,
    name,
    bustype,
    angle,
    voltage,
    voltage_limits,
    base_voltage,
    area,
    load_zone,
    ext,
    internal
end
