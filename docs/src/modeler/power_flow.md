```@meta
EditURL = "<unknown>/docs/src/modeler/power_flow.jl"
```

```@meta
CurrentModule = PowerSystems
```

# Power Flow

`PowerSystems.jl` provides the capability to run a power flow with the intention of providing a valid initial AC operating point to the system. It is not meant as an analytics tool, the main isue is determine if the system has feasible AC data.

The power flow solver uses [NLsolve.jl](https://github.com/JuliaNLSolvers/NLsolve.jl) under the hood and takes any keyword argument accepted by NLsolve

```@example power_flow
using PowerSystems
```

```@docs
solve_powerflow
solve_powerflow!
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

