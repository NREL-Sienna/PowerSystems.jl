
import UUIDs

"""Internal storage common to PowerSystems types."""
struct PowerSystemInternal
    uuid::Base.UUID
end

"""Creates PowerSystemInternal with a UUID."""
PowerSystemInternal() = PowerSystemInternal(UUIDs.uuid4())

"""Gets the UUID for any PowerSystemType."""
function get_uuid(obj::T)::Base.UUID where T <: PowerSystemType
    return obj.internal.uuid
end

"""Gets the UUIDs for a vector of any PowerSystemType."""
function get_uuids(objs::Vector{T})::Vector{Base.UUID} where T <: PowerSystemType
    return [get_uuid(x) for x in objs]
end
