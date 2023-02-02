# Serializing PowerSystem Data

## Introduction

PowerSystems.jl supports serializing/deserializing data with JSON. This notebook
provides an example of how to write and read a `System` to/from disk.

### Dependencies

Let's use a dataset from the [tabular data parsing example](https://nbviewer.jupyter.org/github/NREL-SIIP/SIIPExamples.jl/blob/master/notebook/2_PowerSystems_examples/parse_matpower.ipynb)

````@example 06_serialize_data
using SIIPExamples

pkgpath = pkgdir(SIIPExamples)
include(joinpath(pkgpath, "test", "2_PowerSystems_examples", "02_parse_matpower.jl"))
````

### Write data to a temporary directory

````@example 06_serialize_data
folder = mktempdir()
path = joinpath(folder, "system.json")
println("Serializing to $path")
to_json(sys, path)

filesize(path) / (1024 * 1024) #MiB
````

### Read the JSON file and create a new `System`

````@example 06_serialize_data
sys2 = System(path)
````
