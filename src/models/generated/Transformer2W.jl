#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Transformer2W <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primary_shunt::Float64
        rate::Union{Nothing, Float64}
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

The 2-W transformer model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer. The model allocates the iron losses and magnetizing susceptance to the primary side.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `reactive_power_flow::Float64`
- `arc::Arc`
- `r::Float64`: System per-unit value, validation range: (-2, 4), action if invalid: error
- `x::Float64`: System per-unit value, validation range: (-2, 4), action if invalid: error
- `primary_shunt::Float64`: System per-unit value, validation range: (0, 2), action if invalid: error
- `rate::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Transformer2W <: ACBranch
    name::String
    available::Bool
    active_power_flow::Float64
    reactive_power_flow::Float64
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    "System per-unit value"
    primary_shunt::Float64
    rate::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function Transformer2W(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function Transformer2W(::Nothing)
    Transformer2W(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primary_shunt=0.0,
        rate=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Transformer2W) = value.name
"""Get Transformer2W available."""
get_available(value::Transformer2W) = value.available
"""Get Transformer2W active_power_flow."""
get_active_power_flow(value::Transformer2W) = get_value(value, :active_power_flow)
"""Get Transformer2W reactive_power_flow."""
get_reactive_power_flow(value::Transformer2W) = get_value(value, :reactive_power_flow)
"""Get Transformer2W arc."""
get_arc(value::Transformer2W) = value.arc
"""Get Transformer2W r."""
get_r(value::Transformer2W) = value.r
"""Get Transformer2W x."""
get_x(value::Transformer2W) = value.x
"""Get Transformer2W primary_shunt."""
get_primary_shunt(value::Transformer2W) = value.primary_shunt
"""Get Transformer2W rate."""
get_rate(value::Transformer2W) = get_value(value, :rate)
"""Get Transformer2W services."""
get_services(value::Transformer2W) = value.services
"""Get Transformer2W ext."""
get_ext(value::Transformer2W) = value.ext

InfrastructureSystems.get_forecasts(value::Transformer2W) = value.forecasts
"""Get Transformer2W internal."""
get_internal(value::Transformer2W) = value.internal


InfrastructureSystems.set_name!(value::Transformer2W, val::String) = value.name = val
"""Set Transformer2W available."""
set_available!(value::Transformer2W, val::Bool) = value.available = val
"""Set Transformer2W active_power_flow."""
set_active_power_flow!(value::Transformer2W, val::Float64) = value.active_power_flow = val
"""Set Transformer2W reactive_power_flow."""
set_reactive_power_flow!(value::Transformer2W, val::Float64) = value.reactive_power_flow = val
"""Set Transformer2W arc."""
set_arc!(value::Transformer2W, val::Arc) = value.arc = val
"""Set Transformer2W r."""
set_r!(value::Transformer2W, val::Float64) = value.r = val
"""Set Transformer2W x."""
set_x!(value::Transformer2W, val::Float64) = value.x = val
"""Set Transformer2W primary_shunt."""
set_primary_shunt!(value::Transformer2W, val::Float64) = value.primary_shunt = val
"""Set Transformer2W rate."""
set_rate!(value::Transformer2W, val::Union{Nothing, Float64}) = value.rate = val
"""Set Transformer2W services."""
set_services!(value::Transformer2W, val::Vector{Service}) = value.services = val
"""Set Transformer2W ext."""
set_ext!(value::Transformer2W, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::Transformer2W, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set Transformer2W internal."""
set_internal!(value::Transformer2W, val::InfrastructureSystemsInternal) = value.internal = val
