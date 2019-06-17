#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the economical parameters of renewable generation technologies."""
struct EconRenewable <: PowerSystems.TechnicalParams
    curtailpenalty::Float64
    variablecost::Union{Nothing, Float64}
    internal::PowerSystems.PowerSystemInternal
end

function EconRenewable(curtailpenalty, variablecost, )
    EconRenewable(curtailpenalty, variablecost, PowerSystemInternal())
end

function EconRenewable(; curtailpenalty, variablecost, )
    EconRenewable(curtailpenalty, variablecost, )
end

# Constructor for demo purposes; non-functional.

function EconRenewable(::Nothing)
    EconRenewable(;
        curtailpenalty=0.0,
        variablecost=0.0,
    )
end

"""Get EconRenewable curtailpenalty."""
get_curtailpenalty(value::EconRenewable) = value.curtailpenalty
"""Get EconRenewable variablecost."""
get_variablecost(value::EconRenewable) = value.variablecost
"""Get EconRenewable internal."""
get_internal(value::EconRenewable) = value.internal
