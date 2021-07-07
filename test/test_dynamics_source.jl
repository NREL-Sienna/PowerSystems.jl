@testset "Test Dynamic Source" begin
    sys = System(100)
    bus = Bus(nothing)
    add_component!(sys, bus)
    source = Source(nothing)
    set_bus!(source, bus)
    add_component!(sys, source)
    pvs = PeriodicVariableSource(nothing)
    set_bus!(pvs, bus)
    set_dynamic_injector!(source, pvs)
    @test get_dynamic_injector(source) !== nothing
end
