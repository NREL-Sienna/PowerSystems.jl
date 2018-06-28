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
function GenClassifier(gen::Array{T}) where T <: PowerSystems.Generator

    t = [d for d in gen if isa(d, PowerSystems.ThermalGen)]
    r = [d for d in gen if isa(d, PowerSystems.RenewableGen)]
    h = [d for d in gen if isa(d, PowerSystems.HydroGen)]

    #Check for type stability
    isempty(t) ? t = nothing: t
    isempty(r) ? r = nothing: r
    isempty(h) ? h = nothing: h

    generators = PowerSystems.Sources(t,r,h)

    return generators
end