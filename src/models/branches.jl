abstract type
    Branch <: PowerSystemType
end

include("./branches/lines.jl")
include("./branches/transformers.jl")
include("../utils/ybus_calculations.jl")
include("../utils/ptdf_calculations.jl")


