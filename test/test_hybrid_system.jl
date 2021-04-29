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
end

@testset "Hybrid System from parsed files" begin
    sys = create_rts_system_with_hybrid_system(add_forecasts = true)
    hybrids = collect(get_components(HybridSystem, sys))
    @test length(hybrids) == 1
    h_sys = hybrids[1]

    electric_load = nothing
    thermal_unit = nothing
    subcomponents = collect(get_subcomponents(h_sys))
    @test length(subcomponents) == 4
    for subcomponent in subcomponents
        @test !PSY.is_attached(subcomponent, sys)
        if subcomponent isa PowerLoad
            electric_load = subcomponent
        elseif subcomponent isa ThermalStandard
            thermal_unit = subcomponent
        end
    end
    @test electric_load !== nothing
    @test thermal_unit !== nothing

    sts = collect(get_time_series_multiple(h_sys, type = SingleTimeSeries))
    @test length(sts) == 2
    forecasts = collect(get_time_series_multiple(h_sys, type = AbstractDeterministic))
    @test length(forecasts) == 2

    @test get_time_series(SingleTimeSeries, h_sys, electric_load, "max_active_power") isa
          SingleTimeSeries
    @test get_time_series(SingleTimeSeries, h_sys, "PowerLoad__max_active_power") isa
          SingleTimeSeries
    @test get_time_series(
        AbstractDeterministic,
        h_sys,
        electric_load,
        "max_active_power",
    ) isa DeterministicSingleTimeSeries
    @test get_time_series(AbstractDeterministic, h_sys, "PowerLoad__max_active_power") isa
          DeterministicSingleTimeSeries

    @test !has_time_series(h_sys, thermal_unit)
    @test has_time_series(h_sys, electric_load)
    remove_time_series!(
        sys,
        AbstractDeterministic,
        h_sys,
        electric_load,
        "max_active_power",
    )
    forecasts = collect(get_time_series_multiple(h_sys, type = AbstractDeterministic))
    @test length(forecasts) == 1
    @test has_time_series(h_sys, electric_load)
    remove_time_series!(sys, SingleTimeSeries, h_sys, electric_load, "max_active_power")
    sts = collect(get_time_series_multiple(h_sys, type = SingleTimeSeries))
    @test length(sts) == 1
    @test !has_time_series(h_sys, electric_load)
end

@testset "Hybrid System from unattached subcomponents" begin
    sys = PSB.build_system(PSB.PSITestSystems, "test_RTS_GMLC_sys"; add_forecasts = false)
    thermal_unit = first(get_components(ThermalStandard, sys))
    bus = get_bus(thermal_unit)
    electric_load = first(get_components(PowerLoad, sys))
    storage = first(get_components(GenericBattery, sys))
    renewable_unit = first(get_components(RenewableDispatch, sys))

    for subcomponent in (thermal_unit, electric_load, storage, renewable_unit)
        remove_component!(sys, subcomponent)
    end

    name = "Test H"
    h_sys = HybridSystem(
        name = name,
        available = true,
        status = true,
        bus = bus,
        active_power = 1.0,
        reactive_power = 1.0,
        thermal_unit = thermal_unit,
        electric_load = electric_load,
        storage = storage,
        renewable_unit = renewable_unit,
        base_power = 100.0,
        operation_cost = TwoPartCost(nothing),
    )
    add_component!(sys, h_sys)

    # Add time series for a subcomponent.
    initial_time = Dates.DateTime("2020-09-01")
    resolution = Dates.Hour(1)
    other_time = initial_time + resolution
    name1 = "test1"
    name2 = "test2"
    horizon = 24
    data = Dict(initial_time => rand(horizon), other_time => 5.0 * rand(horizon))

    expected_timestamps = collect(range(initial_time, step = resolution, length = horizon))
    expected_data = data[initial_time]
    expected_ta = TimeSeries.TimeArray(expected_timestamps, expected_data)

    # No scaling factor
    forecast = Deterministic(name1, data, resolution)
    add_time_series!(sys, h_sys, thermal_unit, forecast)

    @test get_time_series(Deterministic, h_sys, thermal_unit, name1) isa Deterministic
    @test get_time_series(Deterministic, h_sys, "ThermalStandard__test1") isa Deterministic

    @test get_time_series_values(Deterministic, h_sys, thermal_unit, name1) == expected_data
    @test get_time_series_timestamps(Deterministic, h_sys, thermal_unit, name1) ==
          expected_timestamps
    @test get_time_series_array(Deterministic, h_sys, thermal_unit, name1) == expected_ta

    # With scaling factor
    expected_data = data[initial_time] * get_max_active_power(thermal_unit)
    expected_ta = TimeSeries.TimeArray(expected_timestamps, expected_data)
    forecast = Deterministic(
        name2,
        data,
        resolution,
        scaling_factor_multiplier = get_max_active_power,
    )
    add_time_series!(sys, h_sys, thermal_unit, forecast)

    @test get_time_series(Deterministic, h_sys, thermal_unit, name2) isa Deterministic
    @test get_time_series(Deterministic, h_sys, "ThermalStandard__test2") isa Deterministic

    @test get_time_series_values(Deterministic, h_sys, thermal_unit, name2) == expected_data
    @test get_time_series_timestamps(Deterministic, h_sys, thermal_unit, name2) ==
          expected_timestamps
    @test get_time_series_array(Deterministic, h_sys, thermal_unit, name2) == expected_ta
end
