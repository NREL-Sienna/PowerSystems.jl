# [Group generators into plants](@id group_generators_into_plants)

This how-to shows how to group generator units into plant structures. For background on
when plant-level aggregation matters, see [Grouping generators into plants](@ref grouping_generators_into_plants).

## Prerequisites

```@example group_generators_into_plants
using PowerSystems
using PowerSystemCaseBuilder

sys = build_system(PSISystems, "c_sys5_pjm")
```

## Group thermal units by shaft

Create a [`ThermalPowerPlant`](@ref), then attach generators with a `shaft_number` keyword.
Units on the same shaft share mechanical coupling:

```@example group_generators_into_plants
gens = collect(get_components(ThermalStandard, sys))
gen1, gen2, gen3 = gens[1], gens[2], gens[3]

plant = ThermalPowerPlant(; name = "Coal Plant Alpha")

add_supplemental_attribute!(sys, gen1, plant; shaft_number = 1)
add_supplemental_attribute!(sys, gen2, plant; shaft_number = 1)
add_supplemental_attribute!(sys, gen3, plant; shaft_number = 2)
```

Query units on a specific shaft with [`get_components_in_shaft`](@ref):

```@example group_generators_into_plants
shaft_1_gens = get_components_in_shaft(sys, plant, 1)
length(shaft_1_gens)
```

## Group hydro units by penstock

[`HydroPowerPlant`](@ref) uses a positional `penstock_number` argument (not a keyword).
Only [`HydroTurbine`](@ref) and [`HydroPumpTurbine`](@ref) components are supported.
Create the plant with [`HydroPowerPlant`](@ref), attach turbines with
`add_supplemental_attribute!(sys, turbine, hydro_plant, penstock_number)`, and query with
[`get_components_in_penstock`](@ref).

Penstock grouping is separate from linking [`HydroReservoir`](@ref) components to turbines;
see [Link hydro reservoirs to turbines](@ref hydro_resv).

## Group renewable units by PCC

[`RenewablePowerPlant`](@ref) uses a positional `pcc_number` argument. Supported components
are [`RenewableGen`](@ref) and [`EnergyReservoirStorage`](@ref). Attach with
`add_supplemental_attribute!(sys, component, renewable_plant, pcc_number)` and query with
[`get_components_in_pcc`](@ref).

## Group combined cycle units

For block-level combined cycle modeling, use [`CombinedCycleBlock`](@ref) with the
`hrsg_number` keyword. Only generators with `CT` or `CA` [`PrimeMovers`](@ref) are allowed:

```@example group_generators_into_plants
cc_block = CombinedCycleBlock(;
    name = "CC Unit 1",
    configuration = CombinedCycleConfiguration.DoubleCombustionOneSteam,
)
get_name(cc_block)
```

For mutually exclusive operating modes, use [`CombinedCycleFractional`](@ref) with the
`exclusion_group` keyword. Only generators with the `CC` prime mover type are allowed.
Attach CT/CA or CC units to the block or fractional plant once those generators are in
your [`System`](@ref); see the [Public API Reference](@ref) for constructor and accessor details.

## Query and remove associations

Retrieve all units in a plant with [`get_associated_components`](@ref):

```@example group_generators_into_plants
all_gens = collect(get_associated_components(sys, plant; component_type = ThermalGen))
total_capacity = sum(get_active_power_limits(g).max for g in all_gens)
total_capacity
```

Remove a unit from a plant without deleting either object:

```@example group_generators_into_plants
remove_supplemental_attribute!(sys, gen1, plant)
```

## See also

  - [Grouping generators into plants](@ref grouping_generators_into_plants) — when and why to use plant attributes
  - [Link hydro reservoirs to turbines](@ref hydro_resv) — reservoir ↔ turbine topology
  - [Attach supplemental data to components](@ref attach_contextual_data) — general attachment pattern
