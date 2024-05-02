#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FixedAdmittance <: ElectricLoad
        name::String
        available::Bool
        bus::ACBus
        Y::Complex{Float64}
        dynamic_injector::Union{Nothing, DynamicInjection}
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `bus::ACBus`: Bus that this component is connected to
- `Y::Complex{Float64}`: System per-unit value
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection model for admittance
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data).
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct FixedAdmittance <: ElectricLoad
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "System per-unit value"
    Y::Complex{Float64}
    "corresponding dynamic injection model for admittance"
    dynamic_injector::Union{Nothing, DynamicInjection}
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

function FixedAdmittance(name, available, bus, Y, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    FixedAdmittance(name, available, bus, Y, dynamic_injector, services, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function FixedAdmittance(; name, available, bus, Y, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    FixedAdmittance(name, available, bus, Y, dynamic_injector, services, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function FixedAdmittance(::Nothing)
    FixedAdmittance(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        Y=0.0,
        dynamic_injector=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`FixedAdmittance`](@ref) `name`."""
get_name(value::FixedAdmittance) = value.name
"""Get [`FixedAdmittance`](@ref) `available`."""
get_available(value::FixedAdmittance) = value.available
"""Get [`FixedAdmittance`](@ref) `bus`."""
get_bus(value::FixedAdmittance) = value.bus
"""Get [`FixedAdmittance`](@ref) `Y`."""
get_Y(value::FixedAdmittance) = value.Y
"""Get [`FixedAdmittance`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::FixedAdmittance) = value.dynamic_injector
"""Get [`FixedAdmittance`](@ref) `services`."""
get_services(value::FixedAdmittance) = value.services
"""Get [`FixedAdmittance`](@ref) `ext`."""
get_ext(value::FixedAdmittance) = value.ext
"""Get [`FixedAdmittance`](@ref) `time_series_container`."""
get_time_series_container(value::FixedAdmittance) = value.time_series_container
"""Get [`FixedAdmittance`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::FixedAdmittance) = value.supplemental_attributes_container
"""Get [`FixedAdmittance`](@ref) `internal`."""
get_internal(value::FixedAdmittance) = value.internal

"""Set [`FixedAdmittance`](@ref) `available`."""
set_available!(value::FixedAdmittance, val) = value.available = val
"""Set [`FixedAdmittance`](@ref) `bus`."""
set_bus!(value::FixedAdmittance, val) = value.bus = val
"""Set [`FixedAdmittance`](@ref) `Y`."""
set_Y!(value::FixedAdmittance, val) = value.Y = val
"""Set [`FixedAdmittance`](@ref) `services`."""
set_services!(value::FixedAdmittance, val) = value.services = val
"""Set [`FixedAdmittance`](@ref) `ext`."""
set_ext!(value::FixedAdmittance, val) = value.ext = val
"""Set [`FixedAdmittance`](@ref) `time_series_container`."""
set_time_series_container!(value::FixedAdmittance, val) = value.time_series_container = val
"""Set [`FixedAdmittance`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::FixedAdmittance, val) = value.supplemental_attributes_container = val
