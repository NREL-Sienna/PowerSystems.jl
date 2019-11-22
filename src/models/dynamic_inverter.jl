abstract type InverterComponent <: DynamicComponent end

mutable struct DynamicInverter{C<:Converter,
                               O<:OuterControl,
                               VC<:VSControl,
                               DC<:DCSource,
                               P<:FrequencyEstimator,
                               F<:Filter} <: DynInjection
    number::Int64
    name::Symbol
    bus::Bus
    ω_ref::Float64
    V_ref::Float64
    P_ref::Float64
    Q_ref::Float64
    MVABase::Float64
    converter::C
    outercontrol::O
    vscontrol::VC
    dc_source::DC
    freq_estimator::P
    filter::F #add MVAbase here
    n_states::Int64
    states::Vector{Symbol}
    inner_vars::Vector{Float64}
    local_state_ix::Dict{InverterComponent,Vector{Int64}}
    input_port_mapping::Dict{InverterComponent,Vector{Int64}}

        function DynInverter(number::Int64,
                            name::Symbol,
                            bus::Bus,
                            ω_ref::Float64,
                            V_ref::Float64,
                            P_ref::Float64,
                            Q_ref::Float64,
                            MVABase::Float64,
                            converter::C,
                            outercontrol::O,
                            vscontrol::VC,
                            dc_source::DC,
                            freq_estimator::P,
                            filter::F) where {C<:Converter,
                                              O<:OuterControl,
                                              VC<:VSControl,
                                              DC<:DCSource,
                                              P<:FrequencyEstimator,
                                              F<:Filter}

            n_states = (converter.n_states +
                       outercontrol.n_states +
                       vscontrol.n_states +
                       dc_source.n_states +
                       freq_estimator.n_states +
                       filter.n_states)

            states = vcat(converter.states,
                        outercontrol.states,
                        vscontrol.states,
                        dc_source.states,
                        freq_estimator.states,
                        filter.states)

            new{C, O, VC, DC, P, F}(number,
                                    name,
                                    bus,
                                    ω_ref,
                                    V_ref,
                                    P_ref,
                                    Q_ref,
                                    MVABase,
                                    converter,
                                    outercontrol,
                                    vscontrol,
                                    dc_source,
                                    freq_estimator,
                                    filter,
                                    n_states,
                                    states)

        end
end

get_inverter_Sbase(device::DynamicInverter) = device.converter.s_rated
get_inverter_Vref(device::DynamicInverter) = device.V_ref
