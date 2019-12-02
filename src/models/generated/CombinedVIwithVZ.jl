#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct CombinedVIwithVZ <: VSControl
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
        internal::InfrastructureSystemsInternal
    end

Parameters of an inner loop controller using virtual impedance, voltage controller and current controller.

# Arguments
- `kpv::Float64`: voltage controller proportional gain
- `kiv::Float64`: voltage controller integral gain
- `kffv::Float64`: Binary variable to enable feed-forward gain of voltage.
- `rv::Float64`: virtual resistance
- `lv::Float64`: virtual inductance
- `kpc::Float64`: current controller proportional gain
- `kic::Float64`: current controller integral gain
- `kffi::Float64`: Binary variable to enable feed-forward gain of current
- `ωad::Float64`: active damping filter cutoff frequency (rad/sec)
- `kad::Float64`: active damping gain
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct CombinedVIwithVZ <: VSControl
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
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function CombinedVIwithVZ(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext=Dict{String, Any}(), )
    CombinedVIwithVZ(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext, [:ξ_d, :ξ_q, :γ_d, :γ_q, :ϕ_d, :ϕ_q], 6, InfrastructureSystemsInternal(), )
end

function CombinedVIwithVZ(; kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext=Dict{String, Any}(), )
    CombinedVIwithVZ(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, ext, )
end

# Constructor for demo purposes; non-functional.
function CombinedVIwithVZ(::Nothing)
    CombinedVIwithVZ(;
        kpv=0,
        kiv=0,
        kffv=0,
        rv=0,
        lv=0,
        kpc=0,
        kic=0,
        kffi=0,
        ωad=0,
        kad=0,
        ext=Dict{String, Any}(),
    )
end

"""Get CombinedVIwithVZ kpv."""
get_kpv(value::CombinedVIwithVZ) = value.kpv
"""Get CombinedVIwithVZ kiv."""
get_kiv(value::CombinedVIwithVZ) = value.kiv
"""Get CombinedVIwithVZ kffv."""
get_kffv(value::CombinedVIwithVZ) = value.kffv
"""Get CombinedVIwithVZ rv."""
get_rv(value::CombinedVIwithVZ) = value.rv
"""Get CombinedVIwithVZ lv."""
get_lv(value::CombinedVIwithVZ) = value.lv
"""Get CombinedVIwithVZ kpc."""
get_kpc(value::CombinedVIwithVZ) = value.kpc
"""Get CombinedVIwithVZ kic."""
get_kic(value::CombinedVIwithVZ) = value.kic
"""Get CombinedVIwithVZ kffi."""
get_kffi(value::CombinedVIwithVZ) = value.kffi
"""Get CombinedVIwithVZ ωad."""
get_ωad(value::CombinedVIwithVZ) = value.ωad
"""Get CombinedVIwithVZ kad."""
get_kad(value::CombinedVIwithVZ) = value.kad
"""Get CombinedVIwithVZ ext."""
get_ext(value::CombinedVIwithVZ) = value.ext
"""Get CombinedVIwithVZ states."""
get_states(value::CombinedVIwithVZ) = value.states
"""Get CombinedVIwithVZ n_states."""
get_n_states(value::CombinedVIwithVZ) = value.n_states
"""Get CombinedVIwithVZ internal."""
get_internal(value::CombinedVIwithVZ) = value.internal
