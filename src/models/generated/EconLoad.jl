#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the economical parameters of interruptible loads."""
mutable struct EconLoad <: PowerSystems.TechnicalParams
    curtailpenalty::Float64
    variablecost::Union{Nothing, Float64}
    internal::PowerSystems.PowerSystemInternal
end

function EconLoad(curtailpenalty, variablecost, )
    EconLoad(curtailpenalty, variablecost, PowerSystemInternal())
end

function EconLoad(; curtailpenalty, variablecost, )
    EconLoad(curtailpenalty, variablecost, )
end

# Constructor for demo purposes; non-functional.

function EconLoad(::Nothing)
    EconLoad(;
        curtailpenalty=0.0,
        variablecost=0.0,
    )
end

"""Get EconLoad curtailpenalty."""
get_curtailpenalty(value::EconLoad) = value.curtailpenalty
"""Get EconLoad variablecost."""
get_variablecost(value::EconLoad) = value.variablecost
"""Get EconLoad internal."""
get_internal(value::EconLoad) = value.internal
