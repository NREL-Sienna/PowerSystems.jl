# Serializing PowerSystem Data

**Originally Contributed by**: Clayton Barrows

## Introduction

PowerSystems.jl supports serializing/deserializing data with JSON. This provides an example of how to write and read a `System` to/from disk.

## Dependencies

Let's use a dataset from the tabular data parsing tutorial:

```@repl serialize_data
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "test_data")
sys = System(joinpath(file_dir, "case5_re.m"))
```

## Write data to a temporary directory

```@repl serialize_data
folder = mktempdir()
path = joinpath(folder, "system.json")
println("Serializing to $path")
to_json(sys, path)
```

## Read the JSON file and create a new `System`

```@repl serialize_data
sys2 = System(path)
```
