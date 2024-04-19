#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TwoTerminalVSCDCLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        rectifier_tap_limits::MinMax
        rectifier_xrc::Float64
        rectifier_firing_angle::MinMax
        inverter_tap_limits::MinMax
        inverter_xrc::Float64
        inverter_firing_angle::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

As implemented in Milano's Book, Page 397.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `arc::Arc`
- `rectifier_tap_limits::MinMax`
- `rectifier_xrc::Float64`
- `rectifier_firing_angle::MinMax`
- `inverter_tap_limits::MinMax`
- `inverter_xrc::Float64`
- `inverter_firing_angle::MinMax`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TwoTerminalVSCDCLine <: ACBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    rectifier_tap_limits::MinMax
    rectifier_xrc::Float64
    rectifier_firing_angle::MinMax
    inverter_tap_limits::MinMax
    inverter_xrc::Float64
    inverter_firing_angle::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TwoTerminalVSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    TwoTerminalVSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function TwoTerminalVSCDCLine(; name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalVSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function TwoTerminalVSCDCLine(::Nothing)
    TwoTerminalVSCDCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        rectifier_tap_limits=(min=0.0, max=0.0),
        rectifier_xrc=0.0,
        rectifier_firing_angle=(min=0.0, max=0.0),
        inverter_tap_limits=(min=0.0, max=0.0),
        inverter_xrc=0.0,
        inverter_firing_angle=(min=0.0, max=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`TwoTerminalVSCDCLine`](@ref) `name`."""
get_name(value::TwoTerminalVSCDCLine) = value.name
"""Get [`TwoTerminalVSCDCLine`](@ref) `available`."""
get_available(value::TwoTerminalVSCDCLine) = value.available
"""Get [`TwoTerminalVSCDCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::TwoTerminalVSCDCLine) = get_value(value, value.active_power_flow)
"""Get [`TwoTerminalVSCDCLine`](@ref) `arc`."""
get_arc(value::TwoTerminalVSCDCLine) = value.arc
"""Get [`TwoTerminalVSCDCLine`](@ref) `rectifier_tap_limits`."""
get_rectifier_tap_limits(value::TwoTerminalVSCDCLine) = value.rectifier_tap_limits
"""Get [`TwoTerminalVSCDCLine`](@ref) `rectifier_xrc`."""
get_rectifier_xrc(value::TwoTerminalVSCDCLine) = value.rectifier_xrc
"""Get [`TwoTerminalVSCDCLine`](@ref) `rectifier_firing_angle`."""
get_rectifier_firing_angle(value::TwoTerminalVSCDCLine) = value.rectifier_firing_angle
"""Get [`TwoTerminalVSCDCLine`](@ref) `inverter_tap_limits`."""
get_inverter_tap_limits(value::TwoTerminalVSCDCLine) = value.inverter_tap_limits
"""Get [`TwoTerminalVSCDCLine`](@ref) `inverter_xrc`."""
get_inverter_xrc(value::TwoTerminalVSCDCLine) = value.inverter_xrc
"""Get [`TwoTerminalVSCDCLine`](@ref) `inverter_firing_angle`."""
get_inverter_firing_angle(value::TwoTerminalVSCDCLine) = value.inverter_firing_angle
"""Get [`TwoTerminalVSCDCLine`](@ref) `services`."""
get_services(value::TwoTerminalVSCDCLine) = value.services
"""Get [`TwoTerminalVSCDCLine`](@ref) `ext`."""
get_ext(value::TwoTerminalVSCDCLine) = value.ext
"""Get [`TwoTerminalVSCDCLine`](@ref) `time_series_container`."""
get_time_series_container(value::TwoTerminalVSCDCLine) = value.time_series_container
"""Get [`TwoTerminalVSCDCLine`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::TwoTerminalVSCDCLine) = value.supplemental_attributes_container
"""Get [`TwoTerminalVSCDCLine`](@ref) `internal`."""
get_internal(value::TwoTerminalVSCDCLine) = value.internal

"""Set [`TwoTerminalVSCDCLine`](@ref) `available`."""
set_available!(value::TwoTerminalVSCDCLine, val) = value.available = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TwoTerminalVSCDCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`TwoTerminalVSCDCLine`](@ref) `arc`."""
set_arc!(value::TwoTerminalVSCDCLine, val) = value.arc = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `rectifier_tap_limits`."""
set_rectifier_tap_limits!(value::TwoTerminalVSCDCLine, val) = value.rectifier_tap_limits = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `rectifier_xrc`."""
set_rectifier_xrc!(value::TwoTerminalVSCDCLine, val) = value.rectifier_xrc = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `rectifier_firing_angle`."""
set_rectifier_firing_angle!(value::TwoTerminalVSCDCLine, val) = value.rectifier_firing_angle = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `inverter_tap_limits`."""
set_inverter_tap_limits!(value::TwoTerminalVSCDCLine, val) = value.inverter_tap_limits = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `inverter_xrc`."""
set_inverter_xrc!(value::TwoTerminalVSCDCLine, val) = value.inverter_xrc = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `inverter_firing_angle`."""
set_inverter_firing_angle!(value::TwoTerminalVSCDCLine, val) = value.inverter_firing_angle = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `services`."""
set_services!(value::TwoTerminalVSCDCLine, val) = value.services = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `ext`."""
set_ext!(value::TwoTerminalVSCDCLine, val) = value.ext = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `time_series_container`."""
set_time_series_container!(value::TwoTerminalVSCDCLine, val) = value.time_series_container = val
"""Set [`TwoTerminalVSCDCLine`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::TwoTerminalVSCDCLine, val) = value.supplemental_attributes_container = val
