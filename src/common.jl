const Min_Max = NamedTuple{(:min, :max), Tuple{Float64, Float64}}
const Up_Down = NamedTuple{(:up, :down), Tuple{Float64, Float64}}
const From_To_Float = NamedTuple{(:from, :to), Tuple{Float64, Float64}}
const FromTo_ToFrom_Float = NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}

"From http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf Table B-4"
IS.@scoped_enum GeneratorCostModel begin
    PIECEWISE_LINEAR = 1
    POLYNOMIAL = 2
end

IS.@scoped_enum AngleUnit begin
    DEGREES
    RADIANS
end

IS.@scoped_enum BusType begin
    ISOLATED
    PQ
    PV
    REF
    SLACK
end

IS.@scoped_enum LoadModel begin
    ConstantImpedance # Z
    ConstantCurrent   # I
    ConstantPower     # P
end

"From https://www.eia.gov/survey/form/eia_923/instructions.pdf"
IS.@scoped_enum PrimeMover begin
    BA # Energy Storage, Battery
    BT # Turbines Used in a Binary Cycle (including those used for geothermal applications)
    CA # Combined-Cycle – Steam Part
    CC # Combined-Cycle - Aggregated Plant *augmentation of EIA
    CE # Energy Storage, Compressed Air
    CP # Energy Storage, Concentrated Solar Power
    CS # Combined-Cycle Single-Shaft Combustion turbine and steam turbine share a single generator
    CT # Combined-Cycle Combustion Turbine Part
    ES # Energy Storage, Other (Specify on Schedule 9, Comments)
    FC # Fuel Cell
    FW # Energy Storage, Flywheel
    GT # Combustion (Gas) Turbine (including jet engine design)
    HA # Hydrokinetic, Axial Flow Turbine
    HB # Hydrokinetic, Wave Buoy
    HK # Hydrokinetic, Other
    HY # Hydraulic Turbine (including turbines associated with delivery of water by pipeline)
    IC # Internal Combustion (diesel, piston, reciprocating) Engine
    PS # Energy Storage, Reversible Hydraulic Turbine (Pumped Storage)
    OT # Other – Specify on SCHEDULE 9.
    ST # Steam Turbine (including nuclear, geothermal and solar steam; does not include combined-cycle turbine)
    PVe # Photovoltaic *renaming from EIA PV to PVe to avoid conflict with BusType.PV
    WT # Wind Turbine, Onshore
    WS # Wind Turbine, Offshore
end

"AER Aggregated Fuel Code From https://www.eia.gov/survey/form/eia_923/instructions.pdf"
IS.@scoped_enum ThermalFuel begin
    COAL # COL    # Anthracite Coal and Bituminous Coal
    WASTE_COAL # WOC    # Waste/Other Coal (includes anthracite culm, gob, fine coal, lignite waste, waste coal)
    DISTILLATE_FUEL_OIL # DFO # Distillate Fuel Oil (Diesel, No. 1, No. 2, and No. 4
    WASTE_OIL # WOO    # Waste Oil Kerosene and JetFuel Butane, Propane,
    PETROLEUM_COKE # PC  # Petroleum Coke
    RESIDUAL_FUEL_OIL    # RFO # Residual Fuel Oil (No. 5, No. 6 Fuel Oils, and Bunker Oil)
    NATURAL_GAS # NG    # Natural Gas
    OTHER_GAS # OOG    # Other Gas and blast furnace gas
    NUCLEAR # NUC # Nuclear Fission (Uranium, Plutonium, Thorium)
    AG_BIPRODUCT # ORW    # Agricultural Crop Byproducts/Straw/Energy Crops
    MUNICIPAL_WASTE # MLG    # Municipal Solid Waste – Biogenic component
    WOOD_WASTE # WWW     # Wood Waste Liquids excluding Black Liquor (BLQ) (Includes red liquor, sludge wood, spent sulfite liquor, and other wood-based liquids)
    GEOTHERMAL # GEO     # Geothermal
    OTHER # OTH     # Other
end

IS.@scoped_enum StateType begin
    Differential
    Algebraic
    Hybrid
end

PS_MAX_LOG = parse(Int, get(ENV, "PS_MAX_LOG", "50"))
DEFAULT_BASE_MVA = 100.0

const POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE =
    joinpath(dirname(pathof(PowerSystems)), "descriptors", "power_system_structs.json")

const DEFAULT_SYSTEM_FREQUENCY = 60.0

const INFINITE_TIME = 1e6
const START_COST = 1e8
