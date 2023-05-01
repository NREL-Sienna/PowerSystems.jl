# Creating a custom `Component`

## Type Hierarchy

All structs that correlate to power system components must be subtypes of the
[`Component`](@ref) abstract type. Browse its type hierachy to choose an appropriate
supertype for your new struct.

## Interfaces

Refer to the
[managing components guide](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/components_and_container/)
for component requirements.

**Note**: `get_internal`, `get_name`, and `get_time_series_container` are
imported into `PowerSystems`, so you should implement your methods as
`PowerSystems` methods.

Some abstract types define required interface functions in docstring. Be sure
to implement each of them for your new type.

Formalized documentation for each abstract type is TBD.

## Specialize an Existing Type

There are scenarios where you may want to make a new type that is identical to
an existing type except for one attribute or behavior, and don't want to
duplicate the entire existing type and methods. In programming languages that
support inheritance you would derive a new class from the existing class and
automatically inherit its fields and methods. Julia doesn't support that.
However, you can achieve a similar result with a forwarding macro.
The basic idea is that you include the existing type within your struct and
then use a macro to automatically forward specific methods to that instance.

A few PowerSystems structs use the macro `InfrastructureSystems.@forward` to
do this. Refer to the struct [`RoundRotorQuadratic`](@ref) for an example of how to
use this.

## Custom Rules

Some types require special checks before they can be added to or removed from a
system. One example is the case where a component includes another component
that is also stored in the system. We must ensure that the parent component
does not contain a reference to another component that is not already attached
to the system.

Similarly, if the child object is removed from the system we must also remove
the parent's reference to that child.

The source file `src/base.jl` provides functions that you can implement for
your new type to manage these scenarios.

- `check_component_addition(sys::System, component::Component; kwargs...)`
- `handle_component_addition!(sys::System, component::Component; kwargs...)`
- `check_component_removal(sys::System, component::Component; kwargs...)`
- `handle_component_removal!(sys::System, component::Component; kwargs...)`

The functions `add_component!()` and `remove_component!()` call the check
function before performing actions and then call the handle function
afterwards. The default behavior of these functions is to do nothing. Implement
versions that take your type in order to add your own checks or perform
additional actions.

Beware of the condition where a custom method is already implemented for a
supertype of your type.

Note that you can call the helper functions `is_attached(component, system)`
and `throw_if_not_attached(component, system)`.

### Custom Validation

You can implement three methods to perform custom validation or correction for your type.
PowerSystems calls all of these functions in `add_component!`.

- `sanitize_component!(component::Component, sys::System)`: intended to make standard data corrections (e.g. voltage angle in degrees -> radians)
- `validate_component(component::Component)`: intended to check component field values for internal consistency
- `validate_component_with_system(component::Component, sys::System)`: intended to check component field values for consistency with system

### Struct Requirements for Serialization of custom components

One key feature of `PowerSystems.jl` is the serialization capabilities. Supporting
serialization and de-serialization of custom components requires the implementation of
several methods. The serialization code converts structs to dictionaries where the struct
fields become dictionary keys.

The code imposes these requirements:

1. The InfrastructureSystems methods `serialize` and `deserialize` must be
   implemented for the struct. InfrastructureSystems implements a method that
   covers all subtypes of `InfrastructureSystemsType`. All PowerSystems
   components should be subtypes of `PowerSystems.Component` which is a subtype
   `InfrastructureSystemsType`, so any new structs should be covered as well.
2. All struct fields must be able to be encoded in JSON format or be covered be
   covered by `serialize` and `deserialize` methods. Basic types, such as
   numbers and strings or arrays and dictionaries of numbers and strings,
   should just work. Complex containers with symbols may not.
3. Structs relying on the default `deserialize` method must have a kwarg-only
   constructor. The deserialization code constructs objects by splatting the
   dictionary key/value pairs into the constructor.
4. Structs that contain other PowerSystem components (like a generator contains
   a bus) must serialize those components as UUIDs instead of actual values.
   The deserialization code uses the UUIDs as a mechanism to restore a
   reference to the actual object rather a new object with identical values. It
   also significantly reduces the size of the JSON file.

Refer to `InfrastructureSystems.serialize_struct` for example behavior. New
structs that are not subtypes of `InfrastructureSystemsType` may be able to
call it directly.

### Adding `PowerSystems.jl` as a dependency in a modeling package

```julia
module MyModelingModule

import PowerSystems
import InfrastructureSystems
const PSY = PowerSystems
const IS = InfrastructureSystems

export MyDevice
export get_name

mutable struct MyDevice <: PSY.Device
    name::String
    internal::IS.InfrastructureSystemsInternal
end

function MyDevice(name::String)
    return MyDevice(name, IS.InfrastructureSystemsInternal())
end

PSY.get_name(val::MyDevice) = val.name

end
```

### Auto-Generating Custom Structs
It is possible to use an advanced future to auto-generate structs in Julia source code files.
It is not mandatory to use these tools, but it can be useful if you need to generate multiple
custom structs for your model. Please refer to the docstrings for the functions `generate_struct`
and `generate_structs`. Full details are in the InfrastructureSystems documentation at
https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/auto_generation/
