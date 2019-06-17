#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the procurement products for system simulations."""
mutable struct StaticReserve <: Reserve
    name::String
    contributingdevices::Vector{Device}  # devices from which the product can be procured
    timeframe::Float64  # the relative saturation timeframe
    requirement::Float64  # the required quantity of the product should be scaled by a Forecast
    internal::PowerSystems.PowerSystemInternal
end

function StaticReserve(name, contributingdevices, timeframe, requirement, )
    StaticReserve(name, contributingdevices, timeframe, requirement, PowerSystemInternal())
end

function StaticReserve(; name, contributingdevices, timeframe, requirement, )
    StaticReserve(name, contributingdevices, timeframe, requirement, )
end

# Constructor for demo purposes; non-functional.

function StaticReserve(::Nothing)
    StaticReserve(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
        requirement=0.0,
    )
end

"""Get StaticReserve name."""
get_name(value::StaticReserve) = value.name
"""Get StaticReserve contributingdevices."""
get_contributingdevices(value::StaticReserve) = value.contributingdevices
"""Get StaticReserve timeframe."""
get_timeframe(value::StaticReserve) = value.timeframe
"""Get StaticReserve requirement."""
get_requirement(value::StaticReserve) = value.requirement
"""Get StaticReserve internal."""
get_internal(value::StaticReserve) = value.internal
