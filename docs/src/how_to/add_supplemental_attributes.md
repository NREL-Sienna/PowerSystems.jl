# [Attach supplemental data to components](@id attach_contextual_data)

This how-to shows how to attach supplemental attributes to components in a [`System`](@ref).
It uses [`FixedForcedOutage`](@ref) as the example. For background on why contextual data
is kept separate from components, see [Supplemental attributes](@ref supplemental_attributes_explanation).

## Prerequisites

```@example attach_contextual_data
using PowerSystems
using PowerSystemCaseBuilder

sys = build_system(PSISystems, "c_sys5_pjm")
```

## Attach a single attribute

Retrieve the target component, construct the attribute, then attach it with
[`add_supplemental_attribute!`](@ref):

```@example attach_contextual_data
gen = first(get_components(ThermalStandard, sys))
outage = FixedForcedOutage(; outage_status = 0.0)  # 0.0 = available, 1.0 = outaged
add_supplemental_attribute!(sys, gen, outage)
```

## Attach attributes in bulk and share them across components

For adding many attributes at once, use [`begin_supplemental_attributes_update`](@ref)
to batch the operations. This reduces index update overhead and automatically reverts
all changes if an error occurs. The same attribute instance can be attached to more than
one component to model shared properties:

```@example attach_contextual_data
gens = collect(get_components(ThermalStandard, sys))
gen1 = gens[1]
gen2 = gens[2]
shared_outage = FixedForcedOutage(; outage_status = 1.0)

begin_supplemental_attributes_update(sys) do
    add_supplemental_attribute!(sys, gen1, shared_outage)
    add_supplemental_attribute!(sys, gen2, shared_outage)
end
```

## Next steps

  - [Query contextual data on a system](@ref query_contextual_data) — retrieve attributes you have attached
  - [Group generators into plants](@ref group_generators_into_plants) — plant-level grouping
  - [Model Outages](@ref model_outages) — outage-specific workflows
  - [Add emissions to generators](@ref add_emissions_to_generators) — emissions metadata
