@testset "Test single `HydroTurbine` with single `HydroReservoir`" begin
    sys = System(100.0)

    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    reservoir = HydroReservoir(nothing)
    turbine = HydroTurbine(nothing)
    turbine.bus = bus
    set_reservoirs!(turbine, [reservoir])

    add_component!(sys, turbine)
    @test len(get_components(HydroTurbine, sys)) == 1
end

@testset "Test multiple `HydroTurbine` with single `HydroReservoir`" begin
    sys = System(100.0)

    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    hydro_reservoir = HydroReservoir(nothing)
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
        reservoir = get_reservoirs(turbine)
        @test length(reservoir) == 1
        @test reservoir[1] isa HydroReservoir
        @test reservoir[1] == hydro_reservoir
    end
end

