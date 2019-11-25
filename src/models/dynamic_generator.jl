mutable struct DynamicGenerator{M<:Machine,
                               S<:Shaft,
                               A<:AVR,
                               TG<:TurbineGov,
                               P<:PSS} <: DynamicInjection
    number::Int64
    name::Symbol
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
        function DynamicGenerator(number::Int64,
                              name::Symbol,
                              bus::Bus,
                              ω_ref::Float64,
                              V_ref::Float64,
                              P_ref::Float64,
                              machine::M,
                              shaft::S,
                              avr::A,
                              tg::TG,
                              pss::P) where {M<:Machine,
                                             S<:Shaft,
                                             A<:AVR,
                                             TG<:TurbineGov,
                                             P<:PSS}

            n_states = (machine.n_states +
                       shaft.n_states +
                       avr.n_states +
                       tg.n_states +
                       pss.n_states)

            states = vcat(machine.states,
                          shaft.states,
                          avr.states,
                          tg.states,
                          pss.states)

            new{M,S,A,TG,P}(number,
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
                            states)
        end
  end

get_Sbase(device::DynamicGenerator) = device.machine.s_rated
get_Vref(device::DynamicGenerator) = device.V_ref
