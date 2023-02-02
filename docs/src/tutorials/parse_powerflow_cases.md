# Parsing MATPOWER Files

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse MATPOWER and PSSe raw files and create a `System` using [PowerSystems.jl](github.com/NREL-SIIP/PowerSystems.jl)

### Create a `System` from a Matpower File

````@example parse_power_flow_cases
sys = System(joinpath(base_dir, "matpower", "case5_re.m"))
sys
````

### Create a `System` a PSS/e File

````@example parse_power_flow_cases
sys = System(joinpath(base_dir, "data", "psse_raw", "RTS-GMLC.RAW"));

sys
````

This data set does not contain any time series data. For this, check the next tutorial
