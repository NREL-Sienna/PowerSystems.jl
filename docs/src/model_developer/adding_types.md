# Adding PowerSystems Types

This page describes how developers should add types to PowerSystems. Refer to
this
[guide](https://nrel-siip.github.io/InfrastructureSystems.jl/latest/man/guide/#Component-structs)
first.

## Type Hierarchy
All structs that correlate to power system components must be subtypes of the
`Component` abstract type. Browse its type hierachy to choose an appropriate
supertype for your new struct.

## Auto-generating Structs
Most PowerSystems structs are auto-generated from the JSON descriptor file
`src/descriptors/power_system_structs.json`. You can add your new struct
here or write it manually.

If all you need is the basic struct definition and getter/setter functions then
you will likely find the auto-generation helpful.

If you will need to write specialized functions for the type then you will
probably want to write it manually.

Refer to this
[link](https://nrel-siip.github.io/InfrastructureSystems.jl/latest/man/guide/#Auto-Generation-of-component-structs)
for more information.

## Interfaces
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
do this. Refer to the struct `RoundRotorQuadratic` for an example of how to
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

## JSON Serialization
PowerSystems provides functionality to serialize an entire system to a JSON
file and then deserialize it back to a system. The main benefit is that
deserializing is significantly faster than reconstructing the system from raw
data files.

### Struct Requirements for Serialization
The serialization code converts structs to dictionaries where the struct fields
become dictionary keys. The code imposes these requirements:

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

### Testing a New Struct
It's likely that a new type will just work. Here's how you can test it:

```Julia
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

### Handling Problems
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
