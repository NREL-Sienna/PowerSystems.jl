
"""Internal storage common to PowerSystems types."""
struct PowerSystemInternal
    uuid::UUIDs.UUID
end

"""Creates PowerSystemInternal with a UUID."""
PowerSystemInternal() = PowerSystemInternal(UUIDs.uuid4())

"""Gets the UUID for any PowerSystemType."""
function get_uuid(obj::T)::UUIDs.UUID where T <: PowerSystemType
    @assert :internal in fieldnames(T)
    return obj.internal.uuid
end
