#=
This file is auto-generated. Do not edit.
=#


mutable struct TechRenewable <: PowerSystems.TechnicalParams
    rating::Float64
    reactivepowerlimits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    powerfactor::Float64
    internal::PowerSystems.PowerSystemInternal
end

function TechRenewable(rating, reactivepowerlimits, powerfactor, )
    TechRenewable(rating, reactivepowerlimits, powerfactor, PowerSystemInternal())
end

function TechRenewable(; rating, reactivepowerlimits, powerfactor, )
    TechRenewable(rating, reactivepowerlimits, powerfactor, )
end

# Constructor for demo purposes; non-functional.

function TechRenewable(::Nothing)
    TechRenewable(;
        rating=0.0,
        reactivepowerlimits=nothing,
        powerfactor=1.0,
    )
end

"""Get TechRenewable rating."""
get_rating(value::TechRenewable) = value.rating
"""Get TechRenewable reactivepowerlimits."""
get_reactivepowerlimits(value::TechRenewable) = value.reactivepowerlimits
"""Get TechRenewable powerfactor."""
get_powerfactor(value::TechRenewable) = value.powerfactor
"""Get TechRenewable internal."""
get_internal(value::TechRenewable) = value.internal
