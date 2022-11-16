@testset "Test functionality of System" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecasts = false)
    summary(devnull, sys)
    @test get_frequency(sys) == PSY.DEFAULT_SYSTEM_FREQUENCY

    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    @test IS.get_uuid(generator) == IS.get_uuid(generators[1])
    @test_throws(IS.ArgumentError, add_component!(sys, generator))

    generators2 = get_components_by_name(ThermalGen, sys, get_name(generators[1]))
    @test length(generators2) == 1
    @test IS.get_uuid(generators2[1]) == IS.get_uuid(generators[1])
    @test !has_time_series(generators2[1])

    @test isnothing(get_component(ThermalStandard, sys, "not-a-name"))
    @test isempty(get_components_by_name(ThermalGen, sys, "not-a-name"))
    @test_throws(
        IS.ArgumentError,
        get_components_by_name(ThermalStandard, sys, "not-a-name")
    )
    @test isempty(get_components(ThermalStandard, sys, x -> (!get_available(x))))
    @test !isempty(get_available_components(ThermalStandard, sys))
    # Test get_bus* functionality.
    bus_numbers = Vector{Int}()
    for bus in get_components(Bus, sys)
        push!(bus_numbers, bus.number)
        if length(bus_numbers) >= 2
            break
        end
    end

    bus = PowerSystems.get_bus(sys, bus_numbers[1])
    @test bus.number == bus_numbers[1]

    buses = PowerSystems.get_buses(sys, Set(bus_numbers))
    sort!(bus_numbers)
    sort!(buses; by = x -> x.number)
    @test length(bus_numbers) == length(buses)
    for (bus_number, bus) in zip(bus_numbers, buses)
        @test bus_number == bus.number
    end

    @test get_forecast_initial_times(sys) == []
    @test get_time_series_resolution(sys) == Dates.Hour(1)

    # Get time_series with a name and without.
    components = collect(get_components(HydroEnergyReservoir, sys))
    @test !isempty(components)
    component = components[1]
    ts = get_time_series(SingleTimeSeries, component, "max_active_power")
    @test ts isa SingleTimeSeries

    returned_it, returned_len = check_time_series_consistency(sys, SingleTimeSeries)
    @test returned_it == first(TimeSeries.timestamp(get_data(ts)))
    @test returned_len == length(get_data(ts))

    # Test all versions of get_time_series_[array|timestamps|values]
    values1 = get_time_series_array(component, ts)
    values2 = get_time_series_array(SingleTimeSeries, component, "max_active_power")
    @test values1 == values2
    values3 = get_time_series_array(SingleTimeSeries, component, "max_active_power")
    @test values1 == values3

    val = get_time_series_array(SingleTimeSeries, component, "max_active_power")
    @test val isa TimeSeries.TimeArray
    val = get_time_series_timestamps(SingleTimeSeries, component, "max_active_power")
    @test val isa Array
    @test val[1] isa Dates.DateTime
    val = get_time_series_values(SingleTimeSeries, component, "max_active_power")
    @test val isa Array
    @test val[1] isa AbstractFloat

    val = get_time_series_array(component, ts)
    @test val isa TimeSeries.TimeArray
    val = get_time_series_timestamps(component, ts)
    @test val isa Array
    @test val[1] isa Dates.DateTime
    val = get_time_series_values(component, ts)
    @test val isa Array
    @test val[1] isa AbstractFloat

    clear_time_series!(sys)
    @test length(collect(get_time_series_multiple(sys))) == 0
    @test IS.get_internal(sys) isa IS.InfrastructureSystemsInternal
end

@testset "Test get_componets filter_func" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecasts = false)
    gen = first(get_components(ThermalStandard, sys))
    name = get_name(gen)
    generators = get_components(ThermalStandard, sys) do gen
        get_name(gen) == name && get_available(gen)
    end

    @test length(generators) == 1 && get_name(first(generators)) == name
end

@testset "Test handling of bus_numbers" begin
    sys = create_rts_system()
    # TODO: sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")

    @test length(sys.bus_numbers) > 0
    buses = get_components(Bus, sys)
    bus_numbers = sort!([get_number(bus) for bus in buses])
    @test bus_numbers == get_bus_numbers(sys)

    # Remove some components
    remove_components!(x -> get_number(x) ∈ [101, 201], sys, Bus)
    @test length(sys.bus_numbers) == length(bus_numbers) - 2

    # Remove entire type
    remove_components!(sys, Bus)
    @test length(sys.bus_numbers) == 0

    # Remove individually.
    for bus in buses
        add_component!(sys, bus)
    end
    @test length(sys.bus_numbers) > 0
    for bus in buses
        remove_component!(sys, bus)
    end
    @test length(sys.bus_numbers) == 0

    # Remove by name.
    for bus in buses
        add_component!(sys, bus)
    end
    @test length(sys.bus_numbers) > 0
    for bus in buses
        remove_component!(Bus, sys, get_name(bus))
    end
    @test length(sys.bus_numbers) == 0
end

@testset "Test System iterators" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")

    i = 0
    for component in iterate_components(sys)
        i += 1
    end

    components = get_components(Component, sys)
    @test i == length(components)

    # Test debugging functions.
    component = first(components)
    uuid = IS.get_uuid(component)
    @test get_name(get_component(sys, uuid)) == get_name(component)
    @test get_name(get_component(sys, string(uuid))) == get_name(component)
end

@testset "Test remove_component" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    generators = get_components(ThermalStandard, sys)
    initial_length = length(generators)
    @assert initial_length > 0
    gen = collect(generators)[1]

    remove_component!(sys, gen)

    @test isnothing(get_component(typeof(gen), sys, get_name(gen)))
    generators = get_components(typeof(gen), sys)
    @test length(generators) == initial_length - 1

    @test_throws(IS.ArgumentError, remove_component!(sys, gen))

    add_component!(sys, gen)
    remove_component!(typeof(gen), sys, get_name(gen))
    @test isnothing(get_component(typeof(gen), sys, get_name(gen)))

    @assert length(get_components(typeof(gen), sys)) > 0
    remove_components!(sys, typeof(gen))
    @test_throws(IS.ArgumentError, remove_components!(sys, typeof(gen)))

    remove_components!(sys, Area)
    @test isempty(get_components(Area, sys))
    @test isnothing(get_area(collect(get_components(Bus, sys))[1]))
end

@testset "Test missing Arc bus" begin
    sys = System(100.0)
    line = Line(nothing)
    @test_throws(IS.ArgumentError, add_component!(sys, line))
end

@testset "Test frequency set" begin
    sys = System(100; frequency = 50.0)
    @test get_frequency(sys) == 50.0
end

@testset "Test exported names" begin
    @test IS.validate_exported_names(PowerSystems)
end

@testset "Test system ext" begin
    sys = System(100.0)
    ext = get_ext(sys)
    ext["data"] = 2
    @test get_ext(sys)["data"] == 2
    clear_ext!(sys)
    @test isempty(get_ext(sys))
end

@testset "Test system checks" begin
    sys = System(100.0)
    @test_logs (:warn, r"There are no .* Components in the System") match_mode = :any check(
        sys,
    )
end

@testset "Test system units" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecasts = false)
    @test get_units_base(sys) == "DEVICE_BASE"
    set_units_base_system!(sys, "SYSTEM_BASE")
    @test get_units_base(sys) == "SYSTEM_BASE"
end

@testset "Test add_time_series multiple components" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.bustype = BusTypes.REF
    add_component!(sys, bus)
    components = []
    len = 2
    for i in 1:len
        gen = ThermalStandard(nothing)
        gen.name = string(i)
        gen.bus = bus
        add_component!(sys, gen)
        push!(components, gen)
    end

    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    end_time = Dates.DateTime("2020-01-01T23:00:00")
    dates = collect(initial_time:Dates.Hour(1):end_time)
    data = collect(1:24)
    ta = TimeSeries.TimeArray(dates, data, ["1"])
    name = "max_active_power"
    ts = SingleTimeSeries(; name = name, data = ta)
    add_time_series!(sys, components, ts)

    for i in 1:len
        component = get_component(ThermalStandard, sys, string(i))
        ts = get_time_series(SingleTimeSeries, component, name)
        @test ts isa SingleTimeSeries
    end
end

@testset "Test set_name! of system component" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.bustype = BusTypes.REF
    add_component!(sys, bus)
    set_name!(sys, bus, "new_name")
    @test get_component(Bus, sys, "new_name") === bus

    @test_throws ErrorException set_name!(bus, "new_name2")
    remove_component!(sys, bus)
    set_name!(bus, "new_name2")
    @test get_name(bus) == "new_name2"
end

@testset "Test forecast parameters" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.bustype = BusTypes.REF
    add_component!(sys, bus)
    gen = ThermalStandard(nothing)
    gen.name = "gen"
    gen.bus = bus
    add_component!(sys, gen)

    resolution = Dates.Hour(1)
    initial_time = Dates.DateTime("2020-09-01")
    second_time = initial_time + resolution
    name = "test"
    horizon = 24
    data = SortedDict(initial_time => ones(horizon), second_time => ones(horizon))

    forecast = Deterministic(; data = data, name = name, resolution = resolution)
    add_time_series!(sys, gen, forecast)

    @test get_time_series_resolution(sys) == resolution
    @test get_forecast_horizon(sys) == horizon
    @test get_forecast_initial_timestamp(sys) == initial_time
    @test get_forecast_interval(sys) == Dates.Millisecond(second_time - initial_time)
    @test get_forecast_window_count(sys) == 2
    @test Dates.Hour(get_forecast_total_period(sys)) ==
          Dates.Hour(second_time - initial_time) + Dates.Hour(resolution * horizon)
    @test get_forecast_initial_times(sys) == [initial_time, second_time]

    remove_time_series!(sys, typeof(forecast), gen, get_name(forecast))
    @test_throws ArgumentError get_time_series(typeof(forecast), gen, get_name(forecast))
end

@testset "Invalid constructor" begin
    @test_throws IS.DataFormatError System("data.invalid")
end

@testset "Test deepcopy with runchecks" begin
    sys = System(100.0)
    @test get_runchecks(sys)
    @test get_runchecks(deepcopy(sys))
end

@testset "Test deepcopy with runchecks disabled" begin
    sys = System(100.0; runchecks = false)
    @test !get_runchecks(sys)
    sys2 = deepcopy(sys)
    @test sys2 isa System
    @test !get_runchecks(sys)
end

@testset "Test time series counts" begin
    c_sys5 = PSB.build_system(
        PSITestSystems,
        "c_sys5_uc";
        add_forecasts = true,
        force_build = true,
    )
    _, ts_count, forecast_count = get_time_series_counts(c_sys5)
    @test ts_count == 0
    @test forecast_count == 3
end

@testset "Test deepcopy with time series options" begin
    sys = PSB.build_system(
        PSITestSystems,
        "test_RTS_GMLC_sys";
        time_series_in_memory = true,
        force_build = true,
    )
    @test sys.data.time_series_storage isa IS.InMemoryTimeSeriesStorage
    sys2 = deepcopy(sys)
    @test sys2.data.time_series_storage isa IS.InMemoryTimeSeriesStorage
    @test IS.compare_values(sys, sys2)
    # Ensure that the storage references got updated correctly.
    for component in get_components(Component, sys2, x -> has_time_series(x))
        @test component.time_series_container.time_series_storage ===
              sys2.data.time_series_storage
    end

    sys = PSB.build_system(
        PSITestSystems,
        "test_RTS_GMLC_sys";
        time_series_in_memory = false,
        force_build = true,
    )
    @test sys.data.time_series_storage isa IS.Hdf5TimeSeriesStorage
    sys2 = deepcopy(sys)
    @test sys2.data.time_series_storage isa IS.Hdf5TimeSeriesStorage
    @test sys.data.time_series_storage.file_path != sys2.data.time_series_storage.file_path
    @test IS.compare_values(sys, sys2)
    for component in get_components(Component, sys2, x -> has_time_series(x))
        @test component.time_series_container.time_series_storage ===
              sys2.data.time_series_storage
    end
end

@testset "Test with compression enabled" begin
    @test get_compression_settings(System(100.0)) == CompressionSettings(; enabled = false)

    settings = CompressionSettings(; enabled = true, type = CompressionTypes.BLOSC)
    @test get_compression_settings(System(100.0; compression = settings)) == settings
    @test get_compression_settings(System(100.0; enable_compression = true)) ==
          CompressionSettings(; enabled = true)
end

@testset "Test compare_values" begin
    sys1 = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    sys2 = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    gen1 = first(get_components(ThermalStandard, sys1))
    gen2 = first(get_components(ThermalStandard, sys2))
    @test IS.compare_values(gen1, gen2)
    @test IS.compare_values(sys1, sys2)

    set_active_power!(gen1, get_active_power(gen1) + 0.1)
    @test(
        @test_logs(
            (:error, r"not match"),
            match_mode = :any,
            !IS.compare_values(gen1, gen2),
        )
    )
    @test(
        @test_logs(
            (:error, r"not match"),
            match_mode = :any,
            !IS.compare_values(sys1, sys2)
        )
    )
end

@testset "Test check_components" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecasts = false)
    check_components(sys)
    check_components(sys, Component)
    check_components(sys, Generator)
    check_components(sys, ThermalStandard)
    check_components(sys, get_components(ThermalStandard, sys))
    components = get_components(ThermalStandard, sys)
    gen = first(components)
    check_components(sys, components)
    check_component(sys, gen)

    # Invalid Bus base_voltage values throw errors.
    # Invalid ThermalStandard active_power logs warning messages.

    bus = first(get_components(Bus, sys))
    check_component(sys, bus)
    orig = get_base_voltage(bus)
    set_base_voltage!(bus, -1.0)
    try
        @test_logs(
            (:error, "Invalid range"),
            match_mode = :any,
            @test_throws IS.InvalidValue check_component(sys, bus)
        )
    finally
        set_base_voltage!(bus, orig)
    end

    gen.active_power = 100.0
    @test_logs :warn, "Invalid range" match_mode = :any check_component(sys, gen)
    @test_logs :warn, "Invalid range" match_mode = :any check_components(
        sys,
        ThermalStandard,
    )

    @test !(@test_logs :warn, r"is larger than the max expected in the" match_mode = :any check_sil_values(
        sys,
    ))
end
