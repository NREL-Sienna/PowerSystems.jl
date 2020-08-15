#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct GeneralGovModel <: TurbineGov
        Rselect::Int
        fuel_flag::Int
        R::Float64
        Tpelec::Float64
        speed_error_signal::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Kp_gov::Float64
        Ki_gov::Float64
        Kd_gov::Float64
        Td_gov::Float64
        valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        T_act::Float64
        K_turb::Float64
        Wf_nl::Float64
        Tb::Float64
        Tc::Float64
        T_eng::Float64
        Tf_load::Float64
        Kp_load::Float64
        Ki_load::Float64
        Ld_ref::Float64
        Dm::Float64
        R_open::Float64
        R_close::Float64
        Ki_mw::Float64
        A_set::Float64
        Ka::Float64
        Ta::Float64
        T_rate::Float64
        db::Float64
        Tsa::Float64
        Tsb::Float64
        R_lim::NamedTuple{(:up, :down), Tuple{Float64, Float64}}
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

GE General Governor/Turbine Model. The GeneralGovModel (GGOV1) model is a general purpose governor model used for a variety of prime movers controlled by proportional-integral-derivative (PID) governors including gas turbines.

# Arguments
- `Rselect::Int`: Feedback signal for governor droop, validation range: (-2, 1), action if invalid: error
- `fuel_flag::Int`: Flag Switch for fuel source characteristic, validation range: (0, 1), action if invalid: error
- `R::Float64`: Speed droop parameter, validation range: (&quot;eps()&quot;, nothing), action if invalid: error
- `Tpelec::Float64`: Electrical power transducer time constant, seconds, validation range: (&quot;eps()&quot;, nothing), action if invalid: error
- `speed_error_signal::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Speed error signal limits
- `Kp_gov::Float64`: Governor proportional gain, validation range: (0.0, nothing), action if invalid: error
- `Ki_gov::Float64`: Governor integral gain, validation range: (0.0, nothing), action if invalid: error
- `Kd_gov::Float64`: Governor derivative gain, validation range: (0.0, nothing), action if invalid: error
- `Td_gov::Float64`: Governor derivative time constant, validation range: (0.0, nothing), action if invalid: error
- `valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Valve position limits
- `T_act::Float64`: Actuator time constant, validation range: (0.0, nothing), action if invalid: error
- `K_turb::Float64`: Turbine gain, validation range: (0.0, nothing), action if invalid: error
- `Wf_nl::Float64`: No load fuel flow, pu, validation range: (0.0, nothing), action if invalid: error
- `Tb::Float64`: Turbine lag time constant, sec, validation range: (0.0, nothing), action if invalid: error
- `Tc::Float64`: Turbine lead time constant, sec, validation range: (0.0, nothing), action if invalid: error
- `T_eng::Float64`: Transport lag time constant for diesel engine, sec, validation range: (0.0, nothing), action if invalid: error
- `Tf_load::Float64`: Load limiter time constant, validation range: (0.0, nothing), action if invalid: error
- `Kp_load::Float64`: Load limiter proportional gain for PI controller, validation range: (0.0, nothing), action if invalid: error
- `Ki_load::Float64`: Load integral gain for PI controller, validation range: (0.0, nothing), action if invalid: error
- `Ld_ref::Float64`: Load limiter integral gain for PI controller, validation range: (0.0, nothing), action if invalid: error
- `Dm::Float64`: Mechanical damping coefficient, pu, validation range: (0.0, nothing), action if invalid: error
- `R_open::Float64`: Maximum valve opening rate, pu/sec, validation range: (0.0, nothing), action if invalid: error
- `R_close::Float64`: Maximum valve closing rate, pu/sec, validation range: (0.0, nothing), action if invalid: error
- `Ki_mw::Float64`: Power controller (reset) gain, validation range: (0.0, nothing), action if invalid: error
- `A_set::Float64`: Acceleration limiter setpoint, pu/sec, validation range: (0.0, nothing), action if invalid: error
- `Ka::Float64`: Acceleration limiter gain, validation range: (0.0, nothing), action if invalid: error
- `Ta::Float64`: Acceleration limiter time constant , validation range: (&quot;eps()&quot;, nothing), action if invalid: error
- `T_rate::Float64`: Turbine rating, validation range: (0.0, nothing), action if invalid: error
- `db::Float64`: Speed governor deadband, validation range: (0.0, nothing), action if invalid: error
- `Tsa::Float64`: Temperature detection lead time constant, validation range: (0.0, nothing), action if invalid: error
- `Tsb::Float64`: Temperature detection lag time constant, validation range: (0.0, nothing), action if invalid: error
- `R_lim::NamedTuple{(:up, :down), Tuple{Float64, Float64}}`: Maximum rate of load increa, action if invalid: error
- `P_ref::Float64`: Reference Power Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the GGOV1 model are:
	Pe: Machine Electrical Power Measurement,
	x_g1: Governor differential control,
	x_g2: Governor integral control, 
	x_g3: Turbine actuator, 
	x_g4: Turbine Lead-Lag, 
	x_g5: Turbine load limiter measurement, 
	x_g6: Turbine Load Limiter Integral Control, 
	x_g7: Supervisory Load Control, 
	x_g8: Acceleration Control, 
	x_g9 Temperature Detection Lead - Lag:
- `n_states::Int`: GeneralGovModel has 10 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GeneralGovModel <: TurbineGov
    "Feedback signal for governor droop"
    Rselect::Int
    "Flag Switch for fuel source characteristic"
    fuel_flag::Int
    "Speed droop parameter"
    R::Float64
    "Electrical power transducer time constant, seconds"
    Tpelec::Float64
    "Speed error signal limits"
    speed_error_signal::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Governor proportional gain"
    Kp_gov::Float64
    "Governor integral gain"
    Ki_gov::Float64
    "Governor derivative gain"
    Kd_gov::Float64
    "Governor derivative time constant"
    Td_gov::Float64
    "Valve position limits"
    valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Actuator time constant"
    T_act::Float64
    "Turbine gain"
    K_turb::Float64
    "No load fuel flow, pu"
    Wf_nl::Float64
    "Turbine lag time constant, sec"
    Tb::Float64
    "Turbine lead time constant, sec"
    Tc::Float64
    "Transport lag time constant for diesel engine, sec"
    T_eng::Float64
    "Load limiter time constant"
    Tf_load::Float64
    "Load limiter proportional gain for PI controller"
    Kp_load::Float64
    "Load integral gain for PI controller"
    Ki_load::Float64
    "Load limiter integral gain for PI controller"
    Ld_ref::Float64
    "Mechanical damping coefficient, pu"
    Dm::Float64
    "Maximum valve opening rate, pu/sec"
    R_open::Float64
    "Maximum valve closing rate, pu/sec"
    R_close::Float64
    "Power controller (reset) gain"
    Ki_mw::Float64
    "Acceleration limiter setpoint, pu/sec"
    A_set::Float64
    "Acceleration limiter gain"
    Ka::Float64
    "Acceleration limiter time constant "
    Ta::Float64
    "Turbine rating"
    T_rate::Float64
    "Speed governor deadband"
    db::Float64
    "Temperature detection lead time constant"
    Tsa::Float64
    "Temperature detection lag time constant"
    Tsb::Float64
    "Maximum rate of load increa"
    R_lim::NamedTuple{(:up, :down), Tuple{Float64, Float64}}
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the GGOV1 model are:
	Pe: Machine Electrical Power Measurement,
	x_g1: Governor differential control,
	x_g2: Governor integral control, 
	x_g3: Turbine actuator, 
	x_g4: Turbine Lead-Lag, 
	x_g5: Turbine load limiter measurement, 
	x_g6: Turbine Load Limiter Integral Control, 
	x_g7: Supervisory Load Control, 
	x_g8: Acceleration Control, 
	x_g9 Temperature Detection Lead - Lag:"
    states::Vector{Symbol}
    "GeneralGovModel has 10 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GeneralGovModel(Rselect, fuel_flag, R, Tpelec, speed_error_signal, Kp_gov, Ki_gov, Kd_gov, Td_gov, valve_position_limits, T_act, K_turb, Wf_nl, Tb, Tc, T_eng, Tf_load, Kp_load, Ki_load, Ld_ref, Dm, R_open, R_close, Ki_mw, A_set, Ka, Ta, T_rate, db, Tsa, Tsb, R_lim, P_ref=1.0, ext=Dict{String, Any}(), )
    GeneralGovModel(Rselect, fuel_flag, R, Tpelec, speed_error_signal, Kp_gov, Ki_gov, Kd_gov, Td_gov, valve_position_limits, T_act, K_turb, Wf_nl, Tb, Tc, T_eng, Tf_load, Kp_load, Ki_load, Ld_ref, Dm, R_open, R_close, Ki_mw, A_set, Ka, Ta, T_rate, db, Tsa, Tsb, R_lim, P_ref, ext, [:Pe, :x_g1, :x_g2, :x_g3, :x_g4, :x_g5, :x_g6, :x_g7, :x_g8, :x_g9], 10, InfrastructureSystemsInternal(), )
end

function GeneralGovModel(; Rselect, fuel_flag, R, Tpelec, speed_error_signal, Kp_gov, Ki_gov, Kd_gov, Td_gov, valve_position_limits, T_act, K_turb, Wf_nl, Tb, Tc, T_eng, Tf_load, Kp_load, Ki_load, Ld_ref, Dm, R_open, R_close, Ki_mw, A_set, Ka, Ta, T_rate, db, Tsa, Tsb, R_lim, P_ref=1.0, ext=Dict{String, Any}(), )
    GeneralGovModel(Rselect, fuel_flag, R, Tpelec, speed_error_signal, Kp_gov, Ki_gov, Kd_gov, Td_gov, valve_position_limits, T_act, K_turb, Wf_nl, Tb, Tc, T_eng, Tf_load, Kp_load, Ki_load, Ld_ref, Dm, R_open, R_close, Ki_mw, A_set, Ka, Ta, T_rate, db, Tsa, Tsb, R_lim, P_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function GeneralGovModel(::Nothing)
    GeneralGovModel(;
        Rselect=1,
        fuel_flag=0,
        R=0,
        Tpelec=0,
        speed_error_signal=(min=0.0, max=0.0),
        Kp_gov=0,
        Ki_gov=0,
        Kd_gov=0,
        Td_gov=0,
        valve_position_limits=(min=0.0, max=0.0),
        T_act=0,
        K_turb=0,
        Wf_nl=0,
        Tb=0,
        Tc=0,
        T_eng=0,
        Tf_load=0,
        Kp_load=0,
        Ki_load=0,
        Ld_ref=0,
        Dm=0,
        R_open=0,
        R_close=0,
        Ki_mw=0,
        A_set=0,
        Ka=0,
        Ta=0,
        T_rate=0,
        db=0,
        Tsa=0,
        Tsb=0,
        R_lim=(up = 0.0, down = 0.0),
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get GeneralGovModel Rselect."""
get_Rselect(value::GeneralGovModel) = value.Rselect
"""Get GeneralGovModel fuel_flag."""
get_fuel_flag(value::GeneralGovModel) = value.fuel_flag
"""Get GeneralGovModel R."""
get_R(value::GeneralGovModel) = value.R
"""Get GeneralGovModel Tpelec."""
get_Tpelec(value::GeneralGovModel) = value.Tpelec
"""Get GeneralGovModel speed_error_signal."""
get_speed_error_signal(value::GeneralGovModel) = value.speed_error_signal
"""Get GeneralGovModel Kp_gov."""
get_Kp_gov(value::GeneralGovModel) = value.Kp_gov
"""Get GeneralGovModel Ki_gov."""
get_Ki_gov(value::GeneralGovModel) = value.Ki_gov
"""Get GeneralGovModel Kd_gov."""
get_Kd_gov(value::GeneralGovModel) = value.Kd_gov
"""Get GeneralGovModel Td_gov."""
get_Td_gov(value::GeneralGovModel) = value.Td_gov
"""Get GeneralGovModel valve_position_limits."""
get_valve_position_limits(value::GeneralGovModel) = value.valve_position_limits
"""Get GeneralGovModel T_act."""
get_T_act(value::GeneralGovModel) = value.T_act
"""Get GeneralGovModel K_turb."""
get_K_turb(value::GeneralGovModel) = value.K_turb
"""Get GeneralGovModel Wf_nl."""
get_Wf_nl(value::GeneralGovModel) = value.Wf_nl
"""Get GeneralGovModel Tb."""
get_Tb(value::GeneralGovModel) = value.Tb
"""Get GeneralGovModel Tc."""
get_Tc(value::GeneralGovModel) = value.Tc
"""Get GeneralGovModel T_eng."""
get_T_eng(value::GeneralGovModel) = value.T_eng
"""Get GeneralGovModel Tf_load."""
get_Tf_load(value::GeneralGovModel) = value.Tf_load
"""Get GeneralGovModel Kp_load."""
get_Kp_load(value::GeneralGovModel) = value.Kp_load
"""Get GeneralGovModel Ki_load."""
get_Ki_load(value::GeneralGovModel) = value.Ki_load
"""Get GeneralGovModel Ld_ref."""
get_Ld_ref(value::GeneralGovModel) = value.Ld_ref
"""Get GeneralGovModel Dm."""
get_Dm(value::GeneralGovModel) = value.Dm
"""Get GeneralGovModel R_open."""
get_R_open(value::GeneralGovModel) = value.R_open
"""Get GeneralGovModel R_close."""
get_R_close(value::GeneralGovModel) = value.R_close
"""Get GeneralGovModel Ki_mw."""
get_Ki_mw(value::GeneralGovModel) = value.Ki_mw
"""Get GeneralGovModel A_set."""
get_A_set(value::GeneralGovModel) = value.A_set
"""Get GeneralGovModel Ka."""
get_Ka(value::GeneralGovModel) = value.Ka
"""Get GeneralGovModel Ta."""
get_Ta(value::GeneralGovModel) = value.Ta
"""Get GeneralGovModel T_rate."""
get_T_rate(value::GeneralGovModel) = value.T_rate
"""Get GeneralGovModel db."""
get_db(value::GeneralGovModel) = value.db
"""Get GeneralGovModel Tsa."""
get_Tsa(value::GeneralGovModel) = value.Tsa
"""Get GeneralGovModel Tsb."""
get_Tsb(value::GeneralGovModel) = value.Tsb
"""Get GeneralGovModel R_lim."""
get_R_lim(value::GeneralGovModel) = value.R_lim
"""Get GeneralGovModel P_ref."""
get_P_ref(value::GeneralGovModel) = value.P_ref
"""Get GeneralGovModel ext."""
get_ext(value::GeneralGovModel) = value.ext
"""Get GeneralGovModel states."""
get_states(value::GeneralGovModel) = value.states
"""Get GeneralGovModel n_states."""
get_n_states(value::GeneralGovModel) = value.n_states
"""Get GeneralGovModel internal."""
get_internal(value::GeneralGovModel) = value.internal

"""Set GeneralGovModel Rselect."""
set_Rselect!(value::GeneralGovModel, val::Int) = value.Rselect = val
"""Set GeneralGovModel fuel_flag."""
set_fuel_flag!(value::GeneralGovModel, val::Int) = value.fuel_flag = val
"""Set GeneralGovModel R."""
set_R!(value::GeneralGovModel, val::Float64) = value.R = val
"""Set GeneralGovModel Tpelec."""
set_Tpelec!(value::GeneralGovModel, val::Float64) = value.Tpelec = val
"""Set GeneralGovModel speed_error_signal."""
set_speed_error_signal!(value::GeneralGovModel, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.speed_error_signal = val
"""Set GeneralGovModel Kp_gov."""
set_Kp_gov!(value::GeneralGovModel, val::Float64) = value.Kp_gov = val
"""Set GeneralGovModel Ki_gov."""
set_Ki_gov!(value::GeneralGovModel, val::Float64) = value.Ki_gov = val
"""Set GeneralGovModel Kd_gov."""
set_Kd_gov!(value::GeneralGovModel, val::Float64) = value.Kd_gov = val
"""Set GeneralGovModel Td_gov."""
set_Td_gov!(value::GeneralGovModel, val::Float64) = value.Td_gov = val
"""Set GeneralGovModel valve_position_limits."""
set_valve_position_limits!(value::GeneralGovModel, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.valve_position_limits = val
"""Set GeneralGovModel T_act."""
set_T_act!(value::GeneralGovModel, val::Float64) = value.T_act = val
"""Set GeneralGovModel K_turb."""
set_K_turb!(value::GeneralGovModel, val::Float64) = value.K_turb = val
"""Set GeneralGovModel Wf_nl."""
set_Wf_nl!(value::GeneralGovModel, val::Float64) = value.Wf_nl = val
"""Set GeneralGovModel Tb."""
set_Tb!(value::GeneralGovModel, val::Float64) = value.Tb = val
"""Set GeneralGovModel Tc."""
set_Tc!(value::GeneralGovModel, val::Float64) = value.Tc = val
"""Set GeneralGovModel T_eng."""
set_T_eng!(value::GeneralGovModel, val::Float64) = value.T_eng = val
"""Set GeneralGovModel Tf_load."""
set_Tf_load!(value::GeneralGovModel, val::Float64) = value.Tf_load = val
"""Set GeneralGovModel Kp_load."""
set_Kp_load!(value::GeneralGovModel, val::Float64) = value.Kp_load = val
"""Set GeneralGovModel Ki_load."""
set_Ki_load!(value::GeneralGovModel, val::Float64) = value.Ki_load = val
"""Set GeneralGovModel Ld_ref."""
set_Ld_ref!(value::GeneralGovModel, val::Float64) = value.Ld_ref = val
"""Set GeneralGovModel Dm."""
set_Dm!(value::GeneralGovModel, val::Float64) = value.Dm = val
"""Set GeneralGovModel R_open."""
set_R_open!(value::GeneralGovModel, val::Float64) = value.R_open = val
"""Set GeneralGovModel R_close."""
set_R_close!(value::GeneralGovModel, val::Float64) = value.R_close = val
"""Set GeneralGovModel Ki_mw."""
set_Ki_mw!(value::GeneralGovModel, val::Float64) = value.Ki_mw = val
"""Set GeneralGovModel A_set."""
set_A_set!(value::GeneralGovModel, val::Float64) = value.A_set = val
"""Set GeneralGovModel Ka."""
set_Ka!(value::GeneralGovModel, val::Float64) = value.Ka = val
"""Set GeneralGovModel Ta."""
set_Ta!(value::GeneralGovModel, val::Float64) = value.Ta = val
"""Set GeneralGovModel T_rate."""
set_T_rate!(value::GeneralGovModel, val::Float64) = value.T_rate = val
"""Set GeneralGovModel db."""
set_db!(value::GeneralGovModel, val::Float64) = value.db = val
"""Set GeneralGovModel Tsa."""
set_Tsa!(value::GeneralGovModel, val::Float64) = value.Tsa = val
"""Set GeneralGovModel Tsb."""
set_Tsb!(value::GeneralGovModel, val::Float64) = value.Tsb = val
"""Set GeneralGovModel R_lim."""
set_R_lim!(value::GeneralGovModel, val::NamedTuple{(:up, :down), Tuple{Float64, Float64}}) = value.R_lim = val
"""Set GeneralGovModel P_ref."""
set_P_ref!(value::GeneralGovModel, val::Float64) = value.P_ref = val
"""Set GeneralGovModel ext."""
set_ext!(value::GeneralGovModel, val::Dict{String, Any}) = value.ext = val
"""Set GeneralGovModel states."""
set_states!(value::GeneralGovModel, val::Vector{Symbol}) = value.states = val
"""Set GeneralGovModel n_states."""
set_n_states!(value::GeneralGovModel, val::Int) = value.n_states = val
"""Set GeneralGovModel internal."""
set_internal!(value::GeneralGovModel, val::InfrastructureSystemsInternal) = value.internal = val
