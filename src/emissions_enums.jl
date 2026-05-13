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

# Values
- `CO2 = 1`: Carbon dioxide
- `CO2E = 2`: Carbon dioxide equivalent
- `CH4 = 3`: Methane
- `N2O = 4`: Nitrous oxide
- `NOX = 10`: Nitrogen oxides
- `SO2 = 11`: Sulfur dioxide
- `PM25 = 20`: Particulate matter (2.5 μm)
- `PM10 = 21`: Particulate matter (10 μm)
- `HG = 30`: Mercury
- `HAP = 40`: Hazardous air pollutants
- `CUSTOM = 99`: User-defined pollutant
""" PollutantType

IS.@scoped_enum(
    EmissionBasis,
    FUEL_INPUT = 1,
    POWER_OUTPUT = 2,
)
@doc """
Enumeration of emission rate basis types.

# Values
- `FUEL_INPUT = 1`: Mass per unit of heat input (e.g., lb/MMBtu, kg/GJ)
- `POWER_OUTPUT = 2`: Mass per unit of electrical output (e.g., lb/MWh, kg/MWh)
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

# Values
- `KG = 1`: Kilograms
- `LB = 2`: Pounds
- `SHORT_TON = 3`: Short tons (2000 lb)
- `METRIC_TON = 4`: Metric tons (1000 kg)
""" MassUnit

IS.@scoped_enum(
    EnergyUnit,
    MMBTU = 1,
    GJ = 2,
    MWH = 3,
)
@doc """
Enumeration of energy units for emissions rate denominator.

# Values
- `MMBTU = 1`: Million British thermal units
- `GJ = 2`: Gigajoules
- `MWH = 3`: Megawatt-hours
""" EnergyUnit
