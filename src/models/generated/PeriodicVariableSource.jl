#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PeriodicVariableSource <: StaticInjection
        name::String
        available::Bool
        bus::Bus
        initial_active_power::Float64
        initial_reactive_power::Float64
        R_th::Float64
        X_th::Float64
        internal_voltage_bias::Float64
        internal_voltage_frequencies::Vector{Float64}
        internal_voltage_coefficients::Vector{Tuple{Float64,Float64}}
        internal_angle_bias::Float64
        internal_angle_frequencies::Vector{Float64}
        internal_angle_coefficients::Vector{Tuple{Float64,Float64}}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

This struct acts as an infinity bus with time varying phasor values magnitude and angle V(t) 	heta(t). Time varying functions are represented using fourier series

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `initial_active_power::Float64`
- `initial_reactive_power::Float64`
- `R_th::Float64`: Source Thevenin resistance, validation range: `(0, nothing)`
- `X_th::Float64`: Source Thevenin reactance, validation range: `(0, nothing)`
- `internal_voltage_bias::Float64`: a0 term of the Fourier Series for the voltage
- `internal_voltage_frequencies::Vector{Float64}`: Frequencies in radians/s
- `internal_voltage_coefficients::Vector{Tuple{Float64,Float64}}`: Coefficients for terms n > 1. First component corresponds to sin and second component to cos
- `internal_angle_bias::Float64`: a0 term of the Fourier Series for the angle
- `internal_angle_frequencies::Vector{Float64}`: Frequencies in radians/s
- `internal_angle_coefficients::Vector{Tuple{Float64,Float64}}`: Coefficients for terms n > 1. First component corresponds to sin and second component to cos
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PeriodicVariableSource <: StaticInjection
    name::String
    available::Bool
    bus::Bus
    initial_active_power::Float64
    initial_reactive_power::Float64
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
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PeriodicVariableSource(name, available, bus, initial_active_power, initial_reactive_power, R_th, X_th, internal_voltage_bias=0.0, internal_voltage_frequencies=[0.0], internal_voltage_coefficients=[(0.0, 0.0)], internal_angle_bias=0.0, internal_angle_frequencies=[0.0], internal_angle_coefficients=[(0.0, 0.0)], services=Device[], ext=Dict{String, Any}(), )
    PeriodicVariableSource(name, available, bus, initial_active_power, initial_reactive_power, R_th, X_th, internal_voltage_bias, internal_voltage_frequencies, internal_voltage_coefficients, internal_angle_bias, internal_angle_frequencies, internal_angle_coefficients, services, ext, InfrastructureSystemsInternal(), )
end

function PeriodicVariableSource(; name, available, bus, initial_active_power, initial_reactive_power, R_th, X_th, internal_voltage_bias=0.0, internal_voltage_frequencies=[0.0], internal_voltage_coefficients=[(0.0, 0.0)], internal_angle_bias=0.0, internal_angle_frequencies=[0.0], internal_angle_coefficients=[(0.0, 0.0)], services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    PeriodicVariableSource(name, available, bus, initial_active_power, initial_reactive_power, R_th, X_th, internal_voltage_bias, internal_voltage_frequencies, internal_voltage_coefficients, internal_angle_bias, internal_angle_frequencies, internal_angle_coefficients, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function PeriodicVariableSource(::Nothing)
    PeriodicVariableSource(;
        name="init",
        available=false,
        bus=Bus(nothing),
        initial_active_power=0.0,
        initial_reactive_power=0.0,
        R_th=0,
        X_th=0,
        internal_voltage_bias=0,
        internal_voltage_frequencies=Any[0],
        internal_voltage_coefficients=[(0.0, 0.0)],
        internal_angle_bias=0,
        internal_angle_frequencies=Any[0],
        internal_angle_coefficients=[(0.0, 0.0)],
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`PeriodicVariableSource`](@ref) `name`."""
get_name(value::PeriodicVariableSource) = value.name
"""Get [`PeriodicVariableSource`](@ref) `available`."""
get_available(value::PeriodicVariableSource) = value.available
"""Get [`PeriodicVariableSource`](@ref) `bus`."""
get_bus(value::PeriodicVariableSource) = value.bus
"""Get [`PeriodicVariableSource`](@ref) `initial_active_power`."""
get_initial_active_power(value::PeriodicVariableSource) = value.initial_active_power
"""Get [`PeriodicVariableSource`](@ref) `initial_reactive_power`."""
get_initial_reactive_power(value::PeriodicVariableSource) = value.initial_reactive_power
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
"""Get [`PeriodicVariableSource`](@ref) `services`."""
get_services(value::PeriodicVariableSource) = value.services
"""Get [`PeriodicVariableSource`](@ref) `ext`."""
get_ext(value::PeriodicVariableSource) = value.ext
"""Get [`PeriodicVariableSource`](@ref) `internal`."""
get_internal(value::PeriodicVariableSource) = value.internal

"""Set [`PeriodicVariableSource`](@ref) `name`."""
set_name!(value::PeriodicVariableSource, val) = value.name = val
"""Set [`PeriodicVariableSource`](@ref) `available`."""
set_available!(value::PeriodicVariableSource, val) = value.available = val
"""Set [`PeriodicVariableSource`](@ref) `bus`."""
set_bus!(value::PeriodicVariableSource, val) = value.bus = val
"""Set [`PeriodicVariableSource`](@ref) `initial_active_power`."""
set_initial_active_power!(value::PeriodicVariableSource, val) = value.initial_active_power = val
"""Set [`PeriodicVariableSource`](@ref) `initial_reactive_power`."""
set_initial_reactive_power!(value::PeriodicVariableSource, val) = value.initial_reactive_power = val
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
"""Set [`PeriodicVariableSource`](@ref) `services`."""
set_services!(value::PeriodicVariableSource, val) = value.services = val
"""Set [`PeriodicVariableSource`](@ref) `ext`."""
set_ext!(value::PeriodicVariableSource, val) = value.ext = val

