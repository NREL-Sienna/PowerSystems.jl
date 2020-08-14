"""
Obtain coefficients (A, B) of the function Se = B(x - A)^2 for
Se(1.2) = B(1.2 - A)^2 and Se(1.0) = B(1.0 - A)^2 as:
Se(1.0) = Se(1.2)/(1.2 - A)^2 * (1.0 - A)^2 that yields
(1.2 - A)^2 Se(1.0) = Se(1.2) * (1.0 - A)^2 or expanding:
(Se(1.2) - Se(1.0)) A^2 + (2.4 Se(1.0) - 2 Se(1.2)) A + (Se(1.2) - 1.44 Se(1.0)) = 0
and uses the negative solution of the quadratic equation
"""
function get_quadratic_saturation(Se::Tuple{Float64, Float64})
    if Se[1] == 0.0 || Se[2] == 0.0
        @warn "$(Se[1]) or $(Se[2]) equals to zero. Ignoring saturation."
        return (0.0, 0.0)
    end
    if Se[2] <= Se[1]
        throw(IS.ConflictingInputsError("Se(1.2) <= Se(1.0). Saturation data is inconsistent."))
    end
    E1 = 1.0
    E12 = 1.2
    Sat_Se1 = Se[1]
    Sat_Se12 = Se[2]
    Sat_a = sqrt(E1 * Sat_Se1 / (E12 * Sat_Se12)) * ((Sat_Se12 > 0) + (Sat_Se12 < 0))
    Sat_A = E12 - (E1 - E12) / (Sat_a - 1)
    Sat_B = E12 * Sat_Se12 * (Sat_a - 1)^2 * ((Sat_a > 0) + (Sat_a < 0)) / (E1 - E12)^2

    return (Sat_A, Sat_B)
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
        throw(IS.ConflictingInputsError("Se(1.2) <= Se(1.0). Saturation data is inconsistent."))
    end
    B = Se[1]
    A = log(Se[2] / B) / log(1.2)

    return (A, B)
end
