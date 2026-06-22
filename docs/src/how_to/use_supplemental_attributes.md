# [Query contextual data on a system](@id query_contextual_data)

This how-to assumes you have a [`System`](@ref) with at least one [`FixedForcedOutage`](@ref)
attached to a component. See [Attach supplemental data to components](@ref attach_contextual_data)
if you need to set that up first.

## Prerequisites

```@example query_contextual_data
using PowerSystems
using PowerSystemCaseBuilder

sys = build_system(PSISystems, "c_sys5_pjm")
gen = first(get_components(ThermalStandard, sys))
outage = FixedForcedOutage(; outage_status = 0.0)
add_supplemental_attribute!(sys, gen, outage)
```

## Get the attributes in a system

Use [`get_supplemental_attributes`](@ref) with a supplemental attribute type to retrieve all
matching attributes from a system:

```@example query_contextual_data
for outage in get_supplemental_attributes(FixedForcedOutage, sys)
    @show summary(outage)
end
```

The output includes the attribute type name and its [UUID](@ref U) — a unique identifier
automatically assigned when the attribute was created.

## Get the attributes associated with a component

Use [`get_supplemental_attributes`](@ref) with a component instead of a system to retrieve
only the attributes attached to that component:

```@example query_contextual_data
gen1 = first(get_components(ThermalStandard, sys))
for outage in get_supplemental_attributes(FixedForcedOutage, gen1)
    @show summary(outage)
end
```

The output includes the attribute type name and its [UUID](@ref U). You can also pass a
filter function as the first argument — for example,
`x -> PowerSystems.get_outage_status(x) >= 0.5` — to narrow results by field values.

## Get the components associated with an attribute

Use [`get_associated_components`](@ref) to retrieve the components attached to a single
supplemental attribute:

```@example query_contextual_data
outage = first(get_supplemental_attributes(FixedForcedOutage, sys))
for component in get_associated_components(sys, outage)
    @show summary(component)
end
```

The output is a summary of each associated component's type and name. You can also pass a
`component_type` keyword argument (e.g., `component_type = ThermalStandard`) to filter
results to a specific component type.

## Get component / attribute pairs

Use [`get_component_supplemental_attribute_pairs`](@ref) to retrieve component/attribute pairs
by type. Prefer this over nested loops iterating over components and their attributes separately:

```@example query_contextual_data
for (gen, outage) in get_component_supplemental_attribute_pairs(
    ThermalStandard,
    FixedForcedOutage,
    sys,
)
    @show summary(gen) summary(outage)
end
```

The output is a summary of each generator and its associated [`FixedForcedOutage`](@ref).

## See also

  - [Supplemental attributes](@ref supplemental_attributes_explanation) — why contextual data is separate from components
  - [Attach supplemental data to components](@ref attach_contextual_data) — attaching attributes
