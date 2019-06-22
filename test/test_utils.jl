
@testset "Test utility functions" begin
    concrete_types = PowerSystems.get_all_concrete_subtypes(Component)
    @test length([x for x in concrete_types if isconcretetype(x)]) == length(concrete_types)
end
