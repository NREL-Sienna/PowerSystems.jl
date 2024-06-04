#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TransmissionInterface <: Service
        name::String
        available::Bool
        active_power_flow_limits::MinMax
        violation_penalty::Float64
        direction_mapping::Dict{String, Int}
        internal::InfrastructureSystemsInternal
    end

A collection of branches that make up an interface or corridor for the transfer of power, such as between different [`Areas`](@ref Area) or [`LoadZones`](@ref LoadZone).

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `active_power_flow_limits::MinMax`: Minimum and maximum active power flow limits on the interface (MW)
- `violation_penalty::Float64`: (optional) Penalty cost for violating the flow limits in the interface
- `direction_mapping::Dict{String, Int}`: (optional) Dictionary of 1 or -1 flow multipliers for the lines, for cases when a line has a reverse direction with respect to the interface
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct TransmissionInterface <: Service
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Minimum and maximum active power flow limits on the interface (MW)"
    active_power_flow_limits::MinMax
    "(optional) Penalty cost for violating the flow limits in the interface"
    violation_penalty::Float64
    "(optional) Dictionary of 1 or -1 flow multipliers for the lines, for cases when a line has a reverse direction with respect to the interface"
    direction_mapping::Dict{String, Int}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function TransmissionInterface(name, available, active_power_flow_limits, violation_penalty=INFINITE_COST, direction_mapping=Dict{String, Int}(), )
    TransmissionInterface(name, available, active_power_flow_limits, violation_penalty, direction_mapping, InfrastructureSystemsInternal(), )
end

function TransmissionInterface(; name, available, active_power_flow_limits, violation_penalty=INFINITE_COST, direction_mapping=Dict{String, Int}(), internal=InfrastructureSystemsInternal(), )
    TransmissionInterface(name, available, active_power_flow_limits, violation_penalty, direction_mapping, internal, )
end

# Constructor for demo purposes; non-functional.
function TransmissionInterface(::Nothing)
    TransmissionInterface(;
        name="init",
        available=false,
        active_power_flow_limits=(min=0.0, max=0.0),
        violation_penalty=0.0,
        direction_mapping=Dict{String, Int}(),
    )
end

"""Get [`TransmissionInterface`](@ref) `name`."""
get_name(value::TransmissionInterface) = value.name
"""Get [`TransmissionInterface`](@ref) `available`."""
get_available(value::TransmissionInterface) = value.available
"""Get [`TransmissionInterface`](@ref) `active_power_flow_limits`."""
get_active_power_flow_limits(value::TransmissionInterface) = get_value(value, value.active_power_flow_limits)
"""Get [`TransmissionInterface`](@ref) `violation_penalty`."""
get_violation_penalty(value::TransmissionInterface) = value.violation_penalty
"""Get [`TransmissionInterface`](@ref) `direction_mapping`."""
get_direction_mapping(value::TransmissionInterface) = value.direction_mapping
"""Get [`TransmissionInterface`](@ref) `internal`."""
get_internal(value::TransmissionInterface) = value.internal

"""Set [`TransmissionInterface`](@ref) `available`."""
set_available!(value::TransmissionInterface, val) = value.available = val
"""Set [`TransmissionInterface`](@ref) `active_power_flow_limits`."""
set_active_power_flow_limits!(value::TransmissionInterface, val) = value.active_power_flow_limits = set_value(value, val)
"""Set [`TransmissionInterface`](@ref) `violation_penalty`."""
set_violation_penalty!(value::TransmissionInterface, val) = value.violation_penalty = val
"""Set [`TransmissionInterface`](@ref) `direction_mapping`."""
set_direction_mapping!(value::TransmissionInterface, val) = value.direction_mapping = val
