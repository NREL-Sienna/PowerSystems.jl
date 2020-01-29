mutable struct DynamicGenerator{
    M<:Machine,
    S<:Shaft,
    A<:AVR,
    TG<:TurbineGov,
    P<:PSS,
} <: DynamicInjection
    number::Int64
    name::String
    bus::Bus
    ω_ref::Float64
    V_ref::Float64
    P_ref::Float64
    machine::M
    shaft::S
    avr::A
    tg::TG
    pss::P
    n_states::Int64
    states::Vector{Symbol}
    ext::Dict{String, Any}
    function DynamicGenerator(
        number::Int64,
        name::String,
        bus::Bus,
        ω_ref::Float64,
        V_ref::Float64,
        P_ref::Float64,
        machine::M,
        shaft::S,
        avr::A,
        tg::TG,
        pss::P,
    ) where {M<:Machine, S<:Shaft, A<:AVR, TG<:TurbineGov, P<:PSS}

        n_states = (machine.n_states + shaft.n_states + avr.n_states + tg.n_states +
                    pss.n_states)

        states = vcat(machine.states, shaft.states, avr.states, tg.states, pss.states)

        new{M,S,A,TG,P}(
            number,
            name,
            bus,
            ω_ref,
            V_ref,
            P_ref,
            machine,
            shaft,
            avr,
            tg,
            pss,
            n_states,
            states,
            Dict{String, Any}()
        )
    end
end

get_Sbase(device::DynamicGenerator) = device.machine.s_rated
get_bus(device::DynamicGenerator) = device.bus
get_states(device::DynamicGenerator) = device.states
get_n_states(device::DynamicGenerator) = device.n_states
get_number(device::DynamicGenerator) = device.number
get_name(device::DynamicGenerator) = device.name
get_ω_ref(device::DynamicGenerator)  = device.ω_ref
get_V_ref(device::DynamicGenerator) = device.V_ref
get_P_ref(device::DynamicGenerator) = device.P_ref
get_machine(device::DynamicGenerator) = device.machine
get_shaft(device::DynamicGenerator) = device.shaft
get_avr(device::DynamicGenerator) = device.avr
get_tg(device::DynamicGenerator) = device.tg
get_pss(device::DynamicGenerator) = device.pss
get_ext(device::DynamicGenerator) = device.ext
