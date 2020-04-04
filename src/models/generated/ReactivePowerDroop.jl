#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReactivePowerDroop <: ReactivePowerControl
        kq::Float64
        ωf::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a Reactive Power droop controller

# Arguments
- `kq::Float64`: frequency droop gain, validation range: (0, nothing)
- `ωf::Float64`: filter frequency cutoff, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ReactivePowerDroop <: ReactivePowerControl
    "frequency droop gain"
    kq::Float64
    "filter frequency cutoff"
    ωf::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ReactivePowerDroop(kq, ωf, ext=Dict{String, Any}(), )
    ReactivePowerDroop(kq, ωf, ext, [:q_oc], 1, InfrastructureSystemsInternal(), )
end

function ReactivePowerDroop(; kq, ωf, ext=Dict{String, Any}(), )
    ReactivePowerDroop(kq, ωf, ext, )
end

# Constructor for demo purposes; non-functional.
function ReactivePowerDroop(::Nothing)
    ReactivePowerDroop(;
        kq=0,
        ωf=0,
        ext=Dict{String, Any}(),
    )
end

"""Get ReactivePowerDroop kq."""
get_kq(value::ReactivePowerDroop) = value.kq
"""Get ReactivePowerDroop ωf."""
get_ωf(value::ReactivePowerDroop) = value.ωf
"""Get ReactivePowerDroop ext."""
get_ext(value::ReactivePowerDroop) = value.ext
"""Get ReactivePowerDroop states."""
get_states(value::ReactivePowerDroop) = value.states
"""Get ReactivePowerDroop n_states."""
get_n_states(value::ReactivePowerDroop) = value.n_states
"""Get ReactivePowerDroop internal."""
get_internal(value::ReactivePowerDroop) = value.internal
