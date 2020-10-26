# # Quick Start Guide
#
# `PowerSystems.jl` is structured to enable intuitive data creation scripts, flexible interfaces
# for data intake and straight forward extension of the data model. These features are enabled
# through three main features:
#
# - Abstract type hierarchy,
# - Optimized read/write data container (the container is called `System`),
# - Utilities to facilitate modeling, extensions, and integration.
#
# You can access example data in the [Power Systems Test Data Repository](https://github.com/NREL-SIIP/PowerSystemsTestData)
# the data can be downloaded with the submodule `UtilsData`
#
# ## Loading data

# Code can be loaded from Matpower files and return a summary of the system's components and
# time-series

using PowerSystems
const PSY = PowerSystems
DATA_DIR = download(PSY.UtilsData.TestData, folder = pwd())
system_data = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m"))

# -----
# ## Using `PowerSystems.jl` for modeling
#
# This example function implements a function where the modeler can choose the technology
# by its type and use the different implementations of \jlinline{get_max_active_power}.
# Note that in line 15 the function takes an abstract type to and in line 16 a concrete type.
# This code exemplifies the flexibility of the container interface to facilitate the
# development of models consistent with the ontology of the topology

function installed_capacity(system::System; technology::Type{T} = Generator) where T <: Generator
    installed_capacity = 0.0
    for g in get_components(T, system)
        installed_capacity += get_max_active_power(g)
    end
    return installed_capacity
end

# total installed capacity

installed_capacity(system_data)

# installed capacity of the thermal generation

installed_capacity(system_data; technology = ThermalStandard)

# installed capacity of renewable generation

installed_capacity(system_data; technology = RenewableGen)
