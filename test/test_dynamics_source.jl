# Non functional system data. This code is just for testing.
# Do not copy paste this code.
@testset "Test Dynamic Source" begin
    sys = System(100.0)
    bus = ACBus(nothing)
    set_bustype!(bus, ACBusTypes.SLACK)
    add_component!(sys, bus)
    source = Source(nothing)
    set_bus!(source, bus)
    add_component!(sys, source)
    pvs = PeriodicVariableSource(nothing)
    add_component!(sys, pvs, source)
    @test get_components(PeriodicVariableSource, sys) !== nothing
end

@testset "Test Dynamic Source" begin
    sys = System(100.0)
    bus = ACBus(nothing)
    set_bustype!(bus, ACBusTypes.REF)
    add_component!(sys, bus)
    source = Source(nothing)
    set_bus!(source, bus)
    add_component!(sys, source)
    pvs = PeriodicVariableSource(nothing)
    add_component!(sys, pvs, source)
    @test get_components(PeriodicVariableSource, sys) !== nothing
    # Disabled: Source's default operation_cost is an ImportExportCost, and the schema's
    # ImportExportCost has no `ancillary_service_offers` field, so no converter can be
    # written without dropping data. Blocked on SiennaSchemas#16.
    # sys2 = roundtrip_system(sys)
end
