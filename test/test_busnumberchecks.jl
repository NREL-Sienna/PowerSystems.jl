
base_dir = dirname(dirname(pathof(PowerSystems)))

@testset "Check bus index" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    @test sort([b.number for b in collect(get_components(Bus, sys))]) == [1, 2, 3, 4, 10]
    @test sort(
        collect(Set([b.arc.from.number for b in collect(get_components(Branch, sys))])),
    ) == [1, 2, 3, 4]
    @test sort(
        collect(Set([b.arc.to.number for b in collect(get_components(Branch, sys))])),
    ) == [2, 3, 4, 10]

    # TODO: add test for loadzones testing MAPPING_BUSNUMBER2INDEX

end

@testset "Test unique bus numbers" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    number = 100
    bus1 = Bus(;
        number = number,
        name = "bus100",
        bustype = BusTypes.PV,
        angle = 1.0,
        magnitude = 1.0,
        voltage_limits = (min = -1.0, max = 1.0),
        base_voltage = 1.0,
    )
    bus2 = Bus(;
        number = number,
        name = "bus101",
        bustype = BusTypes.PV,
        angle = 1.0,
        magnitude = 1.0,
        voltage_limits = (min = -1.0, max = 1.0),
        base_voltage = 1.0,
        area = nothing,
        load_zone = nothing,
    )

    add_component!(sys, bus1)
    @test_throws ArgumentError add_component!(sys, bus2)
end
