#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ACBus <: Bus
        number::Int
        name::String
        bustype::Union{Nothing, ACBusTypes}
        angle::Union{Nothing, Float64}
        magnitude::Union{Nothing, Float64}
        voltage_limits::Union{Nothing, MinMax}
        base_voltage::Union{Nothing, Float64}
        area::Union{Nothing, Area}
        load_zone::Union{Nothing, LoadZone}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

An AC bus

# Arguments
- `number::Int`: A unique bus identification number (positive integer)
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `bustype::Union{Nothing, ACBusTypes}`: Used to describe the connectivity and behavior of this bus. [Options are listed here.](@ref acbustypes_list)
- `angle::Union{Nothing, Float64}`: angle of the bus in radians, validation range: `(-1.571, 1.571)`
- `magnitude::Union{Nothing, Float64}`: voltage as a multiple of `base_voltage`, validation range: `voltage_limits`
- `voltage_limits::Union{Nothing, MinMax}`: limits on the voltage variation as multiples of `base_voltage`
- `base_voltage::Union{Nothing, Float64}`: the base voltage in kV, validation range: `(0, nothing)`
- `area::Union{Nothing, Area}`: (default: `nothing`) the area containing the bus
- `load_zone::Union{Nothing, LoadZone}`: (default: `nothing`) the load zone containing the bus
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct ACBus <: Bus
    "A unique bus identification number (positive integer)"
    number::Int
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Used to describe the connectivity and behavior of this bus. [Options are listed here.](@ref acbustypes_list)"
    bustype::Union{Nothing, ACBusTypes}
    "angle of the bus in radians"
    angle::Union{Nothing, Float64}
    "voltage as a multiple of `base_voltage`"
    magnitude::Union{Nothing, Float64}
    "limits on the voltage variation as multiples of `base_voltage`"
    voltage_limits::Union{Nothing, MinMax}
    "the base voltage in kV"
    base_voltage::Union{Nothing, Float64}
    "the area containing the bus"
    area::Union{Nothing, Area}
    "the load zone containing the bus"
    load_zone::Union{Nothing, LoadZone}
    "An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)"
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal

    function ACBus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, )
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

function ACBus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    ACBus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, InfrastructureSystemsInternal(), )
end

function ACBus(; number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    ACBus(number, name, bustype, angle, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function ACBus(::Nothing)
    ACBus(;
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

"""Get [`ACBus`](@ref) `number`."""
get_number(value::ACBus) = value.number
"""Get [`ACBus`](@ref) `name`."""
get_name(value::ACBus) = value.name
"""Get [`ACBus`](@ref) `bustype`."""
get_bustype(value::ACBus) = value.bustype
"""Get [`ACBus`](@ref) `angle`."""
get_angle(value::ACBus) = value.angle
"""Get [`ACBus`](@ref) `magnitude`."""
get_magnitude(value::ACBus) = value.magnitude
"""Get [`ACBus`](@ref) `voltage_limits`."""
get_voltage_limits(value::ACBus) = value.voltage_limits
"""Get [`ACBus`](@ref) `base_voltage`."""
get_base_voltage(value::ACBus) = value.base_voltage
"""Get [`ACBus`](@ref) `area`."""
get_area(value::ACBus) = value.area
"""Get [`ACBus`](@ref) `load_zone`."""
get_load_zone(value::ACBus) = value.load_zone
"""Get [`ACBus`](@ref) `ext`."""
get_ext(value::ACBus) = value.ext
"""Get [`ACBus`](@ref) `internal`."""
get_internal(value::ACBus) = value.internal

"""Set [`ACBus`](@ref) `number`."""
set_number!(value::ACBus, val) = value.number = val
"""Set [`ACBus`](@ref) `bustype`."""
set_bustype!(value::ACBus, val) = value.bustype = val
"""Set [`ACBus`](@ref) `angle`."""
set_angle!(value::ACBus, val) = value.angle = val
"""Set [`ACBus`](@ref) `magnitude`."""
set_magnitude!(value::ACBus, val) = value.magnitude = val
"""Set [`ACBus`](@ref) `voltage_limits`."""
set_voltage_limits!(value::ACBus, val) = value.voltage_limits = val
"""Set [`ACBus`](@ref) `base_voltage`."""
set_base_voltage!(value::ACBus, val) = value.base_voltage = val
"""Set [`ACBus`](@ref) `area`."""
set_area!(value::ACBus, val) = value.area = val
"""Set [`ACBus`](@ref) `load_zone`."""
set_load_zone!(value::ACBus, val) = value.load_zone = val
"""Set [`ACBus`](@ref) `ext`."""
set_ext!(value::ACBus, val) = value.ext = val
