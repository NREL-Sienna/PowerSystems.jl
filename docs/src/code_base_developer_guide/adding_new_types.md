# Adding PowerSystems Types

This page describes how developers should add types to `PowerSystems.jl` Refer to
the
[managing components guide](https://nrel-siip.github.io/InfrastructureSystems.jl/stable/dev_guide/components_and_container/)
first.

## Auto-generating Structs

Most PowerSystems structs are auto-generated from the JSON descriptor file
`src/descriptors/power_system_structs.json`. You can add your new struct
here or write it manually.

If all you need is the basic struct definition and getter/setter functions then
you will likely find the auto-generation helpful.

If you will need to write specialized functions for the type then you will
probably want to write it manually.

Refer to this
[link](https://nrel-siip.github.io/InfrastructureSystems.jl/stable/dev_guide/auto_generation/)
for more information.

### Testing a New Struct

It's likely that a new type will just work. Here's how you can test it:

```julia
using PowerSystems

# Assume a system is built and stored in the variable sys.
to_json(sys, "sys.json")

# Browse the JSON file to examine how PowerSystems stored your instance.
# This method requires installation of jq.
jq . sys.json | less

# Re-create the system and find your component.
sys2 = System("sys.json")
get_component(MyType, sys, "component_name")
```
