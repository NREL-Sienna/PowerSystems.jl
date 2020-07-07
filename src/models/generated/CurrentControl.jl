#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct CurrentControl <: InnerControl
        kpv::Float64
        kiv::Float64
        kffv::Float64
        rv::Float64
        lv::Float64
        kpc::Float64
        kic::Float64
        kffi::Float64
        ωad::Float64
        kad::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of an inner loop current control PID using virtual impedance based on D'Arco, Suul and Fosso.
"A Virtual Synchronous Machine implementation for distributed control of power converters in SmartGrids."
Electric Power Systems Research 122 (2015) 180–197.

# Arguments
- `kpv::Float64`: voltage controller proportional gain, validation range: (0, nothing)
- `kiv::Float64`: voltage controller integral gain, validation range: (0, nothing)
- `kffv::Float64`: Binary variable to enable feed-forward gain of voltage., validation range: (0, nothing)
- `rv::Float64`: virtual resistance, validation range: (0, nothing)
- `lv::Float64`: virtual inductance, validation range: (0, nothing)
- `kpc::Float64`: current controller proportional gain, validation range: (0, nothing)
- `kic::Float64`: current controller integral gain, validation range: (0, nothing)
- `kffi::Float64`: Binary variable to enable feed-forward gain of current, validation range: (0, nothing)
- `ωad::Float64`: active damping filter cutoff frequency (rad/sec), validation range: (0, nothing)
- `kad::Float64`: active damping gain, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the VirtualInertia model are:
	ξd_ic: d-axis integrator state of the PI voltage controller,
	ξq_ic: q-axis integrator state of the PI voltage controller,
	γd_ic: d-axis integrator state of the PI current controller,
	γq_ic: q-axis integrator state of the PI current controller,
	ϕd_ic: d-axis low-pass filter of active damping,
	ϕq_ic: q-axis low-pass filter of active damping
- `n_states::Int64`: CurrentControl has 6 states
"""
mutable struct CurrentControl <: InnerControl
    "voltage controller proportional gain"
    kpv::Float64
    "voltage controller integral gain"
    kiv::Float64
    "Binary variable to enable feed-forward gain of voltage."
    kffv::Float64
    "virtual resistance"
    rv::Float64
    "virtual inductance"
    lv::Float64
    "current controller proportional gain"
    kpc::Float64
    "current controller integral gain"
    kic::Float64
    "Binary variable to enable feed-forward gain of current"
    kffi::Float64
    "active damping filter cutoff frequency (rad/sec)"
    ωad::Float64
    "active damping gain"
    kad::Float64
    ext::Dict{String, Any}
    "The states of the VirtualInertia model are:
	ξd_ic: d-axis integrator state of the PI voltage controller,
	ξq_ic: q-axis integrator state of the PI voltage controller,
	γd_ic: d-axis integrator state of the PI current controller,
	γq_ic: q-axis integrator state of the PI current controller,
	ϕd_ic: d-axis low-pass filter of active damping,
	ϕq_ic: q-axis low-pass filter of active damping"
    states::Vector{Symbol}
    "CurrentControl has 6 states"
    n_states::Int64
end

function CurrentControl(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext=Dict{String, Any}(), )
    CurrentControl(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext, [:ξd_ic, :ξq_ic, :γd_ic, :γq_ic, :ϕd_ic, :ϕq_ic], 6, )
end

function CurrentControl(; kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext=Dict{String, Any}(), )
    CurrentControl(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext, )
end

# Constructor for demo purposes; non-functional.
function CurrentControl(::Nothing)
    CurrentControl(;
        kpv=0.0,
        kiv=0.0,
        kffv=0.0,
        rv=0.0,
        lv=0.0,
        kpc=0.0,
        kic=0.0,
        kffi=0.0,
        ωad=0.0,
        kad=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get CurrentControl kpv."""
get_kpv(value::CurrentControl) = value.kpv
"""Get CurrentControl kiv."""
get_kiv(value::CurrentControl) = value.kiv
"""Get CurrentControl kffv."""
get_kffv(value::CurrentControl) = value.kffv
"""Get CurrentControl rv."""
get_rv(value::CurrentControl) = value.rv
"""Get CurrentControl lv."""
get_lv(value::CurrentControl) = value.lv
"""Get CurrentControl kpc."""
get_kpc(value::CurrentControl) = value.kpc
"""Get CurrentControl kic."""
get_kic(value::CurrentControl) = value.kic
"""Get CurrentControl kffi."""
get_kffi(value::CurrentControl) = value.kffi
"""Get CurrentControl ωad."""
get_ωad(value::CurrentControl) = value.ωad
"""Get CurrentControl kad."""
get_kad(value::CurrentControl) = value.kad
"""Get CurrentControl ext."""
get_ext(value::CurrentControl) = value.ext
"""Get CurrentControl states."""
get_states(value::CurrentControl) = value.states
"""Get CurrentControl n_states."""
get_n_states(value::CurrentControl) = value.n_states

"""Set CurrentControl kpv."""
set_kpv!(value::CurrentControl, val::Float64) = value.kpv = val
"""Set CurrentControl kiv."""
set_kiv!(value::CurrentControl, val::Float64) = value.kiv = val
"""Set CurrentControl kffv."""
set_kffv!(value::CurrentControl, val::Float64) = value.kffv = val
"""Set CurrentControl rv."""
set_rv!(value::CurrentControl, val::Float64) = value.rv = val
"""Set CurrentControl lv."""
set_lv!(value::CurrentControl, val::Float64) = value.lv = val
"""Set CurrentControl kpc."""
set_kpc!(value::CurrentControl, val::Float64) = value.kpc = val
"""Set CurrentControl kic."""
set_kic!(value::CurrentControl, val::Float64) = value.kic = val
"""Set CurrentControl kffi."""
set_kffi!(value::CurrentControl, val::Float64) = value.kffi = val
"""Set CurrentControl ωad."""
set_ωad!(value::CurrentControl, val::Float64) = value.ωad = val
"""Set CurrentControl kad."""
set_kad!(value::CurrentControl, val::Float64) = value.kad = val
"""Set CurrentControl ext."""
set_ext!(value::CurrentControl, val::Dict{String, Any}) = value.ext = val
"""Set CurrentControl states."""
set_states!(value::CurrentControl, val::Vector{Symbol}) = value.states = val
"""Set CurrentControl n_states."""
set_n_states!(value::CurrentControl, val::Int64) = value.n_states = val
