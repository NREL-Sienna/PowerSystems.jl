#=
This file is auto-generated. Do not edit.
=#


mutable struct TechRenewable <: TechnicalParams
    rating::Float64  # Thermal limited MVA Power Output of the unit. &lt;= Capacity
    primemover::PrimeMovers  # PrimeMover Technology according to EIA 923
    reactivepowerlimits::Union{Nothing, Min_Max}
    powerfactor::Float64
    internal::PowerSystemInternal
end

function TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, )
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, PowerSystemInternal())
end

function TechRenewable(; rating, primemover, reactivepowerlimits, powerfactor, )
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, )
end

# Constructor for demo purposes; non-functional.

function TechRenewable(::Nothing)
    TechRenewable(;
        rating=0.0,
        primemover=OT::PrimeMovers,
        reactivepowerlimits=nothing,
        powerfactor=1.0,
    )
end

"""Get TechRenewable rating."""
get_rating(value::TechRenewable) = value.rating
"""Get TechRenewable primemover."""
get_primemover(value::TechRenewable) = value.primemover
"""Get TechRenewable reactivepowerlimits."""
get_reactivepowerlimits(value::TechRenewable) = value.reactivepowerlimits
"""Get TechRenewable powerfactor."""
get_powerfactor(value::TechRenewable) = value.powerfactor
"""Get TechRenewable internal."""
get_internal(value::TechRenewable) = value.internal
