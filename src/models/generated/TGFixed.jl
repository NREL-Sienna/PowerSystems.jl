#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TGFixed <: TurbineGov
        efficiency::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a fixed Turbine Governor that returns a fixed mechanical torque
 given by the product of P_ref*efficiency

# Arguments
- `efficiency::Float64`:  Efficiency factor that multiplies P_ref, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TGFixed <: TurbineGov
    " Efficiency factor that multiplies P_ref"
    efficiency::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TGFixed(efficiency, ext=Dict{String, Any}(), )
    TGFixed(efficiency, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function TGFixed(; efficiency, ext=Dict{String, Any}(), )
    TGFixed(efficiency, ext, )
end

# Constructor for demo purposes; non-functional.
function TGFixed(::Nothing)
    TGFixed(;
        efficiency=0,
        ext=Dict{String, Any}(),
    )
end

"""Get TGFixed efficiency."""
get_efficiency(value::TGFixed) = value.efficiency
"""Get TGFixed ext."""
get_ext(value::TGFixed) = value.ext
"""Get TGFixed states."""
get_states(value::TGFixed) = value.states
"""Get TGFixed n_states."""
get_n_states(value::TGFixed) = value.n_states
"""Get TGFixed internal."""
get_internal(value::TGFixed) = value.internal

"""Set TGFixed efficiency."""
set_efficiency(value::TGFixed, val) = value.efficiency = val
"""Set TGFixed ext."""
set_ext(value::TGFixed, val) = value.ext = val
"""Set TGFixed states."""
set_states(value::TGFixed, val) = value.states = val
"""Set TGFixed n_states."""
set_n_states(value::TGFixed, val) = value.n_states = val
"""Set TGFixed internal."""
set_internal(value::TGFixed, val) = value.internal = val
