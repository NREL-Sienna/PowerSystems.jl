# Troubleshooting code development

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
