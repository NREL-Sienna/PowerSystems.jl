#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AggregateDistributedGenerationA <: DynamicInjection
        Pf_Flag::Int
        Freq_Flag::Int
        PQ_Flag::Int
        Gen_Flag::Int
        Vtrip_Flag::Int
        Ftrip_Flag::Int
        T_rv::Float64
        Trf::Float64
        dbd1::Float64
        dbd2::Float64
        K_qv::Float64
        V_ref0::Float64
        Tp::Float64
        T_iq::Float64
        D_dn::Float64
        D_up::Float64
        fdbd1::Float64
        fdbd2::Float64
        femax::Float64
        femin::Float64
        Pmax::Float64
        Pmin::Float64
        dPmax::Float64
        dPmin::Float64
        Tpord::Float64
        Kpg::Float64
        Kig::Float64
        I_max::Float64
        vl0::Float64
        vl1::Float64
        vh0::Float64
        vh1::Float64
        tv10::Float64
        tvl1::Float64
        tvh0::Float64
        tvh1::Float64
        Vrfrac::Float64
        fl::Float64
        fh::Float64
        tfl::Float64
        tfh::Float64
        Tg::Float64
        rrpwr::Float64
        Tv::Float64
        Vpr::Float64
        Iqhl::Float64
        Iqll::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of the DERA1 model in PSS/E

# Arguments
- `Pf_Flag::Int`: Flag for Power Factor Control, validation range: `(0, 1)`
- `Freq_Flag::Int`: Flag to enable/disable frequency control, validation range: `(0, 1)`
- `PQ_Flag::Int`: Flag used to enforce maximum current, validation range: `(0, 1)`
- `Gen_Flag::Int`: Flag to specify generator or storage, validation range: `(0, 1)`
- `Vtrip_Flag::Int`: Flag to enable/disable voltage trip logic, validation range: `(0, 1)`
- `Ftrip_Flag::Int`: Flag to enable/disable frequency trip logic, validation range: `(0, 1)`
- `T_rv::Float64`: Voltage measurement transducer time constant, validation range: `(0, nothing)`
- `Trf::Float64`: Frequency measurement transducer time constant, validation range: `(0, nothing)`
- `dbd1::Float64`: Lower voltage deadband (<=0) (pu), validation range: `(nothing, 0)`
- `dbd2::Float64`: Upper voltage deadband (>0 (pu), validation range: `(0, nothing)`
- `K_qv::Float64`: Proportional voltage control gain (pu), validation range: `(0, nothing)`
- `V_ref0::Float64`: User defined reference. If 0, PSID initializes to initial terminal voltage, validation range: `(0, nothing)`
- `Tp::Float64`: Power measurement transducer time constant, validation range: `(0, nothing)`
- `T_iq::Float64`: Time constant for low-pass filter for state q_V when QFlag = 0, validation range: `(0, nothing)`
- `D_dn::Float64`: Reciprocal of droop for over-frequency conditions (>0) (pu), validation range: `(0, nothing)`
- `D_up::Float64`: Reciprocal of droop for under-frequency conditions <=0) (pu), validation range: `(0, nothing)`
- `fdbd1::Float64`: Deadband for frequency control, lower threshold (<=0) (pu), validation range: `(nothing, 0)`
- `fdbd2::Float64`: Deadband for frequency control, upper threshold (>=0) (pu), validation range: `(0, nothing)`
- `femax::Float64`: Frequency error upper limit (pu), validation range: `(0, nothing)`
- `femin::Float64`: Frequency error lower limit (pu), validation range: `(0, nothing)`
- `Pmax::Float64`: Maximum power limit (pu), validation range: `(0, nothing)`
- `Pmin::Float64`: Minimum power limit (pu), validation range: `(0, nothing)`
- `dPmax::Float64`: Power reference maximum ramp rate (>0) (pu/s), validation range: `(0, nothing)`
- `dPmin::Float64`: Minimum ramp rate (pu/s), validation range: `(nothing, 0)`
- `Tpord::Float64`: Power filter time constant, validation range: `(0, nothing)`
- `Kpg::Float64`: PI controller proportional gain (pu), validation range: `(0, nothing)`
- `Kig::Float64`: PI controller integral gain (pu), validation range: `(0, nothing)`
- `I_max::Float64`: Maximum limit on total converter current (pu), validation range: `(0, nothing)`
- `vl0::Float64`: Inverter voltage break-point for low voltage cut-out (pu), validation range: `(0, nothing)`
- `vl1::Float64`: Inverter voltage break-point for low voltage cut-out (vl1 > vl0) (pu), validation range: `(0, nothing)`
- `vh0::Float64`: Inverter voltage break-point for high voltage cut-out (pu), validation range: `(0, nothing)`
- `vh1::Float64`: Inverter voltage break-point for high voltage cut-out (vh1<vh0) (pu), validation range: `(0, nothing)`
- `tv10::Float64`: Low voltage cut-out timer corresponding to voltage vl0 (s), validation range: `(0, nothing)`
- `tvl1::Float64`: Low voltage cut-out timer corresponding to voltage vl1 (s), validation range: `(0, nothing)`
- `tvh0::Float64`: High voltage cut-out timer corresponding to voltage vh0 (s), validation range: `(0, nothing)`
- `tvh1::Float64`: High voltage cut-out timer corresponding to voltage vh1 (s), validation range: `(0, nothing)`
- `Vrfrac::Float64`: Fraction of device that recovers after voltage comes back to within vl1 < V < vh1 (0 <= Vrfrac <= 1), validation range: `(0, 1)`
- `fl::Float64`: Inverter frequency break-point for low frequency cut-out (Hz), validation range: `(0, nothing)`
- `fh::Float64`: Inverter frequency break-point for high frequency cut-out (Hz), validation range: `(0, nothing)`
- `tfl::Float64`: Low frequency cut-out timer corresponding to frequency fl (s), validation range: `(0, nothing)`
- `tfh::Float64`: High frequency cut-out timer corresponding to frequency fh (s), validation range: `(0, nothing)`
- `Tg::Float64`: Current control time constant (to represent behavior of inner control loops) (> 0) (s), validation range: `(0, nothing)`
- `rrpwr::Float64`: Ramp rate for real power increase following a fault (pu/s), validation range: `(0, nothing)`
- `Tv::Float64`: Time constant on the output of the multiplier (s), validation range: `(0, nothing)`
- `Vpr::Float64`: Voltage below which frequency tripping is disabled (pu), validation range: `(0, nothing)`
- `Iqhl::Float64`: Upper limit on reactive current injection Iqinj (pu), validation range: `(0, nothing)`
- `Iqll::Float64`: Lower limit on reactive current injection Iqinj (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of AggregateDistributedGenerationA depends on the Flags
- `n_states::Int`: The states of AggregateDistributedGenerationA depends on the Flags
"""
mutable struct AggregateDistributedGenerationA <: DynamicInjection
    "Flag for Power Factor Control"
    Pf_Flag::Int
    "Flag to enable/disable frequency control"
    Freq_Flag::Int
    "Flag used to enforce maximum current"
    PQ_Flag::Int
    "Flag to specify generator or storage"
    Gen_Flag::Int
    "Flag to enable/disable voltage trip logic"
    Vtrip_Flag::Int
    "Flag to enable/disable frequency trip logic"
    Ftrip_Flag::Int
    "Voltage measurement transducer time constant"
    T_rv::Float64
    "Frequency measurement transducer time constant"
    Trf::Float64
    "Lower voltage deadband (<=0) (pu)"
    dbd1::Float64
    "Upper voltage deadband (>0 (pu)"
    dbd2::Float64
    "Proportional voltage control gain (pu)"
    K_qv::Float64
    "User defined reference. If 0, PSID initializes to initial terminal voltage"
    V_ref0::Float64
    "Power measurement transducer time constant"
    Tp::Float64
    "Time constant for low-pass filter for state q_V when QFlag = 0"
    T_iq::Float64
    "Reciprocal of droop for over-frequency conditions (>0) (pu)"
    D_dn::Float64
    "Reciprocal of droop for under-frequency conditions <=0) (pu)"
    D_up::Float64
    "Deadband for frequency control, lower threshold (<=0) (pu)"
    fdbd1::Float64
    "Deadband for frequency control, upper threshold (>=0) (pu)"
    fdbd2::Float64
    "Frequency error upper limit (pu)"
    femax::Float64
    "Frequency error lower limit (pu)"
    femin::Float64
    "Maximum power limit (pu)"
    Pmax::Float64
    "Minimum power limit (pu)"
    Pmin::Float64
    "Power reference maximum ramp rate (>0) (pu/s)"
    dPmax::Float64
    "Minimum ramp rate (pu/s)"
    dPmin::Float64
    "Power filter time constant"
    Tpord::Float64
    "PI controller proportional gain (pu)"
    Kpg::Float64
    "PI controller integral gain (pu)"
    Kig::Float64
    "Maximum limit on total converter current (pu)"
    I_max::Float64
    "Inverter voltage break-point for low voltage cut-out (pu)"
    vl0::Float64
    "Inverter voltage break-point for low voltage cut-out (vl1 > vl0) (pu)"
    vl1::Float64
    "Inverter voltage break-point for high voltage cut-out (pu)"
    vh0::Float64
    "Inverter voltage break-point for high voltage cut-out (vh1<vh0) (pu)"
    vh1::Float64
    "Low voltage cut-out timer corresponding to voltage vl0 (s)"
    tv10::Float64
    "Low voltage cut-out timer corresponding to voltage vl1 (s)"
    tvl1::Float64
    "High voltage cut-out timer corresponding to voltage vh0 (s)"
    tvh0::Float64
    "High voltage cut-out timer corresponding to voltage vh1 (s)"
    tvh1::Float64
    "Fraction of device that recovers after voltage comes back to within vl1 < V < vh1 (0 <= Vrfrac <= 1)"
    Vrfrac::Float64
    "Inverter frequency break-point for low frequency cut-out (Hz)"
    fl::Float64
    "Inverter frequency break-point for high frequency cut-out (Hz)"
    fh::Float64
    "Low frequency cut-out timer corresponding to frequency fl (s)"
    tfl::Float64
    "High frequency cut-out timer corresponding to frequency fh (s)"
    tfh::Float64
    "Current control time constant (to represent behavior of inner control loops) (> 0) (s)"
    Tg::Float64
    "Ramp rate for real power increase following a fault (pu/s)"
    rrpwr::Float64
    "Time constant on the output of the multiplier (s)"
    Tv::Float64
    "Voltage below which frequency tripping is disabled (pu)"
    Vpr::Float64
    "Upper limit on reactive current injection Iqinj (pu)"
    Iqhl::Float64
    "Lower limit on reactive current injection Iqinj (pu)"
    Iqll::Float64
    ext::Dict{String, Any}
    "The states of AggregateDistributedGenerationA depends on the Flags"
    states::Vector{Symbol}
    "The states of AggregateDistributedGenerationA depends on the Flags"
    n_states::Int
end

function AggregateDistributedGenerationA(Pf_Flag, Freq_Flag, PQ_Flag, Gen_Flag, Vtrip_Flag, Ftrip_Flag, T_rv, Trf, dbd1, dbd2, K_qv, V_ref0, Tp, T_iq, D_dn, D_up, fdbd1, fdbd2, femax, femin, Pmax, Pmin, dPmax, dPmin, Tpord, Kpg, Kig, I_max, vl0, vl1, vh0, vh1, tv10, tvl1, tvh0, tvh1, Vrfrac, fl, fh, tfl, tfh, Tg, rrpwr, Tv, Vpr, Iqhl, Iqll, ext=Dict{String, Any}(), )
    AggregateDistributedGenerationA(Pf_Flag, Freq_Flag, PQ_Flag, Gen_Flag, Vtrip_Flag, Ftrip_Flag, T_rv, Trf, dbd1, dbd2, K_qv, V_ref0, Tp, T_iq, D_dn, D_up, fdbd1, fdbd2, femax, femin, Pmax, Pmin, dPmax, dPmin, Tpord, Kpg, Kig, I_max, vl0, vl1, vh0, vh1, tv10, tvl1, tvh0, tvh1, Vrfrac, fl, fh, tfl, tfh, Tg, rrpwr, Tv, Vpr, Iqhl, Iqll, ext, PowerSystems.get_AggregateDistributedGenerationA_states(Freq_Flag)[1], PowerSystems.get_AggregateDistributedGenerationA_states(Freq_Flag)[2], )
end

function AggregateDistributedGenerationA(; Pf_Flag, Freq_Flag, PQ_Flag, Gen_Flag, Vtrip_Flag, Ftrip_Flag, T_rv, Trf, dbd1, dbd2, K_qv, V_ref0, Tp, T_iq, D_dn, D_up, fdbd1, fdbd2, femax, femin, Pmax, Pmin, dPmax, dPmin, Tpord, Kpg, Kig, I_max, vl0, vl1, vh0, vh1, tv10, tvl1, tvh0, tvh1, Vrfrac, fl, fh, tfl, tfh, Tg, rrpwr, Tv, Vpr, Iqhl, Iqll, ext=Dict{String, Any}(), states=PowerSystems.get_AggregateDistributedGenerationA_states(Freq_Flag)[1], n_states=PowerSystems.get_AggregateDistributedGenerationA_states(Freq_Flag)[2], )
    AggregateDistributedGenerationA(Pf_Flag, Freq_Flag, PQ_Flag, Gen_Flag, Vtrip_Flag, Ftrip_Flag, T_rv, Trf, dbd1, dbd2, K_qv, V_ref0, Tp, T_iq, D_dn, D_up, fdbd1, fdbd2, femax, femin, Pmax, Pmin, dPmax, dPmin, Tpord, Kpg, Kig, I_max, vl0, vl1, vh0, vh1, tv10, tvl1, tvh0, tvh1, Vrfrac, fl, fh, tfl, tfh, Tg, rrpwr, Tv, Vpr, Iqhl, Iqll, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function AggregateDistributedGenerationA(::Nothing)
    AggregateDistributedGenerationA(;
        Pf_Flag=0,
        Freq_Flag=0,
        PQ_Flag=0,
        Gen_Flag=0,
        Vtrip_Flag=0,
        Ftrip_Flag=0,
        T_rv=0,
        Trf=0,
        dbd1=0,
        dbd2=0,
        K_qv=0,
        V_ref0=0,
        Tp=0,
        T_iq=0,
        D_dn=0,
        D_up=0,
        fdbd1=0,
        fdbd2=0,
        femax=0,
        femin=0,
        Pmax=0,
        Pmin=0,
        dPmax=0,
        dPmin=0,
        Tpord=0,
        Kpg=0,
        Kig=0,
        I_max=0,
        vl0=0,
        vl1=0,
        vh0=0,
        vh1=0,
        tv10=0,
        tvl1=0,
        tvh0=0,
        tvh1=0,
        Vrfrac=0,
        fl=0,
        fh=0,
        tfl=0,
        tfh=0,
        Tg=0,
        rrpwr=0,
        Tv=0,
        Vpr=0,
        Iqhl=0,
        Iqll=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`AggregateDistributedGenerationA`](@ref) `Pf_Flag`."""
get_Pf_Flag(value::AggregateDistributedGenerationA) = value.Pf_Flag
"""Get [`AggregateDistributedGenerationA`](@ref) `Freq_Flag`."""
get_Freq_Flag(value::AggregateDistributedGenerationA) = value.Freq_Flag
"""Get [`AggregateDistributedGenerationA`](@ref) `PQ_Flag`."""
get_PQ_Flag(value::AggregateDistributedGenerationA) = value.PQ_Flag
"""Get [`AggregateDistributedGenerationA`](@ref) `Gen_Flag`."""
get_Gen_Flag(value::AggregateDistributedGenerationA) = value.Gen_Flag
"""Get [`AggregateDistributedGenerationA`](@ref) `Vtrip_Flag`."""
get_Vtrip_Flag(value::AggregateDistributedGenerationA) = value.Vtrip_Flag
"""Get [`AggregateDistributedGenerationA`](@ref) `Ftrip_Flag`."""
get_Ftrip_Flag(value::AggregateDistributedGenerationA) = value.Ftrip_Flag
"""Get [`AggregateDistributedGenerationA`](@ref) `T_rv`."""
get_T_rv(value::AggregateDistributedGenerationA) = value.T_rv
"""Get [`AggregateDistributedGenerationA`](@ref) `Trf`."""
get_Trf(value::AggregateDistributedGenerationA) = value.Trf
"""Get [`AggregateDistributedGenerationA`](@ref) `dbd1`."""
get_dbd1(value::AggregateDistributedGenerationA) = value.dbd1
"""Get [`AggregateDistributedGenerationA`](@ref) `dbd2`."""
get_dbd2(value::AggregateDistributedGenerationA) = value.dbd2
"""Get [`AggregateDistributedGenerationA`](@ref) `K_qv`."""
get_K_qv(value::AggregateDistributedGenerationA) = value.K_qv
"""Get [`AggregateDistributedGenerationA`](@ref) `V_ref0`."""
get_V_ref0(value::AggregateDistributedGenerationA) = value.V_ref0
"""Get [`AggregateDistributedGenerationA`](@ref) `Tp`."""
get_Tp(value::AggregateDistributedGenerationA) = value.Tp
"""Get [`AggregateDistributedGenerationA`](@ref) `T_iq`."""
get_T_iq(value::AggregateDistributedGenerationA) = value.T_iq
"""Get [`AggregateDistributedGenerationA`](@ref) `D_dn`."""
get_D_dn(value::AggregateDistributedGenerationA) = value.D_dn
"""Get [`AggregateDistributedGenerationA`](@ref) `D_up`."""
get_D_up(value::AggregateDistributedGenerationA) = value.D_up
"""Get [`AggregateDistributedGenerationA`](@ref) `fdbd1`."""
get_fdbd1(value::AggregateDistributedGenerationA) = value.fdbd1
"""Get [`AggregateDistributedGenerationA`](@ref) `fdbd2`."""
get_fdbd2(value::AggregateDistributedGenerationA) = value.fdbd2
"""Get [`AggregateDistributedGenerationA`](@ref) `femax`."""
get_femax(value::AggregateDistributedGenerationA) = value.femax
"""Get [`AggregateDistributedGenerationA`](@ref) `femin`."""
get_femin(value::AggregateDistributedGenerationA) = value.femin
"""Get [`AggregateDistributedGenerationA`](@ref) `Pmax`."""
get_Pmax(value::AggregateDistributedGenerationA) = value.Pmax
"""Get [`AggregateDistributedGenerationA`](@ref) `Pmin`."""
get_Pmin(value::AggregateDistributedGenerationA) = value.Pmin
"""Get [`AggregateDistributedGenerationA`](@ref) `dPmax`."""
get_dPmax(value::AggregateDistributedGenerationA) = value.dPmax
"""Get [`AggregateDistributedGenerationA`](@ref) `dPmin`."""
get_dPmin(value::AggregateDistributedGenerationA) = value.dPmin
"""Get [`AggregateDistributedGenerationA`](@ref) `Tpord`."""
get_Tpord(value::AggregateDistributedGenerationA) = value.Tpord
"""Get [`AggregateDistributedGenerationA`](@ref) `Kpg`."""
get_Kpg(value::AggregateDistributedGenerationA) = value.Kpg
"""Get [`AggregateDistributedGenerationA`](@ref) `Kig`."""
get_Kig(value::AggregateDistributedGenerationA) = value.Kig
"""Get [`AggregateDistributedGenerationA`](@ref) `I_max`."""
get_I_max(value::AggregateDistributedGenerationA) = value.I_max
"""Get [`AggregateDistributedGenerationA`](@ref) `vl0`."""
get_vl0(value::AggregateDistributedGenerationA) = value.vl0
"""Get [`AggregateDistributedGenerationA`](@ref) `vl1`."""
get_vl1(value::AggregateDistributedGenerationA) = value.vl1
"""Get [`AggregateDistributedGenerationA`](@ref) `vh0`."""
get_vh0(value::AggregateDistributedGenerationA) = value.vh0
"""Get [`AggregateDistributedGenerationA`](@ref) `vh1`."""
get_vh1(value::AggregateDistributedGenerationA) = value.vh1
"""Get [`AggregateDistributedGenerationA`](@ref) `tv10`."""
get_tv10(value::AggregateDistributedGenerationA) = value.tv10
"""Get [`AggregateDistributedGenerationA`](@ref) `tvl1`."""
get_tvl1(value::AggregateDistributedGenerationA) = value.tvl1
"""Get [`AggregateDistributedGenerationA`](@ref) `tvh0`."""
get_tvh0(value::AggregateDistributedGenerationA) = value.tvh0
"""Get [`AggregateDistributedGenerationA`](@ref) `tvh1`."""
get_tvh1(value::AggregateDistributedGenerationA) = value.tvh1
"""Get [`AggregateDistributedGenerationA`](@ref) `Vrfrac`."""
get_Vrfrac(value::AggregateDistributedGenerationA) = value.Vrfrac
"""Get [`AggregateDistributedGenerationA`](@ref) `fl`."""
get_fl(value::AggregateDistributedGenerationA) = value.fl
"""Get [`AggregateDistributedGenerationA`](@ref) `fh`."""
get_fh(value::AggregateDistributedGenerationA) = value.fh
"""Get [`AggregateDistributedGenerationA`](@ref) `tfl`."""
get_tfl(value::AggregateDistributedGenerationA) = value.tfl
"""Get [`AggregateDistributedGenerationA`](@ref) `tfh`."""
get_tfh(value::AggregateDistributedGenerationA) = value.tfh
"""Get [`AggregateDistributedGenerationA`](@ref) `Tg`."""
get_Tg(value::AggregateDistributedGenerationA) = value.Tg
"""Get [`AggregateDistributedGenerationA`](@ref) `rrpwr`."""
get_rrpwr(value::AggregateDistributedGenerationA) = value.rrpwr
"""Get [`AggregateDistributedGenerationA`](@ref) `Tv`."""
get_Tv(value::AggregateDistributedGenerationA) = value.Tv
"""Get [`AggregateDistributedGenerationA`](@ref) `Vpr`."""
get_Vpr(value::AggregateDistributedGenerationA) = value.Vpr
"""Get [`AggregateDistributedGenerationA`](@ref) `Iqhl`."""
get_Iqhl(value::AggregateDistributedGenerationA) = value.Iqhl
"""Get [`AggregateDistributedGenerationA`](@ref) `Iqll`."""
get_Iqll(value::AggregateDistributedGenerationA) = value.Iqll
"""Get [`AggregateDistributedGenerationA`](@ref) `ext`."""
get_ext(value::AggregateDistributedGenerationA) = value.ext
"""Get [`AggregateDistributedGenerationA`](@ref) `states`."""
get_states(value::AggregateDistributedGenerationA) = value.states
"""Get [`AggregateDistributedGenerationA`](@ref) `n_states`."""
get_n_states(value::AggregateDistributedGenerationA) = value.n_states

"""Set [`AggregateDistributedGenerationA`](@ref) `Pf_Flag`."""
set_Pf_Flag!(value::AggregateDistributedGenerationA, val) = value.Pf_Flag = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Freq_Flag`."""
set_Freq_Flag!(value::AggregateDistributedGenerationA, val) = value.Freq_Flag = val
"""Set [`AggregateDistributedGenerationA`](@ref) `PQ_Flag`."""
set_PQ_Flag!(value::AggregateDistributedGenerationA, val) = value.PQ_Flag = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Gen_Flag`."""
set_Gen_Flag!(value::AggregateDistributedGenerationA, val) = value.Gen_Flag = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Vtrip_Flag`."""
set_Vtrip_Flag!(value::AggregateDistributedGenerationA, val) = value.Vtrip_Flag = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Ftrip_Flag`."""
set_Ftrip_Flag!(value::AggregateDistributedGenerationA, val) = value.Ftrip_Flag = val
"""Set [`AggregateDistributedGenerationA`](@ref) `T_rv`."""
set_T_rv!(value::AggregateDistributedGenerationA, val) = value.T_rv = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Trf`."""
set_Trf!(value::AggregateDistributedGenerationA, val) = value.Trf = val
"""Set [`AggregateDistributedGenerationA`](@ref) `dbd1`."""
set_dbd1!(value::AggregateDistributedGenerationA, val) = value.dbd1 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `dbd2`."""
set_dbd2!(value::AggregateDistributedGenerationA, val) = value.dbd2 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `K_qv`."""
set_K_qv!(value::AggregateDistributedGenerationA, val) = value.K_qv = val
"""Set [`AggregateDistributedGenerationA`](@ref) `V_ref0`."""
set_V_ref0!(value::AggregateDistributedGenerationA, val) = value.V_ref0 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Tp`."""
set_Tp!(value::AggregateDistributedGenerationA, val) = value.Tp = val
"""Set [`AggregateDistributedGenerationA`](@ref) `T_iq`."""
set_T_iq!(value::AggregateDistributedGenerationA, val) = value.T_iq = val
"""Set [`AggregateDistributedGenerationA`](@ref) `D_dn`."""
set_D_dn!(value::AggregateDistributedGenerationA, val) = value.D_dn = val
"""Set [`AggregateDistributedGenerationA`](@ref) `D_up`."""
set_D_up!(value::AggregateDistributedGenerationA, val) = value.D_up = val
"""Set [`AggregateDistributedGenerationA`](@ref) `fdbd1`."""
set_fdbd1!(value::AggregateDistributedGenerationA, val) = value.fdbd1 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `fdbd2`."""
set_fdbd2!(value::AggregateDistributedGenerationA, val) = value.fdbd2 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `femax`."""
set_femax!(value::AggregateDistributedGenerationA, val) = value.femax = val
"""Set [`AggregateDistributedGenerationA`](@ref) `femin`."""
set_femin!(value::AggregateDistributedGenerationA, val) = value.femin = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Pmax`."""
set_Pmax!(value::AggregateDistributedGenerationA, val) = value.Pmax = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Pmin`."""
set_Pmin!(value::AggregateDistributedGenerationA, val) = value.Pmin = val
"""Set [`AggregateDistributedGenerationA`](@ref) `dPmax`."""
set_dPmax!(value::AggregateDistributedGenerationA, val) = value.dPmax = val
"""Set [`AggregateDistributedGenerationA`](@ref) `dPmin`."""
set_dPmin!(value::AggregateDistributedGenerationA, val) = value.dPmin = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Tpord`."""
set_Tpord!(value::AggregateDistributedGenerationA, val) = value.Tpord = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Kpg`."""
set_Kpg!(value::AggregateDistributedGenerationA, val) = value.Kpg = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Kig`."""
set_Kig!(value::AggregateDistributedGenerationA, val) = value.Kig = val
"""Set [`AggregateDistributedGenerationA`](@ref) `I_max`."""
set_I_max!(value::AggregateDistributedGenerationA, val) = value.I_max = val
"""Set [`AggregateDistributedGenerationA`](@ref) `vl0`."""
set_vl0!(value::AggregateDistributedGenerationA, val) = value.vl0 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `vl1`."""
set_vl1!(value::AggregateDistributedGenerationA, val) = value.vl1 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `vh0`."""
set_vh0!(value::AggregateDistributedGenerationA, val) = value.vh0 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `vh1`."""
set_vh1!(value::AggregateDistributedGenerationA, val) = value.vh1 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `tv10`."""
set_tv10!(value::AggregateDistributedGenerationA, val) = value.tv10 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `tvl1`."""
set_tvl1!(value::AggregateDistributedGenerationA, val) = value.tvl1 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `tvh0`."""
set_tvh0!(value::AggregateDistributedGenerationA, val) = value.tvh0 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `tvh1`."""
set_tvh1!(value::AggregateDistributedGenerationA, val) = value.tvh1 = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Vrfrac`."""
set_Vrfrac!(value::AggregateDistributedGenerationA, val) = value.Vrfrac = val
"""Set [`AggregateDistributedGenerationA`](@ref) `fl`."""
set_fl!(value::AggregateDistributedGenerationA, val) = value.fl = val
"""Set [`AggregateDistributedGenerationA`](@ref) `fh`."""
set_fh!(value::AggregateDistributedGenerationA, val) = value.fh = val
"""Set [`AggregateDistributedGenerationA`](@ref) `tfl`."""
set_tfl!(value::AggregateDistributedGenerationA, val) = value.tfl = val
"""Set [`AggregateDistributedGenerationA`](@ref) `tfh`."""
set_tfh!(value::AggregateDistributedGenerationA, val) = value.tfh = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Tg`."""
set_Tg!(value::AggregateDistributedGenerationA, val) = value.Tg = val
"""Set [`AggregateDistributedGenerationA`](@ref) `rrpwr`."""
set_rrpwr!(value::AggregateDistributedGenerationA, val) = value.rrpwr = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Tv`."""
set_Tv!(value::AggregateDistributedGenerationA, val) = value.Tv = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Vpr`."""
set_Vpr!(value::AggregateDistributedGenerationA, val) = value.Vpr = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Iqhl`."""
set_Iqhl!(value::AggregateDistributedGenerationA, val) = value.Iqhl = val
"""Set [`AggregateDistributedGenerationA`](@ref) `Iqll`."""
set_Iqll!(value::AggregateDistributedGenerationA, val) = value.Iqll = val
"""Set [`AggregateDistributedGenerationA`](@ref) `ext`."""
set_ext!(value::AggregateDistributedGenerationA, val) = value.ext = val

