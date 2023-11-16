#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InnerControlBESS <: InnerControl
        k_soc::Float64
        kd_pc::Float64
        kd_ic::Float64
        kq_pc::Float64
        kq_ic::Float64
        T_lpf::Float64
        K_m::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of an inner loop from https://ieeexplore.ieee.org/document/9166575.

# Arguments
- `k_soc::Float64`: SoC compensation gain, validation range: `(0, nothing)`
- `kd_pc::Float64`: Current controller d-axis proportional gain, validation range: `(0, nothing)`
- `kd_ic::Float64`: Current controller d-axis integral gain, validation range: `(0, nothing)`
- `kq_pc::Float64`: Current controller q-axis proportional gain, validation range: `(0, nothing)`
- `kq_ic::Float64`: Current controller q-axis integral gain, validation range: `(0, nothing)`
- `T_lpf::Float64`: DC voltage low pass filter time constant (s)., validation range: `(0, nothing)`
- `K_m::Float64`: Modulation Gain., validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the InnerControlBESS model are:
	vdc_m: measured dc-voltage,
	γd_ic: d-axis integrator state of the PI current controller,
	γq_ic: q-axis integrator state of the PI current controller,
	soc: state of charge internal state
- `n_states::Int`: InnerControlBESS has 4 states
"""
mutable struct InnerControlBESS <: InnerControl
    "SoC compensation gain"
    k_soc::Float64
    "Current controller d-axis proportional gain"
    kd_pc::Float64
    "Current controller d-axis integral gain"
    kd_ic::Float64
    "Current controller q-axis proportional gain"
    kq_pc::Float64
    "Current controller q-axis integral gain"
    kq_ic::Float64
    "DC voltage low pass filter time constant (s)."
    T_lpf::Float64
    "Modulation Gain."
    K_m::Float64
    ext::Dict{String, Any}
    "The states of the InnerControlBESS model are:
	vdc_m: measured dc-voltage,
	γd_ic: d-axis integrator state of the PI current controller,
	γq_ic: q-axis integrator state of the PI current controller,
	soc: state of charge internal state"
    states::Vector{Symbol}
    "InnerControlBESS has 4 states"
    n_states::Int
end

function InnerControlBESS(k_soc, kd_pc, kd_ic, kq_pc, kq_ic, T_lpf, K_m, ext=Dict{String, Any}(), )
    InnerControlBESS(k_soc, kd_pc, kd_ic, kq_pc, kq_ic, T_lpf, K_m, ext, [:vdc_m, :γd_ic, :γq_ic, :soc], 4, )
end

function InnerControlBESS(; k_soc, kd_pc, kd_ic, kq_pc, kq_ic, T_lpf, K_m, ext=Dict{String, Any}(), states=[:vdc_m, :γd_ic, :γq_ic, :soc], n_states=4, )
    InnerControlBESS(k_soc, kd_pc, kd_ic, kq_pc, kq_ic, T_lpf, K_m, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function InnerControlBESS(::Nothing)
    InnerControlBESS(;
        k_soc=0,
        kd_pc=0,
        kd_ic=0,
        kq_pc=0,
        kq_ic=0,
        T_lpf=0,
        K_m=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`InnerControlBESS`](@ref) `k_soc`."""
get_k_soc(value::InnerControlBESS) = value.k_soc
"""Get [`InnerControlBESS`](@ref) `kd_pc`."""
get_kd_pc(value::InnerControlBESS) = value.kd_pc
"""Get [`InnerControlBESS`](@ref) `kd_ic`."""
get_kd_ic(value::InnerControlBESS) = value.kd_ic
"""Get [`InnerControlBESS`](@ref) `kq_pc`."""
get_kq_pc(value::InnerControlBESS) = value.kq_pc
"""Get [`InnerControlBESS`](@ref) `kq_ic`."""
get_kq_ic(value::InnerControlBESS) = value.kq_ic
"""Get [`InnerControlBESS`](@ref) `T_lpf`."""
get_T_lpf(value::InnerControlBESS) = value.T_lpf
"""Get [`InnerControlBESS`](@ref) `K_m`."""
get_K_m(value::InnerControlBESS) = value.K_m
"""Get [`InnerControlBESS`](@ref) `ext`."""
get_ext(value::InnerControlBESS) = value.ext
"""Get [`InnerControlBESS`](@ref) `states`."""
get_states(value::InnerControlBESS) = value.states
"""Get [`InnerControlBESS`](@ref) `n_states`."""
get_n_states(value::InnerControlBESS) = value.n_states

"""Set [`InnerControlBESS`](@ref) `k_soc`."""
set_k_soc!(value::InnerControlBESS, val) = value.k_soc = val
"""Set [`InnerControlBESS`](@ref) `kd_pc`."""
set_kd_pc!(value::InnerControlBESS, val) = value.kd_pc = val
"""Set [`InnerControlBESS`](@ref) `kd_ic`."""
set_kd_ic!(value::InnerControlBESS, val) = value.kd_ic = val
"""Set [`InnerControlBESS`](@ref) `kq_pc`."""
set_kq_pc!(value::InnerControlBESS, val) = value.kq_pc = val
"""Set [`InnerControlBESS`](@ref) `kq_ic`."""
set_kq_ic!(value::InnerControlBESS, val) = value.kq_ic = val
"""Set [`InnerControlBESS`](@ref) `T_lpf`."""
set_T_lpf!(value::InnerControlBESS, val) = value.T_lpf = val
"""Set [`InnerControlBESS`](@ref) `K_m`."""
set_K_m!(value::InnerControlBESS, val) = value.K_m = val
"""Set [`InnerControlBESS`](@ref) `ext`."""
set_ext!(value::InnerControlBESS, val) = value.ext = val
