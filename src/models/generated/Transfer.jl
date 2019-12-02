#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Transfer <: Service
        name::String
        timeframe::Float64
        requirement::Float64
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `timeframe::Float64`: the relative saturation timeframe
- `requirement::Float64`
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Transfer <: Service
    name::String
    "the relative saturation timeframe"
    timeframe::Float64
    requirement::Float64
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Transfer(name, timeframe, requirement, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    Transfer(name, timeframe, requirement, ext, _forecasts, InfrastructureSystemsInternal(), )
end

function Transfer(; name, timeframe, requirement, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    Transfer(name, timeframe, requirement, ext, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function Transfer(::Nothing)
    Transfer(;
        name="init",
        timeframe=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get Transfer name."""
get_name(value::Transfer) = value.name
"""Get Transfer timeframe."""
get_timeframe(value::Transfer) = value.timeframe
"""Get Transfer requirement."""
get_requirement(value::Transfer) = value.requirement
"""Get Transfer ext."""
get_ext(value::Transfer) = value.ext
"""Get Transfer _forecasts."""
get__forecasts(value::Transfer) = value._forecasts
"""Get Transfer internal."""
get_internal(value::Transfer) = value.internal
