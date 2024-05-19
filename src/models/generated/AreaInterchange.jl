#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct AreaInterchange <: Branch
        name::String
        available::Bool
        active_power_flow::Float64
        area_from::Area
        area_to::Area
        flow_limits::FromTo_ToFrom
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Flow exchanged between Areas. This Interchange is agnostic to the lines connecting the areas. It does not substitute Interface which is the total flow across a group of lines.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `area_from::Area`: Area from which the power is extracted
- `area_to::Area`: Area to which the power is injected
- `flow_limits::FromTo_ToFrom`: Max flow between the areas. It ignores lines and other branches totals
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct AreaInterchange <: Branch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Initial condition of active power flow on the line (MW)"
    active_power_flow::Float64
    "Area from which the power is extracted"
    area_from::Area
    "Area to which the power is injected"
    area_to::Area
    "Max flow between the areas. It ignores lines and other branches totals"
    flow_limits::FromTo_ToFrom
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function AreaInterchange(name, available, active_power_flow, area_from, area_to, flow_limits, ext=Dict{String, Any}(), )
    AreaInterchange(name, available, active_power_flow, area_from, area_to, flow_limits, ext, InfrastructureSystemsInternal(), )
end

function AreaInterchange(; name, available, active_power_flow, area_from, area_to, flow_limits, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    AreaInterchange(name, available, active_power_flow, area_from, area_to, flow_limits, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function AreaInterchange(::Nothing)
    AreaInterchange(;
        name="init",
        available=false,
        active_power_flow=0.0,
        area_from=Area(nothing),
        area_to=Area(nothing),
        flow_limits=(from_to=0.0, to_from=0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get [`AreaInterchange`](@ref) `name`."""
get_name(value::AreaInterchange) = value.name
"""Get [`AreaInterchange`](@ref) `available`."""
get_available(value::AreaInterchange) = value.available
"""Get [`AreaInterchange`](@ref) `active_power_flow`."""
get_active_power_flow(value::AreaInterchange) = get_value(value, value.active_power_flow)
"""Get [`AreaInterchange`](@ref) `area_from`."""
get_area_from(value::AreaInterchange) = value.area_from
"""Get [`AreaInterchange`](@ref) `area_to`."""
get_area_to(value::AreaInterchange) = value.area_to
"""Get [`AreaInterchange`](@ref) `flow_limits`."""
get_flow_limits(value::AreaInterchange) = get_value(value, value.flow_limits)
"""Get [`AreaInterchange`](@ref) `ext`."""
get_ext(value::AreaInterchange) = value.ext
"""Get [`AreaInterchange`](@ref) `internal`."""
get_internal(value::AreaInterchange) = value.internal

"""Set [`AreaInterchange`](@ref) `available`."""
set_available!(value::AreaInterchange, val) = value.available = val
"""Set [`AreaInterchange`](@ref) `active_power_flow`."""
set_active_power_flow!(value::AreaInterchange, val) = value.active_power_flow = set_value(value, val)
"""Set [`AreaInterchange`](@ref) `area_from`."""
set_area_from!(value::AreaInterchange, val) = value.area_from = val
"""Set [`AreaInterchange`](@ref) `area_to`."""
set_area_to!(value::AreaInterchange, val) = value.area_to = val
"""Set [`AreaInterchange`](@ref) `flow_limits`."""
set_flow_limits!(value::AreaInterchange, val) = value.flow_limits = set_value(value, val)
"""Set [`AreaInterchange`](@ref) `ext`."""
set_ext!(value::AreaInterchange, val) = value.ext = val
