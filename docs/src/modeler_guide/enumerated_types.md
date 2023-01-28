
# Enumerated Types

To specify fields representing an option from a pre-defined list, some of the fields of
`Component` structs are specified with
[`IS.scoped_enums`](https://nrel-siip.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.@scoped_enum-Tuple{Any,%20Vararg{Any,%20N}%20where%20N}) (e.g.
`set_fuel!(gen, ThermalFuels.COAL)`). Below are the enumerated types contained in `PowerSystems`.

## `ThermalFuels`

Each `ThermalGen` generator struct contains a field for `fuel::ThermalFuels` where `ThermalFuels`
are intended to reflect the options denoted by the
[Aggregated Fuel Codes](https://www.eia.gov/survey/form/eia_923/instructions.pdf) from the
EIA Annual Energy Review. Specifically, `ThermalFuels` is an enumerated type with the
following options:

| EnumName | EIA Fuel Code | Description |
|----------|---------------|-------------|
| `COAL` | COL | Anthracite Coal and Bituminous Coal |
| `WASTE_COAL` | WOC | Waste/Other Coal (includes anthracite culm, gob, fine coal, lignite waste, waste coal) |
| `DISTILLATE_FUEL_OIL` | DFO | Distillate Fuel Oil (Diesel, No. 1, No. 2, and No. 4) |
| `WASTE_OIL` | WOO | Waste Oil Kerosene and JetFuel Butane, Propane |
| `PETROLEUM_COKE` | PC | Petroleum Coke |
| `RESIDUAL_FUEL_OIL` | RFO | Residual Fuel Oil (No. 5, No. 6 Fuel Oils, and Bunker Oil) |
| `NATURAL_GAS` | NG | Natural Gas |
| `OTHER_GAS` | OOG | Other Gas and blast furnace gas |
| `NUCLEAR` | NUC | Nuclear Fission (Uranium, Plutonium, Thorium) |
| `AG_BIPRODUCT` | ORW | Agricultural Crop Byproducts/Straw/Energy Crops |
| `MUNICIPAL_WASTE` |  MLG | Municipal Solid Waste – Biogenic component |
| `WOOD_WASTE` | WWW | Wood Waste Liquids excluding Black Liquor (BLQ) (Includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquids) |
| `GEOTHERMAL` | GEO | Geothermal |
| `OTHER` | OTH | Other |

## `PrimeMovers`

Each generator struct contains a field for `prime_mover::PrimeMovers` where `PrimeMovers`
are intended to reflect the options denoted by
[EIA form 923](https://www.eia.gov/survey/form/eia_923/instructions.pdf). Specifically,
`PrimeMovers` is an enumerated type with the following options:

| EnumName | Description |
|----------|-------------|
| `BA` | Energy Storage, Battery |
| `BT` | Turbines Used in a Binary Cycle (including those used for geothermal applications) |
| `CA` | Combined-Cycle – Steam Part |
| `CC` | Combined-Cycle - Aggregated Plant *augmentation of EIA |
| `CE` | Energy Storage, Compressed Air |
| `CP` | Energy Storage, Concentrated Solar Power |
| `CS` | Combined-Cycle Single-Shaft Combustion turbine and steam turbine share a single generator |
| `CT` | Combined-Cycle Combustion Turbine Part |
| `ES` | Energy Storage, Other |
| `FC` | Fuel Cell |
| `FW` | Energy Storage, Flywheel |
| `GT` | Combustion (Gas) Turbine (including jet engine design) |
| `HA` | Hydrokinetic, Axial Flow Turbine |
| `HB` | Hydrokinetic, Wave Buoy |
| `HK` | Hydrokinetic, Other |
| `HY` | Hydraulic Turbine (including turbines associated with delivery of water by pipeline) |
| `IC` | Internal Combustion (diesel, piston, reciprocating) Engine |
| `PS` | Energy Storage, Reversible Hydraulic Turbine (Pumped Storage) |
| `OT` | Other |
| `ST` | Steam Turbine (including nuclear, geothermal and solar steam; does not include combined-cycle turbine) |
| `PV` | Photovoltaic *renaming from EIA PV to PVe to avoid conflict with BusType.PV |
| `WT` | Wind Turbine, Onshore |
| `WS` | Wind Turbine, Offshore |

## `BusTypes`

`BusTypes` is used to denote which quantities are specified for load flow calculations and
to otherwise categorize buses for modeling activities.

| EnumName | Description |
|----------|-------------|
| `ISOLATED` | Disconnected from network |
| `PQ` | Active and reactive power defined (load bus)|
| `PV` | Active power and voltage magnitude defined (generator bus)|
| `REF` | Reference bus (θ = 0)|
| `SLACK` | Slack bus |

## `AngleUnits`

| EnumName |
|----------|
| `DEGREES` |
| `RADIANS` |

## `StateTypes`

| EnumName |
|----------|
| `Differential` |
| `Algebraic` |
| `Hybrid` |
