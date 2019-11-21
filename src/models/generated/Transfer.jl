#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Transfer <: Service
        name::String
        contributingdevices::Vector{<:Device}
        timeframe::Float64
        requirement::TimeSeries.TimeArray
        _forecasts::InfrastructureSystems.Forecasts
        ext::Union{Nothing, Dict{String, Any}}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `contributingdevices::Vector{<:Device}`
- `timeframe::Float64`: the relative saturation timeframe
- `requirement::TimeSeries.TimeArray`
- `_forecasts::InfrastructureSystems.Forecasts`
- `ext::Union{Nothing, Dict{String, Any}}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Transfer <: Service
    name::String
    contributingdevices::Vector{<:Device}
    "the relative saturation timeframe"
    timeframe::Float64
    requirement::TimeSeries.TimeArray
    _forecasts::InfrastructureSystems.Forecasts
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Transfer(name, contributingdevices, timeframe, requirement, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    Transfer(name, contributingdevices, timeframe, requirement, _forecasts, ext, InfrastructureSystemsInternal())
end

function Transfer(; name, contributingdevices, timeframe, requirement, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    Transfer(name, contributingdevices, timeframe, requirement, _forecasts, ext, )
end


function Transfer(name, contributingdevices, timeframe, requirement, ; ext=nothing)
    _forecasts=InfrastructureSystems.Forecasts()
    Transfer(name, contributingdevices, timeframe, requirement, _forecasts, ext, InfrastructureSystemsInternal())
end

# Constructor for demo purposes; non-functional.

function Transfer(::Nothing)
    Transfer(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
        requirement=[],
        _forecasts=InfrastructureSystems.Forecasts(),
        ext=nothing,
    )
end

"""Get Transfer name."""
get_name(value::Transfer) = value.name
"""Get Transfer contributingdevices."""
get_contributingdevices(value::Transfer) = value.contributingdevices
"""Get Transfer timeframe."""
get_timeframe(value::Transfer) = value.timeframe
"""Get Transfer requirement."""
get_requirement(value::Transfer) = value.requirement
"""Get Transfer _forecasts."""
get__forecasts(value::Transfer) = value._forecasts
"""Get Transfer ext."""
get_ext(value::Transfer) = value.ext
"""Get Transfer internal."""
get_internal(value::Transfer) = value.internal
