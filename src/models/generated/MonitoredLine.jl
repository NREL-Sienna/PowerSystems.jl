#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct MonitoredLine <: ACBranch
        name::String
        available::Bool
        activepower_flow::Float64
        reactivepower_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}
        flowlimits::NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}
        rate::Float64
        anglelimits::Min_Max
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `activepower_flow::Float64`
- `reactivepower_flow::Float64`
- `arc::Arc`
- `r::Float64`: System per-unit value
- `x::Float64`: System per-unit value
- `b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}`: System per-unit value
- `flowlimits::NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}`: TODO: throw warning above max SIL
- `rate::Float64`: TODO: compare to SIL (warn) (theoretical limit)
- `anglelimits::Min_Max`
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct MonitoredLine <: ACBranch
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
    b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}
    "TODO: throw warning above max SIL"
    flowlimits::NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}
    "TODO: compare to SIL (warn) (theoretical limit)"
    rate::Float64
    anglelimits::Min_Max
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function MonitoredLine(name, available, activepower_flow, reactivepower_flow, arc, r, x, b, flowlimits, rate, anglelimits, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    MonitoredLine(name, available, activepower_flow, reactivepower_flow, arc, r, x, b, flowlimits, rate, anglelimits, ext, _forecasts, InfrastructureSystemsInternal())
end

function MonitoredLine(; name, available, activepower_flow, reactivepower_flow, arc, r, x, b, flowlimits, rate, anglelimits, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    MonitoredLine(name, available, activepower_flow, reactivepower_flow, arc, r, x, b, flowlimits, rate, anglelimits, ext, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function MonitoredLine(::Nothing)
    MonitoredLine(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        flowlimits=(from_to=0.0, to_from=0.0),
        rate=0.0,
        anglelimits=(min=-1.571, max=1.571),
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get MonitoredLine name."""
get_name(value::MonitoredLine) = value.name
"""Get MonitoredLine available."""
get_available(value::MonitoredLine) = value.available
"""Get MonitoredLine activepower_flow."""
get_activepower_flow(value::MonitoredLine) = value.activepower_flow
"""Get MonitoredLine reactivepower_flow."""
get_reactivepower_flow(value::MonitoredLine) = value.reactivepower_flow
"""Get MonitoredLine arc."""
get_arc(value::MonitoredLine) = value.arc
"""Get MonitoredLine r."""
get_r(value::MonitoredLine) = value.r
"""Get MonitoredLine x."""
get_x(value::MonitoredLine) = value.x
"""Get MonitoredLine b."""
get_b(value::MonitoredLine) = value.b
"""Get MonitoredLine flowlimits."""
get_flowlimits(value::MonitoredLine) = value.flowlimits
"""Get MonitoredLine rate."""
get_rate(value::MonitoredLine) = value.rate
"""Get MonitoredLine anglelimits."""
get_anglelimits(value::MonitoredLine) = value.anglelimits
"""Get MonitoredLine ext."""
get_ext(value::MonitoredLine) = value.ext
"""Get MonitoredLine _forecasts."""
get__forecasts(value::MonitoredLine) = value._forecasts
"""Get MonitoredLine internal."""
get_internal(value::MonitoredLine) = value.internal
