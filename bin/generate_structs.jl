import Pkg
Pkg.add(Pkg.PackageSpec(name="Mustache", version="0.5.12"))

import JSON2
import Mustache

template = """
#=
This file is auto-generated. Do not edit.
=#

{{#docstring}}\"\"\"{{docstring}}\"\"\"{{/docstring}}
mutable struct {{struct_name}}{{#parametric}}{T <: {{parametric}}}{{/parametric}} <: {{supertype}}
    {{#parameters}}
    {{name}}::{{data_type}}{{#comment}}  # {{{comment}}}{{/comment}}
    {{/parameters}}
    {{#inner_constructor_check}}

    function {{struct_name}}({{#parameters}}{{name}}, {{/parameters}})
        ({{#parameters}}{{name}}, {{/parameters}}) = {{inner_constructor_check}}(
            {{#parameters}}
            {{name}},
            {{/parameters}}
        )
        new({{#parameters}}{{name}}, {{/parameters}})
    end
    {{/inner_constructor_check}}
end

function {{struct_name}}({{#parameters}}{{^internal}}{{name}}, {{/internal}}{{/parameters}})
    {{#parameters}}
    {{/parameters}}
    {{struct_name}}({{#parameters}}{{^internal}}{{name}}, {{/internal}}{{/parameters}}PowerSystemInternal())
end

function {{struct_name}}(; {{#parameters}}{{^internal}}{{name}}, {{/internal}}{{/parameters}})
    {{struct_name}}({{#parameters}}{{^internal}}{{name}}, {{/internal}}{{/parameters}})
end

{{#has_null_values}}
# Constructor for demo purposes; non-functional.

function {{struct_name}}(::Nothing)
    {{struct_name}}(;
        {{#parameters}}
        {{^internal}}
        {{name}}={{#quotes}}"{{null_value}}"{{/quotes}}{{^quotes}}{{null_value}}{{/quotes}},
        {{/internal}}
        {{/parameters}}
    )
end
{{/has_null_values}}

{{#accessors}}
\"\"\"Get {{struct_name}} {{name}}.\"\"\"
{{accessor}}(value::{{struct_name}}) = value.{{name}}
{{/accessors}}
"""

function read_json_data(filename::String)
    return open(filename) do io
        data = JSON2.read(io, Vector{Dict})
    end
end

function generate_structs(directory, data::Vector)
    struct_names = Vector{String}()
    unique_accessor_functions = Set{String}()

    for item in data
        accessors = Vector{Dict}()
        item["has_null_values"] = true
        parameters = Vector{Dict}()
        for field in item["fields"]
            param = namedtuple_to_dict(field)
            push!(parameters, param)

            accessor_name = "get_" * param["name"]
            push!(accessors, Dict("name" => param["name"], "accessor" => accessor_name))
            if accessor_name != "internal"
                push!(unique_accessor_functions, accessor_name)
            end

            if param["name"] == "internal"
                param["internal"] = true
                continue
            end

            # This controls whether a kwargs constructor will be generated.
            if !haskey(param, "null_value")
                item["has_null_values"] = false
            else
                if param["data_type"] == "String"
                    param["quotes"] = true
                end
            end
            param["struct_name"] = item["struct_name"]
        end

        item["parameters"] = parameters
        item["accessors"] = accessors

        filename = joinpath(directory, item["struct_name"] * ".jl")
        open(filename, "w") do io
            write(io, Mustache.render(template, item))
            push!(struct_names, item["struct_name"])
        end
        println("Wrote $filename")
    end

    accessors = sort!(collect(unique_accessor_functions))

    filename = joinpath(directory, "includes.jl")
    open(filename, "w") do io
        for name in struct_names
            write(io, "include(\"$name.jl\")\n")
        end
        write(io, "\n")

        for accessor in accessors
            write(io, "export $accessor\n")
        end
        println("Wrote $filename")
    end
end

function namedtuple_to_dict(tuple)
    parameters = Dict()
    for property in propertynames(tuple)
        parameters[string(property)] = getproperty(tuple, property)
    end

    return parameters
end

function generate_structs(input_file::AbstractString, output_directory::AbstractString)
    # Include each generated file.
    if !isdir(output_directory)
        mkdir(output_directory)
    end

    data = read_json_data(input_file)
    generate_structs(output_directory, data)
end

function main(args)
    if length(args) != 2
        println("Usage: julia generate_structs.jl INPUT_FILE OUTPUT_DIRECTORY")
        exit(1)
    end

    generate_structs(args[1], args[2])
end

main(ARGS)
