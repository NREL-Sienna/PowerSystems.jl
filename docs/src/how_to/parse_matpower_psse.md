# [Parsing MATPOWER or PSS/e Files](@id pm_data)

The following code will create a System from a MATPOWER .m or PSS/e .raw file:

```@repl m_system
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data")
sys = System(joinpath(file_dir, "case5.m"))
```

Originally, the parsing code was copied with permission from
[`PowerModels.jl`](https://github.com/lanl-ansi/PowerModels.jl) but over the years the code base
has had some divergence due to the need to adapt it to for large industrial cases.

The PSSe parser tries to handle correctly all the gotchas that result from the diverse modeling practices transmission engineers employ. However, it is impossible to anticipate all possible variations.

PowerSystems.jl parsing code has been tested and developed using large cases from North America
like the Western Electricity Coordinating Council (WECC) planning case and the Multiregional Modeling Working Group (MMWG) base case models. This parser has also been adapted to load cases in Latin America and the Caribbean and as many of the open data sets available only.

## [Conventions when parsing MATPOWER or PSS/e Files](@id parse_conventions)

!!! Info
    
    In PowerSystems v5, the parsing conventions changed from those in PowerSystems v4. You might experience different behaviors when loading MATPOWER or PSS/e Files.

PowerSystems.jl utilizes a data model that bridges the gap between operational simulations, such as Production Cost Analysis, and electrical engineering simulations, including power flows. Given the different practices in these domains, there are several discrepancies in how to handle data and we have made changes to make the modeling compatible.

In PowerSystems v5, we have implemented the followinf conventions for parsing PSSe files:

  - **BusType correction**: If a bus has a value set to ISOLATED in PSSe, we will confirm that the bus is not entirely disconnected from the network. If the bus is disconnected, it will be set to ISOLATED and set the field available to false. However, if the bus is connected to a generator, we will infer a bus of type PV and set the field 'available' to false. This correction also applies to Matpower. For any other device connected to the bus, we will set it to PQ and set the 'available' field to false. Check [`Understanding ACBusTypes`](@ref bustyped) for a detailed explanation.
  - **Parsing Synchronous Condensers**: If a generator is connected to a PV Bus with activer power set to 0.0, it will be parsed as a [`SynchronousCondenser`](@ref). This prevents for generators to be modeled as dispatchable [`ThermalStandard`](@ref) when it doesn't apply.
  - **Reading and Storing Transformer Data**: The transformer data is always stored in the devices
    ' base. See [`Transformer per unit transformations`](@ref transformers_pu) for additional details.
  - **Tap transformer settings automated fix**: When the tap values in the RAW file are not withing the ranges defined in the same entry, PSSe performs a correction to the data. However, this correction isn't stored back in the file. PowerSystems.jl will correct the tap setting and change the field in the transformer struct.
  - **Reading and Storing Multi-Section Line Data**: PowerSystems.jl does not have a explicit multi-section line object. These devices are parsed as individual lines and the "dummy buses" are added to the system. The additional data is stored in the [`Line`](@ref) `ext` field. Further network reductions are performed using PowerNetworkMatrices.jl
  - **Reading GeographicInformation data from substations (PSSe v35 only)**: If the file contains a substation section. The coordinates will be automatically loaded as a [`GeographicInformation`](@ref) attribute and assigned to the relevant buses.
  - **Use [`InterruptibleStandardLoad`](@ref) (PSSe v35 only)**: In newer versions of PSSe there is a flag for interruptible. Since PowerSystems.jl already has structures to model controllable load like [`InterruptiblePowerLoad`](@ref) and [`ShiftablePowerLoad`](@ref) a new type is used when parsing from PSSe to account of the interruptible behavior in economic modeling.
  - **Treatment of conforming and non-conforming flags**: See the section [`Conforming and Non-Conforming Loads`](@ref conf_loads). PowerSystems.jl uses an enum to represent this data but it does not implement specific models for this behavior.
  - **Breakers and Switches**: From the perspective of PowerSystems.jl breakers and switches are modeled as [`DiscreteControlledACBranch`](@ref). We use an enum to separate between the two but from the data structure perspective both use the same object definition.

### Pending parsing challenges

  - Detecting generation modeled as negative loads
  - Detecting motor loads modeled as generators
  - Parsing outage data

### See also:

  - Parsing [PSS/e .dyr Files](@ref dyr_data), which also includes an example of parsing a
    .raw file
  - Parsing [table data (CSV Files)](@ref table_data)
  - Parsing [time series](@ref parsing_time_series)
