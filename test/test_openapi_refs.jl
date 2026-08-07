@testset "OpenAPIRefs: setindex!/getindex hit and miss" begin
    refs = PSY.OpenAPIRefs("NATURAL_UNITS")
    area = Area(; name = "area1", peak_active_power = 0.0, peak_reactive_power = 0.0)
    refs[1] = area
    @test refs[1] === area
    @test PSY.has_ref(refs, 1)
    @test !PSY.has_ref(refs, 2)
    @test_throws ErrorException refs[2]
end

@testset "OpenAPIRefs: duplicate id rejected" begin
    refs = PSY.OpenAPIRefs("NATURAL_UNITS")
    area1 = Area(; name = "a1", peak_active_power = 0.0, peak_reactive_power = 0.0)
    area2 = Area(; name = "a2", peak_active_power = 0.0, peak_reactive_power = 0.0)
    refs[1] = area1
    @test_throws ErrorException (refs[1] = area2)
    @test refs[1] === area1
end

@testset "OpenAPIRefs: component -> id reverse lookup" begin
    refs = PSY.OpenAPIRefs("NATURAL_UNITS")
    area = Area(; name = "a1", peak_active_power = 0.0, peak_reactive_power = 0.0)
    other = Area(; name = "a2", peak_active_power = 0.0, peak_reactive_power = 0.0)
    refs[7] = area
    @test PSY.component_id(refs, area) == 7
    @test PSY.has_component_id(refs, area)
    @test !PSY.has_component_id(refs, other)
    @test_throws ErrorException PSY.component_id(refs, other)
end

@testset "OpenAPIRefs: document unit system accessor" begin
    refs = PSY.OpenAPIRefs("DEVICE_BASE")
    @test PSY.get_unit_system(refs) == "DEVICE_BASE"
end

@testset "OpenAPI ledger: round trip through System.ext" begin
    sys = System(100.0)
    area = Area(; name = "a1", peak_active_power = 0.0, peak_reactive_power = 0.0)
    add_component!(sys, area)
    refs = PSY.OpenAPIRefs("NATURAL_UNITS")
    refs[1] = area

    @test !PSY.has_ledger(sys)
    @test_throws ErrorException PSY.load_ledger(sys)

    PSY.store_ledger!(sys, refs)
    @test PSY.has_ledger(sys)

    ledger = PSY.load_ledger(sys)
    @test ledger["unit_system"] == "NATURAL_UNITS"
    @test ledger["id_to_uuid"]["1"] == string(IS.get_uuid(area))
end
