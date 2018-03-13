using PowerSystems
cd(string(homedir(),"/.julia/v0.6/PowerSystems"))
plexos = plexoscsv_parser("data_files/plexos_csv_118/")
#data = dict_to_struct(plexos)

using PowerModels
using Ipopt
model_constructor = ACPPowerModel
solver2 = IpoptSolver();
plexos_data = run_generic_model(plexos, model_constructor, solver2, PowerModels.post_pf)