#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TechRenewable <: DeviceParameter
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        reactivepowerlimits::Union{Nothing, Min_Max}
        powerfactor::Float64
        internal::InfrastructureSystemsInternal
    end

Data Structures for the technical parameters of renewable generation technologies.

# Arguments
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `reactivepowerlimits::Union{Nothing, Min_Max}`
- `powerfactor::Float64`, validation range: (0, 1), action if invalid: error
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TechRenewable <: DeviceParameter
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    reactivepowerlimits::Union{Nothing, Min_Max}
    powerfactor::Float64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, )
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, InfrastructureSystemsInternal(), )
end

function TechRenewable(; rating, primemover, reactivepowerlimits, powerfactor, )
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, )
end

# Constructor for demo purposes; non-functional.
function TechRenewable(::Nothing)
    TechRenewable(;
        rating=0.0,
        primemover=PrimeMovers.OT,
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
