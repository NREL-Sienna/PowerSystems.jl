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

| Name                  | EIA Fuel Code | Description                                                                                                                            |
|:--------------------- |:------------- |:-------------------------------------------------------------------------------------------------------------------------------------- |
| `COAL`                | COL           | Anthracite Coal and Bituminous Coal                                                                                                    |
| `WASTE_COAL`          | WOC           | Waste/Other Coal (includes anthracite culm, gob, fine coal, lignite waste, waste coal)                                                 |
| `DISTILLATE_FUEL_OIL` | DFO           | Distillate Fuel Oil (Diesel, No. 1, No. 2, and No. 4)                                                                                  |
| `WASTE_OIL`           | WOO           | Waste Oil Kerosene and JetFuel Butane, Propane                                                                                         |
| `PETROLEUM_COKE`      | PC            | Petroleum Coke                                                                                                                         |
| `RESIDUAL_FUEL_OIL`   | RFO           | Residual Fuel Oil (No. 5, No. 6 Fuel Oils, and Bunker Oil)                                                                             |
| `NATURAL_GAS`         | NG            | Natural Gas                                                                                                                            |
| `OTHER_GAS`           | OOG           | Other Gas and blast furnace gas                                                                                                        |
| `NUCLEAR`             | NUC           | Nuclear Fission (Uranium, Plutonium, Thorium)                                                                                          |
| `AG_BIPRODUCT`        | ORW           | Agricultural Crop Byproducts/Straw/Energy Crops                                                                                        |
| `MUNICIPAL_WASTE`     | MLG           | Municipal Solid Waste – Biogenic component                                                                                             |
| `WOOD_WASTE`          | WWW           | Wood Waste Liquids excluding Black Liquor (BLQ) (Includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquids) |
| `GEOTHERMAL`          | GEO           | Geothermal                                                                                                                             |
| `OTHER`               | OTH           | Other                                                                                                                                  |

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
