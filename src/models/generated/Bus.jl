#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Bus <: Topology
        number::Int64
        name::String
        bus_type::Union{Nothing, BusTypes.BusType}
        angle::Union{Nothing, Float64}
        voltage::Union{Nothing, Float64}
        voltage_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
        base_voltage::Union{Nothing, Float64}
        area::Union{Nothing, Area}
        load_zone::Union{Nothing, LoadZone}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A power-system bus.

# Arguments
- `number::Int64`: number associated with the bus
- `name::String`: the name of the bus
- `bus_type::Union{Nothing, BusTypes.BusType}`: bus type
- `angle::Union{Nothing, Float64}`: angle of the bus in radians, validation range: (-1.571, 1.571), action if invalid: error
- `voltage::Union{Nothing, Float64}`: voltage as a multiple of base_voltage, validation range: voltage_limits, action if invalid: warn
- `voltage_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}`: limits on the voltage variation as multiples of base_voltage
- `base_voltage::Union{Nothing, Float64}`: the base voltage in kV, validation range: (0, nothing), action if invalid: error
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
    bus_type::Union{Nothing, BusTypes.BusType}
    "angle of the bus in radians"
    angle::Union{Nothing, Float64}
    "voltage as a multiple of base_voltage"
    voltage::Union{Nothing, Float64}
    "limits on the voltage variation as multiples of base_voltage"
    voltage_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    "the base voltage in kV"
    base_voltage::Union{Nothing, Float64}
    "the area containing the bus"
    area::Union{Nothing, Area}
    "the load zone containing the bus"
    load_zone::Union{Nothing, LoadZone}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal

    function Bus(number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area, load_zone, ext, internal, )
        (number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area, load_zone, ext, internal, ) = CheckBusParams(
            number,
            name,
            bus_type,
            angle,
            voltage,
            voltage_limits,
            base_voltage,
            area,
            load_zone,
            ext,
            internal,
        )
        new(number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area, load_zone, ext, internal, )
    end
end

function Bus(number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    Bus(number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area, load_zone, ext, InfrastructureSystemsInternal(), )
end

function Bus(; number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area=nothing, load_zone=nothing, ext=Dict{String, Any}(), )
    Bus(number, name, bus_type, angle, voltage, voltage_limits, base_voltage, area, load_zone, ext, )
end

# Constructor for demo purposes; non-functional.
function Bus(::Nothing)
    Bus(;
        number=0,
        name="init",
        bus_type=nothing,
        angle=0.0,
        voltage=0.0,
        voltage_limits=(min=0.0, max=0.0),
        base_voltage=nothing,
        area=nothing,
        load_zone=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get Bus number."""
get_number(value::Bus) = value.number

InfrastructureSystems.get_name(value::Bus) = value.name
"""Get Bus bus_type."""
get_bus_type(value::Bus) = value.bus_type
"""Get Bus angle."""
get_angle(value::Bus) = value.angle
"""Get Bus voltage."""
get_voltage(value::Bus) = value.voltage
"""Get Bus voltage_limits."""
get_voltage_limits(value::Bus) = value.voltage_limits
"""Get Bus base_voltage."""
get_base_voltage(value::Bus) = value.base_voltage
"""Get Bus area."""
get_area(value::Bus) = value.area
"""Get Bus load_zone."""
get_load_zone(value::Bus) = value.load_zone
"""Get Bus ext."""
get_ext(value::Bus) = value.ext
"""Get Bus internal."""
get_internal(value::Bus) = value.internal

"""Set Bus number."""
set_number!(value::Bus, val::Int64) = value.number = val

InfrastructureSystems.set_name!(value::Bus, val::String) = value.name = val
"""Set Bus bus_type."""
set_bus_type!(value::Bus, val::Union{Nothing, BusTypes.BusType}) = value.bus_type = val
"""Set Bus angle."""
set_angle!(value::Bus, val::Union{Nothing, Float64}) = value.angle = val
"""Set Bus voltage."""
set_voltage!(value::Bus, val::Union{Nothing, Float64}) = value.voltage = val
"""Set Bus voltage_limits."""
set_voltage_limits!(value::Bus, val::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}) = value.voltage_limits = val
"""Set Bus base_voltage."""
set_base_voltage!(value::Bus, val::Union{Nothing, Float64}) = value.base_voltage = val
"""Set Bus area."""
set_area!(value::Bus, val::Union{Nothing, Area}) = value.area = val
"""Set Bus load_zone."""
set_load_zone!(value::Bus, val::Union{Nothing, LoadZone}) = value.load_zone = val
"""Set Bus ext."""
set_ext!(value::Bus, val::Dict{String, Any}) = value.ext = val
"""Set Bus internal."""
set_internal!(value::Bus, val::InfrastructureSystemsInternal) = value.internal = val
