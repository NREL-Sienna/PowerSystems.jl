#=
This file is auto-generated. Do not edit.
=#


mutable struct TapTransformer <: ACBranch
    name::String
    available::Bool
    activepower_flow::Float64
    reactivepower_flow::Float64
    arch::Arch
    r::Float64  # System per-unit value
    x::Float64  # System per-unit value
    primaryshunt::Float64  # System per-unit value
    tap::Float64
    rate::Union{Nothing, Float64}
    internal::PowerSystems.PowerSystemInternal
end

function TapTransformer(name, available, activepower_flow, reactivepower_flow, arch, r, x, primaryshunt, tap, rate, )
    TapTransformer(name, available, activepower_flow, reactivepower_flow, arch, r, x, primaryshunt, tap, rate, PowerSystemInternal())
end

function TapTransformer(; name, available, activepower_flow, reactivepower_flow, arch, r, x, primaryshunt, tap, rate, )
    TapTransformer(name, available, activepower_flow, reactivepower_flow, arch, r, x, primaryshunt, tap, rate, )
end

# Constructor for demo purposes; non-functional.

function TapTransformer(::Nothing)
    TapTransformer(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arch=Arch(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primaryshunt=0.0,
        tap=1.0,
        rate=0.0,
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
"""Get TapTransformer arch."""
get_arch(value::TapTransformer) = value.arch
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
"""Get TapTransformer internal."""
get_internal(value::TapTransformer) = value.internal
