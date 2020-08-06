# Adding PowerSystems Types

This page describes how developers should add types to PowerSystems. Refer to
this
[guide](https://nrel-siip.github.io/InfrastructureSystems.jl/latest/man/guide/#Component-structs)
first.

## Type Hierarchy
All structs that correlate to power system components must be subtypes of the
``Component`` abstract type. Browse its type hierachy to choose an appropriate
supertype for your new struct.

## Auto-generating Structs
Most PowerSystems structs are auto-generated from the JSON descriptor file
``src/descriptors/power_system_structs.json``. You can add your new struct
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

A few PowerSystems structs use the macro ``InfrastructureSystems.@forward`` to
do this. Refer to the struct ``RoundRotorQuadratic`` for an example of how to
use this.

## Custom Rules
Some types require special checks before they can be added to or removed from a
system. One example is the case where a component includes another component
that is also stored in the system. We must ensure that the parent component
does not contain a reference to another component that is not already attached
to the system.

Similarly, if the child object is removed from the system we must also remove
the parent's reference to that child.

The source file ``src/base.jl`` provides functions that you can implement for
your new type to manage these scenarios.

- ``check_component_addition(sys::System, component::Component)``
- ``handle_component_addition!(sys::System, component::Component)``
- ``check_component_removal(sys::System, component::Component)``
- ``handle_component_removal!(sys::System, component::Component)``

The functions ``add_component!()`` and ``remove_component!()`` call the check
function before performing actions and then call the handle function
afterwards. The default behavior of these functions is to do nothing. Implement
versions that take your type in order to add your own checks or perform
additional actions.

Beware of the condition where a custom method is already implemented for a
supertype of your type.

Note that you can call the helper functions ``is_attached(component, system)``
and ``throw_if_not_attached(component, system)``.

## JSON Serialization
PowerSystems provides functionality to serialize an entire system to a JSON
file and then deserialize it back to a system. The main benefit is that
deserializing is significantly faster than reconstructing the system from raw
data files.

For most structs with basic types (numbers, strings, arrays and dictionaries of
numbers and strings) the library used by PowerSystems can convert structs
between Julia and JSON with no work required by the user.

In cases where a struct contains another PowerSystems component that is also
stored in the system, extra work is required.  There are two reasons for this:

1. We don't want to duplicate JSON representations of the same component.
2. The deserialization process needs to ensure that the parent component has a
   reference to the child component. It should not contain a different instance
   that is equivalent in content.

To accomplish these goals PowerSystems stores the child component's UUID in the
JSON object instead of its value. The deserialization process ensures that the
child is deserialized first. When it deserializes the parent it looks up the
child's UUID in a dictionary and stores a reference to the value.

PowerSystems implements this logic for many abstract types. For example, all
subtypes of ``Device`` contain a ``Bus``, and so PowerSystems solves this
problem for all devices in one place.

It's likely that your new type will ``just work``. Here's how you can test it:

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

If this doesn't work then we recommend you submit an issue on GitHub so that we
can consult with you on the best way to solve the problem.
