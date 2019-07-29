"""Accepts rating as a Float64 and then creates a TechRenewable."""
function TwoPartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return TwoPartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function ThreePartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return ThreePartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableFix(name, available, bus, rating::Float64)
    tech = TechRenewable(rating, nothing, 1.0)
    RenewableFix(name, available, bus, tech)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableDispatch(name::String, available::Bool, bus::Bus, rating::Float64,
                           op_cost::TwoPartCost)
    tech = TechRenewable(rating, 0.0, nothing, 1.0)
    return RenewableDispatch(name, available, bus, tech, op_cost)
end

"""Accepts curtailment cost as a Float64 and then creates an EconHydro."""
function HydroDispatch(name::AbstractString, available::Bool, bus::Bus, tech::TechHydro,
                       curtailcost::Float64)
    op_cost = TwoPartCost(0.0, curtailcost)
    return HydroDispatch(name, available, bus, tech, op_cost)
end

"""Constructs Deterministic from a Component, label, and TimeArray."""
function Deterministic(component::Component, label::String, data::TimeSeries.TimeArray)
    resolution = getresolution(data)
    initial_time = TimeSeries.timestamp(data)[1]
    Deterministic(component, label, Dates.Minute(resolution), initial_time, data)
end

"""Constructs Deterministic after constructing a TimeArray from initial_time and time_steps.
"""
function Deterministic(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       time_steps::Int)
    data = TimeSeries.TimeArray(
        initial_time : Dates.Hour(1) : initial_time + resolution * (time_steps-1),
        ones(time_steps)
    )
    return Deterministic(component, label, Dates.Minute(resolution), initial_time, data)
end

"""Constructs Deterministic after constructing a TimeArray from initial_time and time_steps.
"""
function Probabilistic(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       quantiles::Vector{Float64},
                       time_steps::Int)

    data = TimeSeries.TimeArray(
        initial_time : Dates.Hour(1) : initial_time + resolution * (time_steps-1),
        ones(time_steps, length(quantiles))
    )

    return Probabilistic(component, label, Dates.Minute(resolution), initial_time, quantiles, data)
end

"""Constructs Probabilistic Forecast after constructing a TimeArray from initial_time and time_steps.
"""
function Probabilistic(component::Component,
                       label::String,
                       quantiles::Vector{Float64},  # Quantiles for the probabilistic forecast
                       data::TimeSeries.TimeArray)

    if !(length(TimeSeries.colnames(data)) == length(quantiles))
        throw(DataFormatError(
            "The size of the provided quantiles and data columns is incosistent"))
    end
    initial_time = TimeSeries.timestamp(data)[1]
    resolution = getresolution(data)

    return Probabilistic(component, label, Dates.Minute(resolution), initial_time, quantiles, data)
end

function PowerLoadPF(name::String, available::Bool, bus::Bus, maxactivepower::Float64,
                     power_factor::Float64)
    maxreactivepower = maxactivepower * sin(acos(power_factor))
    return PowerLoad(name, available, bus, maxactivepower, maxreactivepower)
end

function PowerLoadPF(::Nothing)
    return PowerLoadPF("init", true, Bus(nothing), 0.0, 1.0)
end

"""Accepts anglelimits as a Float64."""
function Line(name, available, arch::Arch, r, x, b, rate, anglelimits::Float64)
    return Line(name, available, arch::Arch, r, x, b, rate,
                (min=-anglelimits, max=anglelimits))
end

"""Allows construction with bus type specified as a string for legacy code."""
function Bus(number, name, bustype::String, angle, voltage, voltagelimits, basevoltage)
    return Bus(number, name, get_enum_value(BusType, bustype), angle, voltage,
               voltagelimits, basevoltage, PowerSystemInternal())
end
