#=
This file is auto-generated. Do not edit.
=#


mutable struct PhaseShiftingTransformer <: ACBranch
    name::String
    available::Bool
    arch::Arch
    r::Float64
    x::Float64
    primaryshunt::Float64
    tap::Float64
    α::Float64
    rate::Float64
    internal::PowerSystems.PowerSystemInternal
end

function PhaseShiftingTransformer(name, available, arch, r, x, primaryshunt, tap, α, rate, )
    PhaseShiftingTransformer(name, available, arch, r, x, primaryshunt, tap, α, rate, PowerSystemInternal())
end

function PhaseShiftingTransformer(; name, available, arch, r, x, primaryshunt, tap, α, rate, )
    PhaseShiftingTransformer(name, available, arch, r, x, primaryshunt, tap, α, rate, )
end

# Constructor for demo purposes; non-functional.

function PhaseShiftingTransformer(::Nothing)
    PhaseShiftingTransformer(;
        name="init",
        available=false,
        arch=Arch(Bus(nothing), Bus(nothing)),
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
"""Get PhaseShiftingTransformer arch."""
get_arch(value::PhaseShiftingTransformer) = value.arch
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
