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
        name::String
        ω_ref::Float64
        converter::C
        outer_control::O
        inner_control::IC
        dc_source::DC
        freq_estimator::P
        filter::F
        n_states::Int
        states::Vector{Symbol}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A dynamic inverter is composed by 6 components, namely a Converter, an Outer Control, an Inner Control,
a DC Source, a Frequency Estimator and a Filter. It requires a Static Injection device that is attached to it.

# Arguments
- `name::String`: Name of inverter.
- `ω_ref::Float64`: Frequency reference set-point in pu.
- `converter <: Converter`: Converter model for the PWM transformation.
- `outer_control <: OuterControl`: Outer-control controller model.
- `inner_control <: InnerControl`: Inner-control controller model.
- `dc_source <: DCSource`: DC Source model.
- `freq_estimator <: FrequencyEstimator`: Frequency Estimator (typically a PLL) model.
- `filter <: Filter`: Filter model.
- `n_states::Int`: Number of states (will depend on the components).
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
    name::String
    ω_ref::Float64
    converter::C
    outer_control::O
    inner_control::IC
    dc_source::DC
    freq_estimator::P
    filter::F
    n_states::Int
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
    n_states = _calc_n_states(
        converter,
        outer_control,
        inner_control,
        dc_source,
        freq_estimator,
        filter,
    )
    states = _calc_states(
        converter,
        outer_control,
        inner_control,
        dc_source,
        freq_estimator,
        filter,
    )

    return DynamicInverter{C, O, IC, DC, P, F}(
        get_name(static_injector),
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
    name::Union{String, StaticInjection},
    ω_ref::Float64,
    converter::C,
    outer_control::O,
    inner_control::IC,
    dc_source::DC,
    freq_estimator::P,
    filter::F,
    n_states = nothing,
    states = nothing,
    ext::Dict{String, Any} = Dict{String, Any}(),
    internal = IS.InfrastructureSystemsInternal(),
) where {
    C <: Converter,
    O <: OuterControl,
    IC <: InnerControl,
    DC <: DCSource,
    P <: FrequencyEstimator,
    F <: Filter,
}
    if name isa StaticInjection
        name = get_name(name)
    end
    if isnothing(n_states)
        @assert isnothing(states)
        n_states = _calc_n_states(
            converter,
            outer_control,
            inner_control,
            dc_source,
            freq_estimator,
            filter,
        )
        states = _calc_states(
            converter,
            outer_control,
            inner_control,
            dc_source,
            freq_estimator,
            filter,
        )
    else
        @assert !isnothing(states)
    end

    DynamicInverter(
        name,
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
        internal,
    )
end

IS.get_name(device::DynamicInverter) = device.name
get_inverter_Sbase(device::DynamicInverter) = device.converter.s_rated
get_ω_ref(device::DynamicInverter) = device.ω_ref
get_ext(device::DynamicInverter) = device.ext
get_states(device::DynamicInverter) = device.states
get_n_states(device::DynamicInverter) = device.n_states
get_converter(device::DynamicInverter) = device.converter
get_outer_control(device::DynamicInverter) = device.outer_control
get_inner_control(device::DynamicInverter) = device.inner_control
get_dc_source(device::DynamicInverter) = device.dc_source
get_freq_estimator(device::DynamicInverter) = device.freq_estimator
get_filter(device::DynamicInverter) = device.filter
get_internal(device::DynamicInverter) = device.internal
get_P_ref(value::DynamicInverter) = get_P_ref(get_active_power(get_outer_control(value)))
get_V_ref(value::DynamicInverter) = get_V_ref(get_reactive_power(get_outer_control(value)))

function _calc_n_states(
    converter,
    outer_control,
    inner_control,
    dc_source,
    freq_estimator,
    filter,
)
    return converter.n_states +
           outer_control.n_states +
           inner_control.n_states +
           dc_source.n_states +
           freq_estimator.n_states +
           filter.n_states
end

function _calc_states(
    converter,
    outer_control,
    inner_control,
    dc_source,
    freq_estimator,
    filter,
)
    return vcat(
        converter.states,
        outer_control.states,
        inner_control.states,
        dc_source.states,
        freq_estimator.states,
        filter.states,
    )
end
