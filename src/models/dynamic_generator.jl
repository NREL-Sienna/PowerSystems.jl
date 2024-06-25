"""
    mutable struct DynamicGenerator{
        M <: Machine,
        S <: Shaft,
        A <: AVR,
        TG <: TurbineGov,
        P <: PSS,
    } <: DynamicInjection
        name::String
        ω_ref::Float64
        machine::M
        shaft::S
        avr::A
        prime_mover::TG
        pss::P
        base_power::Float64
        n_states::Int
        states::Vector{Symbol}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A dynamic generator is composed by 5 components, namely a Machine, a Shaft, an Automatic Voltage Regulator (AVR),
a Prime Mover (o Turbine Governor) and Power System Stabilizer (PSS). It requires a [`StaticInjection`](@ref) device
that is attached to it.

# Arguments
- `name::String`: Name of generator.
- `ω_ref::Float64`: Frequency reference set-point in pu.
- `machine <: Machine`: Machine model for modeling the electro-magnetic phenomena.
- `shaft <: Shaft`: Shaft model for modeling the electro-mechanical phenomena.
- `avr <: AVR`: AVR model of the excitacion system.
- `prime_mover <: TurbineGov`: Prime Mover and Turbine Governor model for mechanical power.
- `pss <: PSS`: Power System Stabilizer model.
- `base_power::Float64`: Base power
- `n_states::Int`: Number of states (will depend on the components).
- `states::Vector{Symbol}`: Vector of states (will depend on the components).
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct DynamicGenerator{
    M <: Machine,
    S <: Shaft,
    A <: AVR,
    TG <: TurbineGov,
    P <: PSS,
} <: DynamicInjection
    name::String
    ω_ref::Float64
    machine::M
    shaft::S
    avr::A
    prime_mover::TG
    pss::P
    base_power::Float64
    n_states::Int
    states::Vector{Symbol}
    ext::Dict{String, Any}
    internal::InfrastructureSystemsInternal
end

function DynamicGenerator(
    name::String,
    ω_ref::Float64,
    machine::M,
    shaft::S,
    avr::A,
    prime_mover::TG,
    pss::P,
    base_power::Float64 = 100.0,
    ext::Dict{String, Any} = Dict{String, Any}(),
) where {M <: Machine, S <: Shaft, A <: AVR, TG <: TurbineGov, P <: PSS}
    n_states = _calc_n_states(machine, shaft, avr, prime_mover, pss)
    states = _calc_states(machine, shaft, avr, prime_mover, pss)

    return DynamicGenerator{M, S, A, TG, P}(
        name,
        ω_ref,
        machine,
        shaft,
        avr,
        prime_mover,
        pss,
        base_power,
        n_states,
        states,
        ext,
        InfrastructureSystemsInternal(),
    )
end

function DynamicGenerator(;
    name::String,
    ω_ref::Float64,
    machine::M,
    shaft::S,
    avr::A,
    prime_mover::TG,
    pss::P,
    base_power::Float64 = 100.0,
    n_states = _calc_n_states(machine, shaft, avr, prime_mover, pss),
    states = _calc_states(machine, shaft, avr, prime_mover, pss),
    ext::Dict{String, Any} = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
) where {M <: Machine, S <: Shaft, A <: AVR, TG <: TurbineGov, P <: PSS}
    return DynamicGenerator(
        name,
        ω_ref,
        machine,
        shaft,
        avr,
        prime_mover,
        pss,
        base_power,
        n_states,
        states,
        ext,
        internal,
    )
end

get_name(device::DynamicGenerator) = device.name
get_states(device::DynamicGenerator) = device.states
get_n_states(device::DynamicGenerator) = device.n_states
get_ω_ref(device::DynamicGenerator) = device.ω_ref
get_machine(device::DynamicGenerator) = device.machine
get_shaft(device::DynamicGenerator) = device.shaft
get_avr(device::DynamicGenerator) = device.avr
get_prime_mover(device::DynamicGenerator) = device.prime_mover
get_pss(device::DynamicGenerator) = device.pss
get_base_power(device::DynamicGenerator) = device.base_power
get_ext(device::DynamicGenerator) = device.ext
get_internal(device::DynamicGenerator) = device.internal
get_V_ref(value::DynamicGenerator) = get_V_ref(get_avr(value))
get_P_ref(value::DynamicGenerator) = get_P_ref(get_prime_mover(value))

set_base_power!(value::DynamicGenerator, val) = value.base_power = val

function _calc_n_states(machine, shaft, avr, prime_mover, pss)
    return get_n_states(machine) +
           get_n_states(shaft) +
           get_n_states(avr) +
           get_n_states(prime_mover) +
           get_n_states(pss)
end

function _calc_states(machine, shaft, avr, prime_mover, pss)
    return vcat(
        get_states(machine),
        get_states(shaft),
        get_states(avr),
        get_states(prime_mover),
        get_states(pss),
    )
end
