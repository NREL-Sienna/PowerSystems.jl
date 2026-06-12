const MinMax = NamedTuple{(:min, :max), Tuple{Float64, Float64}}
const UpDown = NamedTuple{(:up, :down), Tuple{Float64, Float64}}
const StartUpShutDown = NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}
const FromTo = NamedTuple{(:from, :to), Tuple{Float64, Float64}}
const TurbinePump = NamedTuple{(:turbine, :pump), Tuple{Float64, Float64}}
# Exception to CamelCase convention for aliases due to confusssing reading of FromToToFrom
const FromTo_ToFrom = NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}
"""
`NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}` representing the start-up costs (\$)
for a multi-start thermal generator at each temperature stage:

- `hot`: cost when the unit is hot (shortest off-time)
- `warm`: cost when the unit is warm (medium off-time)
- `cold`: cost when the unit is cold (longest off-time)

For single-stage generators, only the `hot` field is meaningful. See also
[`single_start_up_to_stages`](@ref).
"""
const StartUpStages = NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}

# Intended for use with generators that are not multi-start (e.g. ThermalStandard).
# Operators use `hot` when they don’t have multiple stages.
"Convert a single start-up cost value to a `StartUpStages`"
single_start_up_to_stages(start_up::Real) =
    (hot = Float64(start_up), warm = 0.0, cold = 0.0)

IS.@scoped_enum(GeneratorCostModels, PIECEWISE_LINEAR = 1, POLYNOMIAL = 2,)
@doc"
Enumeration representing different cost models for generators in power system analysis.

| Value               | Description                           |
|:------------------ |:------------------------------------- |
| `PIECEWISE_LINEAR` | Piecewise linear cost representation  |
| `POLYNOMIAL`       | Polynomial cost representation        |
" GeneratorCostModels

IS.@scoped_enum(AngleUnits, DEGREES = 1, RADIANS = 2,)
@doc"
AngleUnits

Enumeration of angular measurement units used throughout PowerSystems.jl.

| Value      | Description                 |
|:--------- |:--------------------------- |
| `DEGREES` | Angles expressed in degrees |
| `RADIANS` | Angles expressed in radians |

# Notes
When performing trigonometric calculations with Julia's built-in functions (`sin`, `cos`,
etc.), convert degrees to radians first (e.g., `θ * π/180`) if the unit is `DEGREES`.
" AngleUnits

IS.@scoped_enum(ACBusTypes, PQ = 1, PV = 2, REF = 3, ISOLATED = 4, SLACK = 5,)
@doc"
Enumeration of AC power system bus types (MATPOWER Table B-1).
Each variant corresponds to a standard bus classification used in power flow
and steady-state network models. Set on an [`ACBus`](@ref) via the `bustype` field.

| Value       | Description                                                |
|:---------- |:---------------------------------------------------------- |
| `ISOLATED` | Disconnected from network                                  |
| `PQ`       | Active and reactive power defined (load bus)               |
| `PV`       | Active power and voltage magnitude defined (generator bus) |
| `REF`      | Reference bus (θ = 0)                                      |
| `SLACK`    | Slack bus                                                  |

# Notes
- Numeric values follow the MATPOWER convention for bus type codes.
- Use the enum members (e.g., `ACBusTypes.PQ`, `ACBusTypes.SLACK`) when
    constructing or interpreting network data to ensure compatibility with
    MATPOWER-based data conventions.

# References
- [MATPOWER manual, Table B-1](http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf)
" ACBusTypes

IS.@scoped_enum(
    LoadConformity,
    NON_CONFORMING = 0,
    CONFORMING = 1,
    UNDEFINED = 2,
)
@doc"
WECC-defined enumeration for load conformity classification used in dynamic modeling.

Load conformity indicates whether a load follows system voltage and frequency variations
according to WECC modeling standards:

| Value             | Description                                                       |
|:---------------- |:----------------------------------------------------------------- |
| `NON_CONFORMING` | Non-conforming load                                               |
| `CONFORMING`     | Conforming load                                                   |
| `UNDEFINED`      | Undefined or unknown whether load is conforming or non-conforming |

# See Also
- [`MotorLoadTechnology`](@ref): Related enumeration for motor load technology
    classification.
" LoadConformity

# "From PSSE POM v33 Manual"
IS.@scoped_enum(
    FACTSOperationModes,
    OOS = 0, # out-of-service (i.e., Series and Shunt links open)
    NML = 1, # Normal mode of operation, where Series and Shunt links are operating.
    BYP = 2, # Series link is bypassed (i.e., like a zero impedance line) and Shunt link operates as a STATCOM.
)
@doc"
Enumeration of operational modes for FACTS (Flexible AC Transmission System) devices,
as defined in the PSS/E POM v33 Manual.

| Value  | Description                                                                                     |
|:----- |:----------------------------------------------------------------------------------------------- |
| `OOS` | Out-Of-Service (i.e., Series and Shunt links open)                                              |
| `NML` | Normal mode of operation, where Series and Shunt links are operating                            |
| `BYP` | Series link is bypassed (i.e., like a zero impedance line) and Shunt link operates as a STATCOM |

# References
- PSS/E Power Operations Manual v33, FACTS device specification.
" FACTSOperationModes

IS.@scoped_enum(
    DiscreteControlledBranchType,
    SWITCH = 0,
    BREAKER = 1,
    OTHER = 2,
)
@doc"
DiscreteControlledBranchType

Enumeration of discrete controlled branch device types.

| Value       | Description                                                              |
|:---------- |:------------------------------------------------------------------------ |
| `SWITCH`   | Switching device that can be opened or closed to connect or isolate a circuit segment |
| `BREAKER`  | Circuit breaker capable of interrupting fault current                    |
| `OTHER`    | Other discrete branch device not covered by the above categories         |

# See Also
- [`DiscreteControlledACBranch`](@ref): Branch type that uses this enumeration.
- [`DiscreteControlledBranchStatus`](@ref): Enumeration of the open/closed status for
    these devices.
" DiscreteControlledBranchType

IS.@scoped_enum(
    DiscreteControlledBranchStatus,
    OPEN = 0,
    CLOSED = 1,
)
@doc"
DiscreteControlledBranchStatus

Enumeration describing the controlled (commanded) status of a branch device such as a
breaker or switch. Used with [`DiscreteControlledACBranch`](@ref).

| Value     | Description                          |
|:-------- |:------------------------------------ |
| `OPEN`   | The device is open (non-conducting)  |
| `CLOSED` | The device is closed (conducting)    |

# Notes
Represents the intended or commanded state used by control and protection logic; it may
differ from the actual measured/telemetry state during faults or failures.
" DiscreteControlledBranchStatus

IS.@scoped_enum(
    WindingCategory,
    TR2W_WINDING = 0,       # Transformer2W only winding associated with a TICT
    PRIMARY_WINDING = 1,    # Primary winding of Trasnformer3W associated with a TICT
    SECONDARY_WINDING = 2,  # Secondary winding of Trasnformer3W associated with a TICT
    TERTIARY_WINDING = 3,   # Tertiary winding of Trasnformer3W associated with a TICT
)
@doc"
WindingCategory

Enumeration of transformer winding roles used to interpret a
[`ImpedanceCorrectionData`](@ref) (Transformer Impedance Correction Table) association.

| Value                | Description                                                                 |
|:------------------- |:--------------------------------------------------------------------------- |
| `TR2W_WINDING`      | Winding of a two-winding transformer connected to [`ImpedanceCorrectionData`](@ref) |
| `PRIMARY_WINDING`   | Primary winding of a three-winding transformer connected to [`ImpedanceCorrectionData`](@ref) |
| `SECONDARY_WINDING` | Secondary winding of a three-winding transformer connected to [`ImpedanceCorrectionData`](@ref) |
| `TERTIARY_WINDING`  | Tertiary winding of a three-winding transformer connected to [`ImpedanceCorrectionData`](@ref) |

# See Also
- [`ImpedanceCorrectionTransformerControlMode`](@ref): Enumeration of control modes used
    alongside winding impedance corrections.
" WindingCategory

IS.@scoped_enum(
    WindingGroupNumber,
    UNDEFINED = -99,
    GROUP_0 = 0, # 0 Degrees
    GROUP_1 = 1, # -30 Degrees
    GROUP_5 = 5, # -150 Degrees
    GROUP_6 = 6, # 180 Degrees
    GROUP_7 = 7, # 150 Degrees
    GROUP_11 = 11, # 30 Degrees
)
@doc"
WindingGroupNumber

Enumeration of transformer winding group numbers representing the phase displacement
between primary and secondary windings of three-phase transformers, per IEC 60076-1.

| Value        | Description                                           |
|:----------- |:----------------------------------------------------- |
| `UNDEFINED` | Winding group not specified                           |
| `GROUP_0`   | 0° phase displacement (e.g., Yy0, Dd0, Dz0)           |
| `GROUP_1`   | −30° phase displacement (e.g., Dy1, Yd1, Yz1)         |
| `GROUP_5`   | −150° phase displacement (e.g., Dy5, Yd5, Yz5)       |
| `GROUP_6`   | 180° phase displacement (e.g., Yy6, Dd6, Dz6)       |
| `GROUP_7`   | 150° phase displacement (e.g., Dy7, Yd7, Yz7)        |
| `GROUP_11`  | 30° phase displacement (e.g., Dy11, Yd11, Yz11)      |

# Notes
- Phase displacement is measured from primary to secondary winding; positive angles
    lead and negative angles lag.
- Clock notation: each clock hour represents 30°.

# References
- IEC 60076-1: Power transformers — General.
" WindingGroupNumber

IS.@scoped_enum(
    ImpedanceCorrectionTransformerControlMode,
    PHASE_SHIFT_ANGLE = 1,
    TAP_RATIO = 2,
)
@doc"
ImpedanceCorrectionTransformerControlMode

Enumeration of control modes for impedance correction in transformers, as defined
in the PSS/E transformer control specifications.

| Value                 | Description                                                                 |
|:-------------------- |:--------------------------------------------------------------------------- |
| `PHASE_SHIFT_ANGLE`  | Impedance correction as a function of phase shift angle (phase-shifting transformers) |
| `TAP_RATIO`          | Impedance correction as a function of tap ratio (tap-changing transformers) |

# See Also
- [`ImpedanceCorrectionData`](@ref): Supplemental attribute that uses this control mode.
" ImpedanceCorrectionTransformerControlMode

IS.@scoped_enum(
    TransformerControlObjective, # COD1 or COD2 in PSS\e
    UNDEFINED = -99,
    VOLTAGE_DISABLED = -1,
    REACTIVE_POWER_FLOW_DISABLED = -2,
    ACTIVE_POWER_FLOW_DISABLED = -3,
    CONTROL_OF_DC_LINE_DISABLED = -4,
    ASYMMETRIC_ACTIVE_POWER_FLOW_DISABLED = -5,
    FIXED = 0,
    VOLTAGE = 1,
    REACTIVE_POWER_FLOW = 2,
    ACTIVE_POWER_FLOW = 3,
    CONTROL_OF_DC_LINE = 4,
    ASYMMETRIC_ACTIVE_POWER_FLOW = 5,
)
@doc"
Enumeration of transformer control objectives based on PSS/E COD1 and COD2 fields.

This enumeration defines the control modes for transformer tap changers and phase shifters
as specified in the PSS/E-35 manual.

| Value                                    | Description                                                               |
|:--------------------------------------- |:------------------------------------------------------------------------- |
| `UNDEFINED`                             | Undefined                                                                 |
| `VOLTAGE_DISABLED`                      | Has voltage control capabilities, which are disabled                      |
| `REACTIVE_POWER_FLOW_DISABLED`          | Has reactive power flow control capabilities, which are disabled          |
| `ACTIVE_POWER_FLOW_DISABLED`            | Has active power flow control capabilities, which are disabled            |
| `CONTROL_OF_DC_LINE_DISABLED`           | Has capabilities to control a DC line quantity, which are disabled        |
| `ASYMMETRIC_ACTIVE_POWER_FLOW_DISABLED` | Has asymmetric active power flow control capabilities, which are disabled |
| `FIXED`                                 | Fixed tap and fixed phase shift                                           |
| `VOLTAGE`                               | Voltage control                                                           |
| `REACTIVE_POWER_FLOW`                   | Reactive power flow control                                               |
| `ACTIVE_POWER_FLOW`                     | Active power flow control                                                 |
| `CONTROL_OF_DC_LINE`                    | Control of a DC line quantity                                             |
| `ASYMMETRIC_ACTIVE_POWER_FLOW`          | Asymmetric active power flow control                                      |

# Notes
Negative values indicate disabled control modes, while positive values represent active
control objectives. The `FIXED` mode (0) indicates manual tap position control without
automatic adjustment.
" TransformerControlObjective

IS.@scoped_enum(
    MotorLoadTechnology,
    INDUCTION = 1,
    SYNCHRONOUS = 2,
    UNDETERMINED = 3,
)
@doc"
Enumeration of motor load technology types used in power system dynamic load modeling.

| Value           | Description                                  |
|:-------------- |:-------------------------------------------- |
| `INDUCTION`    | Induction motor                              |
| `SYNCHRONOUS`  | Synchronous motor                            |
| `UNDETERMINED` | Type is not specified or unknown             |

# See Also
- [`LoadConformity`](@ref): Related enumeration for load conformity classification.
" MotorLoadTechnology

IS.@scoped_enum(
    PrimeMovers,
    BA = 1,  # Energy Storage, Battery
    BT = 2,  # Turbines Used in a Binary Cycle (including those used for geothermal applications)
    CA = 3,  # Combined-Cycle – Steam Part
    CC = 4,  # Combined-Cycle - Aggregated Plant *augmentation of EIA
    CE = 5,  # Energy Storage, Compressed Air
    CP = 6,  # Energy Storage, Concentrated Solar Power
    CS = 7,  # Combined-Cycle Single-Shaft Combustion turbine and steam turbine share a single generator
    CT = 8,  # Combined-Cycle Combustion Turbine Part
    ES = 9,  # Energy Storage, Other (Specify on Schedule 9, Comments)
    FC = 10,  # Fuel Cell
    FW = 11,  # Energy Storage, Flywheel
    GT = 12,  # Combustion (Gas) Turbine (including jet engine design)
    HA = 13,  # Hydrokinetic, Axial Flow Turbine
    HB = 14,  # Hydrokinetic, Wave Buoy
    HK = 15,  # Hydrokinetic, Other
    HY = 16,  # Hydraulic Turbine (including turbines associated with delivery of water by pipeline)
    IC = 17,  # Internal Combustion (diesel, piston, reciprocating) Engine
    PS = 18,  # Energy Storage, Reversible Hydraulic Turbine (Pumped Storage)
    OT = 19,  # Other – Specify on SCHEDULE 9.
    ST = 20,  # Steam Turbine (including nuclear, geothermal and solar steam; does not include combined-cycle turbine)
    PVe = 21,  # Photovoltaic *renaming from EIA PV to PVe to avoid conflict with BusType.PV
    WT = 22,  # Wind Turbine, Onshore
    WS = 23,  # Wind Turbine, Offshore
)
@doc"
Enumeration of prime mover types used in electric power generation, as defined by the
U.S. Energy Information Administration (EIA) Form 923 instructions.

Prime movers are the engines, turbines, water wheels, or similar machines that drive
electric generators or provide mechanical energy for other purposes.

# Notes
`PVe` is used for photovoltaic systems, renamed from the EIA code `PV` to avoid a
naming conflict with [`ACBusTypes`](@ref) `PV`.

| Value  | Description                                                                                            |
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
| `PVe` | Photovoltaic (*Note*: renamed from EIA `PV` to avoid conflict with `ACBusTypes.PV`)                  |
| `WT`  | Wind Turbine, Onshore                                                                                  |
| `WS`  | Wind Turbine, Offshore                                                                                 |

# References
- [EIA Form 923 Instructions](https://www.eia.gov/survey/form/eia_923/instructions.pdf)

# See Also
- [`ThermalStandard`](@ref): Uses prime mover information for generator specifications.
- [`ThermalMultiStart`](@ref): Uses prime mover information for generator specifications.
" PrimeMovers

IS.@scoped_enum(
    ThermalFuels,
    COAL = 1,  # General Coal Category.
    ANTHRACITE_COAL = 2,# ANT
    BITUMINOUS_COAL = 3, # BIT
    LIGNITE_COAL = 4, # LIG
    SUBBITUMINOUS_COAL = 5, # SUB
    WASTE_COAL = 6, # WC # includes anthracite culm, bituminous gob, fine coal, lignite waste, waste coal
    REFINED_COAL = 7,  # RC # ncludes any coal which meets the IRS definition of refined coal [Notice 2010-54 or any superseding IRS notices]. Does not include coal processed by coal preparation plants.)
    SYNTHESIS_GAS_COAL = 8, # SGC
    DISTILLATE_FUEL_OIL = 9,  # DFO # includes Diesel, No. 1, No. 2, and No. 4
    JET_FUEL = 10, # JF
    KEROSENE = 11, # KER
    PETROLEUM_COKE = 12,  # PC
    RESIDUAL_FUEL_OIL = 13,  # RFO # includes No. 5, No. 6 Fuel Oils, and Bunker Oil
    PROPANE = 14, # PG # Propane, gaseous
    SYNTHESIS_GAS_PETROLEUM_COKE = 15,  # SGP
    WASTE_OIL = 16,  # WO # including crude oil, liquid butane, liquid propane, naphtha, oil waste, re-refined motor oil, sludge oil, tar oil, or other petroleum-based liquid wastes
    BLASTE_FURNACE_GAS = 17,  # BFG
    NATURAL_GAS = 18,  # NG    # Natural Gas
    OTHER_GAS = 19,  # OOG    # Other Gas and blast furnace gas
    NUCLEAR = 20,  # NUC # Nuclear Fission (Uranium, Plutonium, Thorium)
    AG_BYPRODUCT = 21,  # AB    # Agricultural Crop Byproducts/Straw/Energy Crops
    MUNICIPAL_WASTE = 22,  # MSW    # Municipal Solid Waste – Biogenic component
    OTHER_BIOMASS_SOLIDS = 23,  # OBS
    WOOD_WASTE_SOLIDS = 24,  # WDS # including paper 18 pellets, railroad ties, utility poles, wood chips, bark, and wood waste solid
    OTHER_BIOMASS_LIQUIDS = 26,  # OBL
    SLUDGE_WASTE = 27, # SLW
    BLACK_LIQUOR = 28, # BLQ
    WOOD_WASTE_LIQUIDS = 29, # WDL # includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquid. Excluding black liquour
    LANDFILL_GAS = 30, # LFG
    OTHEHR_BIOMASS_GAS = 31, # OBG # includes digester gas, methane, and other biomass gasses
    GEOTHERMAL = 32,  # GEO
    WASTE_HEAT = 33, # WH # WH should only be reported where the fuel source for the waste heat is undetermined, and for combined-cycle steam turbines that do not have supplemental firing.
    TIREDERIVED_FUEL = 34, # TDF
    OTHER = 35,  # OTH
)

@doc"
Enumeration of thermal fuel types, using EIA Form 923 fuel codes for standardized
reporting of fuel consumption in electric power generation.

Categories include: coal and coal-derived fuels, petroleum products, natural gas, nuclear,
biomass and waste-derived fuels, geothermal, and other thermal energy sources.

| Value                                                                                                                               | EIA Fuel Code | Description                                                                                                                         |
|:---------------------------------------------------------------------------------------------------------------------------------- |:------------- |:----------------------------------------------------------------------------------------------------------------------------------- |
| `ANTHRACITE_COAL`                                                                                                                  | ANT           | Anthracite Coal                                                                                                                     |
| `BITUMINOUS_COAL`                                                                                                                  | BIT           | Bituminous Coal                                                                                                                     |
| `LIGNITE_COAL`                                                                                                                     | LIG           | Lignite Coal                                                                                                                        |
| `SUBBITUMINOUS_COAL`                                                                                                               | SUB           | Subbituminous Coal                                                                                                                  |
| `WASTE_COAL`                                                                                                                       | WC            | Waste/Other Coal (including anthracite culm, bituminous gob, fine coal, lignite waste, waste coal)                                  |
| `REFINED_COAL`                                                                                                                     | RC            | Refined Coal (A coal product that improves heat content and reduces emissions. Excludes coal processed by coal preparation plants.) |
| `SYNTHESIS_GAS_COAL`                                                                                                               | SGC           | Coal-Derived Synthesis Gas                                                                                                          |
| `DISTILLATE_FUEL_OIL`                                                                                                              | DFO           | Distillate Fuel Oil (including diesel, No. 1, No. 2, and No. 4 fuel oils)                                                           |
| `JET_FUEL`                                                                                                                         | JF            | Jet Fuel                                                                                                                            |
| `KEROSENE`                                                                                                                         | KER           | Kerosene                                                                                                                            |
| `PETROLEUM_COKE`                                                                                                                   | PC            | Petroleum Coke                                                                                                                      |
| `RESIDUAL_FUEL_OIL`                                                                                                                | RFO           | Residual Fuel Oil (including No. 5 and No. 6 fuel oils, and bunker C fuel oil)                                                      |
| `PROPANE`                                                                                                                          | PG            | Propane, gaseous                                                                                                                    |
| `SYNTHESIS_GAS_PETROLEUM_COKE`                                                                                                     | SGP           | Petroleum Coke Derived Synthesis Gas                                                                                                |
| `WASTE_OIL`                                                                                                                        | WO            | Waste/Other Oil (including crude oil, liquid butane, liquid propane, naphtha, oil waste, re-refined motor oil, sludge oil, tar oil) |
| `BLASTE_FURNACE_GAS`                                                                                                               | BFG           | Blast Furnace Gas                                                                                                                   |
| `NATURAL_GAS`                                                                                                                      | NG            | Natural Gas                                                                                                                         |
| `OTHER_GAS`                                                                                                                        | OG            | Other Gas                                                                                                                           |
| `AG_BYPRODUCT`                                                                                                                     | AB            | Agricultural By-products                                                                                                            |
| `MUNICIPAL_WASTE`                                                                                                                  | MSW           | Municipal Solid Waste                                                                                                               |
| `OTHER_BIOMASS_SOLIDS`                                                                                                             | OBS           | Other Biomass Solids                                                                                                                |
| `WOOD_WASTE_SOLIDS`                                                                                                                | WDS           | Wood/Wood Waste Solids (including paper, pellets, railroad ties, utility poles, wood chips, bark, and wood waste solids)            |
| `OTHER_BIOMASS_LIQUIDS`                                                                                                            | OBL           | Other Biomass Liquids                                                                                                               |
| `SLUDGE_WASTE`                                                                                                                     | SLW           | Sludge Waste                                                                                                                        |
| `BLACK_LIQUOR`                                                                                                                     | BLQ           | Black Liquor                                                                                                                        |
| `WOOD_WASTE_LIQUIDS`                                                                                                               | WDL           | Wood Waste Liquids excluding Black Liquor (includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquids)    |
| `LANDFILL_GAS`                                                                                                                     | LFG           | Landfill Gas                                                                                                                        |
| `OTHEHR_BIOMASS_GAS`                                                                                                               | OBG           | Other Biomass Gas (includes digester gas, methane, and other biomass gasses)                                                        |
| `NUCLEAR`                                                                                                                          | NUC           | Nuclear Uranium, Plutonium, Thorium                                                                                                 |
| `WASTE_HEAT`                                                                                                                       | WH            | Waste heat not directly attributed to a fuel source                                                                                 |
| `TIREDERIVED_FUEL`                                                                                                                 | TDF           | Tire-derived Fuels                                                                                                                  |
| `COAL`*                                                                                                                            | N/A           | General Coal Fuels                                                                                                                  |
| `GEOTHERMAL`*                                                                                                                      | GEO           | Geothermal Fuels                                                                                                                    |
| `OTHER`                                                                                                                            | OTH           | Other type of fuel                                                                                                                  |

*Asterisk denotes fuel codes not directly from the current EIA 923 form but kept for compatibility with older versions of the form.

# Notes
`COAL` (general coal) and `GEOTHERMAL` codes are not directly from the current EIA 923
form but are retained for compatibility with older data.

# References
- [EIA Form 923 Instructions](https://www.eia.gov/survey/form/eia_923/instructions.pdf)

# See Also
- [`ThermalStandard`](@ref): Generator type that uses this fuel enumeration.
- [`ThermalMultiStart`](@ref): Generator type that uses this fuel enumeration.
- [`PrimeMovers`](@ref): Companion enumeration for generator prime mover type.
" ThermalFuels

IS.@scoped_enum(
    StorageTech,
    PTES = 1, # Pumped thermal energy storage
    LIB = 2, # LiON Battery
    LAB = 3, # Lead Acid Battery
    FLWB = 4, # Redox Flow Battery
    SIB = 5, # Sodium Ion Battery
    ZIB = 6, # Zinc Ion Battery,
    HGS = 7, # Hydrogen Gas Storage,
    LAES = 8, # Liquid Air Storage
    OTHER_CHEM = 9, # Chemmical Storage
    OTHER_MECH = 10, # Mechanical Storage
    OTHER_THERM = 11, # Thermal Storage
)
@doc"
Enumeration of energy storage technologies used in power system modeling.

| Value          | Description                   |
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

# See Also
- [`EnergyReservoirStorage`](@ref): Storage component using this enumeration.
" StorageTech

IS.@scoped_enum(
    PumpHydroStatus,
    OFF = 0,
    GEN = 1,
    PUMP = -1,
)
@doc"
PumpHydroStatus

Operating status of a pumped‑storage hydro unit.

| Value   | Description                                                      |
|:------ |:---------------------------------------------------------------- |
| `OFF`  | Unit is idle — neither generating nor pumping                    |
| `GEN`  | Generating mode (turbine operation), producing active power      |
| `PUMP` | Pumping mode, consuming active power to store energy             |

# Notes
- Integer values are 0, 1, and -1 respectively; the sign reflects net active power direction
  (positive = generation, negative = pumping).
- Intended for use in scheduling, dispatch, and state-tracking of pumped‑storage units.
" PumpHydroStatus

IS.@scoped_enum(StateTypes, Differential = 1, Algebraic = 2, Hybrid = 3,)
@doc"
StateTypes

Categorization of state variable types for dynamic components.

| Value          | Description                                                                    |
|:------------- |:------------------------------------------------------------------------------ |
| `Differential` | State governed by a differential equation (evolves continuously in time)      |
| `Algebraic`   | State determined by an algebraic constraint (no time derivative)               |
| `Hybrid`      | State that can behave as differential or algebraic depending on operating conditions |

# See Also
- [`DynamicComponent`](@ref): Abstract base type whose states are classified by this
    enumeration.
" StateTypes

IS.@scoped_enum(
    ReservoirDataType,
    USABLE_VOLUME = 1,
    TOTAL_VOLUME = 2,
    HEAD = 3,
    ENERGY = 4,
)
@doc"
Enumeration of the quantity type used to represent the state of a [`HydroReservoir`](@ref).

| Value            | Units | Description                                                                                                                                                              |
|:--------------- |:----- |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `USABLE_VOLUME` | m^3   | The volume of water that can be stored for levels between the penstock intake and the top reservoir level                                                                |
| `TOTAL_VOLUME`  | m^3   | The total volume of the reservoir considering a total depletion of the water levels. This unit system usually requires the specification of a valid minimum volume level |
| `HEAD`          | m     | The difference in elevations between the top water levels. It requires a valid conversion constant to go from head to potential energy stored.                           |
| `ENERGY`        | MWh   | Uses energy units in MWh to approximate the water storage as a generic energy reservoir.                                                                                 |

# See Also
- [`ReservoirLocation`](@ref): Enumeration of reservoir location relative to the turbine.
" ReservoirDataType

IS.@scoped_enum(
    HydroTurbineType,
    UNKNOWN = 0,          # Default / unspecified
    PELTON = 1,           # Impulse turbine for high head
    FRANCIS = 2,          # Reaction turbine for medium head
    KAPLAN = 3,           # Propeller-type turbine for low head
    TURGO = 4,            # Impulse turbine similar to Pelton
    CROSSFLOW = 5,        # Banki-Michell (crossflow) turbine
    BULB = 6,             # Kaplan variation for very low head
    DERIAZ = 7,           # Diagonal flow turbine
    PROPELLER = 8,        # Simple propeller turbine
    OTHER = 9             # Catch-all for less common designs
)
@doc"
HydroTurbineType

Enumeration of hydroelectric turbine designs, used to classify hydro generating units
by operating head range and flow characteristics.

| Value        | Description                                                         |
|:----------- |:------------------------------------------------------------------- |
| `UNKNOWN`   | Turbine type is not specified                                       |
| `PELTON`    | Impulse turbine for high-head, low-flow sites                       |
| `FRANCIS`   | Reaction turbine, widely used for medium-head applications          |
| `KAPLAN`    | Adjustable-blade propeller turbine for low-head, high-flow sites    |
| `TURGO`     | Impulse turbine similar to Pelton but suitable for higher flow rates |
| `CROSSFLOW` | Banki-Michell (crossflow) impulse turbine, robust for small hydro   |
| `BULB`      | Compact Kaplan variant for low-head run-of-river plants             |
| `DERIAZ`    | Diagonal flow reaction turbine with variable pitch blades           |
| `PROPELLER` | Fixed-blade propeller turbine                                       |
| `OTHER`     | Placeholder for less common or custom turbine designs               |

# See Also
- [`HydroTurbine`](@ref): Hydro generator component using this enumeration.
" HydroTurbineType

IS.@scoped_enum(
    ReservoirLocation,
    HEAD = 1,
    TAIL = 2,
)
@doc"
ReservoirLocation

Enumeration representing the location of a [`HydroReservoir`](@ref) relative to its
associated turbine unit.

| Value   | Description                                                        |
|:------ |:------------------------------------------------------------------ |
| `HEAD` | Reservoir located upstream of the turbine (higher elevation)       |
| `TAIL` | Reservoir located downstream of the turbine (lower elevation)    |

# See Also
- [`ReservoirDataType`](@ref): Enumeration of the quantity used to represent reservoir
    state.
" ReservoirLocation

IS.@scoped_enum(
    CombinedCycleConfiguration,
    SingleShaftCombustionSteam = 1,
    SeparateShaftCombustionSteam = 2,
    DoubleCombustionOneSteam = 3,
    TripleCombustionOneSteam = 4,
    Other = 5,
)
@doc"
Enumeration describing the physical layout of a combined cycle power plant.

| Value                           | Description                                                          |
|:------------------------------ |:-------------------------------------------------------------------- |
| `SingleShaftCombustionSteam`   | Single combustion turbine on a common shaft with one steam turbine   |
| `SeparateShaftCombustionSteam` | One combustion turbine and one steam turbine on separate shafts      |
| `DoubleCombustionOneSteam`     | Two combustion turbines exhausting into one steam turbine            |
| `TripleCombustionOneSteam`     | Three combustion turbines exhausting into one steam turbine          |
| `Other`                        | Any other combined cycle configuration not covered by the above values |

# See Also
- [`CombinedCycleBlock`](@ref): Plant attribute for combined cycle block-level configurations.
- [`CombinedCycleFractional`](@ref): Plant attribute for combined cycle fractional configurations.
" CombinedCycleConfigurationModule.CombinedCycleConfiguration

const PS_MAX_LOG = parse(Int, get(ENV, "PS_MAX_LOG", "50"))
const DEFAULT_BASE_MVA = 100.0

const POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE =
    joinpath(dirname(pathof(PowerSystems)), "descriptors", "power_system_structs.json")

const DEFAULT_SYSTEM_FREQUENCY = 60.0

const INFINITE_TIME = 1e4
const START_COST = 1e8
const INFINITE_COST = 1e8
const INFINITE_BOUND = 1e6
const BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL = 0.01

const PSSE_PARSER_TAP_RATIO_UBOUND = 1.5
const PSSE_PARSER_TAP_RATIO_LBOUND = 0.5
const PARSER_TAP_RATIO_CORRECTION_TOL = 1e-5

const ZERO_IMPEDANCE_REACTANCE_THRESHOLD = 1e-4

# Absolute threshold below which a shunt admittance component (conductance or
# susceptance) is treated as zero for capability detection, so negligible
# admittances do not force their host bus to be kept during network reduction.
const ZERO_ADMITTANCE_THRESHOLD = 1e-4

const WINDING_NAMES = Dict(
    WindingCategory.PRIMARY_WINDING => "primary",
    WindingCategory.SECONDARY_WINDING => "secondary",
    WindingCategory.TERTIARY_WINDING => "tertiary",
)

const TRANSFORMER3W_PARAMETER_NAMES = [
    "COD", "CONT", "NOMV", "WINDV", "RMA", "RMI",
    "NTP", "VMA", "VMI", "RATA", "RATB", "RATC",
]

# Emissions enums

IS.@scoped_enum(
    PollutantType,
    CO2 = 1,
    CO2E = 2,
    CH4 = 3,
    N2O = 4,
    NOX = 10,
    SO2 = 11,
    PM25 = 20,
    PM10 = 21,
    HG = 30,
    HAP = 40,
    CUSTOM = 99,
)
@doc """
Enumeration of pollutant types for emissions tracking.

| Value     | Description                        |
|:-------- |:---------------------------------- |
| `CO2`    | Carbon dioxide                     |
| `CO2E`   | Carbon dioxide equivalent          |
| `CH4`    | Methane                            |
| `N2O`    | Nitrous oxide                      |
| `NOX`    | Nitrogen oxides                    |
| `SO2`    | Sulfur dioxide                     |
| `PM25`   | Particulate matter (2.5 μm)        |
| `PM10`   | Particulate matter (10 μm)         |
| `HG`     | Mercury                            |
| `HAP`    | Hazardous air pollutants           |
| `CUSTOM` | User-defined pollutant             |
""" PollutantType

IS.@scoped_enum(
    EmissionBasis,
    FUEL_INPUT = 1,
    POWER_OUTPUT = 2,
)
@doc """
Enumeration of emission rate basis types.

| Value            | Description                                                    |
|:--------------- |:-------------------------------------------------------------- |
| `FUEL_INPUT`    | Mass per unit of heat input (e.g., lb/MMBtu, kg/GJ)            |
| `POWER_OUTPUT`  | Mass per unit of electrical output (e.g., lb/MWh, kg/MWh)      |
""" EmissionBasis

IS.@scoped_enum(
    MassUnit,
    KG = 1,
    LB = 2,
    SHORT_TON = 3,
    METRIC_TON = 4,
)
@doc """
Enumeration of mass units for emissions.

| Value          | Description              |
|:------------- |:------------------------ |
| `KG`          | Kilograms                |
| `LB`          | Pounds                   |
| `SHORT_TON`   | Short tons (2000 lb)     |
| `METRIC_TON`  | Metric tons (1000 kg)    |
""" MassUnit

IS.@scoped_enum(
    EnergyUnit,
    MMBTU = 1,
    GJ = 2,
    MWH = 3,
)
@doc """
Enumeration of energy units for emissions rate denominator.

| Value    | Description                  |
|:------- |:---------------------------- |
| `MMBTU` | Million British thermal units |
| `GJ`    | Gigajoules                   |
| `MWH`   | Megawatt-hours               |
""" EnergyUnit
