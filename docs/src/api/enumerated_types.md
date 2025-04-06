# Specifying the type of...

Some fields in PowerSystems.jl are specified with an option from a pre-defined list
(Specified with [`IS.scoped_enums`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.@scoped_enum-Tuple%7BAny,%20Vararg%7BAny,%20N%7D%20where%20N%7D)).

Example syntax:

```
set_fuel!(gen, ThermalFuels.COAL)
```

These predefined lists are below:

## [AC Buses](@id acbustypes_list)

`ACBusTypes` categorize buses for modeling activities and denote which quantities are specified
for load flow calculations. `ACBusTypes` has the options:

| Name       | Description                                                |
|:---------- |:---------------------------------------------------------- |
| `ISOLATED` | Disconnected from network                                  |
| `PQ`       | Active and reactive power defined (load bus)               |
| `PV`       | Active power and voltage magnitude defined (generator bus) |
| `REF`      | Reference bus (θ = 0)                                      |
| `SLACK`    | Slack bus                                                  |

## [Prime Movers](@id pm_list)

Each generator contains a field for `prime_mover::PrimeMovers`, based on the options in
[EIA form 923](https://www.eia.gov/survey/form/eia_923/instructions.pdf).
`PrimeMovers` has the options:

| Name  | Description                                                                                            |
|:----- |:------------------------------------------------------------------------------------------------------ |
| `BA`  | Energy Storage, Battery                                                                                |
| `BT`  | Turbines Used in a Binary Cycle (including those used for geothermal applications)                     |
| `CA`  | Combined-Cycle – Steam Part                                                                            |
| `CC`  | Combined-Cycle - Aggregated Plant *augmentation of EIA                                                 |
| `CE`  | Energy Storage, Compressed Air                                                                         |
| `CP`  | Energy Storage, Concentrated Solar Power                                                               |
| `CS`  | Combined-Cycle Single-Shaft Combustion turbine and steam turbine share a single generator              |
| `CT`  | Combined-Cycle Combustion Turbine Part                                                                 |
| `ES`  | Energy Storage, Other                                                                                  |
| `FC`  | Fuel Cell                                                                                              |
| `FW`  | Energy Storage, Flywheel                                                                               |
| `GT`  | Combustion (Gas) Turbine (including jet engine design)                                                 |
| `HA`  | Hydrokinetic, Axial Flow Turbine                                                                       |
| `HB`  | Hydrokinetic, Wave Buoy                                                                                |
| `HK`  | Hydrokinetic, Other                                                                                    |
| `HY`  | Hydraulic Turbine (including turbines associated with delivery of water by pipeline)                   |
| `IC`  | Internal Combustion (diesel, piston, reciprocating) Engine                                             |
| `PS`  | Energy Storage, Reversible Hydraulic Turbine (Pumped Storage)                                          |
| `OT`  | Other                                                                                                  |
| `ST`  | Steam Turbine (including nuclear, geothermal and solar steam; does not include combined-cycle turbine) |
| `PVe` | Photovoltaic \(*Note*: renaming from EIA PV to PVe to avoid conflict with `ACBusType.PV`\)             |
| `WT`  | Wind Turbine, Onshore                                                                                  |
| `WS`  | Wind Turbine, Offshore                                                                                 |

## [Fuels for Thermal Generators](@id tf_list)

Each [`ThermalGen`](@ref) generator has a field for `fuel::ThermalFuels` where `ThermalFuels`
are intended to reflect the options in the
[Aggregated Fuel Codes](https://www.eia.gov/survey/form/eia_923/instructions.pdf) from the
EIA Annual Energy Review. `ThermalFuels` has the options:

| Name                           | EIA Fuel Code | Description                                                                                                                         |
|:------------------------------ |:------------- |:----------------------------------------------------------------------------------------------------------------------------------- |
| `ANTHRACITE_COAL`              | ANT           | Anthracite Coal                                                                                                                     |
| `BITUMINOUS_COAL`              | BIT           | Bituminous Coal                                                                                                                     |
| `LIGNITE_COAL`                 | LIG           | Lignite Coal                                                                                                                        |
| `SUBBITUMINOUS_COAL`           | SUB           | Subbituminous Coal                                                                                                                  |
| `WASTE_COAL`                   | WC            | Waste/Other Coal (including anthracite culm, bituminous gob, fine coal, lignite waste, waste coal)                                  |
| `REFINED_COAL`                 | RC            | Refined Coal (A coal product that improves heat content and reduces emissions. Excludes coal processed by coal preparation plants.) |
| `SYNTHESIS_GAS_COAL`           | SGC           | Coal-Derived Synthesis Gas                                                                                                          |
| `DISTILLATE_FUEL_OIL`          | DFO           | Distillate Fuel Oil (including diesel, No. 1, No. 2, and No. 4 fuel oils)                                                           |
| `JET_FUEL`                     | JF            | Jet Fuel                                                                                                                            |
| `KEROSENE`                     | KER           | Kerosene                                                                                                                            |
| `PETROLEUM_COKE`               | PC            | Petroleum Coke                                                                                                                      |
| `RESIDUAL_FUEL_OIL`            | RFO           | Residual Fuel Oil (including No. 5 and No. 6 fuel oils, and bunker C fuel oil)                                                      |
| `PROPANE`                      | PG            | Propane, gaseous                                                                                                                    |
| `SYNTHESIS_GAS_PETROLEUM_COKE` | SGP           | Petroleum Coke Derived Synthesis Gas                                                                                                |
| `WASTE_OIL`                    | WO            | Waste/Other Oil (including crude oil, liquid butane, liquid propane, naphtha, oil waste, re-refined motor oil, sludge oil, tar oil) |
| `BLASTE_FURNACE_GAS`           | BFG           | Blast Furnace Gas                                                                                                                   |
| `NATURAL_GAS`                  | NG            | Natural Gas                                                                                                                         |
| `OTHER_GAS`                    | OG            | Other Gas                                                                                                                           |
| `AG_BYPRODUCT`                 | AB            | Agricultural By-products                                                                                                            |
| `MUNICIPAL_WASTE`              | MSW           | Municipal Solid Waste                                                                                                               |
| `OTHER_BIOMASS_SOLIDS`         | OBS           | Other Biomass Solids                                                                                                                |
| `WOOD_WASTE_SOLIDS`            | WDS           | Wood/Wood Waste Solids (including paper, pellets, railroad ties, utility poles, wood chips, bark, and wood waste solids)            |
| `OTHER_BIOMASS_LIQUIDS`        | OBL           | Other Biomass Liquids                                                                                                               |
| `SLUDGE_WASTE`                 | SLW           | Sludge Waste                                                                                                                        |
| `BLACK_LIQUOR`                 | BLQ           | Black Liquor                                                                                                                        |
| `WOOD_WASTE_LIQUIDS`           | WDL           | Wood Waste Liquids excluding Black Liquor (includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquids)    |
| `LANDFILL_GAS`                 | LFG           | Landfill Gas                                                                                                                        |
| `OTHEHR_BIOMASS_GAS`           | OBG           | Other Biomass Gas (includes digester gas, methane, and other biomass gasses)                                                        |
| `NUCLEAR`                      | NUC           | Nuclear Uranium, Plutonium, Thorium                                                                                                 |
| `WASTE_HEAT`                   | WH            | Waste heat not directly attributed to a fuel source                                                                                 |
| `TIREDERIVED_FUEL`             | TDF           | Tire-derived Fuels                                                                                                                  |
| `OTHER`                        | OTH           | Other type of fuel                                                                                                                  |

## [Energy Storage](@id storagetech_list)

`StorageTech` defines the storage technology used in an energy [`Storage`](@ref) system, based
on the options in [EIA form 923](https://www.eia.gov/survey/form/eia_923/instructions.pdf).
`StorageTech` has the options:

| Name          | Description                   |
|:------------- |:----------------------------- |
| `PTES`        | Pumped thermal energy storage |
| `LIB`         | LiON Battery                  |
| `LAB`         | Lead Acid Battery             |
| `FLWB`        | Redox Flow Battery            |
| `SIB`         | Sodium Ion Battery            |
| `ZIB`         | Zinc Ion Battery              |
| `HGS`         | Hydrogen Gas Storage          |
| `LAES`        | Liquid Air Storage            |
| `OTHER_CHEM`  | Other Chemical Storage        |
| `OTHER_MECH`  | Other Mechanical Storage      |
| `OTHER_THERM` | Other Thermal Storage         |

## [Facts Control Devices](@id factsmodes_list)

`FACTSOperationModes` define the operation modes the FACTS Control Devices have.
`FACTSOperationModes` has the options:

| Name  | Description                                                                                     |
|:----- |:----------------------------------------------------------------------------------------------- |
| `OOS` | Out-Of-Service (i.e., Series and Shunt links open)                                              |
| `NML` | Normal mode of operation, where Series and Shunt links are operating                            |
| `BYP` | Series link is bypassed (i.e., like a zero impedance line) and Shunt link operates as a STATCOM |

## [Dynamic States](@id states_list)

`StateTypes` are used to denote the type of dynamic equation a specific [state](@ref S) is subject
to in [`PowerSimulationsDynamics.jl`](https://nrel-sienna.github.io/PowerSimulationsDynamics.jl/stable/).
`StateTypes` has the options:

| Name           | Description                                                                      |
|:-------------- |:-------------------------------------------------------------------------------- |
| `Differential` | State evolves over time via a differential equation ``\dot{x} = f(x)``           |
| `Algebraic`    | State evolves over time by satisfying an algebraic equation ``0 = g(x)``         |
| `Hybrid`       | Depending on specific parameters, the state can be `Differential` or `Algebraic` |

## [Angle Units](@id angleunits_list)

`AngleUnits` can be specified in:

| Name      |
|:--------- |
| `DEGREES` |
| `RADIANS` |
