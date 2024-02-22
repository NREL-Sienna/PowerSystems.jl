test_costs = Dict(
    QuadraticFunctionData =>
        repeat([QuadraticFunctionData(999.0, 1.0, 0.0)], 24),
    PiecewiseLinearPointData =>
        repeat([PiecewiseLinearPointData(repeat([(999.0, 1.0)], 5))], 24),
)

@testset "Test MarketBidCost with Quadratic Cost Timeseries with Service Forecast " begin
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

@testset "Test MarketBidCost with PiecewiseLinearPointData Cost Timeseries" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseLinearPointData])
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
    cost = MarketBidCost(; start_up = 1, no_load = rand(), shut_down = rand())
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
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseLinearPointData],
        other_time => test_costs[PiecewiseLinearPointData])
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
