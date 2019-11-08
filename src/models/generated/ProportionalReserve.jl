#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ProportionalReserve <: Reserve
        name::String
        contributingdevices::Vector{Device}
        timeframe::Float64
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
-`name::String`
-`contributingdevices::Vector{Device}`: devices from which the product can be procured
-`timeframe::Float64`: the relative saturation timeframe
-`_forecasts::InfrastructureSystems.Forecasts`
-`internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ProportionalReserve <: Reserve
    name::String
    "devices from which the product can be procured"
    contributingdevices::Vector{Device}
    "the relative saturation timeframe"
    timeframe::Float64
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ProportionalReserve(name, contributingdevices, timeframe, _forecasts=InfrastructureSystems.Forecasts(), )
    ProportionalReserve(name, contributingdevices, timeframe, _forecasts, InfrastructureSystemsInternal())
end

function ProportionalReserve(; name, contributingdevices, timeframe, _forecasts=InfrastructureSystems.Forecasts(), )
    ProportionalReserve(name, contributingdevices, timeframe, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function ProportionalReserve(::Nothing)
    ProportionalReserve(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get ProportionalReserve name."""
get_name(value::ProportionalReserve) = value.name
"""Get ProportionalReserve contributingdevices."""
get_contributingdevices(value::ProportionalReserve) = value.contributingdevices
"""Get ProportionalReserve timeframe."""
get_timeframe(value::ProportionalReserve) = value.timeframe
"""Get ProportionalReserve _forecasts."""
get__forecasts(value::ProportionalReserve) = value._forecasts
"""Get ProportionalReserve internal."""
get_internal(value::ProportionalReserve) = value.internal
