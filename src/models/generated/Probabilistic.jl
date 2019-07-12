#=
This file is auto-generated. Do not edit.
=#

"""A Probabilistic forecast for a particular data field in a PowerSystemDevice."""
mutable struct Probabilistic{T <: Component} <: Forecast
    component::T
    label::String  # label of component parameter forecasted
    resolution::Dates.Period
    initial_time::Dates.DateTime  # forecast availability time
    quantiles::Vector{Float64}  # Quantiles for the probabilistic forecast
    data::TimeSeries.TimeArray  # TimeStamp - scalingfactor
    internal::PowerSystems.PowerSystemInternal
end

function Probabilistic(component, label, resolution, initial_time, quantiles, data, )
    Probabilistic(component, label, resolution, initial_time, quantiles, data, PowerSystemInternal())
end

function Probabilistic(; component, label, resolution, initial_time, quantiles, data, )
    Probabilistic(component, label, resolution, initial_time, quantiles, data, )
end


"""Get Probabilistic component."""
get_component(value::Probabilistic) = value.component
"""Get Probabilistic label."""
get_label(value::Probabilistic) = value.label
"""Get Probabilistic resolution."""
get_resolution(value::Probabilistic) = value.resolution
"""Get Probabilistic initial_time."""
get_initial_time(value::Probabilistic) = value.initial_time
"""Get Probabilistic quantiles."""
get_quantiles(value::Probabilistic) = value.quantiles
"""Get Probabilistic data."""
get_data(value::Probabilistic) = value.data
"""Get Probabilistic internal."""
get_internal(value::Probabilistic) = value.internal
