abstract type
    Generator <: PowerSystemDevice
end

include("generation/renewable_generation.jl")
include("generation/thermal_generation.jl")
include("generation/hydro_generation.jl")

#Sources shouldn't be exported. It is used internally to classify the generators.
struct Sources{T <: Union{Nothing,Array{<:ThermalGen,1}}, R <: Union{Nothing,Array{<:RenewableGen,1}}, H <: Union{Nothing,Array{<:HydroGen,1}}}
    thermal::T
    renewable::R
    hydro::H
end

# Generator Classifier
function GenClassifier(gen::Array{T}) where T <: Generator

    t = [d for d in gen if isa(d, ThermalGen)]
    r = [d for d in gen if isa(d, RenewableGen)]
    h = [d for d in gen if isa(d, HydroGen)]

    #Check for type stability
    isempty(t) ? t = Array{ThermalGen,1}(0): t
    isempty(r) ? r = Array{RenewableGen,1}(0): r
    isempty(h) ? h = Array{HydroGen,1}(0): h

    generators = Sources(t,r,h)

    return generators
end
