#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TwoTerminalVSCDCLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        rectifier_tap_limits::MinMax
        rectifier_xrc::Float64
        rectifier_firing_angle::MinMax
        inverter_tap_limits::MinMax
        inverter_xrc::Float64
        inverter_firing_angle::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

As implemented in Milano's Book, Page 397.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `arc::Arc`: Used internally to represent network topology. **Do not modify.**
- `rectifier_tap_limits::MinMax`:
- `rectifier_xrc::Float64`:
- `rectifier_firing_angle::MinMax`:
- `inverter_tap_limits::MinMax`:
- `inverter_xrc::Float64`:
- `inverter_firing_angle::MinMax`:
- `services::Vector{Service}`: (default: `Device[]`) (optional) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct TwoTerminalVSCDCLine <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Initial condition of active power flow on the line (MW)"
    active_power_flow::Float64
    "Used internally to represent network topology. **Do not modify.**"
    arc::Arc
    rectifier_tap_limits::MinMax
    rectifier_xrc::Float64
    rectifier_firing_angle::MinMax
    inverter_tap_limits::MinMax
    inverter_xrc::Float64
    inverter_firing_angle::MinMax
    "(optional) Services that this device contributes to"
    services::Vector{Service}
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function TwoTerminalVSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), )
    TwoTerminalVSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, InfrastructureSystemsInternal(), )
end

function TwoTerminalVSCDCLine(; name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalVSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function TwoTerminalVSCDCLine(::Nothing)
    TwoTerminalVSCDCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        rectifier_tap_limits=(min=0.0, max=0.0),
        rectifier_xrc=0.0,
        rectifier_firing_angle=(min=0.0, max=0.0),
        inverter_tap_limits=(min=0.0, max=0.0),
        inverter_xrc=0.0,
        inverter_firing_angle=(min=0.0, max=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`TwoTerminalVSCDCLine`](@ref) `name`."""
get_name(value::TwoTerminalVSCDCLine) = value.name
"""Get [`TwoTerminalVSCDCLine`](@ref) `available`."""
get_available(value::TwoTerminalVSCDCLine) = value.available
"""Get [`TwoTerminalVSCDCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::TwoTerminalVSCDCLine) = get_value(value, value.active_power_flow)
"""Get [`TwoTerminalVSCDCLine`](@ref) `arc`."""
get_arc(value::TwoTerminalVSCDCLine) = value.arc
"""Get [`TwoTerminalVSCDCLine`](@ref) `rectifier_tap_limits`."""
get_rectifier_tap_limits(value::TwoTerminalVSCDCLine) = value.rectifier_tap_limits
"""Get [`TwoTerminalVSCDCLine`](@ref) `rectifier_xrc`."""
get_rectifier_xrc(value::TwoTerminalVSCDCLine) = value.rectifier_xrc
"""Get [`TwoTerminalVSCDCLine`](@ref) `rectifier_firing_angle`."""
get_rectifier_firing_angle(value::TwoTerminalVSCDCLine) = value.rectifier_firing_angle
"""Get [`TwoTerminalVSCDCLine`](@ref) `inverter_tap_limits`."""
get_inverter_tap_limits(value::TwoTerminalVSCDCLine) = value.inverter_tap_limits
"""Get [`TwoTerminalVSCDCLine`](@ref) `inverter_xrc`."""
get_inverter_xrc(value::TwoTerminalVSCDCLine) = value.inverter_xrc
"""Get [`TwoTerminalVSCDCLine`](@ref) `inverter_firing_angle`."""
get_inverter_firing_angle(value::TwoTerminalVSCDCLine) = value.inverter_firing_angle
"""Get [`TwoTerminalVSCDCLine`](@ref) `services`."""
get_services(value::TwoTerminalVSCDCLine) = value.services
"""Get [`TwoTerminalVSCDCLine`](@ref) `ext`."""
get_ext(value::TwoTerminalVSCDCLine) = value.ext
"""Get [`TwoTerminalVSCDCLine`](@ref) `internal`."""
get_internal(value::TwoTerminalVSCDCLine) = value.internal

"""Set [`TwoTerminalVSCDCLine`](@ref) `available`."""
set_available!(value::TwoTerminalVSCDCLine, val) = value.available = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TwoTerminalVSCDCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`TwoTerminalVSCDCLine`](@ref) `arc`."""
set_arc!(value::TwoTerminalVSCDCLine, val) = value.arc = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `rectifier_tap_limits`."""
set_rectifier_tap_limits!(value::TwoTerminalVSCDCLine, val) = value.rectifier_tap_limits = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `rectifier_xrc`."""
set_rectifier_xrc!(value::TwoTerminalVSCDCLine, val) = value.rectifier_xrc = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `rectifier_firing_angle`."""
set_rectifier_firing_angle!(value::TwoTerminalVSCDCLine, val) = value.rectifier_firing_angle = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `inverter_tap_limits`."""
set_inverter_tap_limits!(value::TwoTerminalVSCDCLine, val) = value.inverter_tap_limits = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `inverter_xrc`."""
set_inverter_xrc!(value::TwoTerminalVSCDCLine, val) = value.inverter_xrc = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `inverter_firing_angle`."""
set_inverter_firing_angle!(value::TwoTerminalVSCDCLine, val) = value.inverter_firing_angle = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `services`."""
set_services!(value::TwoTerminalVSCDCLine, val) = value.services = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `ext`."""
set_ext!(value::TwoTerminalVSCDCLine, val) = value.ext = val
