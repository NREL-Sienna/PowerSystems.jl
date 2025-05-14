# [Supplemental Attributes](@id supplemental_attributes)

While the `ext` field is a mechanism for adding arbitrary metadata. PowerSystems.jl, has moved towards a more structured and formalized way of handling supplemental data using [`SupplementalAttribute`](@extref) structs. This is designed to store metadata in a more organized fashion than a generic dictionary. These attributes are intended to be attached to a [`Component`](@ref) types.

## Existing Supplemental Attributes in PowerSystems

### Outages

[`FixedForcedOutage`](@ref)
[`GeometricDistributionForcedOutage`](@ref)

### Other Attributes

[`GeographicInfo`](@ref)
[`ImpedanceCorrectionData`](@ref)
