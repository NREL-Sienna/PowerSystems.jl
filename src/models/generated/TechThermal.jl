#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the technical parameters of thermal generation technologies."""
mutable struct TechThermal <: TechnicalParams
    rating::Float64  # Thermal limited MVA Power Output of the unit. &lt;= Capacity 
    primemover::PrimeMovers  # PrimeMover Technology according to EIA 923
    fuel::ThermalFuels  # PrimeMover Fuel according to EIA 923
    activepowerlimits::Min_Max
    reactivepowerlimits::Union{Nothing, Min_Max}
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    internal::PowerSystemInternal
end

function TechThermal(rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, )
    TechThermal(rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, PowerSystemInternal())
end

function TechThermal(; rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, )
    TechThermal(rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, )
end

# Constructor for demo purposes; non-functional.

function TechThermal(::Nothing)
    TechThermal(;
        rating=0.0,
        primemover=OT::PrimeMovers,
        fuel=OTHER::ThermalFuels,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        timelimits=nothing,
    )
end

"""Get TechThermal rating."""
get_rating(value::TechThermal) = value.rating
"""Get TechThermal primemover."""
get_primemover(value::TechThermal) = value.primemover
"""Get TechThermal fuel."""
get_fuel(value::TechThermal) = value.fuel
"""Get TechThermal activepowerlimits."""
get_activepowerlimits(value::TechThermal) = value.activepowerlimits
"""Get TechThermal reactivepowerlimits."""
get_reactivepowerlimits(value::TechThermal) = value.reactivepowerlimits
"""Get TechThermal ramplimits."""
get_ramplimits(value::TechThermal) = value.ramplimits
"""Get TechThermal timelimits."""
get_timelimits(value::TechThermal) = value.timelimits
"""Get TechThermal internal."""
get_internal(value::TechThermal) = value.internal
