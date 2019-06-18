#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for a proportional reserve product for system simulations."""
mutable struct ProportionalReserve <: Reserve
    name::String
    contributingdevices::Vector{Device}  # devices from which the product can be procured
    timeframe::Float64  # the relative saturation timeframe
    internal::PowerSystems.PowerSystemInternal
end

function ProportionalReserve(name, contributingdevices, timeframe, )
    ProportionalReserve(name, contributingdevices, timeframe, PowerSystemInternal())
end

function ProportionalReserve(; name, contributingdevices, timeframe, )
    ProportionalReserve(name, contributingdevices, timeframe, )
end

# Constructor for demo purposes; non-functional.

function ProportionalReserve(::Nothing)
    ProportionalReserve(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
    )
end

"""Get ProportionalReserve name."""
get_name(value::ProportionalReserve) = value.name
"""Get ProportionalReserve contributingdevices."""
get_contributingdevices(value::ProportionalReserve) = value.contributingdevices
"""Get ProportionalReserve timeframe."""
get_timeframe(value::ProportionalReserve) = value.timeframe
"""Get ProportionalReserve internal."""
get_internal(value::ProportionalReserve) = value.internal
