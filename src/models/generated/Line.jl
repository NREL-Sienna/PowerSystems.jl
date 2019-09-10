#=
This file is auto-generated. Do not edit.
=#


mutable struct Line <: ACBranch
    name::String
    available::Bool
    activepower_flow::Float64
    reactivepower_flow::Float64
    arc::Arc
    r::Float64  # System per-unit value
    x::Float64  # System per-unit value
    b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}  # System per-unit value
    rate::Float64
    anglelimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    internal::PowerSystemInternal
end

function Line(name, available, activepower_flow, reactivepower_flow, arc, r, x, b, rate, anglelimits, )
    Line(name, available, activepower_flow, reactivepower_flow, arc, r, x, b, rate, anglelimits, PowerSystemInternal())
end

function Line(; name, available, activepower_flow, reactivepower_flow, arc, r, x, b, rate, anglelimits, )
    Line(name, available, activepower_flow, reactivepower_flow, arc, r, x, b, rate, anglelimits, )
end

# Constructor for demo purposes; non-functional.

function Line(::Nothing)
    Line(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        rate=0.0,
        anglelimits=(min=-1.571, max=1.571),
    )
end

"""Get Line name."""
get_name(value::Line) = value.name
"""Get Line available."""
get_available(value::Line) = value.available
"""Get Line activepower_flow."""
get_activepower_flow(value::Line) = value.activepower_flow
"""Get Line reactivepower_flow."""
get_reactivepower_flow(value::Line) = value.reactivepower_flow
"""Get Line arc."""
get_arc(value::Line) = value.arc
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
