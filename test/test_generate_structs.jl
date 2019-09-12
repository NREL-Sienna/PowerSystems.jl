@testset "Test generated structs" begin
    descriptor_file = joinpath(@__DIR__, "..", "src", "descriptors",
                               "power_system_structs.json")
    existing_dir = joinpath(@__DIR__, "..", "src", "models", "generated")
    output_dir = "tmp"
    mkdir(output_dir)

    IS.generate_structs(descriptor_file, output_dir)

    matched = true
    try
        run(`diff $output_dir $existing_dir`)
    catch(err)
        @error "Generated structs do not match the descriptor file."
        matched = false
    finally
        rm(output_dir; recursive=true)
    end

    @test matched
end

