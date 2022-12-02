"""
Generate a Julia source code file for one struct from a `StructDefinition`.

Refer to `StructDefinition` and `StructField` for descriptions of the available fields.

# Arguments
- `definition::StructDefinition`: Defines the struct and all fields.
- `filename::AbstractString`: Add the struct definition to this JSON file. Defaults to
  `src/descriptors/power_system_structs.json`
- `output_directory::AbstractString`: Generate the files in this directory. Defaults to
  `src/models/generated`
"""
function generate_struct_file(
    definition::StructDefinition;
    filename = nothing,
    output_directory = nothing,
)
    generate_struct_files(
        [definition];
        filename = filename,
        output_directory = output_directory,
    )
end

"""
Generate Julia source code files for multiple structs from a iterable of `StructDefinition`
instances.

Refer to `StructDefinition` and `StructField` for descriptions of the available fields.

# Arguments
- `definitions`: Defines the structs and all fields.
- `filename::AbstractString`: Add the struct definition to this JSON file. Defaults to
  `src/descriptors/power_system_structs.json`
- `output_directory::AbstractString`: Generate the files in this directory. Defaults to
  `src/models/generated`
"""
function generate_struct_files(definitions; filename = nothing, output_directory = nothing)
    if isnothing(filename)
        filename = joinpath(
            dirname(Base.find_package("PowerSystems")),
            "descriptors",
            "power_system_structs.json",
        )
    end
    if isnothing(output_directory)
        output_directory =
            joinpath(dirname(Base.find_package("PowerSystems")), "models", "generated")
    end

    IS.generate_struct_files(
        definitions;
        filename = filename,
        output_directory = output_directory,
    )
end
