#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the procurement products for system simulations."""
mutable struct StaticReserve <: Reserve
    name::String
    contributingdevices::Vector{Device}  # devices from which the product can be procured
    timeframe::Float64  # the relative saturation timeframe
    requirement::Float64  # the required quantity of the product should be scaled by a Forecast
    _forecasts::InfrastructureSystems.Forecasts
    internal::InfrastructureSystemsInternal
end

function StaticReserve(name, contributingdevices, timeframe, requirement, _forecasts=InfrastructureSystems.Forecasts(), )
    StaticReserve(name, contributingdevices, timeframe, requirement, _forecasts, InfrastructureSystemsInternal())
end

function StaticReserve(; name, contributingdevices, timeframe, requirement, _forecasts=InfrastructureSystems.Forecasts(), )
    StaticReserve(name, contributingdevices, timeframe, requirement, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function StaticReserve(::Nothing)
    StaticReserve(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
        requirement=0.0,
        _forecasts=InfrastructureSystems.Forecasts(),
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
"""Get StaticReserve _forecasts."""
get__forecasts(value::StaticReserve) = value._forecasts
"""Get StaticReserve internal."""
get_internal(value::StaticReserve) = value.internal
