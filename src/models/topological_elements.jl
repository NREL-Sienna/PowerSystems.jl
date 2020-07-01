abstract type Topology <: Component end

"""
Represents a geographical region of system components.

All subtypes must implement the method get_aggregation_topology_accessor.
"""
abstract type AggregationTopology <: Topology end

"""
Return the method to be called on a Bus to get its AggregationTopology value for this type.
"""
function get_aggregation_topology_accessor(::Type{T}) where {T <: AggregationTopology}
    error("get_aggregation_topology_accessor must be implemented for $T")
end

function CheckBusParams(
    number,
    name,
    bustype,
    angle,
    voltage,
    voltagelimits,
    basevoltage,
    area,
    load_zone,
    ext,
    internal,
)
    if !isnothing(bustype)
        if bustype == BusTypes.SLACK
            bustype = BusTypes.REF
            @debug "Changed bus type from SLACK to" bustype
        elseif bustype == BusTypes.ISOLATED
            throw(DataFormatError("isolated buses are not supported; name=$name"))
        end
    end

    return number,
    name,
    bustype,
    angle,
    voltage,
    voltagelimits,
    basevoltage,
    area,
    load_zone,
    ext,
    internal
end
