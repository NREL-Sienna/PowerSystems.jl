@testset "Test generated structs" begin
    descriptor_file = joinpath(@__DIR__, "..", "src", "descriptors",
                               "power_system_structs.json")
    existing_dir = joinpath(@__DIR__, "..", "src", "models", "generated")
    output_dir = "tmp-test-generated-structs"
    if isdir(output_dir)
        rm(output_dir; recursive=true)
    end
    mkdir(output_dir)

    IS.generate_structs(descriptor_file, output_dir; print_results=false)

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

