@testset "Test generated structs" begin
    descriptor_file =
        joinpath(@__DIR__, "..", "src", "descriptors", "power_system_structs.json")
    existing_dir = joinpath(@__DIR__, "..", "src", "models", "generated")
    @test IS.test_generated_structs(descriptor_file, existing_dir)
end
