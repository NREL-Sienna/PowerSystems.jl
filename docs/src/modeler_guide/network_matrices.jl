# # Network Matrices

# `PowerSystems.jl` is able to build classic power systems modeling network matrices such as
# [Ybus](https://en.wikipedia.org/wiki/Nodal_admittance_matrix), [PTDF](https://www.powerworld.com/WebHelp/Content/MainDocumentation_HTML/Power_Transfer_Distribution_Factors.htm) and LODF

# Check section [Network Matrices](@ref net_mat) for more details

# ## Overview
# Network matrices are implemented in `PowerSystems.jl` as arrays that enable using Branch or Bus
# names a indexes to facilitate exploration and analysis. Ybus is stored as an SparseMatrix
# and the PTDF and LODF are stored as dense matrices.

# ## Ybus
using PowerSystems
const PSY = PowerSystems

DATA_DIR = "../../../data" #hide
system_data = System(joinpath(DATA_DIR, "matpower/case14.m"))

ybus = Ybus(system_data)

# ## PTDF

ptdf = PTDF(system_data)

# ## LODF

lodf = LODF(system_data)
