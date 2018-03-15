using PowerSystems
cd(string(homedir(),"/.julia/v0.6/PowerSystems/data_files"))
include("data_5bus.jl")

#data = dict_to_struct(plexos)

using PowerModels
using Ipopt
model_constructor = ACPPowerModel
solver2 = IpoptSolver();
plexos_data = run_generic_model(plexos, model_constructor, solver2, PowerModels.post_pf)