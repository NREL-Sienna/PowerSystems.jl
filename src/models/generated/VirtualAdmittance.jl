#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct VirtualAdmittance <: ACTransmission
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        arc_admittance::Complex{Float64}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A virtual admittance between two buses that does not correspond to a physical component. This can be used to model the effects of network reductions (e.g. Ward reduction).

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow on the line (MVAR)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `arc_admittance::Complex{Float64}`: Admittance in pu ([`SYSTEM_BASE`](@ref per_unit)). The component does not contribute a shunt admittance.
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct VirtualAdmittance <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flow on the line (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow on the line (MVAR)"
    reactive_power_flow::Float64
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Admittance in pu ([`SYSTEM_BASE`](@ref per_unit)). The component does not contribute a shunt admittance."
    arc_admittance::Complex{Float64}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function VirtualAdmittance(name, available, active_power_flow, reactive_power_flow, arc, arc_admittance, ext=Dict{String, Any}(), )
    VirtualAdmittance(name, available, active_power_flow, reactive_power_flow, arc, arc_admittance, ext, InfrastructureSystemsInternal(), )
end

function VirtualAdmittance(; name, available, active_power_flow, reactive_power_flow, arc, arc_admittance, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    VirtualAdmittance(name, available, active_power_flow, reactive_power_flow, arc, arc_admittance, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function VirtualAdmittance(::Nothing)
    VirtualAdmittance(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        arc_admittance=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`VirtualAdmittance`](@ref) `name`."""
get_name(value::VirtualAdmittance) = value.name
"""Get [`VirtualAdmittance`](@ref) `available`."""
get_available(value::VirtualAdmittance) = value.available
"""Get [`VirtualAdmittance`](@ref) `active_power_flow`."""
get_active_power_flow(value::VirtualAdmittance) = get_value(value, Val(:active_power_flow), Val(:mva))
"""Get [`VirtualAdmittance`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::VirtualAdmittance) = get_value(value, Val(:reactive_power_flow), Val(:mva))
"""Get [`VirtualAdmittance`](@ref) `arc`."""
get_arc(value::VirtualAdmittance) = value.arc
"""Get [`VirtualAdmittance`](@ref) `arc_admittance`."""
get_arc_admittance(value::VirtualAdmittance) = value.arc_admittance
"""Get [`VirtualAdmittance`](@ref) `ext`."""
get_ext(value::VirtualAdmittance) = value.ext
"""Get [`VirtualAdmittance`](@ref) `internal`."""
get_internal(value::VirtualAdmittance) = value.internal

"""Set [`VirtualAdmittance`](@ref) `available`."""
set_available!(value::VirtualAdmittance, val) = value.available = val
"""Set [`VirtualAdmittance`](@ref) `active_power_flow`."""
set_active_power_flow!(value::VirtualAdmittance, val) = value.active_power_flow = set_value(value, Val(:active_power_flow), val, Val(:mva))
"""Set [`VirtualAdmittance`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::VirtualAdmittance, val) = value.reactive_power_flow = set_value(value, Val(:reactive_power_flow), val, Val(:mva))
"""Set [`VirtualAdmittance`](@ref) `arc`."""
set_arc!(value::VirtualAdmittance, val) = value.arc = val
"""Set [`VirtualAdmittance`](@ref) `arc_admittance`."""
set_arc_admittance!(value::VirtualAdmittance, val) = value.arc_admittance = val
"""Set [`VirtualAdmittance`](@ref) `ext`."""
set_ext!(value::VirtualAdmittance, val) = value.ext = val
