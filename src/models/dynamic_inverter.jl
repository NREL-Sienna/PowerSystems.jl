abstract type InverterComponent <: DynamicComponent end

"""
    mutable struct DynamicInverter{
        C <: Converter,
        O <: OuterControl,
        IC <: InnerControl,
        DC <: DCSource,
        P <: FrequencyEstimator,
        F <: Filter,
    } <: DynamicInjection
        static_injector::Union{Nothing, StaticInjection}
        ω_ref::Float64
        converter::C
        outer_control::O
        inner_control::IC
        dc_source::DC
        freq_estimator::P
        filter::F
        n_states::Int64
        states::Vector{Symbol}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A dynamic inverter is composed by 6 components, namely a Converter, an Outer Control, an Inner Control,
a DC Source, a Frequency Estimator and a Filter. It requires a Static Injection device that is attached to it.

# Arguments
- `static_injector::Union{Nothing, StaticInjection}`: Static Injector attached to the dynamic inverter.
- `ω_ref::Float64`: Frequency reference set-point in pu.
- `converter <: Converter`: Converter model for the PWM transformation.
- `outer_control <: OuterControl`: Outer-control controller model.
- `inner_control <: InnerControl`: Inner-control controller model.
- `dc_source <: DCSource`: DC Source model.
- `freq_estimator <: FrequencyEstimator`: Frequency Estimator (typically a PLL) model.
- `filter <: Filter`: Filter model.
- `n_states::Int64`: Number of states (will depend on the components).
- `states::Vector{Symbol}`: Vector of states (will depend on the components).
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct DynamicInverter{
    C <: Converter,
    O <: OuterControl,
    IC <: InnerControl,
    DC <: DCSource,
    P <: FrequencyEstimator,
    F <: Filter,
} <: DynamicInjection
    static_injector::Union{Nothing, StaticInjection}
    ω_ref::Float64
    converter::C
    outer_control::O
    inner_control::IC
    dc_source::DC
    freq_estimator::P
    filter::F
    n_states::Int64
    states::Vector{Symbol}
    ext::Dict{String, Any}
    internal::InfrastructureSystemsInternal
end

function DynamicInverter(
    static_injector::StaticInjection,
    ω_ref::Float64,
    converter::C,
    outer_control::O,
    inner_control::IC,
    dc_source::DC,
    freq_estimator::P,
    filter::F,
    ext::Dict{String, Any} = Dict{String, Any}(),
) where {
    C <: Converter,
    O <: OuterControl,
    IC <: InnerControl,
    DC <: DCSource,
    P <: FrequencyEstimator,
    F <: Filter,
}

    n_states = (
        converter.n_states +
        outer_control.n_states +
        inner_control.n_states +
        dc_source.n_states +
        freq_estimator.n_states +
        filter.n_states
    )

    states = vcat(
        converter.states,
        outer_control.states,
        inner_control.states,
        dc_source.states,
        freq_estimator.states,
        filter.states,
    )

    return DynamicInverter{C, O, IC, DC, P, F}(
        static_injector,
        ω_ref,
        converter,
        outer_control,
        inner_control,
        dc_source,
        freq_estimator,
        filter,
        n_states,
        states,
        ext,
        InfrastructureSystemsInternal(),
    )
end

function DynamicInverter(;
    static_injector::StaticInjection,
    ω_ref::Float64,
    converter::C,
    outer_control::O,
    inner_control::IC,
    dc_source::DC,
    freq_estimator::P,
    filter::F,
    ext::Dict{String, Any} = Dict{String, Any}(),
) where {
    C <: Converter,
    O <: OuterControl,
    IC <: InnerControl,
    DC <: DCSource,
    P <: FrequencyEstimator,
    F <: Filter,
}
    DynamicInverter(
        static_injector,
        ω_ref,
        converter,
        outer_control,
        inner_control,
        dc_source,
        freq_estimator,
        filter,
        ext,
    )
end

IS.get_name(device::DynamicInverter) = get_name(device.static_injector)
get_bus(device::DynamicInverter) = get_bus(device.static_injector)
get_inverter_Sbase(device::DynamicInverter) = device.converter.s_rated
get_ω_ref(device::DynamicInverter) = device.ω_ref
get_base_power(device::DynamicInverter) = get_base_power(device.static_injector)
get_ext(device::DynamicInverter) = device.ext
get_states(device::DynamicInverter) = device.states
get_n_states(device::DynamicInverter) = device.n_states
get_converter(device::DynamicInverter) = device.converter
get_outer_control(device::DynamicInverter) = device.outer_control
get_inner_control(device::DynamicInverter) = device.inner_control
get_dc_source(device::DynamicInverter) = device.dc_source
get_freq_estimator(device::DynamicInverter) = device.freq_estimator
get_filter(device::DynamicInverter) = device.filter
get_static_injector(device::DynamicInverter) = device.static_injector
get_internal(device::DynamicInverter) = device.internal
get_P_ref(value::DynamicInverter) = get_P_ref(get_active_power(get_outer_control(value)))
get_V_ref(value::DynamicInverter) = get_V_ref(get_reactive_power(get_outer_control(value)))
