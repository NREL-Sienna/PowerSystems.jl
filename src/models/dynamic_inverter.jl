abstract type InverterComponent <: DynamicComponent end

mutable struct DynamicInverter{
    C<:Converter,
    O<:OuterControl,
    VC<:VSControl,
    DC<:DCSource,
    P<:FrequencyEstimator,
    F<:Filter,
} <: DynamicInjection
    number::Int64
    name::String
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
    ext::Dict{String,Any}
    function DynamicInverter(
        number::Int64,
        name::String,
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
        filter::F,
    ) where {
        C<:Converter,
        O<:OuterControl,
        VC<:VSControl,
        DC<:DCSource,
        P<:FrequencyEstimator,
        F<:Filter,
    }

        n_states = (
            converter.n_states +
            outercontrol.n_states +
            vscontrol.n_states +
            dc_source.n_states +
            freq_estimator.n_states +
            filter.n_states
        )

        states = vcat(
            converter.states,
            outercontrol.states,
            vscontrol.states,
            dc_source.states,
            freq_estimator.states,
            filter.states,
        )

        new{C,O,VC,DC,P,F}(
            number,
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
            states,
            Dict{String,Any}(),
        )

    end
end

get_inverter_Sbase(device::DynamicInverter) = device.converter.s_rated
get_inverter_Vref(device::DynamicInverter) = device.V_ref
get_number(device::DynamicInverter) = device.number
get_name(device::DynamicInverter) = device.name
get_ω_ref(device::DynamicInverter) = device.ω_ref
get_V_ref(device::DynamicInverter) = device.V_ref
get_P_ref(device::DynamicInverter) = device.P_ref
get_Q_ref(device::DynamicInverter) = device.Q_ref
get_bus(device::DynamicInverter) = device.bus
get_ext(device::DynamicInverter) = device.ext
get_states(device::DynamicInverter) = device.states
get_n_states(device::DynamicInverter) = device.n_states
get_converter(device::DynamicInverter) = device.converter
get_outercontrol(device::DynamicInverter) = device.outercontrol
get_vscontrol(device::DynamicInverter) = device.vscontrol
get_dc_source(device::DynamicInverter) = device.dc_source
get_freq_estimator(device::DynamicInverter) = device.freq_estimator
get_filter(device::DynamicInverter) = device.filter
