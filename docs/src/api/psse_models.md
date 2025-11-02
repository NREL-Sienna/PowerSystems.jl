# [Supported PSS/e Models](@id psse_models_ref)

PSS/e's dynamic model library is extensive. `PowerSystems.jl` currently supports parsing the following models for version 5.0:

## Dynamic Generator Models

### Machine Models

| PSS/e Model | PowerSystems Component |
|:----------- |:---------------------- |
| GENSAE      | SalientPoleExponential |
| GENSAL      | SalientPoleQuadratic   |
| GENROE      | RoundRotorExponential  |
| GENCLS      | BaseMachine            |
| GENROU      | RoundRotorQuadratic    |

### Automatic Voltage Regulator (AVR) Models

| PSS/e Model | PowerSystems Component |
|:----------- |:---------------------- |
| IEEET1      | IEEET1                 |
| ESDC1A      | ESDC1A                 |
| ESDC2A      | ESDC2A                 |
| ESAC1A      | ESAC1A                 |
| ESAC6A      | ESAC6A                 |
| ESAC8B      | ESAC8B                 |
| EXAC1       | EXAC1                  |
| EXAC1A      | EXAC1A                 |
| EXAC2       | EXAC2                  |
| EXPIC1      | EXPIC1                 |
| ESST1A      | ESST1A                 |
| ESST4B      | ESST4B                 |
| SCRX        | SCRX                   |
| SEXS        | SEXS                   |
| EXST1       | EXST1                  |
| ST6B        | ST6B                   |
| ST8C        | ST8C                   |

### Turbine Governor Models

| PSS/e Model | PowerSystems Component   |
|:----------- |:------------------------ |
| GAST        | GasTG                    |
| GGOV1       | GeneralGovModel          |
| HYGOV       | HydroTurbineGov          |
| IEEEG1      | IEEETurbineGov1          |
| TGOV1       | SteamTurbineGov1         |
| TGOV1DU     | TGOV1DU                  |
| DEGOV1      | DEGOV1                   |
| PIDGOV      | PIDGOV                   |
| WPIDHY      | WPIDHY                   |

### Power System Stabilizer (PSS) Models

| PSS/e Model | PowerSystems Component |
|:----------- |:---------------------- |
| IEEEST      | IEEEST                 |
| STAB1       | STAB1                  |

## Dynamic Inverter Models

### Converter Models

| PSS/e Model | PowerSystems Component          |
|:----------- |:------------------------------- |
| REGCA1      | RenewableEnergyConverterTypeA   |

### Active and Reactive Power Control Models

| PSS/e Model | PowerSystems Component          |
|:----------- |:------------------------------- |
| REECB1      | ActiveRenewableControllerAB, ReactiveRenewableControllerAB, RECurrentControlB |
| REPCA1      | ActiveRenewableControllerAB, ReactiveRenewableControllerAB |

## Additional Models

| PSS/e Model | PowerSystems Component              |
|:----------- |:----------------------------------- |
| DERA1       | AggregateDistributedGenerationA     |

## See also

  - Parsing [PSS/e dynamic data](@ref dyr_data)
  - Parsing [Matpower or PSS/e RAW Files](@ref pm_data)
