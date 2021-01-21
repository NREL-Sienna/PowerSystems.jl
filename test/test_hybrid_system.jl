@testset "Hybrid System tests" begin
    test_sys = PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false)

    h_sys = HybridSystem(
        name = "Test H",
        available = true,
        status = true,
        bus = get_component(Bus, test_sys, "Bus 1"),
        active_power = 1.0,
        reactive_power = 1.0,
        thermal_unit = ThermalStandard(nothing),
        electric_load = PowerLoad(nothing),
        storage = GenericBattery(nothing),
        renewable_unit = RenewableDispatch(nothing),
        base_power = 100.0,
        operation_cost = TwoPartCost(nothing),
    )
    add_component!(test_sys, h_sys)

    initial_time = Dates.DateTime("2020-09-01")
    resolution = Dates.Hour(1)
    other_time = initial_time + resolution
    name = "test"
    horizon = 24
    data = Dict(initial_time => ones(horizon), other_time => 5.0 * ones(horizon))
    forecast = Deterministic(name, data, resolution)
    add_time_series!(test_sys, h_sys, forecast)
    ts = get_time_series(Deterministic, h_sys, "test")
    @test isa(ts, Deterministic)
    @test_throws ErrorException to_json(test_sys, "./test_sys.json", force = true)
end
