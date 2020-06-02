mutable struct RegulationDevice{T <: StaticInjection} <: Device
    device::T
    droop::Float64
    participation_factor::Float64
    reserve_limit::Float64
    inertia::Float64

    function RegulationDevice{T}(
        device::T,
        droop::Float64,
        participation_factor::Float64,
        reserve_limit::Float64,
        inertia::Float64,
    ) where {T <: StaticInjection}
        IS.@forward((RegulationDevice{T}, :device), T)
        new{T}(device, droop, participation_factor, reserve_limit, inertia)
    end
end

function RegulationDevice(
    device::T;
    droop::Float64 = Inf,
    participation_factor::Float64 = 0.0,
    reserve_limit::Float64 = 0.0,
    inertia::Float64 = 0.0,
) where {T <: StaticInjection}
    return RegulationDevice{T}(device, droop, participation_factor, reserve_limit, inertia)
end

IS.get_name(value::RegulationDevice) = IS.get_name(value.device)
IS.get_uuid(value::RegulationDevice) = IS.get_uuid(value.device)
get_droop(value::RegulationDevice) = value.droop
get_participation_factor(value::RegulationDevice) = value.participation_factor
get_reserve_limit(value::RegulationDevice) = value.reserve_limit
get_inertia(value::RegulationDevice) = value.inertia

set_droop!(value::RegulationDevice, val::Float64) = value.droop = val
set_participation_factor!(value::RegulationDevice, val::Float64) =
    value.participation_factor = val
set_reserve_limit!(value::RegulationDevice, val::Float64) = value.reserve_limit = val
set_inertia!(value::RegulationDevice, val::Float64) = value.inertia = val
