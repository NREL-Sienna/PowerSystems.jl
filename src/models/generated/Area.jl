#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Area <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        load_response::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A collection of buses for control purposes.

The `Area` can be specified when defining each [`ACBus`](@ref) or [`DCBus`](@ref) in the area.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `peak_active_power::Float64`: (optional) Peak active power in the area
- `peak_reactive_power::Float64`: (optional) Peak reactive power in the area
- `load_response::Float64`: (optional) Load-frequency damping parameter modeling how much the load in the area changes due to changes in frequency (MW/Hz). [Example here.](https://doi.org/10.1109/NAPS50074.2021.9449687)
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct Area <: AggregationTopology
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "(optional) Peak active power in the area"
    peak_active_power::Float64
    "(optional) Peak reactive power in the area"
    peak_reactive_power::Float64
    "(optional) Load-frequency damping parameter modeling how much the load in the area changes due to changes in frequency (MW/Hz). [Example here.](https://doi.org/10.1109/NAPS50074.2021.9449687)"
    load_response::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function Area(name, peak_active_power=0.0, peak_reactive_power=0.0, load_response=0.0, ext=Dict{String, Any}(), )
    Area(name, peak_active_power, peak_reactive_power, load_response, ext, InfrastructureSystemsInternal(), )
end

function Area(; name, peak_active_power=0.0, peak_reactive_power=0.0, load_response=0.0, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Area(name, peak_active_power, peak_reactive_power, load_response, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
        load_response=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`Area`](@ref) `name`."""
get_name(value::Area) = value.name
"""Get [`Area`](@ref) `peak_active_power`."""
get_peak_active_power(value::Area) = get_value(value, value.peak_active_power)
"""Get [`Area`](@ref) `peak_reactive_power`."""
get_peak_reactive_power(value::Area) = get_value(value, value.peak_reactive_power)
"""Get [`Area`](@ref) `load_response`."""
get_load_response(value::Area) = value.load_response
"""Get [`Area`](@ref) `ext`."""
get_ext(value::Area) = value.ext
"""Get [`Area`](@ref) `internal`."""
get_internal(value::Area) = value.internal

"""Set [`Area`](@ref) `peak_active_power`."""
set_peak_active_power!(value::Area, val) = value.peak_active_power = set_value(value, val)
"""Set [`Area`](@ref) `peak_reactive_power`."""
set_peak_reactive_power!(value::Area, val) = value.peak_reactive_power = set_value(value, val)
"""Set [`Area`](@ref) `load_response`."""
set_load_response!(value::Area, val) = value.load_response = val
"""Set [`Area`](@ref) `ext`."""
set_ext!(value::Area, val) = value.ext = val
