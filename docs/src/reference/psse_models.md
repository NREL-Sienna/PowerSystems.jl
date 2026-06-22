# [Supported PSS/e Models](@id psse_models_ref)

PSS/e's dynamic model library is extensive. `PowerSystems.jl` currently supports parsing the following models for version 5.0:

## Dynamic Generator Models

### Machine Models

| PSS/e Model | PowerSystems Component           |
|:----------- |:-------------------------------- |
| GENSAE      | [`SalientPoleExponential`](@ref) |
| GENSAL      | [`SalientPoleQuadratic`](@ref)   |
| GENROE      | [`RoundRotorExponential`](@ref)  |
| GENCLS      | [`BaseMachine`](@ref)            |
| GENROU      | [`RoundRotorQuadratic`](@ref)    |

### Automatic Voltage Regulator (AVR) Models

| PSS/e Model | PowerSystems Component |
|:----------- |:---------------------- |
| IEEET1      | [`IEEET1`](@ref)       |
| ESDC1A      | [`ESDC1A`](@ref)       |
| ESDC2A      | [`ESDC2A`](@ref)       |
| ESAC1A      | [`ESAC1A`](@ref)       |
| ESAC6A      | [`ESAC6A`](@ref)       |
| ESAC8B      | [`ESAC8B`](@ref)       |
| EXAC1       | [`EXAC1`](@ref)        |
| EXAC1A      | [`EXAC1A`](@ref)       |
| EXAC2       | [`EXAC2`](@ref)        |
| EXPIC1      | [`EXPIC1`](@ref)       |
| ESST1A      | [`ESST1A`](@ref)       |
| ESST4B      | [`ESST4B`](@ref)       |
| SCRX        | [`SCRX`](@ref)         |
| SEXS        | [`SEXS`](@ref)         |
| EXST1       | [`EXST1`](@ref)        |
| ST6B        | [`ST6B`](@ref)         |
| ST8C        | [`ST8C`](@ref)         |

### Turbine Governor Models

| PSS/e Model | PowerSystems Component     |
|:----------- |:-------------------------- |
| GAST        | [`GasTG`](@ref)            |
| GGOV1       | [`GeneralGovModel`](@ref)  |
| HYGOV       | [`HydroTurbineGov`](@ref)  |
| IEEEG1      | [`IEEETurbineGov1`](@ref)  |
| TGOV1       | [`SteamTurbineGov1`](@ref) |
| TGOV1DU     | [`SteamTurbineGov1`](@ref) |
| DEGOV1      | [`DEGOV1`](@ref)           |
| PIDGOV      | [`PIDGOV`](@ref)           |
| WPIDHY      | [`WPIDHY`](@ref)           |

### Power System Stabilizer (PSS) Models

| PSS/e Model | PowerSystems Component |
|:----------- |:---------------------- |
| IEEEST      | [`IEEEST`](@ref)       |
| STAB1       | [`STAB1`](@ref)        |

## Dynamic Inverter Models

### Converter Models

| PSS/e Model | PowerSystems Component                  |
|:----------- |:--------------------------------------- |
| REGCA1      | [`RenewableEnergyConverterTypeA`](@ref) |

### Active and Reactive Power Control Models

| PSS/e Model | PowerSystems Component                                                                                      |
|:----------- |:----------------------------------------------------------------------------------------------------------- |
| REECB1      | [`ActiveRenewableControllerAB`](@ref), [`ReactiveRenewableControllerAB`](@ref), [`RECurrentControlB`](@ref) |
| REPCA1      | [`ActiveRenewableControllerAB`](@ref), [`ReactiveRenewableControllerAB`](@ref)                              |

## Additional Models

| PSS/e Model | PowerSystems Component                    |
|:----------- |:----------------------------------------- |
| DERA1       | [`AggregateDistributedGenerationA`](@ref) |

## See also

  - Parsing [PSS/e dynamic data](@ref dyr_data)
  - Parsing [Matpower or PSS/e RAW Files](@ref pm_data)
