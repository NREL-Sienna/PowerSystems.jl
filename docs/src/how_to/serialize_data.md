# Serialize Data to a JSON

PowerSystems.jl supports serializing/deserializing data with JSON. This provides an example
of how to write and read a `System` to/from disk.

You can do this to save your own custom system, but we'll use an existing
dataset from
[`PowerSystemCaseBuilder.jl`](https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl),
simply to illustrate the process.

First, load the dependencies and a `System` from `PowerSystemCaseBuilder`:
```@repl serialize_data
using PowerSystems
using PowerSystemCaseBuilder
sys = build_system(PSISystems, "c_sys5_pjm")
```

## Write data to a JSON

Set up your target path, for example in a "mysystems" subfolder:
```@repl serialize_data
folder = mkdir("mysystems");
path = joinpath(folder, "system.json")
```

Now write the system to JSON:
```@repl serialize_data
to_json(sys, path)
```

## Read the JSON file and create a new `System`

Now, you can read the file back in, and verify the new system has the same data as above:
```@repl serialize_data
sys2 = System(path)
rm(folder, recursive=true); #hide
```
