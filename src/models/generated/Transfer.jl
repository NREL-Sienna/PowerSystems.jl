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
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `requirement::Float64`:
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct Transfer <: Service
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    requirement::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function Transfer(name, available, requirement, ext=Dict{String, Any}(), )
    Transfer(name, available, requirement, ext, InfrastructureSystemsInternal(), )
end

function Transfer(; name, available, requirement, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Transfer(name, available, requirement, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function Transfer(::Nothing)
    Transfer(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
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
"""Get [`Transfer`](@ref) `internal`."""
get_internal(value::Transfer) = value.internal

"""Set [`Transfer`](@ref) `available`."""
set_available!(value::Transfer, val) = value.available = val
"""Set [`Transfer`](@ref) `requirement`."""
set_requirement!(value::Transfer, val) = value.requirement = val
"""Set [`Transfer`](@ref) `ext`."""
set_ext!(value::Transfer, val) = value.ext = val
