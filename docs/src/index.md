# Welcome to PowerSystems.jl

```@meta
CurrentModule = PowerSystems
```

!!! tip "Announcement"
    PowerSystems.jl upgraded to version 4.0 in June 2024, which included breaking changes.
    Visit the [v4.0 migration guide](@ref psy4_migration) for information on
    how to update your existing code.

!!! warning "Under Construction"
    The PowerSystems.jl is being actively being rewritten for version 4.0 using the new
    format described in [How To Use This Documentation](@ref). Your patience is appreciated
    as we make this change! For now, some documentation is not located in its final home.
    Please reach out with questions and suggestions.

## About

`PowerSystems.jl` is part of the National Renewable Energy Laboratory's
[Sienna ecosystem](https://www.nrel.gov/analysis/sienna.html), an open source framework for
scheduling problems and dynamic simulations for power systems. The Sienna ecosystem can be
[found on github](https://github.com/NREL-Sienna/Sienna). It contains three applications:
- [Sienna\Data](https://github.com/NREL-Sienna/Sienna?tab=readme-ov-file#siennadata) enables
    efficient data input, analysis, and transformation
- [Sienna\Ops](https://github.com/NREL-Sienna/Sienna?tab=readme-ov-file#siennaops) enables
    enables system scheduling simulations by formulating and solving optimization problems
- [Sienna\Dyn](https://github.com/NREL-Sienna/Sienna?tab=readme-ov-file#siennadyn) enables
    system transient analysis including small signal stability and full system dynamic
    simulations

Each application uses multiple packages in the [`Julia`](http://www.julialang.org)
programming language.

`PowerSystems.jl` is the foundation of Sienna\Data, and it is used with all three
applications. It provides a rigorous
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

## How To Use This Documentation

There are five main sections containing different information:

- **Tutorials** - Detailed walk-throughs to help you *learn* how to use
    `PowerSystems.jl`
- **How to...** - Directions to help *guide* your work for a particular task
- **Explanation** - Additional details and background information to help you *understand*
    `PowerSystems.jl`, its structure, and how it works behind the scenes
- **Reference** - Technical references and API for a quick *look-up* during your work
- **Model Library** - Technical references of the data types and their functions that
    `PowerSystems.jl` uses to model power system components

`PowerSystems.jl` strives to follow the [Diataxis](https://diataxis.fr/) documentation
framework.

## Getting Started

If you are new to `PowerSystems.jl`, here's how we suggest getting started:
1. [Install](@ref install)
2. Work through the introductory tutorial: [Create and Explore a Power `System`](@ref) to
    familiarize yourself with how `PowerSystems.jl` works
3. Work through the other basic tutorials based on your interests
  - See [Working with Time Series Data](@ref tutorial_time_series) if you will be doing
      production cost modeling or working with time series
  - See [Creating a System with Dynamic devices](@ref) and the
      [tutorial in PowerSimulationsDynamics](https://nrel-sienna.github.io/PowerSimulationsDynamics.jl/stable/tutorials/tutorial_dynamic_data/)
      if you are interested in [dynamic](@ref D) simulations
4. Then, see the how-to's on parsing [Matpower](@ref pm_data) or [PSS/e files](@ref dyr_data) or
    [CSV files](@ref table_data) to begin loading your own data into `PowerSystems.jl`
