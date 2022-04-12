#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Transfer <: Service
        name::String
        available::Bool
        requirement::Float64
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `requirement::Float64`
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Transfer <: Service
    name::String
    available::Bool
    requirement::Float64
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Transfer(name, available, requirement, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    Transfer(name, available, requirement, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function Transfer(; name, available, requirement, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    Transfer(name, available, requirement, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function Transfer(::Nothing)
    Transfer(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`Transfer`](@ref) `name`."""
get_name(value::Transfer) = value.name
"""Get [`Transfer`](@ref) `available`."""
get_available(value::Transfer) = value.available
"""Get [`Transfer`](@ref) `requirement`."""
get_requirement(value::Transfer) = value.requirement
"""Get [`Transfer`](@ref) `ext`."""
get_ext(value::Transfer) = value.ext
"""Get [`Transfer`](@ref) `time_series_container`."""
get_time_series_container(value::Transfer) = value.time_series_container
"""Get [`Transfer`](@ref) `internal`."""
get_internal(value::Transfer) = value.internal

"""Set [`Transfer`](@ref) `available`."""
set_available!(value::Transfer, val) = value.available = val
"""Set [`Transfer`](@ref) `requirement`."""
set_requirement!(value::Transfer, val) = value.requirement = val
"""Set [`Transfer`](@ref) `ext`."""
set_ext!(value::Transfer, val) = value.ext = val
"""Set [`Transfer`](@ref) `time_series_container`."""
set_time_series_container!(value::Transfer, val) = value.time_series_container = val
