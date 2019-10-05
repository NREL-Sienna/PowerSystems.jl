#=
This file is auto-generated. Do not edit.
=#

"""The 2-W transformer model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer. The model allocates the iron losses and magnetizing susceptance to the primary side."""
mutable struct Transformer2W <: ACBranch
    name::String
    available::Bool
    activepower_flow::Float64
    reactivepower_flow::Float64
    arc::Arc
    r::Float64  # System per-unit value
    x::Float64  # System per-unit value
    primaryshunt::Float64  # System per-unit value
    rate::Union{Nothing, Float64}
    _forecasts::InfrastructureSystems.Forecasts
    internal::InfrastructureSystemsInternal
end

function Transformer2W(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, rate, _forecasts=InfrastructureSystems.Forecasts(), )
    Transformer2W(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, rate, _forecasts, InfrastructureSystemsInternal())
end

function Transformer2W(; name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, rate, _forecasts=InfrastructureSystems.Forecasts(), )
    Transformer2W(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, rate, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function Transformer2W(::Nothing)
    Transformer2W(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primaryshunt=0.0,
        rate=nothing,
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get Transformer2W name."""
get_name(value::Transformer2W) = value.name
"""Get Transformer2W available."""
get_available(value::Transformer2W) = value.available
"""Get Transformer2W activepower_flow."""
get_activepower_flow(value::Transformer2W) = value.activepower_flow
"""Get Transformer2W reactivepower_flow."""
get_reactivepower_flow(value::Transformer2W) = value.reactivepower_flow
"""Get Transformer2W arc."""
get_arc(value::Transformer2W) = value.arc
"""Get Transformer2W r."""
get_r(value::Transformer2W) = value.r
"""Get Transformer2W x."""
get_x(value::Transformer2W) = value.x
"""Get Transformer2W primaryshunt."""
get_primaryshunt(value::Transformer2W) = value.primaryshunt
"""Get Transformer2W rate."""
get_rate(value::Transformer2W) = value.rate
"""Get Transformer2W _forecasts."""
get__forecasts(value::Transformer2W) = value._forecasts
"""Get Transformer2W internal."""
get_internal(value::Transformer2W) = value.internal
