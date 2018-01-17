#isdefined(Base, :__precompile__) && __precompile__()

module PowerSchema

using TimeSeries 
using PowerModels
using DataFrames
using TimeSeries
using Base.convert

# PowerSchema models
include("models/topological_types.jl")
#include("models/renewable_types.jl")
#include("models/conventional_types.jl")
#include("models/load_types.jl")

# Include Parsing files
#include("parsers/matpower_parser.jl")
#include("parsers/dict_to_struct.jl")
#include("parsers/psse_parser.jl")
#include("parsers/plexoscsv_parser.jl")

end 
