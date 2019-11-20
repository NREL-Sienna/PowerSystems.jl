#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct StaticReserve <: Reserve
        name::String
        contributingdevices::Vector{&lt;:Device}
        timeframe::Float64
        requirement::Float64
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`
- `contributingdevices::Vector{&lt;:Device}`: devices from which the product can be procured
- `timeframe::Float64`: the relative saturation timeframe
- `requirement::Float64`: the required quantity of the product should be scaled by a Forecast
- `_forecasts::InfrastructureSystems.Forecasts`: component forecasts
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserve <: Reserve
    name::String
    "devices from which the product can be procured"
    contributingdevices::Vector{&lt;:Device}
    "the relative saturation timeframe"
    timeframe::Float64
    "the required quantity of the product should be scaled by a Forecast"
    requirement::Float64
    "component forecasts"
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
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
