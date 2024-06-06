# Add a New Type

This page describes how developers should add types to `PowerSystems.jl` Refer to
the
[managing components guide](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/components_and_container/)
first.

## [Auto-generating Structs](@id autogen)

Most `PowerSystems.jl` structs are auto-generated from the JSON descriptor file
`src/descriptors/power_system_structs.json`. You can add your new struct
here or write it manually when contributing code to the repository

If all you need is the basic struct definition and getter/setter functions then
you will likely find the auto-generation helpful.

If you will need to write specialized functions for the type then you will
probably want to write it manually.

Refer to this
[link](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/auto_generation/)
for more information.

### Testing the addition of new struct to the code base

In order to merge new structs to the code base, your struct needs to pass several tests.

1. addition to `System`
2. retrieval from `System`
3. serialization/de-serialization

The following code block is an example of the code that the new struct needs to pass

```julia
using PowerSystems

sys = System(100.0)
device = NewType(data)

# add your component to the system
add_component!(sys, device)
retrived_device = get_component(NewType, sys, "component_name")

# Serialize
to_json(sys, "sys.json")

# Re-create the system and find your component.
sys2 = System("sys.json")
serialized_device = get_component(NewType, sys, "component_name")

@test get_name(retrieved_device) == get_name(serialized_device)
```
