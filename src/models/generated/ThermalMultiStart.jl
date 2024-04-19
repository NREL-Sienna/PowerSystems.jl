#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ThermalMultiStart <: ThermalGen
        name::String
        available::Bool
        status::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover_type::PrimeMovers
        fuel::ThermalFuels
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        ramp_limits::Union{Nothing, UpDown}
        power_trajectory::Union{Nothing, StartUpShutDown}
        time_limits::Union{Nothing, UpDown}
        start_time_limits::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}
        start_types::Int
        operation_cost::OperationalCost
        base_power::Float64
        services::Vector{Service}
        time_at_status::Float64
        must_run::Bool
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

Data Structure for thermal generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `status::Bool`
- `bus::ACBus`
- `active_power::Float64`, validation range: `active_power_limits`, action if invalid: `warn`
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923
- `fuel::ThermalFuels`: Prime mover fuel according to EIA 923
- `active_power_limits::MinMax`
- `reactive_power_limits::Union{Nothing, MinMax}`
- `ramp_limits::Union{Nothing, UpDown}`, validation range: `(0, nothing)`, action if invalid: `error`
- `power_trajectory::Union{Nothing, StartUpShutDown}`: Power trajectory the unit will take during the start-up and shut-down ramp process, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `start_time_limits::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}`:  Time limits for start-up based on turbine temperature in hours
- `start_types::Int`:  Number of start-up based on turbine temperature, validation range: `(1, 3)`, action if invalid: `error`
- `operation_cost::OperationalCost`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `services::Vector{Service}`: Services that this device contributes to
- `time_at_status::Float64`
- `must_run::Bool`
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThermalMultiStart <: ThermalGen
    name::String
    available::Bool
    status::Bool
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Prime mover technology according to EIA 923"
    prime_mover_type::PrimeMovers
    "Prime mover fuel according to EIA 923"
    fuel::ThermalFuels
    active_power_limits::MinMax
    reactive_power_limits::Union{Nothing, MinMax}
    ramp_limits::Union{Nothing, UpDown}
    "Power trajectory the unit will take during the start-up and shut-down ramp process"
    power_trajectory::Union{Nothing, StartUpShutDown}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, UpDown}
    " Time limits for start-up based on turbine temperature in hours"
    start_time_limits::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}
    " Number of start-up based on turbine temperature"
    start_types::Int
    operation_cost::OperationalCost
    "Base power of the unit in MVA"
    base_power::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    time_at_status::Float64
    must_run::Bool
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalMultiStart(name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services=Device[], time_at_status=INFINITE_TIME, must_run=false, dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    ThermalMultiStart(name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services, time_at_status, must_run, dynamic_injector, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function ThermalMultiStart(; name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services=Device[], time_at_status=INFINITE_TIME, must_run=false, dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    ThermalMultiStart(name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services, time_at_status, must_run, dynamic_injector, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function ThermalMultiStart(::Nothing)
    ThermalMultiStart(;
        name="init",
        available=false,
        status=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover_type=PrimeMovers.OT,
        fuel=ThermalFuels.OTHER,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        ramp_limits=nothing,
        power_trajectory=nothing,
        time_limits=nothing,
        start_time_limits=nothing,
        start_types=1,
        operation_cost=MultiStartCost(nothing),
        base_power=0.0,
        services=Device[],
        time_at_status=INFINITE_TIME,
        must_run=false,
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`ThermalMultiStart`](@ref) `name`."""
get_name(value::ThermalMultiStart) = value.name
"""Get [`ThermalMultiStart`](@ref) `available`."""
get_available(value::ThermalMultiStart) = value.available
"""Get [`ThermalMultiStart`](@ref) `status`."""
get_status(value::ThermalMultiStart) = value.status
"""Get [`ThermalMultiStart`](@ref) `bus`."""
get_bus(value::ThermalMultiStart) = value.bus
"""Get [`ThermalMultiStart`](@ref) `active_power`."""
get_active_power(value::ThermalMultiStart) = get_value(value, value.active_power)
"""Get [`ThermalMultiStart`](@ref) `reactive_power`."""
get_reactive_power(value::ThermalMultiStart) = get_value(value, value.reactive_power)
"""Get [`ThermalMultiStart`](@ref) `rating`."""
get_rating(value::ThermalMultiStart) = get_value(value, value.rating)
"""Get [`ThermalMultiStart`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::ThermalMultiStart) = value.prime_mover_type
"""Get [`ThermalMultiStart`](@ref) `fuel`."""
get_fuel(value::ThermalMultiStart) = value.fuel
"""Get [`ThermalMultiStart`](@ref) `active_power_limits`."""
get_active_power_limits(value::ThermalMultiStart) = get_value(value, value.active_power_limits)
"""Get [`ThermalMultiStart`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::ThermalMultiStart) = get_value(value, value.reactive_power_limits)
"""Get [`ThermalMultiStart`](@ref) `ramp_limits`."""
get_ramp_limits(value::ThermalMultiStart) = get_value(value, value.ramp_limits)
"""Get [`ThermalMultiStart`](@ref) `power_trajectory`."""
get_power_trajectory(value::ThermalMultiStart) = get_value(value, value.power_trajectory)
"""Get [`ThermalMultiStart`](@ref) `time_limits`."""
get_time_limits(value::ThermalMultiStart) = value.time_limits
"""Get [`ThermalMultiStart`](@ref) `start_time_limits`."""
get_start_time_limits(value::ThermalMultiStart) = value.start_time_limits
"""Get [`ThermalMultiStart`](@ref) `start_types`."""
get_start_types(value::ThermalMultiStart) = value.start_types
"""Get [`ThermalMultiStart`](@ref) `operation_cost`."""
get_operation_cost(value::ThermalMultiStart) = value.operation_cost
"""Get [`ThermalMultiStart`](@ref) `base_power`."""
get_base_power(value::ThermalMultiStart) = value.base_power
"""Get [`ThermalMultiStart`](@ref) `services`."""
get_services(value::ThermalMultiStart) = value.services
"""Get [`ThermalMultiStart`](@ref) `time_at_status`."""
get_time_at_status(value::ThermalMultiStart) = value.time_at_status
"""Get [`ThermalMultiStart`](@ref) `must_run`."""
get_must_run(value::ThermalMultiStart) = value.must_run
"""Get [`ThermalMultiStart`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::ThermalMultiStart) = value.dynamic_injector
"""Get [`ThermalMultiStart`](@ref) `ext`."""
get_ext(value::ThermalMultiStart) = value.ext
"""Get [`ThermalMultiStart`](@ref) `time_series_container`."""
get_time_series_container(value::ThermalMultiStart) = value.time_series_container
"""Get [`ThermalMultiStart`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::ThermalMultiStart) = value.supplemental_attributes_container
"""Get [`ThermalMultiStart`](@ref) `internal`."""
get_internal(value::ThermalMultiStart) = value.internal

"""Set [`ThermalMultiStart`](@ref) `available`."""
set_available!(value::ThermalMultiStart, val) = value.available = val
"""Set [`ThermalMultiStart`](@ref) `status`."""
set_status!(value::ThermalMultiStart, val) = value.status = val
"""Set [`ThermalMultiStart`](@ref) `bus`."""
set_bus!(value::ThermalMultiStart, val) = value.bus = val
"""Set [`ThermalMultiStart`](@ref) `active_power`."""
set_active_power!(value::ThermalMultiStart, val) = value.active_power = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `reactive_power`."""
set_reactive_power!(value::ThermalMultiStart, val) = value.reactive_power = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `rating`."""
set_rating!(value::ThermalMultiStart, val) = value.rating = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::ThermalMultiStart, val) = value.prime_mover_type = val
"""Set [`ThermalMultiStart`](@ref) `fuel`."""
set_fuel!(value::ThermalMultiStart, val) = value.fuel = val
"""Set [`ThermalMultiStart`](@ref) `active_power_limits`."""
set_active_power_limits!(value::ThermalMultiStart, val) = value.active_power_limits = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::ThermalMultiStart, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `ramp_limits`."""
set_ramp_limits!(value::ThermalMultiStart, val) = value.ramp_limits = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `power_trajectory`."""
set_power_trajectory!(value::ThermalMultiStart, val) = value.power_trajectory = set_value(value, val)
"""Set [`ThermalMultiStart`](@ref) `time_limits`."""
set_time_limits!(value::ThermalMultiStart, val) = value.time_limits = val
"""Set [`ThermalMultiStart`](@ref) `start_time_limits`."""
set_start_time_limits!(value::ThermalMultiStart, val) = value.start_time_limits = val
"""Set [`ThermalMultiStart`](@ref) `start_types`."""
set_start_types!(value::ThermalMultiStart, val) = value.start_types = val
"""Set [`ThermalMultiStart`](@ref) `operation_cost`."""
set_operation_cost!(value::ThermalMultiStart, val) = value.operation_cost = val
"""Set [`ThermalMultiStart`](@ref) `base_power`."""
set_base_power!(value::ThermalMultiStart, val) = value.base_power = val
"""Set [`ThermalMultiStart`](@ref) `services`."""
set_services!(value::ThermalMultiStart, val) = value.services = val
"""Set [`ThermalMultiStart`](@ref) `time_at_status`."""
set_time_at_status!(value::ThermalMultiStart, val) = value.time_at_status = val
"""Set [`ThermalMultiStart`](@ref) `must_run`."""
set_must_run!(value::ThermalMultiStart, val) = value.must_run = val
"""Set [`ThermalMultiStart`](@ref) `ext`."""
set_ext!(value::ThermalMultiStart, val) = value.ext = val
"""Set [`ThermalMultiStart`](@ref) `time_series_container`."""
set_time_series_container!(value::ThermalMultiStart, val) = value.time_series_container = val
"""Set [`ThermalMultiStart`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::ThermalMultiStart, val) = value.supplemental_attributes_container = val
