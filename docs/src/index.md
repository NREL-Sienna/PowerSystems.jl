# PowerSystems.jl

```@meta
CurrentModule = PowerSystems
```

!!! tip "Announcement"
    PowerSystems.jl upgraded to version 4.0 in June 2024, which included breaking changes.
    Visit the [v4.0 migration guide](@ref psy4_migration) for information on
    how to update your existing code.

## Overview

`PowerSystems.jl` is a [`Julia`](http://www.julialang.org) package that provides a rigorous
data model using Julia structures to enable power systems modeling. `PowerSystems.jl` is
agnostic to a specific mathematical model and can be used for many model categories.

`PowerSystems.jl` provides tools to prepare and process data useful
for electric energy systems modeling. This package serves two purposes:

1. It facilitates the development and open sharing of large data sets for Power Systems modeling
2. It provides a data model that imposes discipline on model specification, addressing the challenge of design and terminology choices when sharing code and data.

The main features include:

- Comprehensive and extensible library of data structures for electric systems modeling.
- Large scale data set development tools based on common text based data formats
  (PSS/e `.raw` and `.dyr`, and `MATPOWER`) and configurable tabular data (e.g. CSV)
  parsing capabilities.
- Optimized container for component data and time series supporting serialization to
  portable file formats and configurable validation routines.

`PowerSystems.jl` documentation and code are organized according to the needs of different
users depending on their skillset and requirements. In broad terms there are three categories:

- **Modeler**: Users that want to run a particular analysis or experiment and use `PowerSystems.jl` to develop data sets.

- **Model Developer**: Users that want to develop custom components and structs in order to exploit `PowerSystems.jl` features to produce custom data sets.

- **Code Base Developers**: Users that want to add new core functionalities or fix bugs in the core capabilities of `PowerSystems.jl`.

`PowerSystems.jl` is an active project under development, and we welcome your feedback,
suggestions, and bug reports.

**Note**: `PowerSystems.jl` uses [`InfrastructureSystems.jl`](https://github.com/NREL-Sienna/InfrastructureSystems.jl)
as a utility library. Several methods are re-exported from `InfrastructureSystems.jl`.
For most users there is no need to import `InfrastructureSystems.jl`.

## Installation

The latest stable release of PowerSystems can be installed using the Julia package manager with

```julia
] add PowerSystems
```

For the current development version, "checkout" this package with

```julia
] add PowerSystems#main
```

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

------------
PowerSystems has been developed as part of the Scalable Integrated Infrastructure Planning
(SIIP) initiative at the U.S. Department of Energy's National Renewable Energy
Laboratory ([NREL](https://www.nrel.gov/)).
