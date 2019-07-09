#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the technical parameters of thermal generation technologies."""
mutable struct TechThermal <: PowerSystems.TechnicalParams
    rating::Float64  # Thermal limited MVA Power Output of the unit. &lt;= Capacity 
    activepower::Float64
    activepowerlimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactivepower::Float64
    reactivepowerlimits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    internal::PowerSystems.PowerSystemInternal
end

function TechThermal(rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, )
    TechThermal(rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, PowerSystemInternal())
end

function TechThermal(; rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, )
    TechThermal(rating, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits, )
end

# Constructor for demo purposes; non-functional.

function TechThermal(::Nothing)
    TechThermal(;
        rating=0.0,
        activepower=0.0,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepower=0.0,
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        timelimits=nothing,
    )
end

"""Get TechThermal rating."""
get_rating(value::TechThermal) = value.rating
"""Get TechThermal activepower."""
get_activepower(value::TechThermal) = value.activepower
"""Get TechThermal activepowerlimits."""
get_activepowerlimits(value::TechThermal) = value.activepowerlimits
"""Get TechThermal reactivepower."""
get_reactivepower(value::TechThermal) = value.reactivepower
"""Get TechThermal reactivepowerlimits."""
get_reactivepowerlimits(value::TechThermal) = value.reactivepowerlimits
"""Get TechThermal ramplimits."""
get_ramplimits(value::TechThermal) = value.ramplimits
"""Get TechThermal timelimits."""
get_timelimits(value::TechThermal) = value.timelimits
"""Get TechThermal internal."""
get_internal(value::TechThermal) = value.internal
