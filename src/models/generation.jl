abstract type
    Generator <: PowerSystemDevice
end

include("generation/tech_common.jl")
include("generation/econ_common.jl")
include("generation/renewable_generation.jl")
include("generation/thermal_generation.jl")
include("generation/hydro_generation.jl")

struct GenClasses <: PowerSystemComponent
    thermal::Union{Nothing,Array{ <: ThermalGen,1}}
    renewable::Union{Nothing,Array{ <: RenewableGen,1}}
    hydro::Union{Nothing,Array{ <: HydroGen,1}}
end

# Generator Classifier
function genclassifier(gen::Array{T}) where T <: Generator

    t = [d for d in gen if isa(d, ThermalGen)]
    r = [d for d in gen if isa(d, RenewableGen)]
    h = [d for d in gen if isa(d, HydroGen)]

    #Check for data consistency
    if isempty(t)
        t = nothing
    end

    if isempty(r)
        r = nothing
    end

    if isempty(h)
        h = nothing
    end

    generators = GenClasses(t, r, h)

    return generators
end

