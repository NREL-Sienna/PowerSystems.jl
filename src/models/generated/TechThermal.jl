#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TechThermal <: DeviceParameter
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        fuel::ThermalFuels.ThermalFuel
        activepowerlimits::Min_Max
        reactivepowerlimits::Union{Nothing, Min_Max}
        ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        participation_factor::Float64
        internal::InfrastructureSystemsInternal
    end

Data Structure for the technical parameters of thermal generation technologies.

# Arguments
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `fuel::ThermalFuels.ThermalFuel`: PrimeMover Fuel according to EIA 923
- `activepowerlimits::Min_Max`
- `reactivepowerlimits::Union{Nothing, Min_Max}`
- `ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`, validation range: (0, nothing), action if invalid: error
- `timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`, validation range: (0, nothing), action if invalid: error
- `participation_factor::Float64`: AGC Participation Factor, validation range: (0, 1.0), action if invalid: error
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TechThermal <: DeviceParameter
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    "PrimeMover Fuel according to EIA 923"
    fuel::ThermalFuels.ThermalFuel
    activepowerlimits::Min_Max
    reactivepowerlimits::Union{Nothing, Min_Max}
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "AGC Participation Factor"
    participation_factor::Float64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TechThermal(rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, participation_factor=0.0, )
    TechThermal(rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, participation_factor, InfrastructureSystemsInternal(), )
end

function TechThermal(; rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, participation_factor=0.0, )
    TechThermal(rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, participation_factor, )
end

# Constructor for demo purposes; non-functional.
function TechThermal(::Nothing)
    TechThermal(;
        rating=0.0,
        primemover=PrimeMovers.OT,
        fuel=ThermalFuels.OTHER,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        timelimits=nothing,
        participation_factor=0.0,
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
"""Get TechThermal participation_factor."""
get_participation_factor(value::TechThermal) = value.participation_factor
"""Get TechThermal internal."""
get_internal(value::TechThermal) = value.internal
