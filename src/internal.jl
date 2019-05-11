
import UUIDs

"""Internal storage common to PowerSystems types."""
struct PowerSystemInternal
    uuid::Base.UUID
end

"""Creates PowerSystemInternal with a UUID."""
PowerSystemInternal() = PowerSystemInternal(UUIDs.uuid4())

"""Gets the UUID for any PowerSystemType."""
function get_uuid(obj::PowerSystemType)::Base.UUID
    return obj.internal.uuid
end
