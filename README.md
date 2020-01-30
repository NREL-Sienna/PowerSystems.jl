# PowerSystems

[![Build Status](https://travis-ci.com/NREL/PowerSystems.jl.svg?branch=master)](https://travis-ci.com/NREL/PowerSystems.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/96iqo76vjlrvnu90/branch/master?svg=true)](https://ci.appveyor.com/project/jd-lara/powersystems-jl/branch/master)
[![codecov](https://codecov.io/gh/NREL/PowerSystems.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/NREL/PowerSystems.jl)
[![Gitter](https://badges.gitter.im/NREL/PowerSystems.jl.svg)](https://gitter.im/NREL/PowerSystems.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://nrel.github.io/PowerSystems.jl/latest)

The `PowerSystems.jl` package provides a rigorous data model using Julia structures to enable power systems analysis and modeling. In addition to stand-alone system analysis tools and data model building, the `PowerSystems.jl` package is used as the foundational data container for the [PowerSimulations.jl](https://github.com/NREL/PowerSimulations.jl) package. `PowerSystems.jl` supports a limited number of data file formats for parsing.

## Version Advisory

- The latest tagged version in PowerSystems will work with Julia v1.2+.

### Device data enabled in PowerSystems:
 - Generators (Thermal, Renewable and Hydro)
 - Transmission (Lines, and Transformers)
 - Active Flow control devices (DC Lines and phase-shifters)
 - Topological elements (Buses, Arcs, Areas)
 - Storage (Batteries)
 - Load (Static, and curtailable)
 - Services (Reserves, transfers)
 - Forecasts (Deterministic, scenario, stochastic)
 - Dynamic Components

### Parsing capabilities in PowerSystems:
 - MATPOWER CaseFormat
 - PSS/E - PTI Format
 - [RTS-GMLC](https://github.com/GridMod/RTS-GMLC/tree/master/RTS_Data/SourceData) table data format

## Installation

You can install it by typing

```julia
julia> ] add PowerSystems
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
