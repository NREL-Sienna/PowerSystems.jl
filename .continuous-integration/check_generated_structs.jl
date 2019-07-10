"""Generate structs from the descriptor file and verify that they match what's in the repo."""

script = joinpath(@__DIR__, "..", "bin", "generate_structs.jl")
@assert ispath(script)
descriptor_file = joinpath(@__DIR__, "..", "src", "descriptors", "power_system_structs.json")
@assert ispath(descriptor_file)
existing_dir = joinpath(@__DIR__, "..", "src", "models", "generated")
@assert ispath(existing_dir)
output_dir = "tmp"
mkdir(output_dir)

# Call read to avoid printing to stdout.
read(`julia $script $descriptor_file $output_dir`)
try
    run(`diff $output_dir $existing_dir`)
catch(err)
    error("Generated structs do not match the descriptor file.")
finally
    rm(output_dir; recursive=true)
end
