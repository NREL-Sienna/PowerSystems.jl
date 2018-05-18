#isdefined(Base, :__precompile__) && __precompile__()

module PowerSystems

using TimeSeries
using PowerModels
using DataFrames
using Base.convert
using CSV
# This packages will be removed with Julia v0.7
using Compat

if VERSION < v"0.7"
    using NamedTuples

    # PowerSystems models
    include("modelsv6/topological_elements.jl")
    include("modelsv6/forecasts.jl")
    include("modelsv6/network/network.jl")

    #Dynamics
    #include("models/dynamics/dynamics.jl")

    #Static types
    include("modelsv6/generation.jl")
    include("modelsv6/storage_devices.jl")
    include("modelsv6/electric_loads.jl")
    include("modelsv6/shunt_elements.jl")

end

if VERSION >= v"0.7"

    # PowerSystems models
    include("modelsv7/topological_elements.jl")
    include("modelsv7/forecasts.jl")
    include("modelsv7/network/network.jl")

    #Dynamics
    #include("models/dynamics/dynamics.jl")

    #Static types
    include("modelsv7/generation.jl")
    include("modelsv7/storage_devices.jl")
    include("modelsv/electric_loads.jl")
    include("modelsv7/shunt_elements.jl")

end


# Include Parsing files
include("parsers/matpower_parser.jl")
include("parsers/dict_to_struct.jl")
include("parsers/psse_parser.jl")
include("parsers/plexoscsv_parser.jl")
#include("parsers/read_forecast.jl")

include("utils.jl")

#Definitions of PowerSystem
include("base.jl")

end
