#=
This file is auto-generated. Do not edit.
=#

"""A power-system bus."""
mutable struct Bus <: Topology
    number::Int64  # number associated with the bus
    name::String  # the name of the bus
    bustype::Union{Nothing, BusType}  # bus type
    angle::Union{Nothing, Float64}  # angle of the bus in radians
    voltage::Union{Nothing, Float64}  # voltage as a multiple of basevoltage
    voltagelimits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}  # limits on the voltage variation as multiples of basevoltage
    basevoltage::Union{Nothing, Float64}  # the base voltage in kV
    internal::PowerSystems.PowerSystemInternal

    function Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, internal, )
        (number, name, bustype, angle, voltage, voltagelimits, basevoltage, internal, ) = CheckBusParams(
             number,  name,  bustype,  angle,  voltage,  voltagelimits,  basevoltage,  internal, 
        )
        new(number, name, bustype, angle, voltage, voltagelimits, basevoltage, internal, )
    end
end

function Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, )
    Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage, PowerSystemInternal())
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
