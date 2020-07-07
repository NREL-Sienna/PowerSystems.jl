#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Reactive_powerDroop <: Reactive_powerControl
        kq::Float64
        ωf::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of a Reactive Power droop controller

# Arguments
- `kq::Float64`: frequency droop gain, validation range: (0, nothing)
- `ωf::Float64`: filter frequency cutoff, validation range: (0, nothing)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
"""
mutable struct Reactive_powerDroop <: Reactive_powerControl
    "frequency droop gain"
    kq::Float64
    "filter frequency cutoff"
    ωf::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
end

function Reactive_powerDroop(kq, ωf, V_ref=1.0, ext=Dict{String, Any}(), )
    Reactive_powerDroop(kq, ωf, V_ref, ext, [:q_oc], 1, )
end

function Reactive_powerDroop(; kq, ωf, V_ref=1.0, ext=Dict{String, Any}(), )
    Reactive_powerDroop(kq, ωf, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function Reactive_powerDroop(::Nothing)
    Reactive_powerDroop(;
        kq=0.0,
        ωf=0.0,
        V_ref=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get Reactive_powerDroop kq."""
get_kq(value::Reactive_powerDroop) = value.kq
"""Get Reactive_powerDroop ωf."""
get_ωf(value::Reactive_powerDroop) = value.ωf
"""Get Reactive_powerDroop V_ref."""
get_V_ref(value::Reactive_powerDroop) = value.V_ref
"""Get Reactive_powerDroop ext."""
get_ext(value::Reactive_powerDroop) = value.ext
"""Get Reactive_powerDroop states."""
get_states(value::Reactive_powerDroop) = value.states
"""Get Reactive_powerDroop n_states."""
get_n_states(value::Reactive_powerDroop) = value.n_states

"""Set Reactive_powerDroop kq."""
set_kq!(value::Reactive_powerDroop, val::Float64) = value.kq = val
"""Set Reactive_powerDroop ωf."""
set_ωf!(value::Reactive_powerDroop, val::Float64) = value.ωf = val
"""Set Reactive_powerDroop V_ref."""
set_V_ref!(value::Reactive_powerDroop, val::Float64) = value.V_ref = val
"""Set Reactive_powerDroop ext."""
set_ext!(value::Reactive_powerDroop, val::Dict{String, Any}) = value.ext = val
"""Set Reactive_powerDroop states."""
set_states!(value::Reactive_powerDroop, val::Vector{Symbol}) = value.states = val
"""Set Reactive_powerDroop n_states."""
set_n_states!(value::Reactive_powerDroop, val::Int64) = value.n_states = val
