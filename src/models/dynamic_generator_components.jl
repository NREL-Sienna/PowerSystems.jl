abstract type DynamicGeneratorComponent <: DynamicComponent end
abstract type AVR <: DynamicGeneratorComponent end
abstract type Machine <: DynamicGeneratorComponent end
abstract type PSS <: DynamicGeneratorComponent end
abstract type Shaft <: DynamicGeneratorComponent end
abstract type TurbineGov <: DynamicGeneratorComponent end

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
