export Generator

abstract type
    Generator
end

include("renewable_generation.jl")
include("conventional_generation.jl")
include("hydro_generation.jl")
