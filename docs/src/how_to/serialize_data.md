# Serialize Data to a JSON

PowerSystems.jl supports serializing/deserializing data with JSON. This provides an example of how to write and read a `System` to/from disk.

## Dependencies

Let's use a dataset from the tabular data parsing tutorial:

```@repl serialize_data
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data"); #hide 
sys = System(joinpath(file_dir, "case5_re.m"))
```

## Write data to a temporary directory

```@repl serialize_data
folder = mktempdir();
path = joinpath(folder, "system.json")
println("Serializing to $path")
to_json(sys, path)
```

## Read the JSON file and create a new `System`

```@repl serialize_data
sys2 = System(path)
```

## How to trouble-shoot serialization issues

If this doesn't work then you likely need to implement custom
`InfrastructureSystems.serialize` and `InfrastructureSystems.deserialize` methods
for your type.  Here are some examples of potential problems and solutions:

**Problem**: Your struct contains a field defined as an abstract type. The
deserialization process doesn't know what concrete type to construct.

*Solution*: Encode the concrete type into the serialized dictionary as a string.

*Example*:  `serialize` and `deserialize` methods for `DynamicBranch` in
`src/models/dynamic_branch.jl`.

**Problem**: Similar to above in that a field is defined as an abstract type
but the struct is parameterized on the actual concrete type.

*Solution*: Use the fact that the concrete type is encoded into the serialized
type of the struct and extract it in a customized `deserialze` method.

*Example*: `deserialize` method for `OuterControl` in
`src/models/OuterControl.jl`.
