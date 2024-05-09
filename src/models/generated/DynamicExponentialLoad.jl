#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct DynamicExponentialLoad <: DynamicInjection
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
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `a::Float64`: Active power static exponential coefficient, validation range: `(0, nothing)`
- `b::Float64`: Reactive power static exponential coefficient, validation range: `(0, nothing)`
- `α::Float64`: Active power transient exponential coefficient, validation range: `(0, nothing)`
- `β::Float64`: Reactive power transient exponential coefficient, validation range: `(0, nothing)`
- `T_p::Float64`: Active Power Time Constant, validation range: `(0, nothing)`
- `T_q::Float64`: Reactive Power Time Constant, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `base_power::Float64`: Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`.
- `states::Vector{Symbol}`: The states are:
	x_p: Integrator state of the active power,
	x_q: Integrator state of the reactive power,
- `n_states::Int`: DynamicExponentialLoad has 2 states
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct DynamicExponentialLoad <: DynamicInjection
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
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
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`."
    base_power::Float64
    "The states are:
	x_p: Integrator state of the active power,
	x_q: Integrator state of the reactive power,"
    states::Vector{Symbol}
    "DynamicExponentialLoad has 2 states"
    n_states::Int
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function DynamicExponentialLoad(name, a, b, α, β, T_p, T_q, ext=Dict{String, Any}(), )
    DynamicExponentialLoad(name, a, b, α, β, T_p, T_q, ext, 100.0, [:x_p, :x_q], 2, InfrastructureSystemsInternal(), )
end

function DynamicExponentialLoad(; name, a, b, α, β, T_p, T_q, ext=Dict{String, Any}(), base_power=100.0, states=[:x_p, :x_q], n_states=2, internal=InfrastructureSystemsInternal(), )
    DynamicExponentialLoad(name, a, b, α, β, T_p, T_q, ext, base_power, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function DynamicExponentialLoad(::Nothing)
    DynamicExponentialLoad(;
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

"""Get [`DynamicExponentialLoad`](@ref) `name`."""
get_name(value::DynamicExponentialLoad) = value.name
"""Get [`DynamicExponentialLoad`](@ref) `a`."""
get_a(value::DynamicExponentialLoad) = value.a
"""Get [`DynamicExponentialLoad`](@ref) `b`."""
get_b(value::DynamicExponentialLoad) = value.b
"""Get [`DynamicExponentialLoad`](@ref) `α`."""
get_α(value::DynamicExponentialLoad) = value.α
"""Get [`DynamicExponentialLoad`](@ref) `β`."""
get_β(value::DynamicExponentialLoad) = value.β
"""Get [`DynamicExponentialLoad`](@ref) `T_p`."""
get_T_p(value::DynamicExponentialLoad) = value.T_p
"""Get [`DynamicExponentialLoad`](@ref) `T_q`."""
get_T_q(value::DynamicExponentialLoad) = value.T_q
"""Get [`DynamicExponentialLoad`](@ref) `ext`."""
get_ext(value::DynamicExponentialLoad) = value.ext
"""Get [`DynamicExponentialLoad`](@ref) `base_power`."""
get_base_power(value::DynamicExponentialLoad) = value.base_power
"""Get [`DynamicExponentialLoad`](@ref) `states`."""
get_states(value::DynamicExponentialLoad) = value.states
"""Get [`DynamicExponentialLoad`](@ref) `n_states`."""
get_n_states(value::DynamicExponentialLoad) = value.n_states
"""Get [`DynamicExponentialLoad`](@ref) `internal`."""
get_internal(value::DynamicExponentialLoad) = value.internal

"""Set [`DynamicExponentialLoad`](@ref) `a`."""
set_a!(value::DynamicExponentialLoad, val) = value.a = val
"""Set [`DynamicExponentialLoad`](@ref) `b`."""
set_b!(value::DynamicExponentialLoad, val) = value.b = val
"""Set [`DynamicExponentialLoad`](@ref) `α`."""
set_α!(value::DynamicExponentialLoad, val) = value.α = val
"""Set [`DynamicExponentialLoad`](@ref) `β`."""
set_β!(value::DynamicExponentialLoad, val) = value.β = val
"""Set [`DynamicExponentialLoad`](@ref) `T_p`."""
set_T_p!(value::DynamicExponentialLoad, val) = value.T_p = val
"""Set [`DynamicExponentialLoad`](@ref) `T_q`."""
set_T_q!(value::DynamicExponentialLoad, val) = value.T_q = val
"""Set [`DynamicExponentialLoad`](@ref) `ext`."""
set_ext!(value::DynamicExponentialLoad, val) = value.ext = val
"""Set [`DynamicExponentialLoad`](@ref) `base_power`."""
set_base_power!(value::DynamicExponentialLoad, val) = value.base_power = val
