#=
This file is auto-generated. Do not edit.
=#


mutable struct Transfer <: Service
    name::String
    contributingdevices::Vector{Device}
    timeframe::Float64
    requirement::TimeSeries.TimeArray
    internal::PowerSystems.PowerSystemInternal
end

function Transfer(name, contributingdevices, timeframe, requirement, )
    Transfer(name, contributingdevices, timeframe, requirement, PowerSystemInternal())
end

function Transfer(; name, contributingdevices, timeframe, requirement, )
    Transfer(name, contributingdevices, timeframe, requirement, )
end

# Constructor for demo purposes; non-functional.

function Transfer(::Nothing)
    Transfer(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
        requirement=[],
    )
end

"""Get Transfer name."""
get_name(value::Transfer) = value.name
"""Get Transfer contributingdevices."""
get_contributingdevices(value::Transfer) = value.contributingdevices
"""Get Transfer timeframe."""
get_timeframe(value::Transfer) = value.timeframe
"""Get Transfer requirement."""
get_requirement(value::Transfer) = value.requirement
"""Get Transfer internal."""
get_internal(value::Transfer) = value.internal
