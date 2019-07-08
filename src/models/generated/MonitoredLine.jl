#=
This file is auto-generated. Do not edit.
=#


mutable struct MonitoredLine <: ACBranch
    name::String
    available::Bool
    arch::Arch
    r::Float64
    x::Float64
    b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}
    flowlimits::NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}
    rate::Float64
    anglelimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    internal::PowerSystems.PowerSystemInternal
end

function MonitoredLine(name, available, arch, r, x, b, flowlimits, rate, anglelimits, )
    MonitoredLine(name, available, arch, r, x, b, flowlimits, rate, anglelimits, PowerSystemInternal())
end

function MonitoredLine(; name, available, arch, r, x, b, flowlimits, rate, anglelimits, )
    MonitoredLine(name, available, arch, r, x, b, flowlimits, rate, anglelimits, )
end

# Constructor for demo purposes; non-functional.

function MonitoredLine(::Nothing)
    MonitoredLine(;
        name="init",
        available=false,
        arch=Arch(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        flowlimits=(from_to=0.0, to_from=0.0),
        rate=0.0,
        anglelimits=(min=-90.0, max=-90.0),
    )
end

"""Get MonitoredLine name."""
get_name(value::MonitoredLine) = value.name
"""Get MonitoredLine available."""
get_available(value::MonitoredLine) = value.available
"""Get MonitoredLine arch."""
get_arch(value::MonitoredLine) = value.arch
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
"""Get MonitoredLine internal."""
get_internal(value::MonitoredLine) = value.internal
