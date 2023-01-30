# [Type Structure](@id type_structure)

The abstract hierarchy enables categorization of the devices by their operational
characteristics and modeling requirements.

For instance, generation is classified by the distinctive
data requirements for modeling in three categories: [`ThermalGen`](@ref), [`RenewableGen`](@ref),
and [`HydroGen`](@ref).

As a result of this design, developers can define model logic entirely based on abstract
types and create generic code to support modeling technologies that are not yet
implemented in the package.

`PowerSystems.jl` has a category [`Topology`](@ref) of topological components
(e.g., [`ACBus`](@ref), [`Arc`](@ref)), separate from the physical components.

The hierarchy also includes components absent in standard data models, such as services.
The services category includes reserves, transfers and [`AGC`](@ref). The power of `PowerSystems.jl`
lies in providing the abstraction without an implicit mathematical representation of the component.

In [this tutorial](https://nbviewer.jupyter.org/github/NREL-SIIP/SIIPExamples.jl/blob/master/notebook/2_PowerSystems_examples/PowerSystems_intro.ipynb) you can find a more detailed introduction to the type system and how to manipulate data.

```@raw html
<img src="../../assets/AbstractTree.png" width="75%"/>
``` ⠀
