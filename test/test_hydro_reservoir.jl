@testset "Test Hydro Turbine constructors" begin
    turbine = HydroTurbine(; name = "TestTurbine",
        available = true,
        bus = ACBus(nothing),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 1,
        base_power = 100,
        active_power_limits = (min = 0, max = 1),
        reactive_power_limits = nothing,
        outflow_limits = nothing,
        powerhouse_elevation = 0.0,
        ramp_limits = nothing,
        time_limits = nothing,
    )

    set_powerhouse_elevation!(turbine, 10.0)
    @test get_powerhouse_elevation(turbine) == 10.0
end

@testset "Test Hydro Reservoir constructors and getters" begin
    reservoir = HydroReservoir(;
        name = "init",
        available = false,
        initial_level = 1.0,
        storage_level_limits = (min = 0.0, max = 1.0),
        spillage_limits = nothing,
        inflow = 0.0,
        outflow = 0.0,
        level_targets = 0.0,
        travel_time = 0.0,
        intake_elevation = 0.0,
        head_to_volume_factor = 0.0,
    )
    @test get_storage_level_limits(reservoir) == (min = 0.0, max = 1.0)
    @test get_initial_level(reservoir) == 1.0
    @test get_level_data_type(reservoir) == ReservoirDataType.USABLE_VOLUME
    @test get_inflow(reservoir) == 0.0
    @test get_outflow(reservoir) == 0.0
    @test get_intake_elevation(reservoir) == 0.0
    @test get_head_to_volume_factor(reservoir) == 0.0
    set_intake_elevation!(reservoir, 10.0)
    @test get_intake_elevation(reservoir) == 10.0
end

@testset "Test Hydro Reservoir constructors and setters" begin
    reservoir = HydroReservoir(nothing)
    @test set_storage_level_limits!(reservoir, (min = 0.0, max = 0.0)) ==
          (min = 0.0, max = 0.0)
    @test set_level_data_type!(reservoir, ReservoirDataType.HEAD) == ReservoirDataType.HEAD
    @test set_inflow!(reservoir, 10.0) == 10.0
    @test set_outflow!(reservoir, 10.0) == 10.0
end

@testset "Test single `HydroTurbine` with single `HydroReservoir`" begin
    sys = System(100.0)

    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    reservoir = HydroReservoir(nothing)
    add_component!(sys, reservoir)
    turbine = HydroTurbine(nothing)
    turbine.bus = bus
    add_component!(sys, turbine)
    set_reservoirs!(turbine, [reservoir])

    @test has_reservoir(turbine)
    @test has_reservoir(turbine, reservoir)
    @test length(get_components(HydroTurbine, sys)) == 1
    @test length(get_connected_devices(sys, reservoir)) == 1

    remove_reservoir!(turbine, reservoir)
    @test_throws ArgumentError remove_reservoir!(turbine, reservoir)
    @test !has_reservoir(turbine)
    @test !has_reservoir(turbine, reservoir)
    @test length(get_connected_devices(sys, reservoir)) == 0

    remove_component!(sys, reservoir)
    @test_throws ArgumentError get_connected_devices(sys, reservoir)
end

@testset "Test multiple `HydroTurbine` with single `HydroReservoir`" begin
    sys = System(100.0)

    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    hydro_reservoir = HydroReservoir(nothing)
    add_component!(sys, hydro_reservoir)
    turbines = []
    for i in 1:5
        turbine = HydroTurbine(nothing)
        turbine.name = "Turbine" * string(i)
        turbine.bus = bus
        set_reservoirs!(turbine, [hydro_reservoir])
        add_component!(sys, turbine)
        push!(turbines, turbine)
    end

    collected_turbines = collect(get_components(HydroTurbine, sys))
    @test length(turbines) == length(collected_turbines)
    for turbine in collected_turbines
        @test has_reservoir(turbine)
        @test has_reservoir(turbine, hydro_reservoir)
        reservoir = get_reservoirs(turbine)
        @test length(reservoir) == 1
        @test reservoir[1] isa HydroReservoir
        @test reservoir[1] == hydro_reservoir
    end

    mapping = get_reservoir_device_mapping(sys)
    @test mapping isa ReservoirConnectedDevicesMapping
    @test length(get_connected_devices(sys, hydro_reservoir)) == 5
end

@testset "Test single `HydroTurbine` with multiple `HydroReservoir`" begin
    sys = System(100.0)

    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    hydro_reservoir_01 = HydroReservoir(nothing)
    hydro_reservoir_02 = HydroReservoir(nothing)
    hydro_reservoir_02.name = "reservoir02"
    add_component!(sys, hydro_reservoir_01)
    add_component!(sys, hydro_reservoir_02)
    turbine = HydroTurbine(nothing)
    turbine.bus = bus
    add_component!(sys, turbine)
    set_reservoirs!(turbine, [hydro_reservoir_01, hydro_reservoir_02])
    @test length(get_reservoirs(turbine)) == 2

    remove_reservoir!(turbine, hydro_reservoir_02)
    @test length(get_reservoirs(turbine)) == 1
    clear_reservoirs!(turbine)
    @test !has_reservoir(turbine)
    @test length(get_reservoirs(turbine)) == 0
end
