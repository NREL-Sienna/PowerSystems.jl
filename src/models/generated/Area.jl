#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Area <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        load_response::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for control purposes.

# Arguments
- `name::String`
- `peak_active_power::Float64`
- `peak_reactive_power::Float64`
- `load_response::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Area <: AggregationTopology
    name::String
    peak_active_power::Float64
    peak_reactive_power::Float64
    load_response::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Area(name, peak_active_power=0.0, peak_reactive_power=0.0, load_response=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, peak_active_power, peak_reactive_power, load_response, forecasts, InfrastructureSystemsInternal(), )
end

function Area(; name, peak_active_power=0.0, peak_reactive_power=0.0, load_response=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, peak_active_power, peak_reactive_power, load_response, forecasts, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
        load_response=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Area) = value.name
"""Get Area peak_active_power."""
get_peak_active_power(value::Area) = value.peak_active_power
"""Get Area peak_reactive_power."""
get_peak_reactive_power(value::Area) = value.peak_reactive_power
"""Get Area load_response."""
get_load_response(value::Area) = value.load_response

InfrastructureSystems.get_forecasts(value::Area) = value.forecasts
"""Get Area internal."""
get_internal(value::Area) = value.internal


InfrastructureSystems.set_name!(value::Area, val::String) = value.name = val
"""Set Area peak_active_power."""
set_peak_active_power!(value::Area, val::Float64) = value.peak_active_power = val
"""Set Area peak_reactive_power."""
set_peak_reactive_power!(value::Area, val::Float64) = value.peak_reactive_power = val
"""Set Area load_response."""
set_load_response!(value::Area, val::Float64) = value.load_response = val

InfrastructureSystems.set_forecasts!(value::Area, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set Area internal."""
set_internal!(value::Area, val::InfrastructureSystemsInternal) = value.internal = val
