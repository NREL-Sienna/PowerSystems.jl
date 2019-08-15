#=
This file is auto-generated. Do not edit.
=#

"""A Discrete Scenario Based forecast for a particular data field in a PowerSystemDevice."""
mutable struct ScenarioBased{T <: Component} <: Forecast
    component::T
    label::String  # label of component parameter forecasted
    resolution::Dates.Period
    initial_time::Dates.DateTime  # forecast availability time
    scenario_count::Int64  # Number of scenarios
    data::TimeSeries.TimeArray  # timestamp - scalingfactor
    start_index::Int  # starting index of data for this forecast
    horizon::Int  # length of this forecast
    internal::PowerSystemInternal
end

function ScenarioBased(component, label, resolution, initial_time, scenario_count, data, start_index, horizon, )
    ScenarioBased(component, label, resolution, initial_time, scenario_count, data, start_index, horizon, PowerSystemInternal())
end

function ScenarioBased(; component, label, resolution, initial_time, scenario_count, data, start_index, horizon, )
    ScenarioBased(component, label, resolution, initial_time, scenario_count, data, start_index, horizon, )
end


"""Get ScenarioBased component."""
get_component(value::ScenarioBased) = value.component
"""Get ScenarioBased label."""
get_label(value::ScenarioBased) = value.label
"""Get ScenarioBased resolution."""
get_resolution(value::ScenarioBased) = value.resolution
"""Get ScenarioBased initial_time."""
get_initial_time(value::ScenarioBased) = value.initial_time
"""Get ScenarioBased scenario_count."""
get_scenario_count(value::ScenarioBased) = value.scenario_count
"""Get ScenarioBased data."""
get_data(value::ScenarioBased) = value.data
"""Get ScenarioBased start_index."""
get_start_index(value::ScenarioBased) = value.start_index
"""Get ScenarioBased horizon."""
get_horizon(value::ScenarioBased) = value.horizon
"""Get ScenarioBased internal."""
get_internal(value::ScenarioBased) = value.internal
