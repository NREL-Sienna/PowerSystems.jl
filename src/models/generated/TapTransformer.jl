#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TapTransformer <: ACBranch
        name::String
        available::Bool
        activepower_flow::Float64
        reactivepower_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primaryshunt::Float64
        tap::Float64
        rate::Union{Nothing, Float64}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
-`name::String`
-`available::Bool`
-`activepower_flow::Float64`
-`reactivepower_flow::Float64`
-`arc::Arc`
-`r::Float64`: System per-unit value
-`x::Float64`: System per-unit value
-`primaryshunt::Float64`: System per-unit value
-`tap::Float64`
-`rate::Union{Nothing, Float64}`
-`_forecasts::InfrastructureSystems.Forecasts`
-`internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TapTransformer <: ACBranch
    name::String
    available::Bool
    activepower_flow::Float64
    reactivepower_flow::Float64
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    "System per-unit value"
    primaryshunt::Float64
    tap::Float64
    rate::Union{Nothing, Float64}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TapTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, _forecasts=InfrastructureSystems.Forecasts(), )
    TapTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, _forecasts, InfrastructureSystemsInternal())
end

function TapTransformer(; name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, _forecasts=InfrastructureSystems.Forecasts(), )
    TapTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function TapTransformer(::Nothing)
    TapTransformer(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primaryshunt=0.0,
        tap=1.0,
        rate=0.0,
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get TapTransformer name."""
get_name(value::TapTransformer) = value.name
"""Get TapTransformer available."""
get_available(value::TapTransformer) = value.available
"""Get TapTransformer activepower_flow."""
get_activepower_flow(value::TapTransformer) = value.activepower_flow
"""Get TapTransformer reactivepower_flow."""
get_reactivepower_flow(value::TapTransformer) = value.reactivepower_flow
"""Get TapTransformer arc."""
get_arc(value::TapTransformer) = value.arc
"""Get TapTransformer r."""
get_r(value::TapTransformer) = value.r
"""Get TapTransformer x."""
get_x(value::TapTransformer) = value.x
"""Get TapTransformer primaryshunt."""
get_primaryshunt(value::TapTransformer) = value.primaryshunt
"""Get TapTransformer tap."""
get_tap(value::TapTransformer) = value.tap
"""Get TapTransformer rate."""
get_rate(value::TapTransformer) = value.rate
"""Get TapTransformer _forecasts."""
get__forecasts(value::TapTransformer) = value._forecasts
"""Get TapTransformer internal."""
get_internal(value::TapTransformer) = value.internal
