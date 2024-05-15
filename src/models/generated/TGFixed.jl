#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TGFixed <: TurbineGov
        efficiency::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a fixed Turbine Governor that returns a fixed mechanical torque
 given by the product of P_ref*efficiency

# Arguments
- `efficiency::Float64`: Efficiency factor that multiplies `P_ref`, validation range: `(0, nothing)`
- `P_ref::Float64`: (optional) Reference Power Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) TGFixed has no states
- `n_states::Int`: (**Do not modify.**) TGFixed has no states
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct TGFixed <: TurbineGov
    "Efficiency factor that multiplies `P_ref`"
    efficiency::Float64
    "(optional) Reference Power Set-point (pu)"
    P_ref::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) TGFixed has no states"
    states::Vector{Symbol}
    "(**Do not modify.**) TGFixed has no states"
    n_states::Int
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function TGFixed(efficiency, P_ref=1.0, ext=Dict{String, Any}(), )
    TGFixed(efficiency, P_ref, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function TGFixed(; efficiency, P_ref=1.0, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, internal=InfrastructureSystemsInternal(), )
    TGFixed(efficiency, P_ref, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function TGFixed(::Nothing)
    TGFixed(;
        efficiency=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`TGFixed`](@ref) `efficiency`."""
get_efficiency(value::TGFixed) = value.efficiency
"""Get [`TGFixed`](@ref) `P_ref`."""
get_P_ref(value::TGFixed) = value.P_ref
"""Get [`TGFixed`](@ref) `ext`."""
get_ext(value::TGFixed) = value.ext
"""Get [`TGFixed`](@ref) `states`."""
get_states(value::TGFixed) = value.states
"""Get [`TGFixed`](@ref) `n_states`."""
get_n_states(value::TGFixed) = value.n_states
"""Get [`TGFixed`](@ref) `internal`."""
get_internal(value::TGFixed) = value.internal

"""Set [`TGFixed`](@ref) `efficiency`."""
set_efficiency!(value::TGFixed, val) = value.efficiency = val
"""Set [`TGFixed`](@ref) `P_ref`."""
set_P_ref!(value::TGFixed, val) = value.P_ref = val
"""Set [`TGFixed`](@ref) `ext`."""
set_ext!(value::TGFixed, val) = value.ext = val
