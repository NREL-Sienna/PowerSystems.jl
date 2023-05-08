# PowerSystems.jl

[![Main - CI](https://github.com/NREL-Sienna/PowerSystems.jl/workflows/Main%20-%20CI/badge.svg)](https://github.com/NREL-Sienna/PowerSystems.jl/actions/workflows/main-tests.yml)
[![codecov](https://codecov.io/gh/NREL-Sienna/PowerSystems.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/NREL-Sienna/PowerSystems.jl)
[![Documentation Build](https://github.com/NREL-Sienna/PowerSystems.jl/workflows/Documentation/badge.svg?)](https://nrel-sienna.github.io/PowerSystems.jl/stable)
[![DOI](https://zenodo.org/badge/114039584.svg)](https://zenodo.org/badge/latestdoi/114039584)
[<img src="https://img.shields.io/badge/slack-@SIIP/PSY-blue.svg?logo=slack">](https://join.slack.com/t/nrel-sienna/shared_invite/zt-glam9vdu-o8A9TwZTZqqNTKHa7q3BpQ)
[![PowerSystems.jl Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/PowerSystems)](https://pkgs.genieframework.com?packages=PowerSystems)

The `PowerSystems.jl` package provides a rigorous data model using Julia structures to enable power systems analysis and modeling. In addition to stand-alone system analysis tools and data model building, the `PowerSystems.jl` package is used as the foundational data container for the [PowerSimulations.jl](https://github.com/NREL/PowerSimulations.jl) and [PowerSimulationsDynamics.jl](https://github.com/NREL-Sienna/PowerSimulationsDynamics.jl) packages. `PowerSystems.jl` supports a limited number of data file formats for parsing.

## Version Advisory

- PowerSystems will work with Julia v1.6+.
- If you are planning to use `PowerSystems.jl` in your package, check the [roadmap to version 3.0](https://github.com/NREL-Sienna/PowerSystems.jl/projects/3) for upcoming changes

## Device data enabled in PowerSystems

- Generators (Thermal, Renewable and Hydro)
- Transmission (Lines, and Transformers)
- Active Flow control devices (DC Lines and Phase Shifting Transformers)
- Topological elements (Buses, Arcs, Areas)
- Storage (Batteries)
- Load (Static, and Curtailable)
- Services (Reserves, Transfers)
- TimeSeries (Deterministic, Scenarios, Probabilistic)
- Dynamic Generators Models
- Dynamic Inverter Models

For a more exhaustive list check the [Documentation](https://nrel-sienna.github.io/PowerSystems.jl/stable).

## Parsing capabilities in PowerSystems

- MATPOWER CaseFormat
- PSS/e - PTI Format v30 and v33(.raw and .dyr files)
- [RTS-GMLC](https://github.com/GridMod/RTS-GMLC/tree/main/RTS_Data/SourceData) table data format

## Development

Contributions to the development and enhancement of PowerSystems is welcome. Please see
[CONTRIBUTING.md](https://github.com/NREL/PowerSystems.jl/blob/main/CONTRIBUTING.md) for
code contribution guidelines.

## Citing PowerSystems.jl

[Paper describing `PowerSystems.jl`](https://www.sciencedirect.com/science/article/pii/S2352711021000765)

```bibtex
@article{LARA2021100747,
title = {PowerSystems.jl — A power system data management package for large scale modeling},
journal = {SoftwareX},
volume = {15},
pages = {100747},
year = {2021},
issn = {2352-7110},
doi = {https://doi.org/10.1016/j.softx.2021.100747},
url = {https://www.sciencedirect.com/science/article/pii/S2352711021000765},
author = {José Daniel Lara and Clayton Barrows and Daniel Thom and Dheepak Krishnamurthy and Duncan Callaway},
keywords = {Power Systems, Julia, Energy},
```

## License

PowerSystems is released under a BSD [license](https://github.com/NREL/PowerSystems.jl/blob/main/LICENSE).
PowerSystems has been developed as part of the Scalable Integrated Infrastructure Planning (SIIP)
initiative at the U.S. Department of Energy's National Renewable Energy Laboratory ([NREL](https://www.nrel.gov/)).
