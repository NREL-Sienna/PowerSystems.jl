using Pkg
using Literate

# Literate post-processing functions for tutorial generation

# postprocess function to insert md
function insert_md(content)
    m = match(r"APPEND_MARKDOWN\(\"(.*)\"\)", content)
    if !isnothing(m)
        md_content = read(m.captures[1], String)
        content = replace(content, r"APPEND_MARKDOWN\(\"(.*)\"\)" => md_content)
    end
    return content
end

# Function to add download links to generated markdown
function add_download_links(content, jl_file, ipynb_file)
    # Add download links at the top of the file after the first heading
    download_section = """

*To follow along, you can download this tutorial as a [Julia script (.jl)]($(jl_file)) or [Jupyter notebook (.ipynb)]($(ipynb_file)).*

"""
    # Insert after the first heading (which should be the title)
    # Match the first heading line and replace it with heading + download section
    m = match(r"^(#+ .+)$"m, content)
    if m !== nothing
        heading = m.match
        content = replace(content, r"^(#+ .+)$"m => heading * download_section, count=1)
    end
    return content
end

# Function to add Pkg.status() to notebook within the first markdown cell
function add_pkg_status_to_notebook(nb::Dict)
    cells = get(nb, "cells", [])
    if isempty(cells)
        return nb
    end
    
    # Find the first markdown cell
    first_markdown_idx = nothing
    for (i, cell) in enumerate(cells)
        if get(cell, "cell_type", "") == "markdown"
            first_markdown_idx = i
            break
        end
    end
    
    if first_markdown_idx === nothing
        return nb  # No markdown cell found, return unchanged
    end
    
    first_cell = cells[first_markdown_idx]
    cell_source = get(first_cell, "source", [])
    
    # Convert source array to string to find the first heading
    source_text = join(cell_source)
    
    # Find the first heading (lines starting with #)
    heading_pattern = r"^(#+\s+.+?)$"m
    heading_match = match(heading_pattern, source_text)
    
    if heading_match === nothing
        return nb  # No heading found, return unchanged
    end
    
    # Capture Pkg.status() output at build time
    io = IOBuffer()
    Pkg.status(; io=io)
    pkg_status_output = String(take!(io))
    
    # Create the content to insert: preface + pkg.status() in code block
    preface_lines = ["\n", "_This tutorial has demonstrated compatibility with the package versions below. If you run into any errors, first check your package versions for consistency using `Pkg.status()`._\n", "\n"]
    
    # Format Pkg.status() output as a code block
    pkg_status_lines = split(pkg_status_output, '\n', keepempty=true)
    pkg_status_block = ["```\n"]
    for line in pkg_status_lines
        push!(pkg_status_block, line * "\n")
    end
    push!(pkg_status_block, "```\n", "\n")
    
    # Find the first heading line in the source array
    heading_line_idx = nothing
    for (i, line) in enumerate(cell_source)
        if match(heading_pattern, line) !== nothing
            heading_line_idx = i
            break
        end
    end
    
    if heading_line_idx === nothing
        return nb  # Couldn't find heading line
    end
    
    # Build new source array
    new_source = String[]
    # Add all lines up to and including the heading line
    for i in 1:heading_line_idx
        push!(new_source, cell_source[i])
    end
    
    # Add the preface and pkg.status content right after the heading
    append!(new_source, preface_lines)
    append!(new_source, pkg_status_block)
    
    # Add all remaining lines after the heading
    for i in (heading_line_idx+1):length(cell_source)
        push!(new_source, cell_source[i])
    end
    
    # Update the cell source
    first_cell["source"] = new_source
    cells[first_markdown_idx] = first_cell
    
    nb["cells"] = cells
    return nb
end

# Function to clean up old generated files
function clean_old_generated_files(dir::String)
    # Remove old generated_*.md files before creating new ones
    if !isdir(dir)
        @warn "Directory does not exist: $dir"
        return
    end
    generated_files = filter(f -> startswith(f, "generated_") && endswith(f, ".md"), readdir(dir))
    for file in generated_files
        rm(joinpath(dir, file), force=true)
        @info "Removed old generated file: $file"
    end
end

# Process tutorials with Literate
function make_tutorials()
    tutorial_files = filter(x -> occursin(".jl", x), readdir("docs/src/tutorials"))
    if !isempty(tutorial_files)
        # Clean up old generated tutorial files
        tutorial_outputdir = joinpath(pwd(), "docs", "src", "tutorials")
        clean_old_generated_files(tutorial_outputdir)
        
        for file in tutorial_files
            @show file
            infile_path = joinpath(pwd(), "docs", "src", "tutorials", file)
            execute = occursin("EXECUTE = TRUE", uppercase(readline(infile_path))) ? true : false
            execute && include(infile_path)
            
            outputfile = string("generated_", replace("$file", ".jl" => ""))
            
            # Generate markdown
            Literate.markdown(infile_path,
                              tutorial_outputdir;
                              name = outputfile,
                              credit = false,
                              flavor = Literate.DocumenterFlavor(),
                              documenter = true,
                              postprocess = (content -> add_download_links(insert_md(content), file, string(outputfile, ".ipynb"))),
                              execute = execute)
            
            # Generate notebook
            Literate.notebook(infile_path,
                              tutorial_outputdir;
                              name = outputfile,
                              credit = false,
                              execute = false,
                              postprocess = add_pkg_status_to_notebook)
        end
    end
end
