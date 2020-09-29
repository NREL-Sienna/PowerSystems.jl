# PowerSystems.jl

```@meta
CurrentModule = PowerSystems
```

**The Documentation is still under construction, some sections are unfinished. Please refer to the Model Library Section for the most up-to-date info**

`PowerSystems.jl` is a [`Julia`](http://www.julialang.org) package that provides a rigorous data model using Julia structures to enable power systems modeling.

`PowerSystems.jl` provides tools to prepare and process data useful for electric energy systems modeling. This package serves two purposes:

1. It facilitates the development and open sharing of large data sets for Power Systems modeling
2. It provides a data model that imposes discipline on model specification, addressing the challenge of design and terminology choices when sharing code and data.

The main features include:

- Extensive library of data structures for power systems modeling.
- Parsing capabilities from common data formats (PSS/e raw and dyr, Matpower and CSV)
- Network Matrices calculations
- Utilities for fast iterations of components to develop models

`PowerSystems.jl` documentation and code are organized according to the needs of different users depending on their skillset and requirements. In broad terms there are three categories:

- **Modeler**: Users that want to run a particular analysis or experiment and use `PowerSystems.jl` to develop data sets.

- **Model Developer**: Users that want to develop custom components and structs in order to exploit `PowerSystems.jl` features to produce custom data sets.

- **Advanced Developers**: Users that want to add new core functionalities or fix bugs in the core capabilties of `PowerSystems.jl`. This user should also check [`InfrastructureSystems.jl`](https://github.com/NREL-SIIP/InfrastructureSystems.jl).

`PowerSystems.jl` is an active project under development, and we welcome your feedback, suggestions, and bug reports.

Extended examples of use can be found in [SIIP-Examples PowerSystems](https://github.com/NREL-SIIP/SIIPExamples.jl/tree/master/notebook/PowerSystems_examples)

------------

## Contents

```@contents
Pages = [
    "user_guide/installation.md",
    "user_guide/type_structure.md",
    "modeler/parsing.md",
    "modeler/data.md"
]
Depth = 3
```

------------
PowerSystems has been developed as part of the Scalable Integrated Infrastructure Planning (SIIP) initiative at the U.S. Department of Energy's National Renewable Energy Laboratory ([NREL](https://www.nrel.gov/))
