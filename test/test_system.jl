
@testset "Test functionality of System" begin
    sys = create_rts_system()
    summary(devnull, sys)

    generators = collect(get_components(ThermalStandard, sys))
    generator = get_component(ThermalStandard, sys, get_name(generators[1]))
    @test PowerSystems.get_uuid(generator) == PowerSystems.get_uuid(generators[1])
    @test_throws(PowerSystems.InvalidParameter, add_component!(sys, generator))

    generators2 = get_components_by_name(ThermalGen, sys, get_name(generators[1]))
    @test length(generators2) == 1
    @test PowerSystems.get_uuid(generators2[1]) == PowerSystems.get_uuid(generators[1])

    @test isnothing(get_component(ThermalStandard, sys, "not-a-name"))
    @test isempty(get_components_by_name(ThermalGen, sys, "not-a-name"))
    @test_throws(PowerSystems.InvalidParameter,
                 get_component(ThermalGen, sys, "not-a-name"))
    @test_throws(PowerSystems.InvalidParameter,
                 get_components_by_name(ThermalStandard, sys, "not-a-name"))

    # Negative test of missing type.
    components = Vector{ThermalGen}()
    for subtype in PowerSystems.subtypes(ThermalGen)
        if haskey(sys.components, subtype)
            for (component_type, component) in pop!(sys.components, subtype)
                push!(components, component)
            end
        end
    end

    @test length(collect(get_components(ThermalGen, sys))) == 0
    @test length(collect(get_components(ThermalStandard, sys))) == 0

    # For the next test to work there must be at least one component to add back.
    @test length(components) > 0
    for component in components
        add_component!(sys, component)
    end

    @test length(collect(get_components(ThermalGen, sys))) > 0

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
    sort!(buses, by=x -> x.number)
    @test length(bus_numbers) == length(buses)
    for (bus_number, bus) in zip(bus_numbers, buses)
        @test bus_number == bus.number
    end

    initial_times = get_forecast_initial_times(sys)
    @assert length(initial_times) == 1
    initial_time = initial_times[1]

    # Get forecasts with a label and without.
    components = get_components(HydroDispatch, sys)
    forecasts = get_forecasts(Forecast, sys, initial_time, components, "PMax MW")
    @test length(forecasts) > 0

    forecasts = collect(get_forecasts(Forecast, sys, initial_time, components))
    count = length(forecasts)
    @test count > 0

    # Verify that the two accessor functions return the same results.
    all_components = get_components(Component, sys)
    all_forecasts1 = get_forecasts(Forecast, sys, initial_time, all_components)
    all_forecasts2 = get_forecasts(Forecast, sys, initial_time)
    @test length(all_forecasts1) == length(all_forecasts2)

    # Get specific forecasts. They should not match.
    specific_forecasts = get_forecasts(Deterministic{Bus}, sys, initial_time)
    @test length(specific_forecasts) < length(all_forecasts1)

    @test get_forecasts_horizon(sys) == 24
    @test get_forecasts_initial_time(sys) == Dates.DateTime("2020-01-01T00:00:00")
    @test get_forecasts_interval(sys) == Dates.Hour(1)  # TODO
    @test get_forecasts_resolution(sys) == Dates.Hour(1)  # TODO

    for forecast in collect(get_forecasts(Forecast, sys, initial_time))
        remove_forecast!(sys, forecast)
    end

    @test length(get_forecasts(Forecast, sys, initial_time)) == 0
    @test PowerSystems.is_uninitialized(sys.forecasts)

    # InvalidParameter is thrown if the type is concrete and there is no forecast for a
    # component.
    @test_throws(PowerSystems.InvalidParameter,
                 get_forecasts(Forecast, sys, initial_time, components))

    # But not if the type is abstract.
    new_forecasts = get_forecasts(Forecast, sys, initial_time,
                                  get_components(HydroGen, sys))
    @test length(new_forecasts) == 0

    add_forecasts!(sys, forecasts)

    forecasts = get_forecasts(Forecast, sys, initial_time, components)
    @assert length(forecasts) == count

    @test_throws(PowerSystems.InvalidParameter,
                 get_forecasts(Deterministic{Bus}, sys, initial_time, components))

    f = forecasts[1]
    forecast = Deterministic(Bus(nothing), f.label, f.resolution, f.initial_time, f.data)
    @test_throws(PowerSystems.InvalidParameter, add_forecasts!(sys, [forecast]))

    component = deepcopy(f.component)
    component.internal = PowerSystems.PowerSystemInternal()
    forecast = Deterministic(component, f.label, f.resolution, f.initial_time, f.data)
    @test_throws(PowerSystems.InvalidParameter, add_forecasts!(sys, [forecast]))
end

@testset "Test System iterators" begin
    sys = create_rts_system()

    i = 0
    for component in iterate_components(sys)
        i += 1
    end

    components = get_components(Component, sys)
    @test i == length(components)

    i = 0
    for forecast in iterate_forecasts(sys)
        i += 1
    end

    j = 0
    initial_times = get_forecast_initial_times(sys)
    for initial_time in initial_times
        j += length(get_forecasts(Forecast, sys, initial_time))
    end

    @test i == j
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

    @test_throws(PowerSystems.InvalidParameter, remove_component!(sys, gen))

    add_component!(sys, gen)
    remove_component!(typeof(gen), sys, get_name(gen))
    @test isnothing(get_component(typeof(gen), sys, get_name(gen)))

    @assert length(get_components(typeof(gen), sys)) > 0
    remove_components!(typeof(gen), sys)
    @test_throws(PowerSystems.InvalidParameter, remove_components!(typeof(gen), sys))
end
