@testset "VPP System tests" begin
    test_sys = PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false)


    vpp_sys = VPPSystem(;
        name = "Test VPP",
        available = true,
        status = true,
        bus = get_component(ACBus, test_sys, "Bus 1"),
        active_power = 1.0,
        reactive_power = 1.0,
        storage = EnergyReservoirStorage(nothing),
        renewable_unit = RenewableDispatch(nothing),
        flexible_load = FlexiblePowerLoad(nothing),
        base_power = 100.0,
        operation_cost = MarketBidCost(nothing),
    )
    add_component!(test_sys, vpp_sys)

    initial_time = Dates.DateTime("2020-09-01")
    resolution = Dates.Hour(1)
    other_time = initial_time + resolution
    name = "test"
    horizon = 24
    data = Dict(initial_time => ones(horizon), other_time => 5.0 * ones(horizon))
    forecast = Deterministic(name, data, resolution)
    add_time_series!(test_sys, vpp_sys, forecast)
    ts = get_time_series(Deterministic, vpp_sys, "test")
    @test isa(ts, Deterministic)
end
