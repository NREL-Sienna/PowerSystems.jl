#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct GenericDynamicLoad <: DynamicInjection
        name::String
        a::Float64
        b::Float64
        α::Float64
        β::Float64
        T_p::Float64
        T_q::Float64
        ext::Dict{String, Any}
        base_power::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of 2-states of a generic dynamic load model based on VOLTAGE STABILITY ANALYSIS USING GENERIC DYNAMIC LOAD MODELS by W. Xu and Y. Mansour, IEEE Transactions on Power Systems, 1994.

# Arguments
- `name::String`
- `a::Float64`: Active power static exponential coefficient, validation range: `(0, nothing)`
- `b::Float64`: Reactive power static exponential coefficient, validation range: `(0, nothing)`
- `α::Float64`: Active power transient exponential coefficient, validation range: `(0, nothing)`
- `β::Float64`: Reactive power transient exponential coefficient, validation range: `(0, nothing)`
- `T_p::Float64`: Active Power Time Constant, validation range: `(0, nothing)`
- `T_q::Float64`: Reactive Power Time Constant, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `base_power::Float64`: Base Power
- `states::Vector{Symbol}`: The states are:
	x_p: Integrator state of the active power,
	x_q: Integrator state of the reactive power,
- `n_states::Int`: GenericDynamicLoad has 2 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GenericDynamicLoad <: DynamicInjection
    name::String
    "Active power static exponential coefficient"
    a::Float64
    "Reactive power static exponential coefficient"
    b::Float64
    "Active power transient exponential coefficient"
    α::Float64
    "Reactive power transient exponential coefficient"
    β::Float64
    "Active Power Time Constant"
    T_p::Float64
    "Reactive Power Time Constant"
    T_q::Float64
    ext::Dict{String, Any}
    "Base Power"
    base_power::Float64
    "The states are:
	x_p: Integrator state of the active power,
	x_q: Integrator state of the reactive power,"
    states::Vector{Symbol}
    "GenericDynamicLoad has 2 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GenericDynamicLoad(name, a, b, α, β, T_p, T_q, ext=Dict{String, Any}(), )
    GenericDynamicLoad(name, a, b, α, β, T_p, T_q, ext, 100.0, [:x_p, :x_q], 2, InfrastructureSystemsInternal(), )
end

function GenericDynamicLoad(; name, a, b, α, β, T_p, T_q, ext=Dict{String, Any}(), base_power=100.0, states=[:x_p, :x_q], n_states=2, internal=InfrastructureSystemsInternal(), )
    GenericDynamicLoad(name, a, b, α, β, T_p, T_q, ext, base_power, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function GenericDynamicLoad(::Nothing)
    GenericDynamicLoad(;
        name="init",
        a=0,
        b=0,
        α=0,
        β=0,
        T_p=0,
        T_q=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`GenericDynamicLoad`](@ref) `name`."""
get_name(value::GenericDynamicLoad) = value.name
"""Get [`GenericDynamicLoad`](@ref) `a`."""
get_a(value::GenericDynamicLoad) = value.a
"""Get [`GenericDynamicLoad`](@ref) `b`."""
get_b(value::GenericDynamicLoad) = value.b
"""Get [`GenericDynamicLoad`](@ref) `α`."""
get_α(value::GenericDynamicLoad) = value.α
"""Get [`GenericDynamicLoad`](@ref) `β`."""
get_β(value::GenericDynamicLoad) = value.β
"""Get [`GenericDynamicLoad`](@ref) `T_p`."""
get_T_p(value::GenericDynamicLoad) = value.T_p
"""Get [`GenericDynamicLoad`](@ref) `T_q`."""
get_T_q(value::GenericDynamicLoad) = value.T_q
"""Get [`GenericDynamicLoad`](@ref) `ext`."""
get_ext(value::GenericDynamicLoad) = value.ext
"""Get [`GenericDynamicLoad`](@ref) `base_power`."""
get_base_power(value::GenericDynamicLoad) = value.base_power
"""Get [`GenericDynamicLoad`](@ref) `states`."""
get_states(value::GenericDynamicLoad) = value.states
"""Get [`GenericDynamicLoad`](@ref) `n_states`."""
get_n_states(value::GenericDynamicLoad) = value.n_states
"""Get [`GenericDynamicLoad`](@ref) `internal`."""
get_internal(value::GenericDynamicLoad) = value.internal

"""Set [`GenericDynamicLoad`](@ref) `a`."""
set_a!(value::GenericDynamicLoad, val) = value.a = val
"""Set [`GenericDynamicLoad`](@ref) `b`."""
set_b!(value::GenericDynamicLoad, val) = value.b = val
"""Set [`GenericDynamicLoad`](@ref) `α`."""
set_α!(value::GenericDynamicLoad, val) = value.α = val
"""Set [`GenericDynamicLoad`](@ref) `β`."""
set_β!(value::GenericDynamicLoad, val) = value.β = val
"""Set [`GenericDynamicLoad`](@ref) `T_p`."""
set_T_p!(value::GenericDynamicLoad, val) = value.T_p = val
"""Set [`GenericDynamicLoad`](@ref) `T_q`."""
set_T_q!(value::GenericDynamicLoad, val) = value.T_q = val
"""Set [`GenericDynamicLoad`](@ref) `ext`."""
set_ext!(value::GenericDynamicLoad, val) = value.ext = val
"""Set [`GenericDynamicLoad`](@ref) `base_power`."""
set_base_power!(value::GenericDynamicLoad, val) = value.base_power = val
