#=
This file is auto-generated. Do not edit.
=#


mutable struct TechHydro <: PowerSystems.TechnicalParams
    rating::Float64  # Thermal limited MVA Power Output of the unit. &lt;= Capacity 
    activepower::Float64
    activepowerlimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactivepower::Float64
    reactivepowerlimits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    internal::PowerSystems.PowerSystemInternal
end

function TechHydro(rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, )
    TechHydro(rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, PowerSystemInternal())
end

function TechHydro(; rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, )
    TechHydro(rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, )
end

# Constructor for demo purposes; non-functional.

function TechHydro(::Nothing)
    TechHydro(;
        rating=0.0,
        activepower=0.0,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepower=0.0,
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        timelimits=nothing,
    )
end

"""Get TechHydro rating."""
get_rating(value::TechHydro) = value.rating
"""Get TechHydro activepower."""
get_activepower(value::TechHydro) = value.activepower
"""Get TechHydro activepowerlimits."""
get_activepowerlimits(value::TechHydro) = value.activepowerlimits
"""Get TechHydro reactivepower."""
get_reactivepower(value::TechHydro) = value.reactivepower
"""Get TechHydro reactivepowerlimits."""
get_reactivepowerlimits(value::TechHydro) = value.reactivepowerlimits
"""Get TechHydro ramplimits."""
get_ramplimits(value::TechHydro) = value.ramplimits
"""Get TechHydro timelimits."""
get_timelimits(value::TechHydro) = value.timelimits
"""Get TechHydro internal."""
get_internal(value::TechHydro) = value.internal
