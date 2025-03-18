#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroReservoir <: DeviceParameter
        name::String
        available::Bool
        area::Area
        storage_volume_limits::MinMax
        spillage_outflow_limits::Union{Nothing, MinMax}
        volume_to_power_factor::Float64
        travel_time::Float64
        inflow::Float64
        volume_target::Float64
        conversion_factor::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A hydro reservoir representation.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `area::Area`: Area from which the reservoir is located
- `storage_volume_limits::MinMax`: Minimum and maximum volume limits (m^3)
- `spillage_outflow_limits::Union{Nothing, MinMax}`: limits for spillage, validation range: `(0, nothing)`
- `volume_to_power_factor::Float64`: Conversion factor for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `travel_time::Float64`: Downstream travel time in hours., validation range: `(0, nothing)`
- `inflow::Float64`: Baseline inflow into the reservoir (units can be p.u. or m^3/hr), validation range: `(0, nothing)`
- `volume_target::Float64`: (default: `1.0`) Volume target at the end of simulation as a fraction of the total volume, validation range: `(0, 1)`
- `conversion_factor::Float64`: (default: `1.0`) Conversion factor from flow/volume to energy: m^3 -> p.u-hr
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct HydroReservoir <: DeviceParameter
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Area from which the reservoir is located"
    area::Area
    "Minimum and maximum volume limits (m^3)"
    storage_volume_limits::MinMax
    "limits for spillage"
    spillage_outflow_limits::Union{Nothing, MinMax}
    "Conversion factor for [per unitization](@ref per_unit)"
    volume_to_power_factor::Float64
    "Downstream travel time in hours."
    travel_time::Float64
    "Baseline inflow into the reservoir (units can be p.u. or m^3/hr)"
    inflow::Float64
    "Volume target at the end of simulation as a fraction of the total volume"
    volume_target::Float64
    "Conversion factor from flow/volume to energy: m^3 -> p.u-hr"
    conversion_factor::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function HydroReservoir(name, available, area, storage_volume_limits, spillage_outflow_limits, volume_to_power_factor, travel_time, inflow, volume_target=1.0, conversion_factor=1.0, services=Device[], ext=Dict{String, Any}(), )
    HydroReservoir(name, available, area, storage_volume_limits, spillage_outflow_limits, volume_to_power_factor, travel_time, inflow, volume_target, conversion_factor, services, ext, InfrastructureSystemsInternal(), )
end

function HydroReservoir(; name, available, area, storage_volume_limits, spillage_outflow_limits, volume_to_power_factor, travel_time, inflow, volume_target=1.0, conversion_factor=1.0, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    HydroReservoir(name, available, area, storage_volume_limits, spillage_outflow_limits, volume_to_power_factor, travel_time, inflow, volume_target, conversion_factor, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroReservoir(::Nothing)
    HydroReservoir(;
        name="init",
        available=false,
        area=Area(nothing),
        storage_volume_limits=(min=0.0, max=0.0),
        spillage_outflow_limits=nothing,
        volume_to_power_factor=1.0,
        travel_time=0.0,
        inflow=0.0,
        volume_target=0.0,
        conversion_factor=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`HydroReservoir`](@ref) `name`."""
get_name(value::HydroReservoir) = value.name
"""Get [`HydroReservoir`](@ref) `available`."""
get_available(value::HydroReservoir) = value.available
"""Get [`HydroReservoir`](@ref) `area`."""
get_area(value::HydroReservoir) = value.area
"""Get [`HydroReservoir`](@ref) `storage_volume_limits`."""
get_storage_volume_limits(value::HydroReservoir) = get_value(value, value.storage_volume_limits)
"""Get [`HydroReservoir`](@ref) `spillage_outflow_limits`."""
get_spillage_outflow_limits(value::HydroReservoir) = get_value(value, value.spillage_outflow_limits)
"""Get [`HydroReservoir`](@ref) `volume_to_power_factor`."""
get_volume_to_power_factor(value::HydroReservoir) = value.volume_to_power_factor
"""Get [`HydroReservoir`](@ref) `travel_time`."""
get_travel_time(value::HydroReservoir) = get_value(value, value.travel_time)
"""Get [`HydroReservoir`](@ref) `inflow`."""
get_inflow(value::HydroReservoir) = get_value(value, value.inflow)
"""Get [`HydroReservoir`](@ref) `volume_target`."""
get_volume_target(value::HydroReservoir) = value.volume_target
"""Get [`HydroReservoir`](@ref) `conversion_factor`."""
get_conversion_factor(value::HydroReservoir) = value.conversion_factor
"""Get [`HydroReservoir`](@ref) `services`."""
get_services(value::HydroReservoir) = value.services
"""Get [`HydroReservoir`](@ref) `ext`."""
get_ext(value::HydroReservoir) = value.ext
"""Get [`HydroReservoir`](@ref) `internal`."""
get_internal(value::HydroReservoir) = value.internal

"""Set [`HydroReservoir`](@ref) `available`."""
set_available!(value::HydroReservoir, val) = value.available = val
"""Set [`HydroReservoir`](@ref) `area`."""
set_area!(value::HydroReservoir, val) = value.area = val
"""Set [`HydroReservoir`](@ref) `storage_volume_limits`."""
set_storage_volume_limits!(value::HydroReservoir, val) = value.storage_volume_limits = set_value(value, val)
"""Set [`HydroReservoir`](@ref) `spillage_outflow_limits`."""
set_spillage_outflow_limits!(value::HydroReservoir, val) = value.spillage_outflow_limits = set_value(value, val)
"""Set [`HydroReservoir`](@ref) `volume_to_power_factor`."""
set_volume_to_power_factor!(value::HydroReservoir, val) = value.volume_to_power_factor = val
"""Set [`HydroReservoir`](@ref) `travel_time`."""
set_travel_time!(value::HydroReservoir, val) = value.travel_time = set_value(value, val)
"""Set [`HydroReservoir`](@ref) `inflow`."""
set_inflow!(value::HydroReservoir, val) = value.inflow = set_value(value, val)
"""Set [`HydroReservoir`](@ref) `volume_target`."""
set_volume_target!(value::HydroReservoir, val) = value.volume_target = val
"""Set [`HydroReservoir`](@ref) `conversion_factor`."""
set_conversion_factor!(value::HydroReservoir, val) = value.conversion_factor = val
"""Set [`HydroReservoir`](@ref) `services`."""
set_services!(value::HydroReservoir, val) = value.services = val
"""Set [`HydroReservoir`](@ref) `ext`."""
set_ext!(value::HydroReservoir, val) = value.ext = val
