#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MonitoredLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        b::FromTo
        flow_limits::FromTo_ToFrom
        rate::Float64
        angle_limits::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `active_power_flow::Float64`
- `reactive_power_flow::Float64`
- `arc::Arc`: Used internally to represent network topology. **Do not modify.**
- `r::Float64`: System per-unit value, validation range: `(0, 4)`, action if invalid: `warn`
- `x::Float64`: System per-unit value, validation range: `(0, 4)`, action if invalid: `warn`
- `b::FromTo`: System per-unit value, validation range: `(0, 2)`, action if invalid: `warn`
- `flow_limits::FromTo_ToFrom`: throw warning above max SIL
- `rate::Float64`: compare to SIL (warn) (theoretical limit)
- `angle_limits::MinMax`, validation range: `(-1.571, 1.571)`, action if invalid: `error`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data).
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct MonitoredLine <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    active_power_flow::Float64
    reactive_power_flow::Float64
    "Used internally to represent network topology. **Do not modify.**"
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    "System per-unit value"
    b::FromTo
    "throw warning above max SIL"
    flow_limits::FromTo_ToFrom
    "compare to SIL (warn) (theoretical limit)"
    rate::Float64
    angle_limits::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data)."
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function MonitoredLine(; name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function MonitoredLine(::Nothing)
    MonitoredLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        flow_limits=(from_to=0.0, to_from=0.0),
        rate=0.0,
        angle_limits=(min=-1.571, max=1.571),
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`MonitoredLine`](@ref) `name`."""
get_name(value::MonitoredLine) = value.name
"""Get [`MonitoredLine`](@ref) `available`."""
get_available(value::MonitoredLine) = value.available
"""Get [`MonitoredLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::MonitoredLine) = get_value(value, value.active_power_flow)
"""Get [`MonitoredLine`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::MonitoredLine) = get_value(value, value.reactive_power_flow)
"""Get [`MonitoredLine`](@ref) `arc`."""
get_arc(value::MonitoredLine) = value.arc
"""Get [`MonitoredLine`](@ref) `r`."""
get_r(value::MonitoredLine) = value.r
"""Get [`MonitoredLine`](@ref) `x`."""
get_x(value::MonitoredLine) = value.x
"""Get [`MonitoredLine`](@ref) `b`."""
get_b(value::MonitoredLine) = value.b
"""Get [`MonitoredLine`](@ref) `flow_limits`."""
get_flow_limits(value::MonitoredLine) = get_value(value, value.flow_limits)
"""Get [`MonitoredLine`](@ref) `rate`."""
get_rate(value::MonitoredLine) = get_value(value, value.rate)
"""Get [`MonitoredLine`](@ref) `angle_limits`."""
get_angle_limits(value::MonitoredLine) = value.angle_limits
"""Get [`MonitoredLine`](@ref) `services`."""
get_services(value::MonitoredLine) = value.services
"""Get [`MonitoredLine`](@ref) `ext`."""
get_ext(value::MonitoredLine) = value.ext
"""Get [`MonitoredLine`](@ref) `time_series_container`."""
get_time_series_container(value::MonitoredLine) = value.time_series_container
"""Get [`MonitoredLine`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::MonitoredLine) = value.supplemental_attributes_container
"""Get [`MonitoredLine`](@ref) `internal`."""
get_internal(value::MonitoredLine) = value.internal

"""Set [`MonitoredLine`](@ref) `available`."""
set_available!(value::MonitoredLine, val) = value.available = val
"""Set [`MonitoredLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::MonitoredLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::MonitoredLine, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `arc`."""
set_arc!(value::MonitoredLine, val) = value.arc = val
"""Set [`MonitoredLine`](@ref) `r`."""
set_r!(value::MonitoredLine, val) = value.r = val
"""Set [`MonitoredLine`](@ref) `x`."""
set_x!(value::MonitoredLine, val) = value.x = val
"""Set [`MonitoredLine`](@ref) `b`."""
set_b!(value::MonitoredLine, val) = value.b = val
"""Set [`MonitoredLine`](@ref) `flow_limits`."""
set_flow_limits!(value::MonitoredLine, val) = value.flow_limits = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `rate`."""
set_rate!(value::MonitoredLine, val) = value.rate = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `angle_limits`."""
set_angle_limits!(value::MonitoredLine, val) = value.angle_limits = val
"""Set [`MonitoredLine`](@ref) `services`."""
set_services!(value::MonitoredLine, val) = value.services = val
"""Set [`MonitoredLine`](@ref) `ext`."""
set_ext!(value::MonitoredLine, val) = value.ext = val
"""Set [`MonitoredLine`](@ref) `time_series_container`."""
set_time_series_container!(value::MonitoredLine, val) = value.time_series_container = val
"""Set [`MonitoredLine`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::MonitoredLine, val) = value.supplemental_attributes_container = val
