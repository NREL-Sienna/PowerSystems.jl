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
    @test length(get_contributing_devices(sys, reservoir)) == 1

    remove_reservoir!(turbine, reservoir)
    @test !has_reservoir(turbine)
    @test length(get_contributing_devices(sys, reservoir)) == 0
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

    mapping = get_reservoir_contributing_device_mapping(sys)
    @test mapping isa ReservoirContributingDevicesMapping
    @test length(get_contributing_devices(sys, hydro_reservoir)) == 5
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
