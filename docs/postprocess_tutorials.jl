using Pkg

# Literate post-processing functions for tutorial generation

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

# Function to add Pkg.status() to notebook after first cell
function add_pkg_status_to_notebook(nb::Dict)
    cells = get(nb, "cells", [])
    if isempty(cells)
        return nb
    end
    
    # Capture Pkg.status() output at build time
    io = IOBuffer()
    Pkg.status(; io=io)
    pkg_status_output = String(take!(io))
    
    # Create markdown cell with italicized preface
    preface_cell = Dict(
        "cell_type" => "markdown",
        "metadata" => Dict(),
        "source" => ["_This tutorial has demonstrated compatibility with the package versions below. If you run into any errors, first check your package versions for consistency using `Pkg.status()`._\n"]
    )
    
    # Create markdown cell with Pkg.status() output embedded in a code block
    # Split the output into lines and format as markdown code block
    pkg_status_lines = split(pkg_status_output, '\n', keepempty=true)
    pkg_status_source = ["```\n"]
    for line in pkg_status_lines
        push!(pkg_status_source, line * "\n")
    end
    push!(pkg_status_source, "```\n")
    
    pkg_status_cell = Dict(
        "cell_type" => "markdown",
        "metadata" => Dict(),
        "source" => pkg_status_source
    )

    # Insert cells after the first cell (insert in reverse order to maintain indices)
    insert!(cells, 2, pkg_status_cell)
    insert!(cells, 1, preface_cell)
    
    nb["cells"] = cells
    return nb
end
