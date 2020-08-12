# PowerSystems.jl

```@meta
CurrentModule = PowerSystems
```

`PowerSystems.jl` is a [`Julia`](http://www.julialang.org) package that provides a rigorous data model using Julia structures to enable power systems modeling.

`PowerSystems.jl` provides tools to prepares and processes data useful for electric energy systems modelling. This package serves two purposes:

1. It facilitates the development and open sharing of custom datasets between users and computer systems.
2. It provides a data model that imposes discipline on model specification, addressing the challenge of design and terminology choices when sharing code and data.

The main features include:

- Extensive library of data structures for power systems modeling.
- Parsing capabilities from common data formats (PSS/e raw and dyr, Matpower and CSV)
- Network Matrices calculations
- Utilities for fast iterations of components to develop models


`PowerSystems.jl` documentation and code are organized according to the needs of different users depending on their skillset and requirements. In broad terms there are three categories:

- **Modeler**: Users that want to use `PowerSystems.jl` to develop a new data set for a particular analysis or experiment.

- **Model Deverloper**: Users that wants to develop custom device and components and structs and exploit `PowerSystems.jl` features to produce custom data sets.

- **Advanced Developers**: Users that want to add new core functionalities or fix bugs in the core capabilties of `PowerSystems.jl`. This user should also check [`InfrastructureSystems.jl`](https://github.com/NREL-SIIP/InfrastructureSystems.jl).

`PowerSystems.jl` in an active project under development, and we welcome your feedback, suggestions, and bug reports.

Extended examples of use can be found in [SIIP-Examples PowerSystems](https://github.com/NREL-SIIP/SIIPExamples.jl/tree/master/notebook/PowerSystems_examples)

For more detailed documentation of each object in the library, see the API/[PowerSystems](@ref) page.

## Contents

```@contents
Pages = [
    "user_guide/installation.md",
    "user_guide/type_structure.md"
    "modeler/parsing.md",
    "modeler/data.md"
]
Depth = 3
```
