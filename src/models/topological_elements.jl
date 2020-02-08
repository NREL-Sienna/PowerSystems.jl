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
        if bustype == BusTypes.SLACK
            bustype = BusTypes.REF
            @debug "Changed bus type from SLACK to" bustype
        elseif bustype == BusTypes.ISOLATED
            throw(DataFormatError("isolated buses are not supported; name=$name"))
        end
    end

    return number, name, bustype, angle, voltage, voltagelimits, basevoltage, ext, internal
end
