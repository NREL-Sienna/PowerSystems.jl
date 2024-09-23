#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct DCBus <: Bus
        number::Int
        name::String
        magnitude::Union{Nothing, Float64}
        voltage_limits::Union{Nothing, MinMax}
        base_voltage::Union{Nothing, Float64}
        area::Union{Nothing, Area}
        load_zone::Union{Nothing, LoadZone}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A DC bus

# Arguments
- `number::Int`: A unique bus identification number (positive integer)
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `magnitude::Union{Nothing, Float64}`: voltage as a multiple of `base_voltage`, validation range: `voltage_limits`
- `voltage_limits::Union{Nothing, MinMax}`: limits on the voltage variation as multiples of `base_voltage`
- `base_voltage::Union{Nothing, Float64}`: the base voltage in kV, validation range: `(0, nothing)`
- `area::Union{Nothing, Area}`: (default: `nothing`) the area containing the DC bus
- `load_zone::Union{Nothing, LoadZone}`: (default: `nothing`) the load zone containing the DC bus
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct DCBus <: Bus
    "A unique bus identification number (positive integer)"
    number::Int
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "voltage as a multiple of `base_voltage`"
    magnitude::Union{Nothing, Float64}
    "limits on the voltage variation as multiples of `base_voltage`"
    voltage_limits::Union{Nothing, MinMax}
    "the base voltage in kV"
    base_voltage::Union{Nothing, Float64}
    "the area containing the DC bus"
    area::Union{Nothing, Area}
    "the load zone containing the DC bus"
    load_zone::Union{Nothing, LoadZone}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function DCBus(number, name, magnitude, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    DCBus(number, name, magnitude, voltage_limits, base_voltage, area, load_zone, ext, InfrastructureSystemsInternal(), )
end

function DCBus(; number, name, magnitude, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    DCBus(number, name, magnitude, voltage_limits, base_voltage, area, load_zone, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function DCBus(::Nothing)
    DCBus(;
        number=0,
        name="init",
        magnitude=0.0,
        voltage_limits=(min=0.0, max=0.0),
        base_voltage=nothing,
        area=nothing,
        load_zone=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`DCBus`](@ref) `number`."""
get_number(value::DCBus) = value.number
"""Get [`DCBus`](@ref) `name`."""
get_name(value::DCBus) = value.name
"""Get [`DCBus`](@ref) `magnitude`."""
get_magnitude(value::DCBus) = value.magnitude
"""Get [`DCBus`](@ref) `voltage_limits`."""
get_voltage_limits(value::DCBus) = value.voltage_limits
"""Get [`DCBus`](@ref) `base_voltage`."""
get_base_voltage(value::DCBus) = value.base_voltage
"""Get [`DCBus`](@ref) `area`."""
get_area(value::DCBus) = value.area
"""Get [`DCBus`](@ref) `load_zone`."""
get_load_zone(value::DCBus) = value.load_zone
"""Get [`DCBus`](@ref) `ext`."""
get_ext(value::DCBus) = value.ext
"""Get [`DCBus`](@ref) `internal`."""
get_internal(value::DCBus) = value.internal

"""Set [`DCBus`](@ref) `number`."""
set_number!(value::DCBus, val) = value.number = val
"""Set [`DCBus`](@ref) `magnitude`."""
set_magnitude!(value::DCBus, val) = value.magnitude = val
"""Set [`DCBus`](@ref) `voltage_limits`."""
set_voltage_limits!(value::DCBus, val) = value.voltage_limits = val
"""Set [`DCBus`](@ref) `base_voltage`."""
set_base_voltage!(value::DCBus, val) = value.base_voltage = val
"""Set [`DCBus`](@ref) `area`."""
set_area!(value::DCBus, val) = value.area = val
"""Set [`DCBus`](@ref) `load_zone`."""
set_load_zone!(value::DCBus, val) = value.load_zone = val
"""Set [`DCBus`](@ref) `ext`."""
set_ext!(value::DCBus, val) = value.ext = val
