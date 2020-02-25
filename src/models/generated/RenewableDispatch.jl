#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableDispatch <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechRenewable
        op_cost::TwoPartCost
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `tech::TechRenewable`
- `op_cost::TwoPartCost`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechRenewable
    op_cost::TwoPartCost
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableDispatch(; name, available, bus, activepower, reactivepower, tech, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function RenewableDispatch(::Nothing)
    RenewableDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechRenewable(nothing),
        op_cost=TwoPartCost(nothing),
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::RenewableDispatch) = value.name
"""Get RenewableDispatch available."""
get_available(value::RenewableDispatch) = value.available
"""Get RenewableDispatch bus."""
get_bus(value::RenewableDispatch) = value.bus
"""Get RenewableDispatch activepower."""
get_activepower(value::RenewableDispatch) = value.activepower
"""Get RenewableDispatch reactivepower."""
get_reactivepower(value::RenewableDispatch) = value.reactivepower
"""Get RenewableDispatch tech."""
get_tech(value::RenewableDispatch) = value.tech
"""Get RenewableDispatch op_cost."""
get_op_cost(value::RenewableDispatch) = value.op_cost
"""Get RenewableDispatch services."""
get_services(value::RenewableDispatch) = value.services
"""Get RenewableDispatch ext."""
get_ext(value::RenewableDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableDispatch) = value.forecasts
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal
