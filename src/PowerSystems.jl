#isdefined(Base, :__precompile__) && __precompile__()

module PowerSystems

using TimeSeries
using PowerModels
using DataFrames
using Base.convert
using CSV
# This packages will be removed with Julia v0.7
using Compat
using NamedTuples

# PowerSystems models
include("models/topological_elements.jl")
include("models/forecasts.jl")
include("models/network.jl")

#Static types
include("models/generation.jl")
include("models/storage.jl")
include("models/loads.jl")

# Include Parsing files
include("parsers/dict_to_struct.jl")
include("parsers/standardfiles_parser.jl")
include("parsers/csv_parser.jl")

include("utils/checks.jl")
include("utils/print.jl")

#Definitions of PowerSystem
include("base.jl")

end
