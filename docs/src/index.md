# PowerSystems.jl

```@meta
CurrentModule = PowerSystems
```

`PowerSystems.jl` is a [`Julia`](http://www.julialang.org) package Power Systems Modeling that provides a rigorous data model using Julia structures to enable power systems analysis in addition to stand-alone system analysis tools and model building. Each device is defined using a Julia Structure embedded in a hierarchy for types. This enables categorization of the devices by their operational characteristics and the data required to model them.

The storage of power system data has traditionally been done with general use tables based on the power flow problem. However, tables are not inherently designed to store data with mixed data representations or hierarchal structures. This limitation was addressed in the early 1990's with the advent of automation, spurred by increasingly complex data needs for power systems operations. The industry required standardized models to exchange larger and more complex sets of information, and so resorted to an object-oriented data model. The CIM was developed and later made a standard maintained by the IEC - Technical Committee 57 Working Group 13. The aim was to provide a standard definition for power system components that could be used in automated EMS and asset-management databases.

From the computer engineering point-of-view, using tables would require to re-write a lot of code. In most languages with strongly type hierarchies, using a tree structure it is advantageous. This is particularly relevant for code re-use and data encapsulation. Collecting all potential devices is not possible; neither is it desirable. However, it is necessary to have the capability to extend the data model such that different user can store their data in an organized ontology.

For instance, take the data hierarchy for thermal generation devices shown in Fig. \ref{fig:PS_thermal}. Generation is classified by the distinctive operational characteristics of the generators and then further categorized by the data required to model a specific technology.

For more detailed documentation of each object in the library, see the API/[PowerSystems](@ref) page.

## Installation

The latest stable release of PowerModels can be installed using the Julia package manager with

```julia
] add PowerSystems
```

For the current development version, "checkout" this package with

```julia
] add PowerSystems#master
```
