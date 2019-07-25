#=
This file is auto-generated. Do not edit.
=#

"""A deterministic forecast for a particular data field in a PowerSystemDevice."""
mutable struct Deterministic{T <: Component} <: Forecast
    component::T
    label::String  # label of component parameter forecasted
    resolution::Dates.Period
    initial_time::Dates.DateTime  # forecast availability time
    data::TimeSeries.TimeArray  # timestamp - scalingfactor
    start_index::Int  # starting index of data for this forecast
    internal::PowerSystems.PowerSystemInternal
end

function Deterministic(component, label, resolution, initial_time, data, start_index, )
    Deterministic(component, label, resolution, initial_time, data, start_index, PowerSystemInternal())
end

function Deterministic(; component, label, resolution, initial_time, data, start_index, )
    Deterministic(component, label, resolution, initial_time, data, start_index, )
end


"""Get Deterministic component."""
get_component(value::Deterministic) = value.component
"""Get Deterministic label."""
get_label(value::Deterministic) = value.label
"""Get Deterministic resolution."""
get_resolution(value::Deterministic) = value.resolution
"""Get Deterministic initial_time."""
get_initial_time(value::Deterministic) = value.initial_time
"""Get Deterministic data."""
get_data(value::Deterministic) = value.data
"""Get Deterministic start_index."""
get_start_index(value::Deterministic) = value.start_index
"""Get Deterministic internal."""
get_internal(value::Deterministic) = value.internal
