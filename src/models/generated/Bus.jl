#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Bus <: Topology
        number::Int
        name::String
        bustype::Union{Nothing, BusTypes}
        angle::Union{Nothing, Float64}
        magnitude::Union{Nothing, Float64}
        voltage_limits::Union{Nothing, MinMax}
        base_voltage::Union{Nothing, Float64}
        area::Union{Nothing, Area}
        load_zone::Union{Nothing, LoadZone}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A power-system bus.

# Arguments
- `number::Int`: number associated with the bus
- `name::String`: the name of the bus
- `bustype::Union{Nothing, BusTypes}`: bus type
- `angle::Union{Nothing, Float64}`: angle of the bus in radians, validation range: `(-1.571, 1.571)`, action if invalid: `error`
- `magnitude::Union{Nothing, Float64}`: voltage as a multiple of basevoltage, validation range: `voltage_limits`, action if invalid: `warn`
- `voltage_limits::Union{Nothing, MinMax}`: limits on the voltage variation as multiples of basevoltage
- `base_voltage::Union{Nothing, Float64}`: the base voltage in kV, validation range: `(0, nothing)`, action if invalid: `error`
- `area::Union{Nothing, Area}`: the area containing the bus
- `load_zone::Union{Nothing, LoadZone}`: the load zone containing the bus
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Bus <: Topology
    "number associated with the bus"
    number::Int
    "the name of the bus"
    name::String
    "bus type"
    bustype::Union{Nothing, BusTypes}
    "angle of the bus in radians"
    angle::Union{Nothing, Float64}
    "voltage as a multiple of basevoltage"
    magnitude::Union{Nothing, Float64}
    "limits on the voltage variation as multiples of basevoltage"
    voltage_limits::Union{Nothing, MinMax}
    "the base voltage in kV"
    base_voltage::Union{Nothing, Float64}
    "the area containing the bus"
    area::Union{Nothing, Area}
    "the load zone containing the bus"
    load_zone::Union{Nothing, LoadZone}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal

    function Bus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, )
        (number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, ) = check_bus_params(
            number,
            name,
            bustype,
            angle,
            magnitude,
            voltage_limits,
            base_voltage,
            area,
            load_zone,
            ext,
            internal,
        )
        new(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, )
    end
end

function Bus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    Bus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, InfrastructureSystemsInternal(), )
end

function Bus(; number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Bus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function Bus(::Nothing)
    Bus(;
        number=0,
        name="init",
        bustype=nothing,
        angle=0.0,
        magnitude=0.0,
        voltage_limits=(min=0.0, max=0.0),
        base_voltage=nothing,
        area=nothing,
        load_zone=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`Bus`](@ref) `number`."""
get_number(value::Bus) = value.number
"""Get [`Bus`](@ref) `name`."""
get_name(value::Bus) = value.name
"""Get [`Bus`](@ref) `bustype`."""
get_bustype(value::Bus) = value.bustype
"""Get [`Bus`](@ref) `angle`."""
get_angle(value::Bus) = value.angle
"""Get [`Bus`](@ref) `magnitude`."""
get_magnitude(value::Bus) = value.magnitude
"""Get [`Bus`](@ref) `voltage_limits`."""
get_voltage_limits(value::Bus) = value.voltage_limits
"""Get [`Bus`](@ref) `base_voltage`."""
get_base_voltage(value::Bus) = value.base_voltage
"""Get [`Bus`](@ref) `area`."""
get_area(value::Bus) = value.area
"""Get [`Bus`](@ref) `load_zone`."""
get_load_zone(value::Bus) = value.load_zone
"""Get [`Bus`](@ref) `ext`."""
get_ext(value::Bus) = value.ext
"""Get [`Bus`](@ref) `internal`."""
get_internal(value::Bus) = value.internal

"""Set [`Bus`](@ref) `number`."""
set_number!(value::Bus, val) = value.number = val
"""Set [`Bus`](@ref) `bustype`."""
set_bustype!(value::Bus, val) = value.bustype = val
"""Set [`Bus`](@ref) `angle`."""
set_angle!(value::Bus, val) = value.angle = val
"""Set [`Bus`](@ref) `magnitude`."""
set_magnitude!(value::Bus, val) = value.magnitude = val
"""Set [`Bus`](@ref) `voltage_limits`."""
set_voltage_limits!(value::Bus, val) = value.voltage_limits = val
"""Set [`Bus`](@ref) `base_voltage`."""
set_base_voltage!(value::Bus, val) = value.base_voltage = val
"""Set [`Bus`](@ref) `area`."""
set_area!(value::Bus, val) = value.area = val
"""Set [`Bus`](@ref) `load_zone`."""
set_load_zone!(value::Bus, val) = value.load_zone = val
"""Set [`Bus`](@ref) `ext`."""
set_ext!(value::Bus, val) = value.ext = val
