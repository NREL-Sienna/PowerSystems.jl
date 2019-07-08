abstract type Topology <: Component end



struct Arch <: Topology
    from::Bus
    to::Bus
    internal::PowerSystems.PowerSystemInternal
end

function CheckBusParams(number, name, bustype, angle, voltage, voltagelimits, basevoltatge,
                        internal)
    if !isnothing(bustype)
        if bustype == SLACK::BusType
            bustype = REF::BusType
            @debug "Changed bus type from SLACK to" bustype
        elseif bustype == ISOLATED::BusType
            throw(DataFormatError("isolated buses are not supported; name=$name"))
        end
    end

    return number, name, bustype, angle, voltage, voltagelimits, basevoltatge, internal
end
