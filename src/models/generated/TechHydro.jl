#=
This file is auto-generated. Do not edit.
=#


mutable struct TechHydro <: TechnicalParams
    rating::Float64  # Thermal limited MVA Power Output of the unit. &lt;= Capacity 
    primemover::PrimeMovers  # PrimeMover Technology according to EIA 923
    activepowerlimits::Min_Max
    reactivepowerlimits::Union{Nothing, Min_Max}
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    internal::PowerSystemInternal
end

function TechHydro(rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, )
    TechHydro(rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, PowerSystemInternal())
end

function TechHydro(; rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, )
    TechHydro(rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, )
end

# Constructor for demo purposes; non-functional.

function TechHydro(::Nothing)
    TechHydro(;
        rating=0.0,
        primemover=HY::PrimeMovers,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        timelimits=nothing,
    )
end

"""Get TechHydro rating."""
get_rating(value::TechHydro) = value.rating
"""Get TechHydro primemover."""
get_primemover(value::TechHydro) = value.primemover
"""Get TechHydro activepowerlimits."""
get_activepowerlimits(value::TechHydro) = value.activepowerlimits
"""Get TechHydro reactivepowerlimits."""
get_reactivepowerlimits(value::TechHydro) = value.reactivepowerlimits
"""Get TechHydro ramplimits."""
get_ramplimits(value::TechHydro) = value.ramplimits
"""Get TechHydro timelimits."""
get_timelimits(value::TechHydro) = value.timelimits
"""Get TechHydro internal."""
get_internal(value::TechHydro) = value.internal
