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
        _forecasts::InfrastructureSystems.Forecasts
        ext::Union{Nothing, Dict{String, Any}}
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
- `_forecasts::InfrastructureSystems.Forecasts`
- `ext::Union{Nothing, Dict{String, Any}}`
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
    _forecasts::InfrastructureSystems.Forecasts
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

function RenewableDispatch(; name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, )
end


function RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, ; ext=nothing)
    _forecasts=InfrastructureSystems.Forecasts()
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
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
        _forecasts=InfrastructureSystems.Forecasts(),
        ext=nothing,
    )
end

"""Get RenewableDispatch name."""
get_name(value::RenewableDispatch) = value.name
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
"""Get RenewableDispatch _forecasts."""
get__forecasts(value::RenewableDispatch) = value._forecasts
"""Get RenewableDispatch ext."""
get_ext(value::RenewableDispatch) = value.ext
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal
