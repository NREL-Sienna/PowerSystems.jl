@testset "Test Dynamic Source" begin
    sys = System(100)
    bus = Bus(nothing)
    add_component!(sys, bus)
    source = Source(nothing)
    set_bus!(source, bus)
    add_component!(sys, source)
    pvs = PeriodicVariableSource(nothing)
    set_bus!(pvs, bus)
    add_component!(sys, pvs, source)
    @test get_components(PeriodicVariableSource, sys) !== nothing
end

@testset "Test Dynamic Source" begin
    sys = System(100)
    bus = Bus(nothing)
    add_component!(sys, bus)
    source = Source(nothing)
    set_bus!(source, bus)
    add_component!(sys, source)
    pvs = PeriodicVariableSource(nothing)
    set_bus!(pvs, bus)
    add_component!(sys, pvs, source)
    @test get_components(PeriodicVariableSource, sys) !== nothing
    retrieved_pvs = collect(get_components(PeriodicVariableSource, sys))
    temp_dir = mktempdir()
    orig_dir = mktempdir()
    cd(temp_dir)
    to_json(sys, "test.json")
    sys2 = System("test.json")
    serialized_pvs = collect(get_components(PeriodicVariableSource, sys2))
    @test get_name(retrieved_pvs[1]) == get_name(serialized_pvs[1])
end
