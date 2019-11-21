#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TechRenewable <: TechnicalParams
        rating::Float64
        primemover::PrimeMovers
        reactivepowerlimits::Union{Nothing, Min_Max}
        powerfactor::Float64
        ext::Union{Nothing, Dict{String, Any}}
        internal::InfrastructureSystemsInternal
    end

Data Structures for the technical parameters of renewable generation technologies.

# Arguments
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity
- `primemover::PrimeMovers`: PrimeMover Technology according to EIA 923
- `reactivepowerlimits::Union{Nothing, Min_Max}`
- `powerfactor::Float64`
- `ext::Union{Nothing, Dict{String, Any}}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TechRenewable <: TechnicalParams
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers
    reactivepowerlimits::Union{Nothing, Min_Max}
    powerfactor::Float64
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, ext=nothing, )
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, ext, InfrastructureSystemsInternal())
end

function TechRenewable(; rating, primemover, reactivepowerlimits, powerfactor, ext=nothing, )
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, ext, )
end


function TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, ; ext=nothing)
    
    TechRenewable(rating, primemover, reactivepowerlimits, powerfactor, ext, InfrastructureSystemsInternal())
end

# Constructor for demo purposes; non-functional.

function TechRenewable(::Nothing)
    TechRenewable(;
        rating=0.0,
        primemover=OT::PrimeMovers,
        reactivepowerlimits=nothing,
        powerfactor=1.0,
        ext=nothing,
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
"""Get TechRenewable ext."""
get_ext(value::TechRenewable) = value.ext
"""Get TechRenewable internal."""
get_internal(value::TechRenewable) = value.internal
