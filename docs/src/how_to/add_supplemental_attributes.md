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

## Attach attributes in bulk

For adding many attributes at once, use [`begin_supplemental_attributes_update`](@ref)
to batch the operations. This reduces index update overhead and automatically reverts
all changes if an error occurs:

```@example attach_contextual_data
gens = collect(get_components(ThermalStandard, sys))
gen1 = gens[1]
gen2 = gens[2]
outage1 = FixedForcedOutage(; outage_status = 0.0)
outage2 = FixedForcedOutage(; outage_status = 1.0)

begin_supplemental_attributes_update(sys) do
    add_supplemental_attribute!(sys, gen1, outage1)
    add_supplemental_attribute!(sys, gen2, outage2)
end
```

## Share one attribute across multiple components

Attach the same attribute instance to more than one component to model shared properties:

```@example attach_contextual_data
outage = FixedForcedOutage(; outage_status = 1.0)
gens = collect(get_components(ThermalStandard, sys))
gen1 = gens[1]
gen2 = gens[2]

begin_supplemental_attributes_update(sys) do
    add_supplemental_attribute!(sys, gen1, outage)
    add_supplemental_attribute!(sys, gen2, outage)
end
```

## Next steps

  - [Query contextual data on a system](@ref query_contextual_data) — retrieve attributes you have attached
  - [Group generators into plants](@ref group_generators_into_plants) — plant-level grouping
  - [Model generator outages](@ref model_generator_outages) — outage-specific workflows
  - [Add emissions to generators](@ref add_emissions_to_generators) — emissions metadata
