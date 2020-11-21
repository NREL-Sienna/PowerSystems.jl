# # Power Flow

# `PowerSystems.jl` provides the capability to run a power flow with the intention of
# providing a valid initial AC operating point to the system. It is not meant as an analytics
# tool; the main issue is to determine if the system has feasible AC data. This solver does
# not check for reactive power limits or other limiting mechanisms in the grid.

# The power flow solver uses [NLsolve.jl](https://github.com/JuliaNLSolvers/NLsolve.jl) under
# the hood and takes any keyword argument accepted by NLsolve

# Check section [Power Flow](@ref pf) for detailed usage instructions

using PowerSystems
const PSY = PowerSystems

DATA_DIR = "../../../data" #hide
system_data = System(joinpath(DATA_DIR, "matpower/case5.m"))

# `PowerSystems.jl` has two modes of using the power flow solver.

# 1. Solving the power flow for the current operating point in the system.
#    Takes the data in the buses, the `active_power` and `reactive_power` fields
#    in the static injection devices. Returns a dictionary with results in a DataFrame

# example

results = solve_powerflow(system_data)
res["bus_results"]
