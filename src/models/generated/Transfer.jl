#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Transfer <: Service
        name::String
        available::Bool
        requirement::Float64
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `requirement::Float64`
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Transfer <: Service
    name::String
    available::Bool
    requirement::Float64
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Transfer(name, available, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    Transfer(name, available, requirement, ext, forecasts, InfrastructureSystemsInternal(), )
end

function Transfer(; name, available, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    Transfer(name, available, requirement, ext, forecasts, internal, )
end

# Constructor for demo purposes; non-functional.
function Transfer(::Nothing)
    Transfer(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Transfer) = value.name
"""Get [`Transfer`](@ref) `available`."""
get_available(value::Transfer) = value.available
"""Get [`Transfer`](@ref) `requirement`."""
get_requirement(value::Transfer) = value.requirement
"""Get [`Transfer`](@ref) `ext`."""
get_ext(value::Transfer) = value.ext

InfrastructureSystems.get_forecasts(value::Transfer) = value.forecasts
"""Get [`Transfer`](@ref) `internal`."""
get_internal(value::Transfer) = value.internal


InfrastructureSystems.set_name!(value::Transfer, val) = value.name = val
"""Set [`Transfer`](@ref) `available`."""
set_available!(value::Transfer, val) = value.available = val
"""Set [`Transfer`](@ref) `requirement`."""
set_requirement!(value::Transfer, val) = value.requirement = val
"""Set [`Transfer`](@ref) `ext`."""
set_ext!(value::Transfer, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::Transfer, val) = value.forecasts = val
"""Set [`Transfer`](@ref) `internal`."""
set_internal!(value::Transfer, val) = value.internal = val

