
# Enumerated Types

Some of the fields of `Component` structs are specified with `Enum` types. This is useful
when the field should specify an option from a pre-defined list. The following are the
enumerated types contained in `PowerSystems`

## `ThermalFuels`

Each `ThermalGen` generator struct contains a field for `fuel::ThermalFuels` where `ThermalFuels`
are intended to reflect the options denoted by the
[Aggregated Fuel Codes](https://www.eia.gov/survey/form/eia_923/instructions.pdf) from the
EIA Annual Energy Review. Specifically, `ThermalFuels` is an enumerated type with the
following options:

| EnumName | EnumValue | EIA Fuel Code | Description |
|----------|-----------|---------------|-------------|
| COAL | 1 | COL | Anthracite Coal and Bituminous Coal |
| WASTE_COAL | 2 | WOC | Waste/Other Coal (includes anthracite culm, gob, fine coal, lignite waste, waste coal) |
| DISTILLATE_FUEL_OIL | 3 | DFO | Distillate Fuel Oil (Diesel, No. 1, No. 2, and No. 4 |
| WASTE_OIL | 4 | WOO | Waste Oil Kerosene and JetFuel Butane, Propane, |
| PETROLEUM_COKE | 5 | PC | Petroleum Coke |
| RESIDUAL_FUEL_OIL | 6 | RFO | Residual Fuel Oil (No. 5, No. 6 Fuel Oils, and Bunker Oil) |
| NATURAL_GAS | 7 | NG | Natural Gas |
| OTHER_GAS | 8 | OOG | Other Gas and blast furnace gas |
| NUCLEAR | 9 | NUC | Nuclear Fission (Uranium, Plutonium, Thorium) |
| AG_BIPRODUCT | 10 | ORW | Agricultural Crop Byproducts/Straw/Energy Crops |
| MUNICIPAL_WASTE | 11 |  MLG | Municipal Solid Waste – Biogenic component |
| WOOD_WASTE | 12 | WWW | Wood Waste Liquids excluding Black Liquor (BLQ) (Includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquids) |
| GEOTHERMAL | 13 | GEO | Geothermal |
| OTHER | 14 | OTH | Other |

## `PrimeMovers`

Each generator struct contains a field for `prime_mover::PrimeMovers` where `PrimeMovers`
are intended to reflect the options denoted by
[EIA form 923](https://www.eia.gov/survey/form/eia_923/instructions.pdf). Specifically,
`PrimeMovers` is an enumerated type with the following options:

| EnumName | EnumValue | Description |
|----------|-----------|-------------|
| BA | 1 | Energy Storage, Battery |
| BT | 2 | Turbines Used in a Binary Cycle (including those used for geothermal applications) |
| CA | 3 | Combined-Cycle – Steam Part |
| CC | 4 | Combined-Cycle - Aggregated Plant *augmentation of EIA |
| CE | 5 | Energy Storage, Compressed Air |
| CP | 6 | Energy Storage, Concentrated Solar Power |
| CS | 7 | Combined-Cycle Single-Shaft Combustion turbine and steam turbine share a single generator |
| CT | 8 | Combined-Cycle Combustion Turbine Part |
| ES | 9 | Energy Storage, Other (Specify on Schedule 9, Comments) |
| FC | 10 | Fuel Cell |
| FW | 11 | Energy Storage, Flywheel |
| GT | 12 | Combustion (Gas) Turbine (including jet engine design) |
| HA | 13 | Hydrokinetic, Axial Flow Turbine |
| HB | 14 | Hydrokinetic, Wave Buoy |
| HK | 15 | Hydrokinetic, Other |
| HY | 16 | Hydraulic Turbine (including turbines associated with delivery of water by pipeline) |
| IC | 17 | Internal Combustion (diesel, piston, reciprocating) Engine |
| PS | 18 | Energy Storage, Reversible Hydraulic Turbine (Pumped Storage) |
| OT | 19 | Other – Specify on SCHEDULE 9. |
| ST | 20 | Steam Turbine (including nuclear, geothermal and solar steam; does not include combined-cycle turbine) |
| PV | 21 | Photovoltaic *renaming from EIA PV to PVe to avoid conflict with BusType.PV |
| WT | 22 | Wind Turbine, Onshore |
| WS | 23 | Wind Turbine, Offshore |

## `BusTypes`

`BusTypes` is used to denote which quantities are specified for load flow calculations and
to otherwise categorize buses for modeling activities.

| EnumName | EnumValue | Description |
|----------|-----------|-------------|
| ISOLATED | 1 | Disconnected from network |
| PQ | 2 | Active and reactive power defined (load bus)|
| PV | 3 | Active power and voltage magnitude defined (generator bus)|
| REF | 4 | Reference bus (θ = 0)|
| SLACK | 5 | Slack bus |

## `AngleUnits`

| EnumName | EnumValue |
|----------|-----------|
| DEGREES | 1 |
| RADIANS | 2 |

## `LoadModels`

| EnumName | EnumValue | Description |
|----------|-----------|-------------|
| ConstantImpedance | 1 | Z |
| ConstantCurrent | 2 | I |
| ConstantPower | 3 | P |

## `StateTypes`

| EnumName | EnumValue |
|----------|-----------|
| Differential | 1 |
| Algebraic | 2 |
| Hybrid | 3 |
