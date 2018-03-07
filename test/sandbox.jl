using PowerSystems
using PowerModels
using NLopt
using Ipopt
solver = IpoptSolver()
solver2 = NLoptSolver(algorithm =:LD_SLSQP);
model_constructor = ACPPowerModel

using PowerSystems
forecast = ReadPointForecast("data_files/point_forecast_data.csv", Interval = 5, Resolution = 5,)

case_raw = psse_parser("data_files/118_bus.raw")

solution1 = run_generic_model(case_raw, model_constructor, solver2, PowerModels.post_pf)

solution2 = run_generic_model(case_raw, model_constructor, solver, PowerModels.post_pf)

include("data_files/data_5bus.jl")
include("data_files/data_14bus.jl")