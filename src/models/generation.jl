abstract type
    Generator <: PowerSystemDevice
end

include("generation/tech_common.jl")
include("generation/econ_common.jl")
include("generation/renewable_generation.jl")
include("generation/thermal_generation.jl")
include("generation/hydro_generation.jl")


# Generator Classifier
function genclassifier(gen::Array{T}, basemva::Float64) where T <: Generator

    t = [d for d in gen if isa(d, ThermalGen)]
    r = [d for d in gen if isa(d, RenewableGen)]
    h = [d for d in gen if isa(d, HydroGen)]

    #Check for data consistency
    if isempty(t)
        t = nothing
    else
        pu_check_gen(t,basemva)
    end

    if isempty(r)
        r = nothing
    else
        pu_check_gen(r,basemva)
    end

    if isempty(h)
        h = nothing
    else
        pu_check_gen(h,basemva)
    end

    generators = (thermal = t, renewable =r, hydro = h)

    return generators
end

