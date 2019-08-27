"""Accepts rating as a Float64 and then creates a TwoPartCost."""
function TwoPartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return TwoPartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a ThreePartCost."""
function ThreePartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return ThreePartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableFix(name::String, available::Bool, bus::Bus,
                        activepower::Float64, reactivepower::Float64,
                        prime_mover::PrimeMovers, rating::Float64)
    tech = TechRenewable(rating, prime_mover, nothing, 1.0)
    RenewableFix(name, available, bus, activepower, reactivepower, tech)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableDispatch(name::String, available::Bool, bus::Bus,
                           activepower::Float64, reactivepower::Float64,
                           prime_mover::PrimeMovers, rating::Float64, op_cost::TwoPartCost)
    tech = TechRenewable(rating, prime_mover, nothing, 1.0)
    return RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost)
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

function Deterministic(component::Component,
                       label::AbstractString,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       data::TimeSeries.TimeArray,
                      )
    start_index = 1
    horizon = length(data)
    return Deterministic(component, label, resolution, initial_time, data, start_index,
                         horizon, PowerSystemInternal())
end

"""Constructs Probabilistic after constructing a TimeArray from initial_time and time_steps.
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

    return Probabilistic(component, label, Dates.Minute(resolution), initial_time,
                         quantiles, data)
end

"""Constructs Probabilistic Forecast after constructing a TimeArray from initial_time and time_steps.
"""
function Probabilistic(component::Component,
                       label::String,
                       quantiles::Vector{Float64},  # Quantiles for the probabilistic forecast
                       data::TimeSeries.TimeArray,
                      )

    if !(length(TimeSeries.colnames(data)) == length(quantiles))
        throw(DataFormatError(
            "The size of the provided quantiles and data columns is incosistent"))
    end
    initial_time = TimeSeries.timestamp(data)[1]
    resolution = getresolution(data)

    return Probabilistic(component, label, Dates.Minute(resolution), initial_time,
                         quantiles, data)
end

function Probabilistic(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       quantiles::Vector{Float64},  # Quantiles for the probabilistic forecast
                       data::TimeSeries.TimeArray)
    start_index = 1
    horizon = length(data)
    return Probabilistic(component, label, resolution, initial_time, quantiles, data,
                         start_index, horizon, PowerSystemInternal())
end


"""Constructs ScenarioBased Forecast after constructing a TimeArray from initial_time and time_steps.
"""
function ScenarioBased(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       scenario_count::Int64,
                       time_steps::Int)

    data = TimeSeries.TimeArray(
        initial_time : Dates.Hour(1) : initial_time + resolution * (time_steps-1),
        ones(time_steps, scenario_count)
    )


    return ScenarioBased(component, label, Dates.Minute(resolution), initial_time, data)
end

"""Constructs ScenarioBased Forecast after constructing a TimeArray from initial_time and time_steps.
"""
function ScenarioBased(component::Component,
                       label::String,
                       data::TimeSeries.TimeArray,
                      )

    initial_time = TimeSeries.timestamp(data)[1]
    resolution = getresolution(data)

    return ScenarioBased(component, label, Dates.Minute(resolution), initial_time,
                         data)
end

function ScenarioBased(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       data::TimeSeries.TimeArray)
    start_index = 1
    scenario_count = length(TimeSeries.colnames(data))
    horizon = length(data)
    return ScenarioBased(component, label, resolution, initial_time, scenario_count, data,
                            start_index, horizon, PowerSystemInternal())
end

function PowerLoadPF(name::String, available::Bool, bus::Bus,
                     model::Union{Nothing, LoadModel}, activepower::Float64,
                     maxactivepower::Float64, power_factor::Float64)
    maxreactivepower = maxactivepower * sin(acos(power_factor))
    reactivepower = activepower * sin(acos(power_factor))
    return PowerLoad(name,
                     available,
                     bus,
                     model,
                     activepower,
                     reactivepower,
                     maxactivepower,
                     maxreactivepower)
end

function PowerLoadPF(::Nothing)
    return PowerLoadPF("init", true, Bus(nothing), nothing, 0.0, 0.0, 1.0)
end

"""Accepts anglelimits as a Float64."""
function Line(name, available::Bool, activepower_flow::Float64,
    reactivepower_flow::Float64, arc::Arc, r, x, b, rate, anglelimits::Float64)
    return Line(name, available, activepower_flow, reactivepower_flow, arc::Arc, r, x, b, rate,
                (min=-anglelimits, max=anglelimits))
end

"""Allows construction with bus type specified as a string for legacy code."""
function Bus(number, name, bustype::String, angle, voltage, voltagelimits, basevoltage)
    return Bus(number, name, get_enum_value(BusType, bustype), angle, voltage,
               voltagelimits, basevoltage, PowerSystemInternal())
end
