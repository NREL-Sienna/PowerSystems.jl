# Parsing MATPOWER Files

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse MATPOWER and PSSe raw files and create a `System` using [PowerSystems.jl](https://github.com/NREL-Sienna/PowerSystems.jl)

### Create a `System` from a Matpower File

```@repl parse_power_flow_cases
# Load directory
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "test_data")
sys = System(joinpath(file_dir, "case5_re.m"))
```

### Create a `System` a PSS/e File

```@repl parse_power_flow_cases
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "test_data")
sys = System(joinpath(file_dir, "RTS-GMLC.RAW"))
```

This data set does not contain any time series data. For this, check the next tutorial
