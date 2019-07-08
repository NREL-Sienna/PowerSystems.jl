#=
This file is auto-generated. Do not edit.
=#


mutable struct Line <: ACBranch
    name::String
    available::Bool
    arch::Arch
    r::Float64
    x::Float64
    b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}
    rate::Float64
    anglelimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    internal::PowerSystems.PowerSystemInternal
end

function Line(name, available, arch, r, x, b, rate, anglelimits, )
    Line(name, available, arch, r, x, b, rate, anglelimits, PowerSystemInternal())
end

function Line(; name, available, arch, r, x, b, rate, anglelimits, )
    Line(name, available, arch, r, x, b, rate, anglelimits, )
end

# Constructor for demo purposes; non-functional.

function Line(::Nothing)
    Line(;
        name="init",
        available=false,
        arch=Arch(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        rate=0.0,
        anglelimits=(min=-90.0, max=-90.0),
    )
end

"""Get Line name."""
get_name(value::Line) = value.name
"""Get Line available."""
get_available(value::Line) = value.available
"""Get Line arch."""
get_arch(value::Line) = value.arch
"""Get Line r."""
get_r(value::Line) = value.r
"""Get Line x."""
get_x(value::Line) = value.x
"""Get Line b."""
get_b(value::Line) = value.b
"""Get Line rate."""
get_rate(value::Line) = value.rate
"""Get Line anglelimits."""
get_anglelimits(value::Line) = value.anglelimits
"""Get Line internal."""
get_internal(value::Line) = value.internal
