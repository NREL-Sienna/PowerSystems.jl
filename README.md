# PowerSystems.jl

![Master - CI](https://github.com/NREL-SIIP/PowerSystems.jl/workflows/Master%20-%20CI/badge.svg)
[![codecov](https://codecov.io/gh/NREL-SIIP/PowerSystems.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/NREL-SIIP/PowerSystems.jl)
[![Documentation Build](https://github.com/NREL-SIIP/PowerSystems.jl/workflows/Documentation/badge.svg?)](https://nrel-siip.github.io/PowerSystems.jl/stable)
[![DOI](https://zenodo.org/badge/114039584.svg)](https://zenodo.org/badge/latestdoi/114039584)
[<img src="https://img.shields.io/badge/slack-@SIIP/PSY-blue.svg?logo=slack">](https://join.slack.com/t/nrel-siip/shared_invite/zt-glam9vdu-o8A9TwZTZqqNTKHa7q3BpQ)

The `PowerSystems.jl` package provides a rigorous data model using Julia structures to enable power systems analysis and modeling. In addition to stand-alone system analysis tools and data model building, the `PowerSystems.jl` package is used as the foundational data container for the [PowerSimulations.jl](https://github.com/NREL/PowerSimulations.jl) package. `PowerSystems.jl` supports a limited number of data file formats for parsing.

## Version Advisory

- The latest tagged version in PowerSystems will work with Julia v1.2+.

## Device data enabled in PowerSystems

- Generators (Thermal, Renewable and Hydro)
- Transmission (Lines, and Transformers)
- Active Flow control devices (DC Lines and phase-shifters)
- Topological elements (Buses, Arcs, Areas)
- Storage (Batteries)
- Load (Static, and curtailable)
- Services (Reserves, transfers)
- TimeSeries (Deterministic, scenario, stochastic)
- Dynamic Components

## Parsing capabilities in PowerSystems

- MATPOWER CaseFormat
- PSS/e - PTI Format
- [RTS-GMLC](https://github.com/GridMod/RTS-GMLC/tree/master/RTS_Data/SourceData) table data format

## Development

Contributions to the development and enahancement of PowerSystems is welcome. Please see
[CONTRIBUTING.md](https://github.com/NREL/PowerSystems.jl/blob/master/CONTRIBUTING.md) for
code contribution guidelines.

## License

PowerSystems is released under a BSD [license](https://github.com/NREL/PowerSystems.jl/blob/master/LICENSE).
PowerSystems has been developed as part of the Scalable Integrated Infrastructure Planning (SIIP)
initiative at the U.S. Department of Energy's National Renewable Energy Laboratory ([NREL](https://www.nrel.gov/))
