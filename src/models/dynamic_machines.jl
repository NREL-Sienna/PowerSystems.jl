"""
Obtain coefficients (A, B) of the function Se = B(x - A)^2/x for
Se(1.2) = B(1.2 - A)^2/1.2 and Se(1.0) = B(1.0 - A)^2/1.0 as:
Se(1.0) = (Se(1.2) * 1.2) /(1.2 - A)^2 * (1.0 - A)^2/1.0 that yields
(1.2 - A)^2 Se(1.0) = Se(1.2) * 1.2 * (1.0 - A)^2 or expanding:
(1.2 * Se(1.2) - Se(1.0)) A^2 + (2.4 Se(1.0) - 2 * 1.2 * Se(1.2)) A + (1.2 * Se(1.2) - 1.44 Se(1.0)) = 0
and uses the negative solution of the quadratic equation.
"""
function get_quadratic_saturation(Se::Tuple{Float64, Float64})
    return calculate_saturation_coefficients((1.0, 1.2), Se)
end

"""
Obtain coefficients (A, B) of the function Se = Bx^A for
Se(1.2) = B(1.2)^A and Se(1.0) = B(1.0)^A as:
B = Se(1.0) and hence
(1.2)^A = Se(1.2)/B -> A = log(Se(1.2)/B) / log(1.2)
"""
function get_exponential_saturation(Se::Tuple{Float64, Float64})
    if Se[1] == 0.0 || Se[2] == 0.0
        @warn "$(Se[1]) or $(Se[2]) equals to zero. Ignoring saturation."
        return (0.0, 0.0)
    end
    if Se[2] <= Se[1]
        throw(
            IS.ConflictingInputsError(
                "Se(1.2) <= Se(1.0). Saturation data is inconsistent.",
            ),
        )
    end
    B = Se[1]
    A = log(Se[2] / B) / log(1.2)

    return (A, B)
end
