"""
Obtain coefficients (A, B) of the function Se = B(x - A)^2 for
Se(1.2) = B(1.2 - A)^2 and Se(1.0) = B(1.0 - A)^2 as:
Se(1.0) = Se(1.2)/(1.2 - A)^2 * (1.0 - A)^2 that yields
(1.2 - A)^2 Se(1.0) = Se(1.2) * (1.0 - A)^2 or expanding:
(Se(1.2) - Se(1.0)) A^2 + (2.4 Se(1.0) - 2 Se(1.2)) A + (Se(1.2) - 1.44 Se(1.0)) = 0
and uses the negative solution of the quadratic equation 
"""
function get_quadratic_saturation(Se::Tuple{Float64, Float64})
    if Se[1] == 0.0 && Se[2] == 0.0
        return (0.0, 0.0)
    end
    if Se[2] <= Se[1]
        throw(IS.ConflictingInputsError("Se(1.2) <= Se(1.0). Saturation data is inconsistent."))
    end
    A =
        (1.0 / (2.0 * (Se[2] - Se[1]))) * (
            2 * Se[2] - 2.4 * Se[1] - sqrt(
                (2.4 * Se[1] - 2.0 * Se[2])^2 -
                4.0 * (Se[2] - 1.44 * Se[1]) * (Se[2] - Se[1]),
            )
        )
    B = Se[2] / (1.2 - A)^2

    @assert abs(B - Se[1] / (1.0 - A)^2) <= 1e-6
    return (A, B)
end

"""
Obtain coefficients (A, B) of the function Se = Bx^A for
Se(1.2) = B(1.2)^A and Se(1.0) = B(1.0)^A as:
B = Se(1.0) and hence
(1.2)^A = Se(1.2)/B -> A = log(Se(1.2)/B) / log(1.2)
"""
function get_exponential_saturation(Se::Tuple{Float64, Float64})
    if Se[1] == 0.0 && Se[2] == 0.0
        return (0.0, 0.0)
    end
    if Se[2] <= Se[1]
        throw(IS.ConflictingInputsError("Se(1.2) <= Se(1.0). Saturation data is inconsistent."))
    end
    B = Se[1]
    A = log(Se[2] / B) / log(1.2)

    return (A, B)
end

"""
"3-states salient-pole synchronous machine with quadratic saturation:
IEEE Std 1110 §5.3.2 (Model 2.1). GENSAL in PSSE and PSLF."
"""
mutable struct SalientPoleQuadratic <: Machine
    base_machine::SalientPoleMachine
    saturation_coeffs::Tuple{Float64, Float64}

    function SalientPoleQuadratic(
        R::Float64,
        Td0_p::Float64,
        Td0_pp::Float64,
        Tq0_pp::Float64,
        Xd::Float64,
        Xq::Float64,
        Xd_p::Float64,
        Xd_pp::Float64,
        Xl::Float64,
        Se::Tuple{Float64, Float64},
    )
        IS.@forward((SalientPoleQuadratic, :base_machine), SalientPoleMachine)
        saturation_coeffs = get_quadratic_saturation(Se)
        new(
            SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se),
            saturation_coeffs,
        )
    end
end

function SalientPoleQuadratic(; R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se)
    SalientPoleQuadratic(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se)
end

function SalientPoleQuadratic(::Nothing)
    SalientPoleQuadratic(;
        R = 0.0,
        Td0_p = 0.0,
        Td0_pp = 0.0,
        Tq0_pp = 0.0,
        Xd = 0.0,
        Xq = 0.0,
        Xd_p = 0.0,
        Xd_pp = 0.0,
        Xl = 0.0,
        Se = (0.0, 0.0),
    )
end

"""
"3-states salient-pole synchronous machine with exponential saturation:
IEEE Std 1110 §5.3.2 (Model 2.1). GENSAE in PSSE and PSLF."
"""
mutable struct SalientPoleExponential <: Machine
    base_machine::SalientPoleMachine
    saturation_coeffs::Tuple{Float64, Float64}

    function SalientPoleExponential(
        R::Float64,
        Td0_p::Float64,
        Td0_pp::Float64,
        Tq0_pp::Float64,
        Xd::Float64,
        Xq::Float64,
        Xd_p::Float64,
        Xd_pp::Float64,
        Xl::Float64,
        Se::Tuple{Float64, Float64},
    )
        IS.@forward((SalientPoleExponential, :base_machine), SalientPoleMachine)
        saturation_coeffs = get_exponential_saturation(Se)
        new(
            SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se),
            saturation_coeffs,
        )
    end
end

function SalientPoleExponential(; R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se)
    SalientPoleExponential(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se)
end

function SalientPoleExponential(::Nothing)
    SalientPoleExponential(;
        R = 0.0,
        Td0_p = 0.0,
        Td0_pp = 0.0,
        Tq0_pp = 0.0,
        Xd = 0.0,
        Xq = 0.0,
        Xd_p = 0.0,
        Xd_pp = 0.0,
        Xl = 0.0,
        Se = (0.0, 0.0),
    )
end

"""
4-states round-rotor synchronous machine with quadratic saturation:
IEEE Std 1110 §5.3.2 (Model 2.2). GENROU model in PSSE and PSLF.
"""
mutable struct RoundRotorQuadratic <: Machine
    base_machine::RoundRotorMachine
    saturation_coeffs::Tuple{Float64, Float64}

    function RoundRotorQuadratic(
        R::Float64,
        Td0_p::Float64,
        Td0_pp::Float64,
        Tq0_p::Float64,
        Tq0_pp::Float64,
        Xd::Float64,
        Xq::Float64,
        Xd_p::Float64,
        Xq_p::Float64,
        Xd_pp::Float64,
        Xl::Float64,
        Se::Tuple{Float64, Float64},
    )
        IS.@forward((RoundRotorQuadratic, :base_machine), RoundRotorMachine)
        saturation_coeffs = get_quadratic_saturation(Se)
        new(
            RoundRotorMachine(
                R,
                Td0_p,
                Td0_pp,
                Tq0_p,
                Tq0_pp,
                Xd,
                Xq,
                Xd_p,
                Xq_p,
                Xd_pp,
                Xl,
                Se,
            ),
            saturation_coeffs,
        )
    end
end

function RoundRotorQuadratic(;
    R,
    Td0_p,
    Td0_pp,
    Tq0_p,
    Tq0_pp,
    Xd,
    Xq,
    Xd_p,
    Xq_p,
    Xd_pp,
    Xl,
    Se,
)
    RoundRotorQuadratic(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se)
end

function RoundRotorQuadratic(::Nothing)
    RoundRotorQuadratic(;
        R = 0.0,
        Td0_p = 0.0,
        Td0_pp = 0.0,
        Tq0_p = 0.0,
        Tq0_pp = 0.0,
        Xd = 0.0,
        Xq = 0.0,
        Xd_p = 0.0,
        Xq_p = 0.0,
        Xd_pp = 0.0,
        Xl = 0.0,
        Se = (0.0, 0.0),
    )
end

"""
4-states round-rotor synchronous machine with quadratic saturation:
IEEE Std 1110 §5.3.2 (Model 2.2). GENROU model in PSSE and PSLF.
"""
mutable struct RoundRotorExponential <: Machine
    base_machine::RoundRotorMachine
    saturation_coeffs::Tuple{Float64, Float64}

    function RoundRotorExponential(
        R::Float64,
        Td0_p::Float64,
        Td0_pp::Float64,
        Tq0_p::Float64,
        Tq0_pp::Float64,
        Xd::Float64,
        Xq::Float64,
        Xd_p::Float64,
        Xq_p::Float64,
        Xd_pp::Float64,
        Xl::Float64,
        Se::Tuple{Float64, Float64},
    )
        IS.@forward((RoundRotorExponential, :base_machine), RoundRotorMachine)
        saturation_coeffs = get_exponential_saturation(Se)
        new(
            RoundRotorMachine(
                R,
                Td0_p,
                Td0_pp,
                Tq0_p,
                Tq0_pp,
                Xd,
                Xq,
                Xd_p,
                Xq_p,
                Xd_pp,
                Xl,
                Se,
            ),
            saturation_coeffs,
        )
    end
end

function RoundRotorExponential(;
    R,
    Td0_p,
    Td0_pp,
    Tq0_p,
    Tq0_pp,
    Xd,
    Xq,
    Xd_p,
    Xq_p,
    Xd_pp,
    Xl,
    Se,
)
    RoundRotorExponential(
        R,
        Td0_p,
        Td0_pp,
        Tq0_p,
        Tq0_pp,
        Xd,
        Xq,
        Xd_p,
        Xq_p,
        Xd_pp,
        Xl,
        Se,
    )
end

function RoundRotorExponential(::Nothing)
    RoundRotorExponential(;
        R = 0.0,
        Td0_p = 0.0,
        Td0_pp = 0.0,
        Tq0_p = 0.0,
        Tq0_pp = 0.0,
        Xd = 0.0,
        Xq = 0.0,
        Xd_p = 0.0,
        Xq_p = 0.0,
        Xd_pp = 0.0,
        Xl = 0.0,
        Se = (0.0, 0.0),
    )
end

get_base_machine(value::SalientPoleQuadratic) = value.base_machine
get_base_machine(value::SalientPoleExponential) = value.base_machine
get_base_machine(value::RoundRotorQuadratic) = value.base_machine
get_base_machine(value::RoundRotorExponential) = value.base_machine
get_saturation_coeffs(value::SalientPoleQuadratic) = value.saturation_coeffs
get_saturation_coeffs(value::SalientPoleExponential) = value.saturation_coeffs
get_saturation_coeffs(value::RoundRotorQuadratic) = value.saturation_coeffs
get_saturation_coeffs(value::RoundRotorExponential) = value.saturation_coeffs

set_base_machine!(value::SalientPoleQuadratic, val::SalientPoleMachine) =
    value.base_machine = val
set_base_machine!(value::SalientPoleExponential, val::SalientPoleMachine) =
    value.base_machine = val
set_base_machine!(value::RoundRotorQuadratic, val::RoundRotorMachine) =
    value.base_machine = val
set_base_machine!(value::RoundRotorExponential, val::RoundRotorMachine) =
    value.base_machine = val
set_saturation_coeffs!(value::SalientPoleQuadratic, val::Tuple{Float64, Float64}) =
    value.saturation_coeffs = val
set_saturation_coeffs!(value::SalientPoleExponential, val::Tuple{Float64, Float64}) =
    value.saturation_coeffs = val
set_saturation_coeffs!(value::RoundRotorQuadratic, val::Tuple{Float64, Float64}) =
    value.saturation_coeffs = val
set_saturation_coeffs!(value::RoundRotorExponential, val::Tuple{Float64, Float64}) =
    value.saturation_coeffs = val
