abstract type DynamicGeneratorComponent <: DynamicComponent end
abstract type AVR <: DynamicGeneratorComponent end
abstract type Machine <: DynamicGeneratorComponent end
abstract type PSS <: DynamicGeneratorComponent end
abstract type Shaft <: DynamicGeneratorComponent end
abstract type TurbineGov <: DynamicGeneratorComponent end

"""
Obtain coefficients (A, B) of the function Se(x) = B(x - A)^2/x for
Se(E1) = B(E1 - A)^2/E1 and Se(E2) = B(E2 - A)^2/2
and uses the negative solution of the quadratic equation 
"""
function get_avr_saturation(E::Tuple{Float64, Float64}, Se::Tuple{Float64, Float64})
    if ((E[1] == 0) & (E[2] == 0)) || ((Se[1] == 0) & (Se[2] == 0))
        return (0.0, 0.0)
    end
    if (E[2] <= E[1]) || (Se[2] <= Se[1])
        throw(IS.ConflictingInputsError("E2 <= E1 or Se1 <= Se2. Saturation data is inconsistent."))
    end
    A =
        (1.0 / (Se[2] * E[2] - Se[1] * E[1])) * (
            E[1] * E[2] * (Se[2] - Se[1]) -
            sqrt(E[1] * E[2] * Se[1] * Se[2] * (E[1] - E[2])^2)
        )
    B = Se[2] * E[2] / (E[2] - A)^2

    @assert abs(B - Se[1] * E[1] / (E[1] - A)^2) <= 1e-2
    return (A, B)
end
