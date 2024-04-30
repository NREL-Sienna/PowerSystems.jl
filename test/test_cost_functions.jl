@testset "Test ValueCurves" begin
    # InputOutputCurve
    io_quadratic = InputOutputCurve(QuadraticFunctionData(3, 2, 1))
    @test io_quadratic isa InputOutputCurve{QuadraticFunctionData}
    @test get_function_data(io_quadratic) == QuadraticFunctionData(3, 2, 1)
    @test IncrementalCurve(io_quadratic) ==
          IncrementalCurve(LinearFunctionData(6, 2), 1.0)
    @test AverageRateCurve(io_quadratic) ==
          AverageRateCurve(LinearFunctionData(3, 2), 1.0)
    @test zero(io_quadratic) == InputOutputCurve(LinearFunctionData(0, 0))
    @test zero(InputOutputCurve) == InputOutputCurve(LinearFunctionData(0, 0))

    io_linear = InputOutputCurve(LinearFunctionData(2, 1))
    @test io_linear isa InputOutputCurve{LinearFunctionData}
    @test get_function_data(io_linear) == LinearFunctionData(2, 1)
    @test InputOutputCurve{QuadraticFunctionData}(io_linear) ==
          InputOutputCurve(QuadraticFunctionData(0, 2, 1))
    @test IncrementalCurve(io_linear) ==
          IncrementalCurve(LinearFunctionData(0, 2), 1.0)
    @test AverageRateCurve(io_linear) ==
          AverageRateCurve(LinearFunctionData(0, 2), 1.0)

    io_piecewise = InputOutputCurve(PiecewiseLinearData([(1, 6), (3, 9), (5, 13)]))
    @test io_piecewise isa InputOutputCurve{PiecewiseLinearData}
    @test get_function_data(io_piecewise) ==
          PiecewiseLinearData([(1, 6), (3, 9), (5, 13)])
    @test IncrementalCurve(io_piecewise) ==
          IncrementalCurve(PiecewiseStepData([1, 3, 5], [1.5, 2]), 6.0)
    @test AverageRateCurve(io_piecewise) ==
          AverageRateCurve(PiecewiseStepData([1, 3, 5], [3, 2.6]), 6.0)

    # IncrementalCurve
    inc_linear = IncrementalCurve(LinearFunctionData(6, 2), 1.0)
    @test inc_linear isa IncrementalCurve{LinearFunctionData}
    @test get_function_data(inc_linear) == LinearFunctionData(6, 2)
    @test get_initial_input(inc_linear) == 1
    @test InputOutputCurve(inc_linear) ==
          InputOutputCurve(QuadraticFunctionData(3, 2, 1))
    @test InputOutputCurve(IncrementalCurve(LinearFunctionData(0, 2), 1.0)) ==
          InputOutputCurve(LinearFunctionData(2, 1))
    @test AverageRateCurve(inc_linear) ==
          AverageRateCurve(LinearFunctionData(3, 2), 1.0)
    @test zero(inc_linear) == IncrementalCurve(LinearFunctionData(0, 0), 0.0)
    @test zero(IncrementalCurve) == IncrementalCurve(LinearFunctionData(0, 0), 0.0)

    inc_piecewise = IncrementalCurve(PiecewiseStepData([1, 3, 5], [1.5, 2]), 6.0)
    @test inc_piecewise isa IncrementalCurve{PiecewiseStepData}
    @test get_function_data(inc_piecewise) == PiecewiseStepData([1, 3, 5], [1.5, 2])
    @test get_initial_input(inc_piecewise) == 6
    @test InputOutputCurve(inc_piecewise) ==
          InputOutputCurve(PiecewiseLinearData([(1, 6), (3, 9), (5, 13)]))
    @test AverageRateCurve(inc_piecewise) ==
          AverageRateCurve(PiecewiseStepData([1, 3, 5], [3, 2.6]), 6.0)

    # AverageRateCurve
    ar_linear = AverageRateCurve(LinearFunctionData(3, 2), 1.0)
    @test ar_linear isa AverageRateCurve{LinearFunctionData}
    @test get_function_data(ar_linear) == LinearFunctionData(3, 2)
    @test get_initial_input(ar_linear) == 1
    @test InputOutputCurve(ar_linear) ==
          InputOutputCurve(QuadraticFunctionData(3, 2, 1))
    @test InputOutputCurve(AverageRateCurve(LinearFunctionData(0, 2), 1.0)) ==
          InputOutputCurve(LinearFunctionData(2, 1))
    @test IncrementalCurve(ar_linear) ==
          IncrementalCurve(LinearFunctionData(6, 2), 1.0)
    @test zero(ar_linear) == AverageRateCurve(LinearFunctionData(0, 0), 0.0)
    @test zero(AverageRateCurve) == AverageRateCurve(LinearFunctionData(0, 0), 0.0)

    ar_piecewise = AverageRateCurve(PiecewiseStepData([1, 3, 5], [3, 2.6]), 6.0)
    @test get_function_data(ar_piecewise) == PiecewiseStepData([1, 3, 5], [3, 2.6])
    @test get_initial_input(ar_piecewise) == 6
    @test InputOutputCurve(ar_piecewise) ==
          InputOutputCurve(PiecewiseLinearData([(1, 6), (3, 9), (5, 13)]))
    @test IncrementalCurve(ar_piecewise) ==
          IncrementalCurve(PiecewiseStepData([1, 3, 5], [1.5, 2]), 6.0)

    # Serialization round trip
    curves_by_type = [  # typeof() gives parameterized types
        (io_quadratic, InputOutputCurve),
        (io_linear, InputOutputCurve),
        (io_piecewise, InputOutputCurve),
        (inc_linear, IncrementalCurve),
        (inc_piecewise, IncrementalCurve),
        (ar_linear, AverageRateCurve),
        (ar_piecewise, AverageRateCurve),
    ]
    for (curve, curve_type) in curves_by_type
        @test IS.serialize(curve) isa AbstractDict
        @test IS.deserialize(curve_type, IS.serialize(curve)) == curve
    end

    @test zero(PSY.ValueCurve) == InputOutputCurve(LinearFunctionData(0, 0))
end

@testset "Test cost aliases" begin
    @test LinearCurve(3.0) == InputOutputCurve(LinearFunctionData(3.0, 0.0))
    @test LinearCurve(3.0, 5.0) == InputOutputCurve(LinearFunctionData(3.0, 5.0))
    @test QuadraticCurve(1.0, 1.0, 18.0) ==
          InputOutputCurve(QuadraticFunctionData(1.0, 1.0, 18.0))
    @test PiecewisePointCurve([(1.0, 20.0), (2.0, 24.0), (3.0, 30.0)]) ==
          InputOutputCurve(PiecewiseLinearData([(1.0, 20.0), (2.0, 24.0), (3.0, 30.0)]))
    @test PiecewiseIncrementalCurve(20.0, [1.0, 2.0, 3.0], [4.0, 6.0]) ==
          IncrementalCurve(PiecewiseStepData([1.0, 2.0, 3.0], [4.0, 6.0]), 20.0)
    @test PiecewiseAverageCurve(20.0, [1.0, 2.0, 3.0], [12.0, 10.0]) ==
          AverageRateCurve(PiecewiseStepData([1.0, 2.0, 3.0], [12.0, 10.0]), 20.0)
end

@testset "Test CostCurve and FuelCurve" begin
    cc = CostCurve(InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3)))
    fc = FuelCurve(InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3)), 4.0)
    # TODO also test fuel curves with time series

    @test get_value_curve(cc) == InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3))
    @test get_value_curve(fc) == InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3))
    @test get_fuel_cost(fc) == 4

    @test IS.serialize(cc) isa AbstractDict
    @test IS.serialize(fc) isa AbstractDict
    @test IS.deserialize(CostCurve, IS.serialize(cc)) == cc
    @test IS.deserialize(FuelCurve, IS.serialize(fc)) == fc

    @test zero(cc) == CostCurve(InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)))
    @test zero(CostCurve) == CostCurve(InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)))
    @test zero(fc) ==
          FuelCurve(InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)), 0.0)
    @test zero(FuelCurve) ==
          FuelCurve(InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)), 0.0)

    @test get_power_units(cc) == UnitSystem.NATURAL_UNITS
    @test get_power_units(fc) == UnitSystem.NATURAL_UNITS
    @test get_power_units(CostCurve(zero(InputOutputCurve), UnitSystem.SYSTEM_BASE)) ==
          UnitSystem.SYSTEM_BASE
    @test get_power_units(FuelCurve(zero(InputOutputCurve), UnitSystem.DEVICE_BASE, 1.0)) ==
          UnitSystem.DEVICE_BASE
end

test_costs = Dict(
    QuadraticFunctionData =>
        repeat([QuadraticFunctionData(999.0, 2.0, 1.0)], 24),
    PiecewiseLinearData =>
        repeat(
            [PiecewiseStepData([1.0, 2.0, 3.0], [4.0, 6.0])],
            24,
        ),
)

@testset "Test MarketBidCost with Quadratic Cost Timeseries with Service Forecast" begin
    # Will throw TypeErrors because market bids must be piecewise, not quadratic and service
    # bids must be piecewise, not scalar
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    service_data = Dict(initial_time => ones(horizon))
    data_quadratic =
        SortedDict(initial_time => test_costs[QuadraticFunctionData])
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast = IS.Deterministic("variable_cost", data_quadratic, resolution)
    @test_throws TypeError set_variable_cost!(sys, generator, forecast)
    for s in generator.services
        forecast = IS.Deterministic(get_name(s), service_data, resolution)
        @test_throws TypeError set_service_bid!(sys, generator, s, forecast)
    end
end

@testset "Test MarketBidCost with PiecewiseLinearData Cost Timeseries" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseLinearData])
    service_data = data_pwl
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast = IS.Deterministic("variable_cost", data_pwl, resolution)
    set_variable_cost!(sys, generator, forecast)
    for s in generator.services
        forecast = IS.Deterministic(get_name(s), service_data, resolution)
        set_service_bid!(sys, generator, s, forecast)
    end

    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test first(TimeSeries.values(cost_forecast)) == first(data_pwl[initial_time])

    for s in generator.services
        service_cost = get_services_bid(generator, market_bid, s; start_time = initial_time)
        @test first(TimeSeries.values(service_cost)) == first(service_data[initial_time])
    end
end

@testset "Test MarketBidCost with single `start_up::Number` value" begin
    expected = (hot = 1.0, warm = 0.0, cold = 0.0)  # should only be used for the `hot` value.
    cost = MarketBidCost(; start_up = 1, no_load_cost = rand(), shut_down = rand())
    @test get_start_up(cost) == expected
end

@testset "Test ReserveDemandCurve with Cost Timeseries" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    other_time = initial_time + resolution
    name = "test"
    horizon = 24
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseLinearData],
        other_time => test_costs[PiecewiseLinearData])
    sys = System(100.0)
    reserve = ReserveDemandCurve{ReserveUp}(nothing)
    add_component!(sys, reserve)
    forecast = IS.Deterministic("variable_cost", data_pwl, resolution)
    set_variable_cost!(sys, reserve, forecast)
    cost_forecast = get_variable_cost(reserve; start_time = initial_time)
    @test first(TimeSeries.values(cost_forecast)) == first(data_pwl[initial_time])
end
