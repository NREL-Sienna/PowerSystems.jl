abstract type DynamicInverterComponent <: DynamicComponent end
abstract type Converter <: DynamicInverterComponent end
abstract type DCSource <: DynamicInverterComponent end
abstract type Filter <: DynamicInverterComponent end
abstract type FrequencyEstimator <: DynamicInverterComponent end
abstract type InnerControl <: DynamicInverterComponent end
abstract type OutputCurrentLimiter <: DynamicInverterComponent end

abstract type ActivePowerControl <: DeviceParameter end
abstract type ReactivePowerControl <: DeviceParameter end
