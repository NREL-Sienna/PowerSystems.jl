abstract type
    Branch <: PowerSystemDevice
end

include("./branches/lines.jl")
include("./branches/transformers.jl")
include("./branches/dc_lines.jl")
include("../utils/ybus_calculations.jl")
include("../utils/ptdf_calculations.jl")


