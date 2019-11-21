abstract type Topology <: Component end

function CheckBusParams(
    number,
    name,
    bustype,
    angle,
    voltage,
    voltagelimits,
    basevoltage,
    ext,
    internal,
)
    if !isnothing(bustype)
        if bustype == SLACK::BusType
            bustype = REF::BusType
            @debug "Changed bus type from SLACK to" bustype
        elseif bustype == ISOLATED::BusType
            throw(IS.DataFormatError("isolated buses are not supported; name=$name"))
        end
    end

    return number, name, bustype, angle, voltage, voltagelimits, basevoltage, ext, internal
end
