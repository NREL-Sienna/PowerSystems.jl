abstract type DynamicInverterComponent <: DynamicComponent end
abstract type Converter <: DynamicInverterComponent end
abstract type DCSource <: DynamicInverterComponent end
abstract type Filter <: DynamicInverterComponent end
abstract type FrequencyEstimator <: DynamicInverterComponent end
abstract type InnerControl <: DynamicInverterComponent end

abstract type ActivePowerControl <: DeviceParameter end
abstract type ReactivePowerControl <: DeviceParameter end

"""
Parameters of a Outer-Loop controller using a virtual inertia with VSM for active power controller
and a reactive power droop controller.
# Conmutable structor
```julia
VirtualInertiaQDroop(A, R)
```
# Arguments
*  `A`::Float64 : Active power controller using virtual inertia with VSM
*  `R`::Float64 : Reactive power controller using reactive power droop
"""
mutable struct OuterControl{A <: ActivePowerControl, R <: ReactivePowerControl} <:
               DynamicInverterComponent
    active_power::A
    reactive_power::R
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
end

function OuterControl(
    active_power::A,
    reactive_power::R,
    ext = Dict{String, Any}(),
) where {A <: ActivePowerControl, R <: ReactivePowerControl}
    OuterControl(
        active_power,
        reactive_power,
        ext,
        vcat(active_power.states, reactive_power.states),
        active_power.n_states + reactive_power.n_states,
    )
end

function OuterControl(; active_power, reactive_power, ext = Dict{String, Any}())
    OuterControl(active_power, reactive_power, ext)
end

get_active_power(value::OuterControl) = value.active_power
get_reactive_power(value::OuterControl) = value.reactive_power
get_ext(value::OuterControl) = value.ext
get_states(value::OuterControl) = value.states
get_n_states(value::OuterControl) = value.n_states
