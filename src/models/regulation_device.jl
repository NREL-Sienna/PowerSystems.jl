"""
Parametric struct to allow Injection Devices to be used in regulation services.
Extends the device type and provides additional fields relevant to regulation services.
"""
mutable struct RegulationDevice{T <: StaticInjection} <: Device
    device::T
    droop::Float64
    participation_factor::NamedTuple{(:up, :dn), Tuple{Float64, Float64}}
    reserve_limit_up::Float64
    reserve_limit_dn::Float64
    inertia::Float64
    cost::Float64
    forecasts::IS.Forecasts
    internal::IS.InfrastructureSystemsInternal

    function RegulationDevice{T}(
        device::T,
        droop::Float64,
        participation_factor::NamedTuple{(:up, :dn), Tuple{Float64, Float64}},
        reserve_limit_up::Float64,
        reserve_limit_dn::Float64,
        inertia::Float64,
        cost::Float64,
        forecasts::IS.Forecasts = IS.Forecasts(),
        internal::IS.InfrastructureSystemsInternal = IS.InfrastructureSystemsInternal(),
    ) where {T <: StaticInjection}
        # Note that forecasts are not forwarded to T. They get copied from T in
        # handle_component_addition!.
        new{T}(
            device,
            droop,
            participation_factor,
            reserve_limit_up,
            reserve_limit_dn,
            inertia,
            cost,
            forecasts,
            internal,
        )
    end
end

"""
Default constructor for the Regulation Device
"""
function RegulationDevice(
    device::T;
    droop::Float64 = Inf,
    participation_factor::NamedTuple{(:up, :dn), Tuple{Float64, Float64}} = (
        up = 0.0,
        dn = 0.0,
    ),
    reserve_limit_up::Float64 = 0.0,
    reserve_limit_dn::Float64 = 0.0,
    inertia::Float64 = 0.0,
    cost::Float64 = 1.0,
) where {T <: StaticInjection}
    return RegulationDevice{T}(
        device,
        droop,
        participation_factor,
        reserve_limit_up,
        reserve_limit_dn,
        inertia,
        cost,
    )
end

function RegulationDevice(;
    device::T,
    droop::Float64 = Inf,
    participation_factor::NamedTuple{(:up, :dn), Tuple{Float64, Float64}} = (
        up = 0.0,
        dn = 0.0,
    ),
    reserve_limit_up::Float64 = 0.0,
    reserve_limit_dn::Float64 = 0.0,
    inertia::Float64 = 0.0,
    cost::Float64 = 1.0,
    forecasts = IS.Forecasts(),
    internal = IS.InfrastructureSystemsInternal(),
) where {T <: StaticInjection}
    return RegulationDevice{T}(
        device,
        droop,
        participation_factor,
        reserve_limit_up,
        reserve_limit_dn,
        inertia,
        cost,
        forecasts,
        internal,
    )
end

const STATIC_INJECTOR_TYPE_KEY = "__static_injector_type"

function IS.serialize(component::T) where {T <: RegulationDevice}
    data = Dict{String, Any}()
    for name in fieldnames(T)
        val = getfield(component, name)
        if val isa StaticInjection
            # The device is not attached to the system, so serialize it and save the type.
            data[STATIC_INJECTOR_TYPE_KEY] = string(typeof(val))
        end
        data[string(name)] = serialize_uuid_handling(val)
    end

    return data
end

function IS.deserialize(
    ::Type{T},
    data::Dict,
    component_cache::Dict,
) where {T <: RegulationDevice}
    @debug T data
    vals = Dict{Symbol, Any}()
    for (name, type) in zip(fieldnames(T), fieldtypes(T))
        val = data[string(name)]
        if val === nothing
            vals[name] = val
        elseif type <: StaticInjection
            type = get_component_type(data[STATIC_INJECTOR_TYPE_KEY])
            vals[name] = deserialize(type, val, component_cache)
        else
            vals[name] = deserialize_uuid_handling(type, name, val, component_cache)
        end
    end

    return RegulationDevice(; vals...)
end

IS.get_forecasts(value::RegulationDevice) = value.forecasts
IS.get_name(value::RegulationDevice) = IS.get_name(value.device)
get_internal(value::RegulationDevice) = value.internal
get_droop(value::RegulationDevice) = value.droop
get_participation_factor(value::RegulationDevice) = value.participation_factor
get_reserve_limit_up(value::RegulationDevice) = value.reserve_limit_up
get_reserve_limit_dn(value::RegulationDevice) = value.reserve_limit_dn
get_inertia(value::RegulationDevice) = value.inertia
get_cost(value::RegulationDevice) = value.cost
get_units_setting(value::RegulationDevice) = value.device.internal.units_info

set_droop!(value::RegulationDevice, val::Float64) = value.droop = val
set_participation_factor!(
    value::RegulationDevice,
    val::NamedTuple{(:up, :dn), Tuple{Float64, Float64}},
) = value.participation_factor = val
set_reserve_limit_up!(value::RegulationDevice, val::Float64) = value.reserve_limit_up = val
set_reserve_limit_dn!(value::RegulationDevice, val::Float64) = value.reserve_limit_dn = val
set_inertia!(value::RegulationDevice, val::Float64) = value.inertia = val
set_cost!(value::RegulationDevice, val::Float64) = value.cost = val
IS.set_forecasts!(value::RegulationDevice, val::IS.Forecasts) = value.forecasts = val
function set_unit_system!(value::RegulationDevice, settings::SystemUnitsSettings)
    value.internal.units_info = value.device.internal.units_info = settings
    return
end

RegulationDeviceSupportedTypes = DataType[
    InterruptibleLoad,
    HydroDispatch,
    HydroEnergyReservoir,
    RenewableDispatch,
    ThermalMultiStart,
    ThermalStandard,
    Source,
    GenericBattery,
]

for RDT in RegulationDeviceSupportedTypes
    IS.@forward(
        (RegulationDevice{RDT}, :device),
        RDT,
        [:get_internal, :get_name, :get_forecasts]
    )
end
