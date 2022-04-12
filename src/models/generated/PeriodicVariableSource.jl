#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PeriodicVariableSource <: DynamicInjection
        name::String
        R_th::Float64
        X_th::Float64
        internal_voltage_bias::Float64
        internal_voltage_frequencies::Vector{Float64}
        internal_voltage_coefficients::Vector{Tuple{Float64,Float64}}
        internal_angle_bias::Float64
        internal_angle_frequencies::Vector{Float64}
        internal_angle_coefficients::Vector{Tuple{Float64,Float64}}
        base_power::Float64
        states::Vector{Symbol}
        n_states::Int
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

This struct acts as an infinity bus with time varying phasor values magnitude and angle V(t) 	heta(t). Time varying functions are represented using fourier series

# Arguments
- `name::String`
- `R_th::Float64`: Source Thevenin resistance, validation range: `(0, nothing)`
- `X_th::Float64`: Source Thevenin reactance, validation range: `(0, nothing)`
- `internal_voltage_bias::Float64`: a0 term of the Fourier Series for the voltage
- `internal_voltage_frequencies::Vector{Float64}`: Frequencies in radians/s
- `internal_voltage_coefficients::Vector{Tuple{Float64,Float64}}`: Coefficients for terms n > 1. First component corresponds to sin and second component to cos
- `internal_angle_bias::Float64`: a0 term of the Fourier Series for the angle
- `internal_angle_frequencies::Vector{Float64}`: Frequencies in radians/s
- `internal_angle_coefficients::Vector{Tuple{Float64,Float64}}`: Coefficients for terms n > 1. First component corresponds to sin and second component to cos
- `base_power::Float64`: Base power
- `states::Vector{Symbol}`: State for time, voltage and angle
- `n_states::Int`
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PeriodicVariableSource <: DynamicInjection
    name::String
    "Source Thevenin resistance"
    R_th::Float64
    "Source Thevenin reactance"
    X_th::Float64
    "a0 term of the Fourier Series for the voltage"
    internal_voltage_bias::Float64
    "Frequencies in radians/s"
    internal_voltage_frequencies::Vector{Float64}
    "Coefficients for terms n > 1. First component corresponds to sin and second component to cos"
    internal_voltage_coefficients::Vector{Tuple{Float64,Float64}}
    "a0 term of the Fourier Series for the angle"
    internal_angle_bias::Float64
    "Frequencies in radians/s"
    internal_angle_frequencies::Vector{Float64}
    "Coefficients for terms n > 1. First component corresponds to sin and second component to cos"
    internal_angle_coefficients::Vector{Tuple{Float64,Float64}}
    "Base power"
    base_power::Float64
    "State for time, voltage and angle"
    states::Vector{Symbol}
    n_states::Int
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PeriodicVariableSource(name, R_th, X_th, internal_voltage_bias=0.0, internal_voltage_frequencies=[0.0], internal_voltage_coefficients=[(0.0, 0.0)], internal_angle_bias=0.0, internal_angle_frequencies=[0.0], internal_angle_coefficients=[(0.0, 0.0)], base_power=100.0, ext=Dict{String, Any}(), )
    PeriodicVariableSource(name, R_th, X_th, internal_voltage_bias, internal_voltage_frequencies, internal_voltage_coefficients, internal_angle_bias, internal_angle_frequencies, internal_angle_coefficients, base_power, ext, [:Vt, :θt], 2, InfrastructureSystemsInternal(), )
end

function PeriodicVariableSource(; name, R_th, X_th, internal_voltage_bias=0.0, internal_voltage_frequencies=[0.0], internal_voltage_coefficients=[(0.0, 0.0)], internal_angle_bias=0.0, internal_angle_frequencies=[0.0], internal_angle_coefficients=[(0.0, 0.0)], base_power=100.0, states=[:Vt, :θt], n_states=2, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    PeriodicVariableSource(name, R_th, X_th, internal_voltage_bias, internal_voltage_frequencies, internal_voltage_coefficients, internal_angle_bias, internal_angle_frequencies, internal_angle_coefficients, base_power, states, n_states, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function PeriodicVariableSource(::Nothing)
    PeriodicVariableSource(;
        name="init",
        R_th=0,
        X_th=0,
        internal_voltage_bias=0,
        internal_voltage_frequencies=Any[0],
        internal_voltage_coefficients=[(0.0, 0.0)],
        internal_angle_bias=0,
        internal_angle_frequencies=Any[0],
        internal_angle_coefficients=[(0.0, 0.0)],
        base_power=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PeriodicVariableSource`](@ref) `name`."""
get_name(value::PeriodicVariableSource) = value.name
"""Get [`PeriodicVariableSource`](@ref) `R_th`."""
get_R_th(value::PeriodicVariableSource) = value.R_th
"""Get [`PeriodicVariableSource`](@ref) `X_th`."""
get_X_th(value::PeriodicVariableSource) = value.X_th
"""Get [`PeriodicVariableSource`](@ref) `internal_voltage_bias`."""
get_internal_voltage_bias(value::PeriodicVariableSource) = value.internal_voltage_bias
"""Get [`PeriodicVariableSource`](@ref) `internal_voltage_frequencies`."""
get_internal_voltage_frequencies(value::PeriodicVariableSource) = value.internal_voltage_frequencies
"""Get [`PeriodicVariableSource`](@ref) `internal_voltage_coefficients`."""
get_internal_voltage_coefficients(value::PeriodicVariableSource) = value.internal_voltage_coefficients
"""Get [`PeriodicVariableSource`](@ref) `internal_angle_bias`."""
get_internal_angle_bias(value::PeriodicVariableSource) = value.internal_angle_bias
"""Get [`PeriodicVariableSource`](@ref) `internal_angle_frequencies`."""
get_internal_angle_frequencies(value::PeriodicVariableSource) = value.internal_angle_frequencies
"""Get [`PeriodicVariableSource`](@ref) `internal_angle_coefficients`."""
get_internal_angle_coefficients(value::PeriodicVariableSource) = value.internal_angle_coefficients
"""Get [`PeriodicVariableSource`](@ref) `base_power`."""
get_base_power(value::PeriodicVariableSource) = value.base_power
"""Get [`PeriodicVariableSource`](@ref) `states`."""
get_states(value::PeriodicVariableSource) = value.states
"""Get [`PeriodicVariableSource`](@ref) `n_states`."""
get_n_states(value::PeriodicVariableSource) = value.n_states
"""Get [`PeriodicVariableSource`](@ref) `ext`."""
get_ext(value::PeriodicVariableSource) = value.ext
"""Get [`PeriodicVariableSource`](@ref) `internal`."""
get_internal(value::PeriodicVariableSource) = value.internal

"""Set [`PeriodicVariableSource`](@ref) `R_th`."""
set_R_th!(value::PeriodicVariableSource, val) = value.R_th = val
"""Set [`PeriodicVariableSource`](@ref) `X_th`."""
set_X_th!(value::PeriodicVariableSource, val) = value.X_th = val
"""Set [`PeriodicVariableSource`](@ref) `internal_voltage_bias`."""
set_internal_voltage_bias!(value::PeriodicVariableSource, val) = value.internal_voltage_bias = val
"""Set [`PeriodicVariableSource`](@ref) `internal_voltage_frequencies`."""
set_internal_voltage_frequencies!(value::PeriodicVariableSource, val) = value.internal_voltage_frequencies = val
"""Set [`PeriodicVariableSource`](@ref) `internal_voltage_coefficients`."""
set_internal_voltage_coefficients!(value::PeriodicVariableSource, val) = value.internal_voltage_coefficients = val
"""Set [`PeriodicVariableSource`](@ref) `internal_angle_bias`."""
set_internal_angle_bias!(value::PeriodicVariableSource, val) = value.internal_angle_bias = val
"""Set [`PeriodicVariableSource`](@ref) `internal_angle_frequencies`."""
set_internal_angle_frequencies!(value::PeriodicVariableSource, val) = value.internal_angle_frequencies = val
"""Set [`PeriodicVariableSource`](@ref) `internal_angle_coefficients`."""
set_internal_angle_coefficients!(value::PeriodicVariableSource, val) = value.internal_angle_coefficients = val
"""Set [`PeriodicVariableSource`](@ref) `base_power`."""
set_base_power!(value::PeriodicVariableSource, val) = value.base_power = val
"""Set [`PeriodicVariableSource`](@ref) `ext`."""
set_ext!(value::PeriodicVariableSource, val) = value.ext = val

