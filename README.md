# PowerSystems

[![Build Status](https://travis-ci.org/NREL/PowerSystems.jl.svg?branch=master)](https://travis-ci.org/NREL/PowerSystems.jl)

[![Build status](https://ci.appveyor.com/api/projects/status/51qboor9s6x8w9tl?svg=true)](https://ci.appveyor.com/project/jdlara-berkeley/powersystems-jl)

[![codecov](https://codecov.io/gh/NREL/PowerSystems.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/NREL/PowerSystems.jl)

The PowerSystems.jl package provides a rigorous data model using Julia structures to enable power systems analysis. In addition to stand alone system analysis, the PowerSystems.jl pakcage provides the foundational data container for the [PowerSimulations.jl](https://github.com/NREL/PowerSimulations.jl) package. PowerSystems enables data structures for a number of devices and relies on a limited number of data formats for parsing.

### Device data enabled in PowerSystems:
 - Generators (Thermal, Renewable, Synhronous Condensers, and Hydro)
 - Transmission (DC Lines, Lines, and Transformers)
 - Topological elements (Buses, Areas)
 - Storage (Batteries)
 - Load (Static, curtailable, and shiftable)
 - Services (Reserves, inter-regional transfers)
 - Forecasts (Deterministic, scenario, stochastic)
 
### Parsing capabilities in PowerSystems:
 - MATPOWER CaseFormat
 - PSS/E - PTI Format
 - [RTS-GMLC](https://github.com/GridMod/RTS-GMLC/tree/master/RTS_Data/SourceData) data format

## Installation

This package is not yet registered. **Until it is, things may change. It is perfectly
usable but should not be considered stable**.

You can install it by typing

```julia
julia> Pkg.clone("https://github.com/NREL/PowerSystems.jl.git")
```

## Usage

Once installed, the `PowerSystems` package can by used by typing

```julia
using PowerSystems
```


## Development

Contributions to the development and enahancement of PowerSystems is welcome. Please see [CONTRIBUTING.md](https://github.com/NREL/PowerSystems.jl/blob/master/CONTRIBUTING.md) for code contribution guidelines.


## License

PowerSystems is released under a BSD [license](https://github.com/NREL/PowerSystems.jl/blob/master/LICENSE). PowerSystems has been developed as part of the Scalable Integrated Infrastructure Planning (SIIP)
initiative at the U.S. Department of Energy's National Renewable Energy Laboratory ([NREL](https://www.nrel.gov/))