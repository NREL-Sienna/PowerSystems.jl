abstract type DynamicInverterComponent <: DynamicComponent end
abstract type Converter <: DynamicInverterComponent end
abstract type DCSource <: DynamicInverterComponent end
abstract type Filter <: DynamicInverterComponent end
abstract type FrequencyEstimator <: DynamicInverterComponent end
abstract type VSControl <: DynamicInverterComponent end

abstract type OuterControl <: DynamicInverterComponent end
abstract type ActivePowerControl end
abstract type ReactivePowerControl end

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
mutable struct VirtualInertiaQdroop{A <: ActivePowerControl,
                                    R <: ReactivePowerControl} <: OuterControl
    active_power::A
    reactive_power::R
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VirtualInertiaQdroop(active_power::A,
                              reactive_power::R,
                              ext=Dict{String, Any}()) where {A <: ActivePowerControl,
                                                              R <: ReactivePowerControl}
    VirtualInertiaQdroop(active_power,
                         reactive_power,
                         ext,
                         active_power.n_states + reactive_power.n_states,
                         vcat(active_power.states, reactive_power.states),
                         InfrastructureSystemsInternal())
end

function VirtualInertiaQdroop(; active_power, reactive_power, ext=Dict{String, Any}())
    VirtualInertiaQdroop(active_power, reactive_power, ext)
end

get_active_power(value::VirtualInertiaQdroop) = value.active_power
get_reactive_power(value::VirtualInertiaQdroop) = value.reactive_power
get_ext(value::VirtualInertiaQdroop) = value.ext
get_states(value::VirtualInertiaQdroop) = value.states
get_n_states(value::VirtualInertiaQdroop) = value.n_states
get_internal(value::VirtualInertiaQdroop) = value.internal
