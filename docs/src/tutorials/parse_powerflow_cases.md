# Parsing MATPOWER Files

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse MATPOWER files and create a `System` using [PowerSystems.jl](github.com/NREL-SIIP/PowerSystems.jl)

### Dependencies

````@example 02_parse_matpower
using PowerSystems
using TimeSeries
````

### Fetch Data

PowerSystems.jl links to some test data that is suitable for this example.
Let's download the test data

### Create a `System`

````@example 02_parse_matpower
sys = System(joinpath(base_dir, "matpower", "case5_re.m"))
sys
````

# Parsing PSS/e `*.RAW` Files

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse PSS/e files and create a `System` using [PowerSystems.jl](github.com/NREL-SIIP/PowerSystems.jl)

### Dependencies

````@example 03_parse_psse
using PowerSystems
using TimeSeries
````

### Fetch Data

PowerSystems.jl links to some test data that is suitable for this example.
Let's download the test data



### Create a `System`

````@example 03_parse_psse
sys = System(joinpath(base_dir, "data", "psse_raw", "RTS-GMLC.RAW"));

sys
````
