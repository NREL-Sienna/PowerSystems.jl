using PowerSystems
cost = VariableCost([(1.0, 1.0), (2.0, 1.1), (3.0, 1.2)])
slopes = get_slopes(cost)
res = [1.0, 10.0, 10.0]
for (ix, v) in enumerate(slopes)
    @test isapprox(v, res[ix])
end

bps = get_breakpoint_upperbounds(cost)
res = [1.0, 0.1, 0.1]
for (ix, v) in enumerate(bps)
    @test isapprox(v, res[ix])
end

@testset "Test MarketBidCost with Polynomial Cost Timeseries with Service Forecast " begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    service_data = Dict(initial_time => ones(horizon))
    polynomial_cost = repeat([(999.0, 1.0)], 24)
    data_polynomial =
        SortedDict(initial_time => polynomial_cost)
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast = IS.Deterministic("variable_cost", data_polynomial, resolution)
    set_variable_cost!(sys, generator, forecast)
    for s in generator.services
        forecast = IS.Deterministic(get_name(s), service_data, resolution)
        set_service_bid!(sys, generator, s, forecast)
    end

    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test first(TimeSeries.values(cost_forecast)).cost ==
          first(data_polynomial[initial_time])

    for s in generator.services
        service_cost = get_services_bid(generator, market_bid, s; start_time = initial_time)
        @test first(TimeSeries.values(service_cost)).cost ==
              first(service_data[initial_time])
    end
end

@testset "Test MarketBidCost with PWL Cost Timeseries" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    pwl_cost = repeat([repeat([(999.0, 1.0)], 5)], 24)
    data_pwl = SortedDict(initial_time => pwl_cost)
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast = IS.Deterministic("variable_cost", data_pwl, resolution)
    set_variable_cost!(sys, generator, forecast)

    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test first(TimeSeries.values(cost_forecast)).cost == first(data_pwl[initial_time])
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
    polynomial_cost = repeat([(999.0, 1.0)], 24)
    data_polynomial =
        SortedDict(initial_time => polynomial_cost, other_time => polynomial_cost)
    pwl_cost = repeat([repeat([(999.0, 1.0)], 5)], 24)
    data_pwl = SortedDict(initial_time => pwl_cost, other_time => pwl_cost)
    for d in [data_polynomial, data_pwl]
        @testset "Add deterministic from $(typeof(d)) to ReserveDemandCurve variable cost" begin
            sys = System(100.0)
            reserve = ReserveDemandCurve{ReserveUp}(nothing)
            add_component!(sys, reserve)
            forecast = IS.Deterministic("variable_cost", d, resolution)
            set_variable_cost!(sys, reserve, forecast)
            cost_forecast = get_variable_cost(reserve; start_time = initial_time)
            @test first(TimeSeries.values(cost_forecast)).cost == first(d[initial_time])
        end
    end
end
