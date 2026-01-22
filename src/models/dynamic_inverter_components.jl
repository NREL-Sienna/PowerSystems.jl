"""Supertype for components that compose a [`DynamicInverter`](@ref)"""
abstract type DynamicInverterComponent <: DynamicComponent end
"""Supertype for converter models that define pulse width modulation (PWM) or space vector modulation (SVM) dynamics"""
abstract type Converter <: DynamicInverterComponent end
"""Supertype for DC source models that define dynamics of the DC side of the converter"""
abstract type DCSource <: DynamicInverterComponent end
"""Supertype for filter models that connect the converter output to the grid"""
abstract type Filter <: DynamicInverterComponent end
"""Supertype for frequency estimator models (typically PLLs) that estimate grid frequency from voltage measurements"""
abstract type FrequencyEstimator <: DynamicInverterComponent end
"""Supertype for inner control loop models that define virtual impedance, voltage control, and current control dynamics"""
abstract type InnerControl <: DynamicInverterComponent end
"""Supertype for output current limiter models that constrain inverter output current"""
abstract type OutputCurrentLimiter <: DynamicInverterComponent end

abstract type ActivePowerControl <: DeviceParameter end
abstract type ReactivePowerControl <: DeviceParameter end
