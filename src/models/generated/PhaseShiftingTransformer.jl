#=
This file is auto-generated. Do not edit.
=#


mutable struct PhaseShiftingTransformer <: ACBranch
    name::String
    available::Bool
    activepower_flow::Float64
    reactivepower_flow::Float64
    arc::Arc
    r::Float64  # System per-unit value
    x::Float64  # System per-unit value
    primaryshunt::Float64
    tap::Float64
    α::Float64
    rate::Union{Nothing, Float64}
    internal::InfrastructureSystemsInternal
end

function PhaseShiftingTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, α, rate, )
    PhaseShiftingTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, α, rate, InfrastructureSystemsInternal())
end

function PhaseShiftingTransformer(; name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, α, rate, )
    PhaseShiftingTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, α, rate, )
end

# Constructor for demo purposes; non-functional.

function PhaseShiftingTransformer(::Nothing)
    PhaseShiftingTransformer(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primaryshunt=0.0,
        tap=1.0,
        α=0.0,
        rate=0.0,
    )
end

"""Get PhaseShiftingTransformer name."""
get_name(value::PhaseShiftingTransformer) = value.name
"""Get PhaseShiftingTransformer available."""
get_available(value::PhaseShiftingTransformer) = value.available
"""Get PhaseShiftingTransformer activepower_flow."""
get_activepower_flow(value::PhaseShiftingTransformer) = value.activepower_flow
"""Get PhaseShiftingTransformer reactivepower_flow."""
get_reactivepower_flow(value::PhaseShiftingTransformer) = value.reactivepower_flow
"""Get PhaseShiftingTransformer arc."""
get_arc(value::PhaseShiftingTransformer) = value.arc
"""Get PhaseShiftingTransformer r."""
get_r(value::PhaseShiftingTransformer) = value.r
"""Get PhaseShiftingTransformer x."""
get_x(value::PhaseShiftingTransformer) = value.x
"""Get PhaseShiftingTransformer primaryshunt."""
get_primaryshunt(value::PhaseShiftingTransformer) = value.primaryshunt
"""Get PhaseShiftingTransformer tap."""
get_tap(value::PhaseShiftingTransformer) = value.tap
"""Get PhaseShiftingTransformer α."""
get_α(value::PhaseShiftingTransformer) = value.α
"""Get PhaseShiftingTransformer rate."""
get_rate(value::PhaseShiftingTransformer) = value.rate
"""Get PhaseShiftingTransformer internal."""
get_internal(value::PhaseShiftingTransformer) = value.internal
