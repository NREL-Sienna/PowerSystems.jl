@testset "Test FunctionData getters" begin
    ld = LinearFunctionData(5)
    @test get_proportional_term(ld) == 5

    qd = QuadraticFunctionData(2, 3, 4)
    @test get_quadratic_term(qd) == 2
    @test get_proportional_term(qd) == 3
    @test get_constant_term(qd) == 4

    pd = PolynomialFunctionData(Dict(0 => 3.0, 1 => 1.0, 3 => 4.0))
    coeffs = get_coefficients(pd)
    @test length(coeffs) == 3
    @test coeffs[0] === 3.0 && coeffs[1] === 1.0 && coeffs[3] === 4.0

    yd = PiecewiseLinearPointData([(1, 1), (3, 5)])
    @test get_segments(yd) == get_points(yd) == [(1, 1), (3, 5)]

    dd = PiecewiseLinearSlopeData([(1, 2), (3, 3)])
    @test get_segments(dd) == [(1, 2), (3, 3)]
    @test get_slopes(dd) == [2, 3]
end

@testset "Test FunctionData calculations" begin
    @test all(isapprox.(get_slopes(PiecewiseLinearPointData([(10, 31.4)])), [3.14]))
    @test get_slopes(PiecewiseLinearPointData([(0, 31.4)])) == [0.0]
    @test isapprox(
        get_slopes(PiecewiseLinearPointData([(1, 1), (1.1, 2), (1.2, 3)])),
        [1, 10, 10])
    @test isapprox(
        get_slopes(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2)])),
        [0, 1, 10])

    @test get_slopes(PiecewiseLinearSlopeData([(1, 1), (1.1, 10), (1.2, 10)])) ==
          [1, 10, 10]

    @test isapprox(
        get_breakpoint_upperbounds(
            PiecewiseLinearPointData([(1, 1), (1.1, 2), (1.2, 3)])),
        [1, 0.1, 0.1])
    @test isapprox(
        get_breakpoint_upperbounds(
            PiecewiseLinearSlopeData([(1, 1), (1.1, 10), (1.2, 10)])),
        [1, 0.1, 0.1])

    @test is_convex(PiecewiseLinearSlopeData([(1, 1), (1.1, 10), (1.2, 10)]))
    @test !is_convex(PiecewiseLinearSlopeData([(1, 1), (1.1, 10), (1.2, 9)]))
    @test is_convex(PiecewiseLinearPointData([(1, 1), (1.1, 2), (1.2, 3)]))
    # TODO the following is non-convex due to the segment from the origin -- is that what we want?
    @test !is_convex(PiecewiseLinearPointData([(1, 100), (1.1, 102), (1.2, 103)]))
end
