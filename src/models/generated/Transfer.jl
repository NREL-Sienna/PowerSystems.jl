#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Transfer <: Service
        name::String
        requirement::Float64
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `requirement::Float64`
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Transfer <: Service
    name::String
    requirement::Float64
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Transfer(name, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    Transfer(name, requirement, ext, forecasts, InfrastructureSystemsInternal(), )
end

function Transfer(; name, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    Transfer(name, requirement, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function Transfer(::Nothing)
    Transfer(;
        name="init",
        requirement=0.0,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Transfer) = value.name
"""Get Transfer requirement."""
get_requirement(value::Transfer) = value.requirement
"""Get Transfer ext."""
get_ext(value::Transfer) = value.ext

InfrastructureSystems.get_forecasts(value::Transfer) = value.forecasts
"""Get Transfer internal."""
get_internal(value::Transfer) = value.internal
