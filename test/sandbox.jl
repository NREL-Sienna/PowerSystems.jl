const LOCAL_PACKAGES = expanduser("~/Dropbox/Remote Code Rep/PowerSchema/src")
push!(LOAD_PATH, LOCAL_PACKAGES)

using PowerSchema
using PowerModels
using NLopt
using Ipopt
solver = IpoptSolver()
solver2 = NLoptSolver(algorithm =:LD_SLSQP);
model_constructor = ACPPowerModel

case_raw = psse_parser("data_files/118_bus.raw")

solution1 = run_generic_model(case_raw, model_constructor, solver2, PowerModels.post_pf)

solution2 = run_generic_model(case_raw, model_constructor, solver, PowerModels.post_pf)

include("data_files/data_5bus.jl")
include("data_files/data_14bus.jl")