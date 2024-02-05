@testset "Test FunctionData getters" begin
    ld = LinearFunctionData(5)
    @test get_proportional_term(ld) == 5

    qd = QuadraticFunctionData(2, 3, 4)
    @test get_quadratic_term(qd) == 2
    @test get_proportional_term(qd) == 3
    @test get_constant_term(qd) == 4

    pd = PolynomialFunctionData(Dict(0 => 3., 1 => 1., 3 => 4.))
    coeffs = get_coefficients(pd)
    @test length(coeffs) == 3
    @test coeffs[0] === 3. && coeffs[1] === 1. && coeffs[3] === 4.
end
