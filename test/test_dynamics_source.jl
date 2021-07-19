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
    sys2, result = validate_serialization(sys; time_series_read_only = false)
    @test result
end
