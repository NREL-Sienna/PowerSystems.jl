#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Bus <: Topology
        number::Int64
        name::String
        bustype::Union{Nothing, BusType}
        angle::Union{Nothing, Float64}
        voltage::Union{Nothing, Float64}
        voltagelimits::Union{Nothing, Min_Max}
        basevoltage::Union{Nothing, Float64}
        internal::InfrastructureSystemsInternal
    end


    mutable struct Bus <: Topology
        number::Int64
        name::String
        bustype::Union{Nothing, BusType}
        angle::Union{Nothing, Float64}
        voltage::Union{Nothing, Float64}
        voltagelimits::Union{Nothing, Min_Max}
        basevoltage::Union{Nothing, Float64}
        internal::InfrastructureSystemsInternal
    end

A power-system bus.

# Arguments

-`number::Int64`: number associated with the bus
-`name::String`: the name of the bus
-`bustype::Union{Nothing, BusType}`: bus type
-`angle::Union{Nothing, Float64}`: angle of the bus in radians
-`voltage::Union{Nothing, Float64}`: voltage as a multiple of basevoltage
-`voltagelimits::Union{Nothing, Min_Max}`: limits on the voltage variation as multiples of basevoltage
-`basevoltage::Union{Nothing, Float64}`: the base voltage in kV
-`internal::InfrastructureSystemsInternal`: Power System internal reference, do not modify


# Arguments
-`number::Int64`: number associated with the bus
-`name::String`: the name of the bus
-`bustype::Union{Nothing, BusType}`: bus type
-`angle::Union{Nothing, Float64}`: angle of the bus in radians
-`voltage::Union{Nothing, Float64}`: voltage as a multiple of basevoltage
-`voltagelimits::Union{Nothing, Min_Max}`: limits on the voltage variation as multiples of basevoltage
-`basevoltage::Union{Nothing, Float64}`: the base voltage in kV
-`internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Bus <: Topology
    "number associated with the bus"
    number::Int64
    "the name of the bus"
    name::String
    "bus type"
    bustype::Union{Nothing, BusType}
    "angle of the bus in radians"
    angle::Union{Nothing, Float64}
    "voltage as a multiple of basevoltage"
    voltage::Union{Nothing, Float64}
    "limits on the voltage variation as multiples of basevoltage"
    voltagelimits::Union{Nothing, Min_Max}
    "the base voltage in kV"
    basevoltage::Union{Nothing, Float64}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal

    function Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, internal, )
        (number, name, bustype, angle, voltage, voltagelimits, basevoltage, internal, ) = CheckBusParams(
            number,
            name,
            bustype,
            angle,
            voltage,
            voltagelimits,
            basevoltage,
            internal,
        )
        new(number, name, bustype, angle, voltage, voltagelimits, basevoltage, internal, )
    end
end

function Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, )
    Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, InfrastructureSystemsInternal())
end

function Bus(; number, name, bustype, angle, voltage, voltagelimits, basevoltage, )
    Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, )
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
    )
end

"""Get Bus number."""
get_number(value::Bus) = value.number
"""Get Bus name."""
get_name(value::Bus) = value.name
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
"""Get Bus internal."""
get_internal(value::Bus) = value.internal
