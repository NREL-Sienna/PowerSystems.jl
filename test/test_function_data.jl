get_test_function_data() = [
    LinearFunctionData(5),
    QuadraticFunctionData(2, 3, 4),
    PolynomialFunctionData(Dict(0 => 3.0, 1 => 1.0, 3 => 4.0)),
    PiecewiseLinearPointData([(1, 1), (3, 5), (5, 10)]),
    PiecewiseLinearSlopeData([1, 3, 5], 1, [2, 2.5]),
]

@testset "Test FunctionData validation" begin
    # @test_throws ArgumentError PiecewiseLinearPointData([(-1, 1), (1, 1)])
    # @test_throws ArgumentError PiecewiseLinearSlopeData([(-1, 1), (1, 1)])
    @test_throws ArgumentError PiecewiseLinearPointData([(2, 1), (1, 1)])
    @test_throws ArgumentError PiecewiseLinearSlopeData([2, 1], 1, [1])
end

@testset "Test FunctionData trivial getters" begin
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
    @test get_points(yd) == [(1, 1), (3, 5)]

    dd = PiecewiseLinearSlopeData([1, 3, 5], 2, [3, 6])
    @test get_x_coords(dd) == [1, 3, 5]
    @test get_y0(dd) == 2
    @test get_slopes(dd) == [3, 6]
end

@testset "Test FunctionData calculations" begin
    @test length(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2)])) == 2
    @test length(PiecewiseLinearSlopeData([1, 1.1, 1.2], 1, [1.1, 10])) == 2

    @test PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2)])[2] == (1, 1)
    @test get_x_coords(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2)])) == [0, 1, 1.1]

    # Tests our overridden Base.:(==)
    @test all(get_test_function_data() .== get_test_function_data())

    @test all(isapprox.(get_slopes(PiecewiseLinearPointData([(0, 0), (10, 31.4)])), [3.14]))
    @test isapprox(
        get_slopes(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2), (1.2, 3)])),
        [1, 10, 10])
    @test isapprox(
        get_slopes(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2)])),
        [1, 10])

    @test isapprox(
        collect.(get_points(PiecewiseLinearSlopeData([1, 3, 5], 1, [2.5, 10]))),
        collect.([(1, 1), (3, 6), (5, 26)]),
    )

    @test isapprox(
        get_x_lengths(PiecewiseLinearPointData([(1, 1), (1.1, 2), (1.2, 3)])),
        [0.1, 0.1])
    @test isapprox(
        get_x_lengths(PiecewiseLinearSlopeData([1, 1.1, 1.2], 1, [1.1, 10])),
        [0.1, 0.1])

    @test is_convex(PiecewiseLinearSlopeData([0, 1, 1.1, 1.2], 1, [1.1, 10, 10]))
    @test !is_convex(PiecewiseLinearSlopeData([0, 1, 1.1, 1.2], 1, [1.1, 10, 9]))
    @test is_convex(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2), (1.2, 3)]))
    @test !is_convex(PiecewiseLinearPointData([(0, 0), (1, 1), (1.1, 2), (5, 3)]))
end

@testset "Test FunctionData piecewise point/slope conversion" begin
    rng = Xoshiro(0)  # Set random seed for determinism
    n_tests = 100
    n_points = 10
    for _ in 1:n_tests
        rand_x = sort(rand(rng, n_points))
        rand_y = rand(rng, n_points)
        pointwise = PiecewiseLinearPointData(collect(zip(rand_x, rand_y)))
        slopewise = PiecewiseLinearSlopeData(
            get_x_coords(pointwise),
            first(get_points(pointwise))[2],
            get_slopes(pointwise))
        pointwise_2 = PiecewiseLinearPointData(get_points(slopewise))
        @test isapprox(collect.(get_points(pointwise_2)), collect.(get_points(pointwise)))
    end
end

@testset "Test FunctionData serialization round trip" begin
    for fd in get_test_function_data()
        for do_jsonify in (false, true)
            serialized = IS.serialize(fd)
            do_jsonify && (serialized = JSON3.read(JSON3.write(serialized), Dict))
            @test typeof(serialized) <: AbstractDict
            deserialized = IS.deserialize(typeof(fd), serialized)
            @test deserialized == fd
        end
    end
end
