#=
This file is auto-generated. Do not edit.
=#


mutable struct EconHydro <: PowerSystems.TechnicalParams
    curtailpenalty::Float64
    variablecost::Union{Nothing, Float64}
    internal::PowerSystems.PowerSystemInternal
end

function EconHydro(curtailpenalty, variablecost, )
    EconHydro(curtailpenalty, variablecost, PowerSystemInternal())
end

function EconHydro(; curtailpenalty, variablecost, )
    EconHydro(curtailpenalty, variablecost, )
end

# Constructor for demo purposes; non-functional.

function EconHydro(::Nothing)
    EconHydro(;
        curtailpenalty=0.0,
        variablecost=0.0,
    )
end

"""Get EconHydro curtailpenalty."""
get_curtailpenalty(value::EconHydro) = value.curtailpenalty
"""Get EconHydro variablecost."""
get_variablecost(value::EconHydro) = value.variablecost
"""Get EconHydro internal."""
get_internal(value::EconHydro) = value.internal
