|  Struct Name  |  Field Name  |  DataType  |  Min  |  Max  |  Action  |
|---------------|--------------|------------|-------|-------|----------|
|TwoPartCost|variable|VariableCost|-|-|-
|TwoPartCost|fixed|Float64|-|-|-
|TwoPartCost|internal|PowerSystems.PowerSystemInternal|-|-|-
|ThreePartCost|variable|VariableCost|-|-|-
|ThreePartCost|fixed|Float64|-|-|-
|ThreePartCost|startup|Float64|0.0|null|warn|
|ThreePartCost|shutdn|Float64|0.0|null|warn|
|ThreePartCost|internal|PowerSystems.PowerSystemInternal|-|-|-
|TechHydro|rating|Float64|0.0|null|error|
|TechHydro|activepower|Float64|activepowerlimits|activepowerlimits|warn|
|TechHydro|activepowerlimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|TechHydro|reactivepower|Float64|reactivepowerlimits|reactivepowerlimits|warn|
|TechHydro|reactivepowerlimits|Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}|-|-|-
|TechHydro|ramplimits|Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}|0.0|null|error|
|TechHydro|timelimits|Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}|0.0|null|error|
|TechHydro|internal|PowerSystems.PowerSystemInternal|-|-|-
|TechRenewable|rating|Float64|0.0|null|error|
|TechRenewable|reactivepower|Float64|reactivepowerlimits|reactivepowerlimits|warn|
|TechRenewable|reactivepowerlimits|Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}|-|-|-
|TechRenewable|powerfactor|Float64|0.0|1.0|error|
|TechRenewable|internal|PowerSystems.PowerSystemInternal|-|-|-
|TechThermal|rating|Float64|0.0|null|error|
|TechThermal|activepower|Float64|activepowerlimits|activepowerlimits|warn|
|TechThermal|activepowerlimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|TechThermal|reactivepower|Float64|reactivepowerlimits|reactivepowerlimits|warn|
|TechThermal|reactivepowerlimits|Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}|-|-|-
|TechThermal|ramplimits|Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}|0.0|null|error|
|TechThermal|timelimits|Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}|0.0|null|error|
|TechThermal|internal|PowerSystems.PowerSystemInternal|-|-|-
|Bus|number|Int64|-|-|-
|Bus|name|String|-|-|-
|Bus|bustype|Union{Nothing, BusType}|-|-|-
|Bus|angle|Union{Nothing, Float64}|-1.571|1.571|error|
|Bus|voltage|Union{Nothing, Float64}|voltagelimits|voltagelimits|warn|
|Bus|voltagelimits|Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}|-|-|-
|Bus|basevoltage|Union{Nothing, Float64}|0.0|null|error|
|Bus|internal|PowerSystems.PowerSystemInternal|-|-|-
|Arch|from|Bus|-|-|-
|Arch|to|Bus|-|-|-
|Arch|internal|PowerSystems.PowerSystemInternal|-|-|-
|Line|name|String|-|-|-
|Line|available|Bool|-|-|-
|Line|arch|Arch|-|-|-
|Line|r|Float64|0.0|2.0|error|
|Line|x|Float64|0.0|2.0|error|
|Line|b|NamedTuple{(:from, :to), Tuple{Float64, Float64}}|0.0|100.0|error|
|Line|rate|Float64|-|-|-
|Line|anglelimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-3.142|3.142|error|
|Line|internal|PowerSystems.PowerSystemInternal|-|-|-
|MonitoredLine|name|String|-|-|-
|MonitoredLine|available|Bool|-|-|-
|MonitoredLine|arch|Arch|-|-|-
|MonitoredLine|r|Float64|0.0|2.0|error|
|MonitoredLine|x|Float64|0.0|2.0|error|
|MonitoredLine|b|NamedTuple{(:from, :to), Tuple{Float64, Float64}}|0.0|2.0|error|
|MonitoredLine|flowlimits|NamedTuple{(:from_to, :to_from), Tuple{Float64, Float64}}|-|-|-
|MonitoredLine|rate|Float64|-|-|-
|MonitoredLine|anglelimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-3.142|3.142|error|
|MonitoredLine|internal|PowerSystems.PowerSystemInternal|-|-|-
|PhaseShiftingTransformer|name|String|-|-|-
|PhaseShiftingTransformer|available|Bool|-|-|-
|PhaseShiftingTransformer|arch|Arch|-|-|-
|PhaseShiftingTransformer|r|Float64|0.0|2.0|error|
|PhaseShiftingTransformer|x|Float64|0.0|2.0|error|
|PhaseShiftingTransformer|primaryshunt|Float64|0.0|2.0|error|
|PhaseShiftingTransformer|tap|Float64|0.0|2.0|error|
|PhaseShiftingTransformer|α|Float64|-3.142|3.142|warn|
|PhaseShiftingTransformer|rate|Union{Nothing, Float64}|0.0|null|error|
|PhaseShiftingTransformer|internal|PowerSystems.PowerSystemInternal|-|-|-
|TapTransformer|name|String|-|-|-
|TapTransformer|available|Bool|-|-|-
|TapTransformer|arch|Arch|-|-|-
|TapTransformer|r|Float64|-2.0|2.0|error|
|TapTransformer|x|Float64|-2.0|2.0|error|
|TapTransformer|primaryshunt|Float64|0.0|2.0|error|
|TapTransformer|tap|Float64|0.0|2.0|error|
|TapTransformer|rate|Union{Nothing, Float64}|0.0|null|error|
|TapTransformer|internal|PowerSystems.PowerSystemInternal|-|-|-
|Transformer2W|name|String|-|-|-
|Transformer2W|available|Bool|-|-|-
|Transformer2W|arch|Arch|-|-|-
|Transformer2W|r|Float64|-2.0|2.5|error|
|Transformer2W|x|Float64|-2.0|2.5|error|
|Transformer2W|primaryshunt|Float64|0.0|2.0|error|
|Transformer2W|rate|Union{Nothing, Float64}|0.0|null|error|
|Transformer2W|internal|PowerSystems.PowerSystemInternal|-|-|-
|HVDCLine|name|String|-|-|-
|HVDCLine|available|Bool|-|-|-
|HVDCLine|arch|Arch|-|-|-
|HVDCLine|activepowerlimits_from|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|HVDCLine|activepowerlimits_to|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|HVDCLine|reactivepowerlimits_from|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|HVDCLine|reactivepowerlimits_to|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|HVDCLine|loss|NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}|-|-|-
|HVDCLine|internal|PowerSystems.PowerSystemInternal|-|-|-
|VSCDCLine|name|String|-|-|-
|VSCDCLine|available|Bool|-|-|-
|VSCDCLine|arch|Arch|-|-|-
|VSCDCLine|rectifier_taplimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|VSCDCLine|rectifier_xrc|Float64|-|-|-
|VSCDCLine|rectifier_firingangle|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|VSCDCLine|inverter_taplimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|VSCDCLine|inverter_xrc|Float64|-|-|-
|VSCDCLine|inverter_firingangle|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|-|-|-
|VSCDCLine|internal|PowerSystems.PowerSystemInternal|-|-|-
|InterruptibleLoad|name|String|-|-|-
|InterruptibleLoad|available|Bool|-|-|-
|InterruptibleLoad|bus|Bus|-|-|-
|InterruptibleLoad|model|String|-|-|-
|InterruptibleLoad|maxactivepower|Float64|-|-|-
|InterruptibleLoad|maxreactivepower|Float64|-|-|-
|InterruptibleLoad|op_cost|TwoPartCost|-|-|-
|InterruptibleLoad|internal|PowerSystems.PowerSystemInternal|-|-|-
|FixedAdmittance|name|String|-|-|-
|FixedAdmittance|available|Bool|-|-|-
|FixedAdmittance|bus|Bus|-|-|-
|FixedAdmittance|Y|Complex{Float64}|-|-|-
|FixedAdmittance|internal|PowerSystems.PowerSystemInternal|-|-|-
|PowerLoad|name|String|-|-|-
|PowerLoad|available|Bool|-|-|-
|PowerLoad|bus|Bus|-|-|-
|PowerLoad|maxactivepower|Float64|-|-|-
|PowerLoad|maxreactivepower|Float64|-|-|-
|PowerLoad|internal|PowerSystems.PowerSystemInternal|-|-|-
|HydroDispatch|name|String|-|-|-
|HydroDispatch|available|Bool|-|-|-
|HydroDispatch|bus|Bus|-|-|-
|HydroDispatch|tech|TechHydro|-|-|-
|HydroDispatch|op_cost|TwoPartCost|-|-|-
|HydroDispatch|internal|PowerSystems.PowerSystemInternal|-|-|-
|HydroFix|name|String|-|-|-
|HydroFix|available|Bool|-|-|-
|HydroFix|bus|Bus|-|-|-
|HydroFix|tech|TechHydro|-|-|-
|HydroFix|internal|PowerSystems.PowerSystemInternal|-|-|-
|HydroStorage|name|String|-|-|-
|HydroStorage|available|Bool|-|-|-
|HydroStorage|bus|Bus|-|-|-
|HydroStorage|tech|TechHydro|-|-|-
|HydroStorage|op_cost|TwoPartCost|-|-|-
|HydroStorage|storagecapacity|Float64|0.0|null|error|
|HydroStorage|initial_storage|Float64|0.0|null|error|
|HydroStorage|internal|PowerSystems.PowerSystemInternal|-|-|-
|RenewableDispatch|name|String|-|-|-
|RenewableDispatch|available|Bool|-|-|-
|RenewableDispatch|bus|Bus|-|-|-
|RenewableDispatch|tech|TechRenewable|-|-|-
|RenewableDispatch|op_cost|TwoPartCost|-|-|-
|RenewableDispatch|internal|PowerSystems.PowerSystemInternal|-|-|-
|RenewableFix|name|String|-|-|-
|RenewableFix|available|Bool|-|-|-
|RenewableFix|bus|Bus|-|-|-
|RenewableFix|tech|TechRenewable|-|-|-
|RenewableFix|internal|PowerSystems.PowerSystemInternal|-|-|-
|ThermalStandard|name|String|-|-|-
|ThermalStandard|available|Bool|-|-|-
|ThermalStandard|bus|Bus|-|-|-
|ThermalStandard|tech|Union{Nothing, TechThermal}|-|-|-
|ThermalStandard|op_cost|ThreePartCost|-|-|-
|ThermalStandard|internal|PowerSystems.PowerSystemInternal|-|-|-
|LoadZones|number|Int64|-|-|-
|LoadZones|name|String|-|-|-
|LoadZones|buses|Vector{Bus}|-|-|-
|LoadZones|maxactivepower|Float64|-|-|-
|LoadZones|maxreactivepower|Float64|-|-|-
|LoadZones|internal|PowerSystems.PowerSystemInternal|-|-|-
|GenericBattery|name|String|-|-|-
|GenericBattery|available|Bool|-|-|-
|GenericBattery|bus|Bus|-|-|-
|GenericBattery|energy|Float64|0.0|null|error|
|GenericBattery|capacity|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|0.0|null|error|
|GenericBattery|rating|Float64|-|-|-
|GenericBattery|activepower|Float64|-|-|-
|GenericBattery|inputactivepowerlimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|0.0|null|error|
|GenericBattery|outputactivepowerlimits|NamedTuple{(:min, :max), Tuple{Float64, Float64}}|0.0|null|error|
|GenericBattery|efficiency|NamedTuple{(:in, :out), Tuple{Float64, Float64}}|0.0|1.0|warn|
|GenericBattery|reactivepower|Float64|-|-|-
|GenericBattery|reactivepowerlimits|Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}|-|-|-
|GenericBattery|internal|PowerSystems.PowerSystemInternal|-|-|-
|ProportionalReserve|name|String|-|-|-
|ProportionalReserve|contributingdevices|Vector{Device}|-|-|-
|ProportionalReserve|timeframe|Float64|0.0|null|error|
|ProportionalReserve|internal|PowerSystems.PowerSystemInternal|-|-|-
|StaticReserve|name|String|-|-|-
|StaticReserve|contributingdevices|Vector{Device}|-|-|-
|StaticReserve|timeframe|Float64|0.0|null|error|
|StaticReserve|requirement|Float64|-|-|-
|StaticReserve|internal|PowerSystems.PowerSystemInternal|-|-|-
|Transfer|name|String|-|-|-
|Transfer|contributingdevices|Vector{Device}|-|-|-
|Transfer|timeframe|Float64|0.0|null|error|
|Transfer|requirement|TimeSeries.TimeArray|-|-|-
|Transfer|internal|PowerSystems.PowerSystemInternal|-|-|-
|Deterministic|component|T|-|-|-
|Deterministic|label|String|-|-|-
|Deterministic|resolution|Dates.Period|-|-|-
|Deterministic|initial_time|Dates.DateTime|-|-|-
|Deterministic|data|TimeSeries.TimeArray|-|-|-
|Deterministic|start_index|Int|-|-|-
|Deterministic|horizon|Int|-|-|-
|Deterministic|internal|PowerSystems.PowerSystemInternal|-|-|-
|Probabilistic|component|T|-|-|-
|Probabilistic|label|String|-|-|-
|Probabilistic|resolution|Dates.Period|-|-|-
|Probabilistic|initial_time|Dates.DateTime|-|-|-
|Probabilistic|probabilities|Vector{Float64}|-|-|-
|Probabilistic|data|TimeSeries.TimeArray|-|-|-
|Probabilistic|start_index|Int|-|-|-
|Probabilistic|horizon|Int|-|-|-
|Probabilistic|internal|PowerSystems.PowerSystemInternal|-|-|-
