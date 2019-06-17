#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for the economical parameters of thermal generation technologies."""
struct EconThermal <: PowerSystems.TechnicalParams
    capacity::Float64
    variablecost::Union{Tuple{Float64, Float64}, Array{Tuple{Float64, Float64}, N} where N}
    fixedcost::Float64
    startupcost::Float64
    shutdncost::Float64
    annualcapacityfactor::Union{Nothing, Float64}
    internal::PowerSystems.PowerSystemInternal
end

function EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor, )
    EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor, PowerSystemInternal())
end

function EconThermal(; capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor, )
    EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor, )
end

# Constructor for demo purposes; non-functional.

function EconThermal(::Nothing)
    EconThermal(;
        capacity=0.0,
        variablecost=[(0.0, 1.0)],
        fixedcost=0.0,
        startupcost=0.0,
        shutdncost=0.0,
        annualcapacityfactor=nothing,
    )
end

"""Get EconThermal capacity."""
get_capacity(value::EconThermal) = value.capacity
"""Get EconThermal variablecost."""
get_variablecost(value::EconThermal) = value.variablecost
"""Get EconThermal fixedcost."""
get_fixedcost(value::EconThermal) = value.fixedcost
"""Get EconThermal startupcost."""
get_startupcost(value::EconThermal) = value.startupcost
"""Get EconThermal shutdncost."""
get_shutdncost(value::EconThermal) = value.shutdncost
"""Get EconThermal annualcapacityfactor."""
get_annualcapacityfactor(value::EconThermal) = value.annualcapacityfactor
"""Get EconThermal internal."""
get_internal(value::EconThermal) = value.internal
