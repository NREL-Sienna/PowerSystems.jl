
@testset "Test functionality of System" begin
    sys = create_rts_system()
    summary(devnull, sys)
    @test get_frequency(sys) == PSY.DEFAULT_SYSTEM_FREQUENCY

    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    @test IS.get_uuid(generator) == IS.get_uuid(generators[1])
    @test_throws(IS.ArgumentError, add_component!(sys, generator))

    generators2 = get_components_by_name(ThermalGen, sys, get_name(generators[1]))
    @test length(generators2) == 1
    @test IS.get_uuid(generators2[1]) == IS.get_uuid(generators[1])
    @test !has_forecasts(generators2[1])

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
    sort!(buses, by = x -> x.number)
    @test length(bus_numbers) == length(buses)
    for (bus_number, bus) in zip(bus_numbers, buses)
        @test bus_number == bus.number
    end

    initial_times = get_forecast_initial_times(sys)
    @assert length(initial_times) == 1
    initial_time = initial_times[1]

    # Get forecasts with a label and without.
    components = collect(get_components(HydroEnergyReservoir, sys))
    @test !isempty(components)
    component = components[1]
    forecast = get_forecast(Deterministic, component, initial_time, "get_max_active_power")
    @test forecast isa Deterministic

    # Test all versions of get_forecast_values()
    values1 = get_forecast_values(component, forecast)
    values2 = get_forecast_values(Deterministic, component, initial_time, "get_max_active_power")
    @test values1 == values2
    values3 = get_forecast_values(
        Deterministic,
        component,
        initial_time,
        "get_max_active_power",
        get_horizon(forecast),
    )
    @test values1 == values3

    horizon = get_forecasts_horizon(sys)
    @test horizon == 24
    @test get_forecasts_initial_time(sys) == Dates.DateTime("2020-01-01T00:00:00")
    @test get_forecasts_interval(sys) == Dates.Hour(0)
    resolution = get_forecasts_resolution(sys)
    @test resolution == Dates.Hour(1)

    # Actual functionality is tested in InfrastructureSystems.
    @test generate_initial_times(sys, resolution, horizon)[1] == initial_time
    @test generate_initial_times(component, resolution, horizon)[1] == initial_time
    @test are_forecasts_contiguous(sys)
    @test are_forecasts_contiguous(component)

    clear_forecasts!(sys)
    @test length(collect(iterate_forecasts(sys))) == 0
end

@testset "Test handling of bus_numbers" begin
    sys = create_rts_system()

    @test length(sys.bus_numbers) > 0
    buses = get_components(Bus, sys)
    bus_numbers = sort!([get_number(bus) for bus in buses])
    @test bus_numbers == get_bus_numbers(sys)

    # Remove entire type
    remove_components!(Bus, sys)
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
    sys = create_rts_system()

    i = 0
    for component in iterate_components(sys)
        i += 1
    end

    components = get_components(Component, sys)
    @test i == length(components)

    initial_times = get_forecast_initial_times(sys)
    unique_initial_times = Set{Dates.DateTime}()
    for forecast in iterate_forecasts(sys)
        push!(unique_initial_times, get_initial_time(forecast))
    end
    @test initial_times == sort!(collect(unique_initial_times))
end

@testset "Test remove_component" begin
    sys = create_rts_system()
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
    remove_components!(typeof(gen), sys)
    @test_throws(IS.ArgumentError, remove_components!(typeof(gen), sys))

    remove_components!(Area, sys)
    @test isempty(get_components(Area, sys))
    @test isnothing(get_area(collect(get_components(Bus, sys))[1]))
end

@testset "Test missing Arc bus" begin
    sys = System(100)
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
    sys = System(100)
    ext = get_ext(sys)
    ext["data"] = 2
    @test get_ext(sys)["data"] == 2
    clear_ext(sys)
    @test isempty(get_ext(sys))
end

@testset "Test system checks" begin
    sys = System(100)
    @test_logs (:warn, r"There are no .* Components in the System") match_mode = :any PSY.check!(
        sys,
    )
end
