#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Bus <: Topology
        number::Int64
        name::String
        bustype::Union{Nothing, BusTypes.BusType}
        angle::Union{Nothing, Float64}
        voltage::Union{Nothing, Float64}
        voltagelimits::Union{Nothing, Min_Max}
        basevoltage::Union{Nothing, Float64}
        area::Union{Nothing, Area}
        load_zone::Union{Nothing, LoadZone}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A power-system bus.

# Arguments
- `number::Int64`: number associated with the bus
- `name::String`: the name of the bus
- `bustype::Union{Nothing, BusTypes.BusType}`: bus type
- `angle::Union{Nothing, Float64}`: angle of the bus in radians, validation range: (-1.571, 1.571), action if invalid: error
- `voltage::Union{Nothing, Float64}`: voltage as a multiple of basevoltage, validation range: voltagelimits, action if invalid: warn
- `voltagelimits::Union{Nothing, Min_Max}`: limits on the voltage variation as multiples of basevoltage
- `basevoltage::Union{Nothing, Float64}`: the base voltage in kV, validation range: (0, nothing), action if invalid: error
- `area::Union{Nothing, Area}`: the area containing the bus
- `load_zone::Union{Nothing, LoadZone}`: the load zone containing the bus
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Bus <: Topology
    "number associated with the bus"
    number::Int64
    "the name of the bus"
    name::String
    "bus type"
    bustype::Union{Nothing, BusTypes.BusType}
    "angle of the bus in radians"
    angle::Union{Nothing, Float64}
    "voltage as a multiple of basevoltage"
    voltage::Union{Nothing, Float64}
    "limits on the voltage variation as multiples of basevoltage"
    voltagelimits::Union{Nothing, Min_Max}
    "the base voltage in kV"
    basevoltage::Union{Nothing, Float64}
    "the area containing the bus"
    area::Union{Nothing, Area}
    "the load zone containing the bus"
    load_zone::Union{Nothing, LoadZone}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal

    function Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, area, load_zone, ext, internal, )
        (number, name, bustype, angle, voltage, voltagelimits, basevoltage, area, load_zone, ext, internal, ) = CheckBusParams(
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
        new(number, name, bustype, angle, voltage, voltagelimits, basevoltage, area, load_zone, ext, internal, )
    end
end

function Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, area, load_zone, ext, InfrastructureSystemsInternal(), )
end

function Bus(; number, name, bustype, angle, voltage, voltagelimits, basevoltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, area, load_zone, ext, )
end

# Constructor for demo purposes; non-functional.
function Bus(::Nothing)
    Bus(;
        number=0,
        name="init",
        bustype=nothing,
        angle=0.0,
        voltage=0.0,
        voltagelimits=(min=0.0, max=0.0),
        basevoltage=nothing,
        area=Area(nothing),
        load_zone=LoadZone(nothing),
        ext=Dict{String, Any}(),
    )
end

"""Get Bus number."""
get_number(value::Bus) = value.number

InfrastructureSystems.get_name(value::Bus) = value.name
"""Get Bus bustype."""
get_bustype(value::Bus) = value.bustype
"""Get Bus angle."""
get_angle(value::Bus) = value.angle
"""Get Bus voltage."""
get_voltage(value::Bus) = value.voltage
"""Get Bus voltagelimits."""
get_voltagelimits(value::Bus) = value.voltagelimits
"""Get Bus basevoltage."""
get_basevoltage(value::Bus) = value.basevoltage
"""Get Bus area."""
get_area(value::Bus) = value.area
"""Get Bus load_zone."""
get_load_zone(value::Bus) = value.load_zone
"""Get Bus ext."""
get_ext(value::Bus) = value.ext
"""Get Bus internal."""
get_internal(value::Bus) = value.internal

"""Set Bus number."""
set_number(value::Bus, val) = value.number = val

InfrastructureSystems.set_name(value::Bus, val) = value.name = val
"""Set Bus bustype."""
set_bustype(value::Bus, val) = value.bustype = val
"""Set Bus angle."""
set_angle(value::Bus, val) = value.angle = val
"""Set Bus voltage."""
set_voltage(value::Bus, val) = value.voltage = val
"""Set Bus voltagelimits."""
set_voltagelimits(value::Bus, val) = value.voltagelimits = val
"""Set Bus basevoltage."""
set_basevoltage(value::Bus, val) = value.basevoltage = val
"""Set Bus area."""
set_area(value::Bus, val) = value.area = val
"""Set Bus load_zone."""
set_load_zone(value::Bus, val) = value.load_zone = val
"""Set Bus ext."""
set_ext(value::Bus, val) = value.ext = val
"""Set Bus internal."""
set_internal(value::Bus, val) = value.internal = val
