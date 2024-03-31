@testset "Test ValueCurves" begin
    # InputOutputCurve
    io_quadratic = PSY.InputOutputCurve(QuadraticFunctionData(3, 2, 1))
    @test io_quadratic isa PSY.InputOutputCurve{QuadraticFunctionData}
    @test PSY.get_function_data(io_quadratic) == QuadraticFunctionData(3, 2, 1)
    @test PSY.IncrementalCurve(io_quadratic) ==
          PSY.IncrementalCurve(LinearFunctionData(6, 2), 1.0)
    @test PSY.AverageRateCurve(io_quadratic) ==
          PSY.AverageRateCurve(LinearFunctionData(3, 2), 1.0)
    @test zero(io_quadratic) == PSY.InputOutputCurve(LinearFunctionData(0, 0))
    @test zero(PSY.InputOutputCurve) == PSY.InputOutputCurve(LinearFunctionData(0, 0))

    io_linear = PSY.InputOutputCurve(LinearFunctionData(2, 1))
    @test io_linear isa PSY.InputOutputCurve{LinearFunctionData}
    @test PSY.get_function_data(io_linear) == LinearFunctionData(2, 1)
    @test PSY.InputOutputCurve{QuadraticFunctionData}(io_linear) ==
          PSY.InputOutputCurve(QuadraticFunctionData(0, 2, 1))
    @test PSY.IncrementalCurve(io_linear) ==
          PSY.IncrementalCurve(LinearFunctionData(0, 2), 1.0)
    @test PSY.AverageRateCurve(io_linear) ==
          PSY.AverageRateCurve(LinearFunctionData(0, 2), 1.0)

    io_piecewise = PSY.InputOutputCurve(PiecewiseLinearData([(1, 6), (3, 9), (5, 13)]))
    @test io_piecewise isa PSY.InputOutputCurve{PiecewiseLinearData}
    @test PSY.get_function_data(io_piecewise) ==
          PiecewiseLinearData([(1, 6), (3, 9), (5, 13)])
    @test PSY.IncrementalCurve(io_piecewise) ==
          PSY.IncrementalCurve(PiecewiseStepData([1, 3, 5], [1.5, 2]), 6.0)
    @test PSY.AverageRateCurve(io_piecewise) ==
          PSY.AverageRateCurve(PiecewiseStepData([1, 3, 5], [3, 2.6]), 6.0)

    # IncrementalCurve
    inc_linear = PSY.IncrementalCurve(LinearFunctionData(6, 2), 1.0)
    @test inc_linear isa PSY.IncrementalCurve{LinearFunctionData}
    @test PSY.get_function_data(inc_linear) == LinearFunctionData(6, 2)
    @test PSY.get_initial_input(inc_linear) == 1
    @test PSY.InputOutputCurve(inc_linear) ==
          PSY.InputOutputCurve(QuadraticFunctionData(3, 2, 1))
    @test PSY.InputOutputCurve(PSY.IncrementalCurve(LinearFunctionData(0, 2), 1.0)) ==
          PSY.InputOutputCurve(LinearFunctionData(2, 1))
    @test PSY.AverageRateCurve(inc_linear) ==
          PSY.AverageRateCurve(LinearFunctionData(3, 2), 1.0)
    @test zero(inc_linear) == PSY.IncrementalCurve(LinearFunctionData(0, 0), 0.0)
    @test zero(PSY.IncrementalCurve) == PSY.IncrementalCurve(LinearFunctionData(0, 0), 0.0)

    inc_piecewise = PSY.IncrementalCurve(PiecewiseStepData([1, 3, 5], [1.5, 2]), 6.0)
    @test inc_piecewise isa PSY.IncrementalCurve{PiecewiseStepData}
    @test PSY.get_function_data(inc_piecewise) == PiecewiseStepData([1, 3, 5], [1.5, 2])
    @test PSY.get_initial_input(inc_piecewise) == 6
    @test PSY.InputOutputCurve(inc_piecewise) ==
          PSY.InputOutputCurve(PiecewiseLinearData([(1, 6), (3, 9), (5, 13)]))
    @test PSY.AverageRateCurve(inc_piecewise) ==
          PSY.AverageRateCurve(PiecewiseStepData([1, 3, 5], [3, 2.6]), 6.0)

    # AverageRateCurve
    ar_linear = PSY.AverageRateCurve(LinearFunctionData(3, 2), 1.0)
    @test ar_linear isa PSY.AverageRateCurve{LinearFunctionData}
    @test PSY.get_function_data(ar_linear) == LinearFunctionData(3, 2)
    @test PSY.get_initial_input(ar_linear) == 1
    @test PSY.InputOutputCurve(ar_linear) ==
          PSY.InputOutputCurve(QuadraticFunctionData(3, 2, 1))
    @test PSY.InputOutputCurve(PSY.AverageRateCurve(LinearFunctionData(0, 2), 1.0)) ==
          PSY.InputOutputCurve(LinearFunctionData(2, 1))
    @test PSY.IncrementalCurve(ar_linear) ==
          PSY.IncrementalCurve(LinearFunctionData(6, 2), 1.0)
    @test zero(ar_linear) == PSY.AverageRateCurve(LinearFunctionData(0, 0), 0.0)
    @test zero(PSY.AverageRateCurve) == PSY.AverageRateCurve(LinearFunctionData(0, 0), 0.0)

    ar_piecewise = PSY.AverageRateCurve(PiecewiseStepData([1, 3, 5], [3, 2.6]), 6.0)
    @test PSY.get_function_data(ar_piecewise) == PiecewiseStepData([1, 3, 5], [3, 2.6])
    @test PSY.get_initial_input(ar_piecewise) == 6
    @test PSY.InputOutputCurve(ar_piecewise) ==
          PSY.InputOutputCurve(PiecewiseLinearData([(1, 6), (3, 9), (5, 13)]))
    @test PSY.IncrementalCurve(ar_piecewise) ==
          PSY.IncrementalCurve(PiecewiseStepData([1, 3, 5], [1.5, 2]), 6.0)

    # Serialization round trip
    curves_by_type = [
        (io_quadratic, PSY.InputOutputCurve),
        (io_linear, PSY.InputOutputCurve),
        (io_piecewise, PSY.InputOutputCurve),
        (inc_linear, PSY.IncrementalCurve),
        (inc_piecewise, PSY.IncrementalCurve),
        (ar_linear, PSY.AverageRateCurve),
        (ar_piecewise, PSY.AverageRateCurve),
    ]
    for (curve, curve_type) in curves_by_type
        @test IS.serialize(curve) isa AbstractDict
        @test IS.deserialize(curve_type, IS.serialize(curve)) == curve
    end

    @test zero(PSY.ValueCurve) == PSY.InputOutputCurve(LinearFunctionData(0, 0))
end

@testset "Test CostCurve and FuelCurve" begin
    cc = PSY.CostCurve(PSY.InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3)))
    fc = PSY.FuelCurve(PSY.InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3)), 4.0)
    # TODO also test fuel curves with time series

    @test PSY.get_value_curve(cc) ==
          PSY.InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3))
    @test PSY.get_value_curve(fc) ==
          PSY.InputOutputCurve(PSY.QuadraticFunctionData(1, 2, 3))
    @test PSY.get_fuel_cost(fc) == 4

    @test IS.serialize(cc) isa AbstractDict
    @test IS.serialize(fc) isa AbstractDict
    @test IS.deserialize(PSY.CostCurve, IS.serialize(cc)) == cc
    @test IS.deserialize(PSY.FuelCurve, IS.serialize(fc)) == fc

    @test zero(cc) == PSY.CostCurve(PSY.InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)))
    @test zero(PSY.CostCurve) ==
          PSY.CostCurve(PSY.InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)))
    @test zero(fc) ==
          PSY.FuelCurve(PSY.InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)), 0.0)
    @test zero(PSY.FuelCurve) ==
          PSY.FuelCurve(PSY.InputOutputCurve(PSY.LinearFunctionData(0.0, 0.0)), 0.0)
end

test_costs = Dict(
    QuadraticFunctionData =>
        repeat([QuadraticFunctionData(999.0, 1.0, 0.0)], 24),
    PiecewiseLinearData =>
        repeat([PiecewiseLinearData(repeat([(999.0, 1.0)], 5))], 24),
)

@testset "Test MarketBidCost with Quadratic Cost Timeseries with Service Forecast" begin
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
    set_variable_cost!(sys, generator, forecast)
    for s in generator.services
        forecast = IS.Deterministic(get_name(s), service_data, resolution)
        set_service_bid!(sys, generator, s, forecast)
    end

    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test first(TimeSeries.values(cost_forecast)) == first(data_quadratic[initial_time])

    for s in generator.services
        service_cost = get_services_bid(generator, market_bid, s; start_time = initial_time)
        @test first(TimeSeries.values(service_cost)) == first(service_data[initial_time])
    end
end

@testset "Test MarketBidCost with PiecewiseLinearData Cost Timeseries" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseLinearData])
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast = IS.Deterministic("variable_cost", data_pwl, resolution)
    set_variable_cost!(sys, generator, forecast)

    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test first(TimeSeries.values(cost_forecast)) == first(data_pwl[initial_time])
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
    data_quadratic =
        SortedDict(
            initial_time => test_costs[QuadraticFunctionData],
            other_time => test_costs[QuadraticFunctionData],
        )
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseLinearData],
        other_time => test_costs[PiecewiseLinearData])
    for d in [data_quadratic, data_pwl]
        @testset "Add deterministic from $(typeof(d)) to ReserveDemandCurve variable cost" begin
            sys = System(100.0)
            reserve = ReserveDemandCurve{ReserveUp}(nothing)
            add_component!(sys, reserve)
            forecast = IS.Deterministic("variable_cost", d, resolution)
            set_variable_cost!(sys, reserve, forecast)
            cost_forecast = get_variable_cost(reserve; start_time = initial_time)
            @test first(TimeSeries.values(cost_forecast)) == first(d[initial_time])
        end
    end
end
