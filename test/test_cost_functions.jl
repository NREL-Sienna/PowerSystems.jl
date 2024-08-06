@testset "Test scope-sensitive printing of IS cost functions" begin
    # Make sure the aliases get registered properly
    @test sprint(show, "text/plain", QuadraticCurve) ==
          "QuadraticCurve (alias for InputOutputCurve{QuadraticFunctionData})"

    # Make sure there are no IS-related prefixes in the printouts
    fc = FuelCurve(InputOutputCurve(IS.QuadraticFunctionData(1, 2, 3)), 4.0)
    @test sprint(show, "text/plain", fc) ==
          sprint(show, "text/plain", fc; context = :compact => false) ==
          "FuelCurve:\n  value_curve: QuadraticCurve (a type of InputOutputCurve) where function is: f(x) = 1.0 x^2 + 2.0 x + 3.0\n  power_units: UnitSystem.NATURAL_UNITS = 2\n  fuel_cost: 4.0\n  vom_cost: LinearCurve (a type of InputOutputCurve) where function is: f(x) = 0.0 x + 0.0"
    @test sprint(show, "text/plain", fc; context = :compact => true) ==
          "FuelCurve with power_units UnitSystem.NATURAL_UNITS = 2, fuel_cost 4.0, vom_cost LinearCurve(0.0, 0.0), and value_curve:\n  QuadraticCurve (a type of InputOutputCurve) where function is: f(x) = 1.0 x^2 + 2.0 x + 3.0"
end

@testset "Test market bid cost interface" begin
    mbc = make_market_bid_curve([100.0, 105.0, 120.0, 130.0], [25.0, 26.0, 28.0, 30.0])
    @test is_market_bid_curve(mbc)
    @test is_market_bid_curve(make_market_bid_curve(get_function_data(mbc)))
    @test_throws ArgumentError make_market_bid_curve(
        [100.0, 105.0, 120.0, 130.0], [26.0, 28.0, 30.0])

    mbc2 = make_market_bid_curve(20.0, [1.0, 2.0, 3.0], [4.0, 6.0])
    @test is_market_bid_curve(mbc2)
    @test is_market_bid_curve(
        make_market_bid_curve(get_function_data(mbc2), get_initial_input(mbc2)),
    )

    mbc3 = make_market_bid_curve(18.0, 20.0, [1.0, 2.0, 3.0], [4.0, 6.0])
    @test is_market_bid_curve(mbc3)
    @test is_market_bid_curve(
        make_market_bid_curve(get_function_data(mbc2), get_initial_input(mbc3)),
    )
end

test_costs = Dict(
    CostCurve{QuadraticCurve} =>
        repeat([CostCurve(QuadraticCurve(999.0, 2.0, 1.0))], 24),
    PiecewiseStepData =>
        repeat([make_market_bid_curve([2.0, 3.0], [4.0, 6.0])], 24),
    PiecewiseIncrementalCurve =>
        repeat([make_market_bid_curve(18.0, 20.0, [1.0, 2.0, 3.0], [4.0, 6.0])], 24),
    Float64 =>
        collect(11.0:34.0),
    PSY.StartUpStages =>
        repeat([(hot = PSY.START_COST, warm = PSY.START_COST, cold = PSY.START_COST)], 24),
)

@testset "Test MarketBidCost with Quadratic Cost Timeseries" begin
    # Will throw TypeErrors because market bids must be piecewise, not quadratic and service
    # bids must be piecewise, not scalar
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    service_data = Dict(initial_time => rand(horizon))
    data_quadratic =
        SortedDict(initial_time => test_costs[CostCurve{QuadraticCurve}])
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generator = get_component(ThermalStandard, sys, "322_CT_6")
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast_fd = IS.Deterministic(
        "variable_cost",
        Dict(k => get_function_data.(v) for (k, v) in pairs(data_quadratic)),
        resolution,
    )
    @test_throws TypeError set_variable_cost!(sys, generator, forecast_fd)
    for s in generator.services
        forecast_fd = IS.Deterministic(get_name(s), service_data, resolution)
        @test_throws TypeError set_service_bid!(sys, generator, s, forecast_fd)
    end
end

@testset "Test MarketBidCost with PiecewiseLinearData Cost Timeseries with Service Bid Forecast" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseStepData])
    service_data = data_pwl
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generator = get_component(ThermalStandard, sys, "322_CT_6")
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast_fd = IS.Deterministic(
        "variable_cost",
        Dict(k => get_function_data.(v) for (k, v) in pairs(data_pwl)),
        resolution,
    )
    set_variable_cost!(sys, generator, forecast_fd)

    for s in generator.services
        forecast_fd = IS.Deterministic(
            get_name(s),
            Dict(k => get_function_data.(v) for (k, v) in pairs(service_data)),
            resolution,
        )
        set_service_bid!(sys, generator, s, forecast_fd)
    end

    iocs = get_incremental_offer_curves(generator, market_bid)
    isequal(first(TimeSeries.values(iocs)), first(data_pwl[initial_time]))
    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test isequal(first(TimeSeries.values(cost_forecast)), first(data_pwl[initial_time]))

    for s in generator.services
        service_cost = get_services_bid(generator, market_bid, s; start_time = initial_time)
        @test isequal(
            first(TimeSeries.values(service_cost)),
            first(service_data[initial_time]),
        )
    end
end

@testset "Test MarketBidCost with PiecewiseLinearData Cost Timeseries, initial_input, and no_load_cost" begin
    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    name = "test"
    horizon = 24
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseIncrementalCurve])
    service_data = data_pwl
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generator = get_component(ThermalStandard, sys, "322_CT_6")
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)
    forecast_fd = IS.Deterministic(
        "variable_cost_function_data",
        Dict(k => get_function_data.(v) for (k, v) in pairs(data_pwl)),
        resolution,
    )
    set_variable_cost!(sys, generator, forecast_fd)

    forecast_ii = IS.Deterministic(
        "variable_cost_initial_input",
        Dict(k => get_initial_input.(get_value_curve.(v)) for (k, v) in pairs(data_pwl)),
        resolution,
    )
    PSY.set_incremental_initial_input!(sys, generator, forecast_ii)

    forecast_iaz = IS.Deterministic(
        "variable_cost_input_at_zero",
        Dict(k => get_input_at_zero.(get_value_curve.(v)) for (k, v) in pairs(data_pwl)),
        resolution,
    )
    set_no_load_cost!(sys, generator, forecast_iaz)

    iocs = get_incremental_offer_curves(generator, market_bid)
    @show iocs
    isequal(first(TimeSeries.values(iocs)), first(data_pwl[initial_time]))
    cost_forecast = get_variable_cost(generator, market_bid; start_time = initial_time)
    @test isequal(first(TimeSeries.values(cost_forecast)), first(data_pwl[initial_time]))
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
    data_pwl = SortedDict(initial_time => test_costs[PiecewiseStepData],
        other_time => test_costs[PiecewiseStepData])
    sys = System(100.0)
    reserve = ReserveDemandCurve{ReserveUp}(nothing)
    add_component!(sys, reserve)
    forecast_fd = IS.Deterministic(
        "variable_cost",
        Dict(k => get_function_data.(v) for (k, v) in pairs(data_pwl)),
        resolution,
    )
    set_variable_cost!(sys, reserve, forecast_fd)
    cost_forecast = get_variable_cost(reserve; start_time = initial_time)
    @test isequal(first(TimeSeries.values(cost_forecast)), first(data_pwl[initial_time]))
end

@testset "Test fuel cost (scalar and time series)" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, "322_CT_6")

    op_cost = get_operation_cost(generator)
    value_curve = get_value_curve(get_variable(op_cost))
    set_variable!(op_cost, FuelCurve(value_curve, 0.0))
    @test get_fuel_cost(generator) == 0.0
    @test_throws ArgumentError get_fuel_cost(generator; len = 2)

    set_fuel_cost!(sys, generator, 1.23)
    @test get_fuel_cost(generator) == 1.23

    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    horizon = 24
    data_float = SortedDict(initial_time => test_costs[Float64])
    forecast_fd = IS.Deterministic("fuel_cost", data_float, resolution)
    set_fuel_cost!(sys, generator, forecast_fd)
    fuel_forecast = get_fuel_cost(generator; start_time = initial_time)
    @test first(TimeSeries.values(fuel_forecast)) == first(data_float[initial_time])
    fuel_forecast = get_fuel_cost(generator)  # missing start_time filled in with initial time
    @test first(TimeSeries.values(fuel_forecast)) == first(data_float[initial_time])
end
@testset "Test no-load cost (scalar and time series)" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, "322_CT_6")
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)

    op_cost = get_operation_cost(generator)
    @test get_no_load_cost(generator, op_cost) === nothing

    set_no_load_cost!(sys, generator, 1.23)
    @test get_no_load_cost(generator, op_cost) == 1.23

    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    horizon = 24
    data_float = SortedDict(initial_time => test_costs[Float64])
    forecast_fd = IS.Deterministic("no_load_cost", data_float, resolution)

    set_no_load_cost!(sys, generator, forecast_fd)
    @test first(TimeSeries.values(get_no_load_cost(generator, op_cost))) ==
          first(data_float[initial_time])
end

@testset "Test startup cost (tuple and time series)" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, "322_CT_6")
    market_bid = MarketBidCost(nothing)
    set_operation_cost!(generator, market_bid)

    op_cost = get_operation_cost(generator)
    @test get_start_up(generator, op_cost) ==
          (hot = PSY.START_COST, warm = PSY.START_COST, cold = PSY.START_COST)

    set_start_up!(sys, generator, (hot = 1.23, warm = 2.34, cold = 3.45))
    @test get_start_up(generator, op_cost) == (hot = 1.23, warm = 2.34, cold = 3.45)

    initial_time = Dates.DateTime("2020-01-01")
    resolution = Dates.Hour(1)
    horizon = 24
    data_sus = SortedDict(initial_time => test_costs[PSY.StartUpStages])
    forecast_fd = IS.Deterministic(
        "start_up",
        Dict(k => Tuple.(v) for (k, v) in pairs(data_sus)),
        resolution,
    )

    set_start_up!(sys, generator, forecast_fd)
    @test first(TimeSeries.values(get_start_up(generator, op_cost))) ==
          first(data_sus[initial_time])
end
