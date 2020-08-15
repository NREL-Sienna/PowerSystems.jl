#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct IEEEST <: PSS
        input_code::Int
        remote_bus_control::Int
        A1::Float64
        A2::Float64
        A3::Float64
        A4::Float64
        A5::Float64
        A6::Float64
        T1::Float64
        T2::Float64
        T3::Float64
        T4::Float64
        T5::Float64
        T6::Float64
        Ks::Float64
        Ls_lim::Tuple{Float64, Float64}
        Vcu::Float64
        Vcl::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

IEEE Stabilizing Model PSS. 

# Arguments
- `input_code::Int`: Code input for stabilizar, validation range: (1, 6)
- `remote_bus_control::Int`: Remot  Bus number for control.
- `A1::Float64`: Filter coefficient, validation range: (0, nothing)
- `A2::Float64`: Filter coefficient, validation range: (0, nothing)
- `A3::Float64`: Filter coefficient, validation range: (0, nothing)
- `A4::Float64`: Filter coefficient, validation range: (0, nothing)
- `A5::Float64`: Filter coefficient, validation range: (0, nothing)
- `A6::Float64`: Filter coefficient, validation range: (0, nothing)
- `T1::Float64`: Time constant, validation range: (0, 10), action if invalid: warn
- `T2::Float64`: Time constant, validation range: (0, 10), action if invalid: warn
- `T3::Float64`: Time constant, validation range: (0, 10), action if invalid: warn
- `T4::Float64`: Time constant, validation range: (0, 10), action if invalid: warn
- `T5::Float64`: Time constant, validation range: (0, 10), action if invalid: warn
- `T6::Float64`: Time constant, validation range: (&quot;eps()&quot;, &quot;2.0&quot;), action if invalid: error
- `Ks::Float64`: Proportional gain, validation range: (0, nothing)
- `Ls_lim::Tuple{Float64, Float64}`: PSS output limits for regulator output (Va_min, Va_max)
- `Vcu::Float64`: Cutoff limiter upper bound, validation range: (0, &quot;1.25&quot;), action if invalid: error
- `Vcl::Float64`: Cutoff limiter lower bound, validation range: (0, &quot;1.0&quot;), action if invalid: error
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	x_p1: 1st filter integration,
	x_p2: 2nd filter integration, 
	x_p3: 3rd filter integration, 
	x_p4: 4rd filter integration, 
	x_p5: T1/T2 lead-lag integrator, 
	x_p6: T3/T4 lead-lag integrator, 
	:x_p7 last integer,
- `n_states::Int`: IEEEST has 7 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct IEEEST <: PSS
    "Code input for stabilizar"
    input_code::Int
    "Remot  Bus number for control."
    remote_bus_control::Int
    "Filter coefficient"
    A1::Float64
    "Filter coefficient"
    A2::Float64
    "Filter coefficient"
    A3::Float64
    "Filter coefficient"
    A4::Float64
    "Filter coefficient"
    A5::Float64
    "Filter coefficient"
    A6::Float64
    "Time constant"
    T1::Float64
    "Time constant"
    T2::Float64
    "Time constant"
    T3::Float64
    "Time constant"
    T4::Float64
    "Time constant"
    T5::Float64
    "Time constant"
    T6::Float64
    "Proportional gain"
    Ks::Float64
    "PSS output limits for regulator output (Va_min, Va_max)"
    Ls_lim::Tuple{Float64, Float64}
    "Cutoff limiter upper bound"
    Vcu::Float64
    "Cutoff limiter lower bound"
    Vcl::Float64
    ext::Dict{String, Any}
    "The states are:
	x_p1: 1st filter integration,
	x_p2: 2nd filter integration, 
	x_p3: 3rd filter integration, 
	x_p4: 4rd filter integration, 
	x_p5: T1/T2 lead-lag integrator, 
	x_p6: T3/T4 lead-lag integrator, 
	:x_p7 last integer,"
    states::Vector{Symbol}
    "IEEEST has 7 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function IEEEST(input_code, remote_bus_control, A1, A2, A3, A4, A5, A6, T1, T2, T3, T4, T5, T6, Ks, Ls_lim, Vcu, Vcl, ext=Dict{String, Any}(), )
    IEEEST(input_code, remote_bus_control, A1, A2, A3, A4, A5, A6, T1, T2, T3, T4, T5, T6, Ks, Ls_lim, Vcu, Vcl, ext, [:x_p1, :x_p2, :x_p3, :x_p4, :x_p5, :x_p6, :x_p7], 7, InfrastructureSystemsInternal(), )
end

function IEEEST(; input_code, remote_bus_control, A1, A2, A3, A4, A5, A6, T1, T2, T3, T4, T5, T6, Ks, Ls_lim, Vcu, Vcl, ext=Dict{String, Any}(), )
    IEEEST(input_code, remote_bus_control, A1, A2, A3, A4, A5, A6, T1, T2, T3, T4, T5, T6, Ks, Ls_lim, Vcu, Vcl, ext, )
end

# Constructor for demo purposes; non-functional.
function IEEEST(::Nothing)
    IEEEST(;
        input_code=1,
        remote_bus_control=0,
        A1=0,
        A2=0,
        A3=0,
        A4=0,
        A5=0,
        A6=0,
        T1=0,
        T2=0,
        T3=0,
        T4=0,
        T5=0,
        T6=0,
        Ks=0,
        Ls_lim=(0.0, 0.0),
        Vcu=0,
        Vcl=0,
        ext=Dict{String, Any}(),
    )
end

"""Get IEEEST input_code."""
get_input_code(value::IEEEST) = value.input_code
"""Get IEEEST remote_bus_control."""
get_remote_bus_control(value::IEEEST) = value.remote_bus_control
"""Get IEEEST A1."""
get_A1(value::IEEEST) = value.A1
"""Get IEEEST A2."""
get_A2(value::IEEEST) = value.A2
"""Get IEEEST A3."""
get_A3(value::IEEEST) = value.A3
"""Get IEEEST A4."""
get_A4(value::IEEEST) = value.A4
"""Get IEEEST A5."""
get_A5(value::IEEEST) = value.A5
"""Get IEEEST A6."""
get_A6(value::IEEEST) = value.A6
"""Get IEEEST T1."""
get_T1(value::IEEEST) = value.T1
"""Get IEEEST T2."""
get_T2(value::IEEEST) = value.T2
"""Get IEEEST T3."""
get_T3(value::IEEEST) = value.T3
"""Get IEEEST T4."""
get_T4(value::IEEEST) = value.T4
"""Get IEEEST T5."""
get_T5(value::IEEEST) = value.T5
"""Get IEEEST T6."""
get_T6(value::IEEEST) = value.T6
"""Get IEEEST Ks."""
get_Ks(value::IEEEST) = value.Ks
"""Get IEEEST Ls_lim."""
get_Ls_lim(value::IEEEST) = value.Ls_lim
"""Get IEEEST Vcu."""
get_Vcu(value::IEEEST) = value.Vcu
"""Get IEEEST Vcl."""
get_Vcl(value::IEEEST) = value.Vcl
"""Get IEEEST ext."""
get_ext(value::IEEEST) = value.ext
"""Get IEEEST states."""
get_states(value::IEEEST) = value.states
"""Get IEEEST n_states."""
get_n_states(value::IEEEST) = value.n_states
"""Get IEEEST internal."""
get_internal(value::IEEEST) = value.internal

"""Set IEEEST input_code."""
set_input_code!(value::IEEEST, val::Int) = value.input_code = val
"""Set IEEEST remote_bus_control."""
set_remote_bus_control!(value::IEEEST, val::Int) = value.remote_bus_control = val
"""Set IEEEST A1."""
set_A1!(value::IEEEST, val::Float64) = value.A1 = val
"""Set IEEEST A2."""
set_A2!(value::IEEEST, val::Float64) = value.A2 = val
"""Set IEEEST A3."""
set_A3!(value::IEEEST, val::Float64) = value.A3 = val
"""Set IEEEST A4."""
set_A4!(value::IEEEST, val::Float64) = value.A4 = val
"""Set IEEEST A5."""
set_A5!(value::IEEEST, val::Float64) = value.A5 = val
"""Set IEEEST A6."""
set_A6!(value::IEEEST, val::Float64) = value.A6 = val
"""Set IEEEST T1."""
set_T1!(value::IEEEST, val::Float64) = value.T1 = val
"""Set IEEEST T2."""
set_T2!(value::IEEEST, val::Float64) = value.T2 = val
"""Set IEEEST T3."""
set_T3!(value::IEEEST, val::Float64) = value.T3 = val
"""Set IEEEST T4."""
set_T4!(value::IEEEST, val::Float64) = value.T4 = val
"""Set IEEEST T5."""
set_T5!(value::IEEEST, val::Float64) = value.T5 = val
"""Set IEEEST T6."""
set_T6!(value::IEEEST, val::Float64) = value.T6 = val
"""Set IEEEST Ks."""
set_Ks!(value::IEEEST, val::Float64) = value.Ks = val
"""Set IEEEST Ls_lim."""
set_Ls_lim!(value::IEEEST, val::Tuple{Float64, Float64}) = value.Ls_lim = val
"""Set IEEEST Vcu."""
set_Vcu!(value::IEEEST, val::Float64) = value.Vcu = val
"""Set IEEEST Vcl."""
set_Vcl!(value::IEEEST, val::Float64) = value.Vcl = val
"""Set IEEEST ext."""
set_ext!(value::IEEEST, val::Dict{String, Any}) = value.ext = val
"""Set IEEEST states."""
set_states!(value::IEEEST, val::Vector{Symbol}) = value.states = val
"""Set IEEEST n_states."""
set_n_states!(value::IEEEST, val::Int) = value.n_states = val
"""Set IEEEST internal."""
set_internal!(value::IEEEST, val::InfrastructureSystemsInternal) = value.internal = val
