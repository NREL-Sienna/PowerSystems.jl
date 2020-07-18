mutable struct DynamicGenerator{
    M <: Machine,
    S <: Shaft,
    A <: AVR,
    TG <: TurbineGov,
    P <: PSS,
} <: DynamicInjection
    static_injector::Union{Nothing, Generator}
    ω_ref::Float64
    machine::M
    shaft::S
    avr::A
    prime_mover::TG
    pss::P
    n_states::Int64
    states::Vector{Symbol}
    ext::Dict{String, Any}
    internal::InfrastructureSystemsInternal
end

function DynamicGenerator(
    static_injector::Generator,
    ω_ref::Float64,
    machine::M,
    shaft::S,
    avr::A,
    prime_mover::TG,
    pss::P,
    ext::Dict{String, Any} = Dict{String, Any}(),
) where {M <: Machine, S <: Shaft, A <: AVR, TG <: TurbineGov, P <: PSS}

    n_states = (
        get_n_states(machine) +
        get_n_states(shaft) +
        get_n_states(avr) +
        get_n_states(prime_mover) +
        get_n_states(pss)
    )
    states = vcat(
        get_states(machine),
        get_states(shaft),
        get_states(avr),
        get_states(prime_mover),
        get_states(pss),
    )

    return DynamicGenerator{M, S, A, TG, P}(
        static_injector,
        ω_ref,
        machine,
        shaft,
        avr,
        prime_mover,
        pss,
        n_states,
        states,
        ext,
        InfrastructureSystemsInternal(),
    )
end

function DynamicGenerator(;
    static_injector::Generator,
    ω_ref::Float64,
    machine::M,
    shaft::S,
    avr::A,
    prime_mover::TG,
    pss::P,
    ext::Dict{String, Any} = Dict{String, Any}(),
) where {M <: Machine, S <: Shaft, A <: AVR, TG <: TurbineGov, P <: PSS}
    DynamicGenerator(static_injector, ω_ref, machine, shaft, avr, prime_mover, pss, ext)
end

IS.get_name(device::DynamicGenerator) = get_name(device.static_injector)
get_bus(device::DynamicGenerator) = get_bus(device.static_injector)
get_Sbase(device::DynamicGenerator) = device.machine.s_rated
get_states(device::DynamicGenerator) = device.states
get_n_states(device::DynamicGenerator) = device.n_states
get_ω_ref(device::DynamicGenerator) = device.ω_ref
get_base_power(device::DynamicGenerator) = get_base_power(device.static_injector)
get_machine(device::DynamicGenerator) = device.machine
get_shaft(device::DynamicGenerator) = device.shaft
get_avr(device::DynamicGenerator) = device.avr
get_prime_mover(device::DynamicGenerator) = device.prime_mover
get_pss(device::DynamicGenerator) = device.pss
get_static_injector(device::DynamicGenerator) = device.static_injector
get_ext(device::DynamicGenerator) = device.ext
get_internal(device::DynamicGenerator) = device.internal
get_V_ref(value::DynamicGenerator) = get_V_ref(get_avr(value))
get_P_ref(value::DynamicGenerator) = get_P_ref(get_prime_mover(value))
