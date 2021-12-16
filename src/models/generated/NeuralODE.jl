#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct NeuralODE <: DynamicInjection
        name::String
        n_layers::Int
        n_neurons::Int
        n_feedback_states::Int
        nn_parameters::Vector{Float64}
        activation_function::String
        initialize_to_zero::Bool
        base_power::Float64
        states::Vector{Symbol}
        n_states::Int
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Densely connected NODE with variable number of feedback states.

# Arguments
- `name::String`
- `n_layers::Int`: Number of hidden layers
- `n_neurons::Int`: Neurons per hidden layer
- `n_feedback_states::Int`: Number of feedback states. The total number of states equals n_feedback_states + 2 for real and imaginary output current.
- `nn_parameters::Vector{Float64}`: Weights and biases of the nn which defines the dynamics of the component
- `activation_function::String`: Activation function for input and hidden layers. Output layer has identity activation.
- `initialize_to_zero::Bool`: If true, initialize the output current to zero. Assumes the NODE was trained and will be used with another device at the same bus which accounts for steady state current to match the PF solution.
- `base_power::Float64`: Base power
- `states::Vector{Symbol}`: Real output current, imaginary output current
- `n_states::Int`
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct NeuralODE <: DynamicInjection
    name::String
    "Number of hidden layers"
    n_layers::Int
    "Neurons per hidden layer"
    n_neurons::Int
    "Number of feedback states. The total number of states equals n_feedback_states + 2 for real and imaginary output current."
    n_feedback_states::Int
    "Weights and biases of the nn which defines the dynamics of the component"
    nn_parameters::Vector{Float64}
    "Activation function for input and hidden layers. Output layer has identity activation."
    activation_function::String
    "If true, initialize the output current to zero. Assumes the NODE was trained and will be used with another device at the same bus which accounts for steady state current to match the PF solution."
    initialize_to_zero::Bool
    "Base power"
    base_power::Float64
    "Real output current, imaginary output current"
    states::Vector{Symbol}
    n_states::Int
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function NeuralODE(name, n_layers, n_neurons, n_feedback_states, nn_parameters, activation_function, initialize_to_zero, base_power=100.0, ext=Dict{String, Any}(), )
    NeuralODE(name, n_layers, n_neurons, n_feedback_states, nn_parameters, activation_function, initialize_to_zero, base_power, ext, [:Ir, :Ii], 2, InfrastructureSystemsInternal(), )
end

function NeuralODE(; name, n_layers, n_neurons, n_feedback_states, nn_parameters, activation_function, initialize_to_zero, base_power=100.0, states=[:Ir, :Ii], n_states=2, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    NeuralODE(name, n_layers, n_neurons, n_feedback_states, nn_parameters, activation_function, initialize_to_zero, base_power, states, n_states, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function NeuralODE(::Nothing)
    NeuralODE(;
        name="init",
        n_layers=0,
        n_neurons=0,
        n_feedback_states=0,
        nn_parameters=Any[0],
        activation_function="0",
        initialize_to_zero=,
        base_power=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`NeuralODE`](@ref) `name`."""
get_name(value::NeuralODE) = value.name
"""Get [`NeuralODE`](@ref) `n_layers`."""
get_n_layers(value::NeuralODE) = value.n_layers
"""Get [`NeuralODE`](@ref) `n_neurons`."""
get_n_neurons(value::NeuralODE) = value.n_neurons
"""Get [`NeuralODE`](@ref) `n_feedback_states`."""
get_n_feedback_states(value::NeuralODE) = value.n_feedback_states
"""Get [`NeuralODE`](@ref) `nn_parameters`."""
get_nn_parameters(value::NeuralODE) = value.nn_parameters
"""Get [`NeuralODE`](@ref) `activation_function`."""
get_activation_function(value::NeuralODE) = value.activation_function
"""Get [`NeuralODE`](@ref) `initialize_to_zero`."""
get_initialize_to_zero(value::NeuralODE) = value.initialize_to_zero
"""Get [`NeuralODE`](@ref) `base_power`."""
get_base_power(value::NeuralODE) = value.base_power
"""Get [`NeuralODE`](@ref) `states`."""
get_states(value::NeuralODE) = value.states
"""Get [`NeuralODE`](@ref) `n_states`."""
get_n_states(value::NeuralODE) = value.n_states
"""Get [`NeuralODE`](@ref) `ext`."""
get_ext(value::NeuralODE) = value.ext
"""Get [`NeuralODE`](@ref) `internal`."""
get_internal(value::NeuralODE) = value.internal

"""Set [`NeuralODE`](@ref) `n_layers`."""
set_n_layers!(value::NeuralODE, val) = value.n_layers = val
"""Set [`NeuralODE`](@ref) `n_neurons`."""
set_n_neurons!(value::NeuralODE, val) = value.n_neurons = val
"""Set [`NeuralODE`](@ref) `n_feedback_states`."""
set_n_feedback_states!(value::NeuralODE, val) = value.n_feedback_states = val
"""Set [`NeuralODE`](@ref) `nn_parameters`."""
set_nn_parameters!(value::NeuralODE, val) = value.nn_parameters = val
"""Set [`NeuralODE`](@ref) `activation_function`."""
set_activation_function!(value::NeuralODE, val) = value.activation_function = val
"""Set [`NeuralODE`](@ref) `initialize_to_zero`."""
set_initialize_to_zero!(value::NeuralODE, val) = value.initialize_to_zero = val
"""Set [`NeuralODE`](@ref) `base_power`."""
set_base_power!(value::NeuralODE, val) = value.base_power = val
"""Set [`NeuralODE`](@ref) `ext`."""
set_ext!(value::NeuralODE, val) = value.ext = val

