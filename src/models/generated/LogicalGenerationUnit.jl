#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct LogicalGenerationUnit <: StaticInjection
        name::String
        available::Bool
        status::OperationalStates.Value
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover_type::PrimeMovers.Value
        fuel::ThermalFuels.Value
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        ramp_limits::Union{Nothing, UpDown}
        power_trajectory::Union{Nothing, StartUpShutDown}
        time_limits::Union{Nothing, UpDown}
        start_time_limits::Union{Nothing, StartUpStages}
        start_types::Int
        operation_cost::OperationalCost
        base_power::Float64
        services::Vector{Service}
        time_at_status::Float64
        commitment_mode::CommitmentModes.Value
        switching_times::Union{Nothing, UpDown}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A logical generation unit: a market-facing unit that the operator dispatches and commits as one resource, such as one configuration of a combined cycle plant.

A logical unit holds its own limits, ramps, start-up data and costs, independent of the physical units behind it. Its `bus` is where it injects when a model represents logical units instead of physical ones. It has the start-up representation of [`ThermalMultiStart`](@ref), with no dynamic model.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `status::OperationalStates.Value`: Operating state of the unit at the start of a simulation. Options are listed [here](@ref opstate_list)
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used, validation range: `active_power_limits`
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR), validation range: `reactive_power_limits`
- `rating::Float64`: Maximum AC side output power rating of the unit. Stored in per unit of the device and not to be confused with base_power, validation range: `(0, nothing)`
- `prime_mover_type::PrimeMovers.Value`: Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)
- `fuel::ThermalFuels.Value`: Prime mover fuel according to EIA 923. Options are listed [here](@ref tf_list)
- `active_power_limits::MinMax`: Minimum and maximum stable active power levels (MW)
- `reactive_power_limits::Union{Nothing, MinMax}`: Minimum and maximum reactive power limits. Set to `Nothing` if not applicable
- `ramp_limits::Union{Nothing, UpDown}`: Ramp up and ramp down limits (MW/min), validation range: `(0, nothing)`
- `power_trajectory::Union{Nothing, StartUpShutDown}`: Power trajectory the unit will take during the start-up and shut-down ramp process, validation range: `(0, nothing)`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in minutes, validation range: `(0, nothing)`
- `start_time_limits::Union{Nothing, StartUpStages}`: Time limits for start-up based on turbine temperature in minutes
- `start_types::Int`: Number of start-up based on turbine temperature, where `1` = *hot*, `2` = *warm*, and `3` = *cold*, validation range: `(1, 3)`
- `operation_cost::OperationalCost`: [`OperationalCost`](@ref) of generation
- `base_power::Float64`: Base power of the unit (MVA) for [per unitization](@ref per_unit), validation range: `(0.0001, nothing)`
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `time_at_status::Float64`: (default: `INFINITE_TIME`) Time (e.g., `Minutes(360)`) the unit has been in its current `status`
- `commitment_mode::CommitmentModes.Value`: (default: `CommitmentModes.COMMITTED`) Commitment mode of the unit. Options are listed [here](@ref commit_list)
- `switching_times::Union{Nothing, UpDown}`: (default: `nothing`) Time it takes the unit to switch ONLINE or OFFLINE after a start or shut-down is initiated, in minutes, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
- `input_basis`: (keyword constructor only, required) `u"CU"` or `u"NU"`, the units of bare numbers on unit-bearing fields. Tagged values (`50.0u"MW"`) keep their own units
"""
mutable struct LogicalGenerationUnit <: StaticInjection
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Operating state of the unit at the start of a simulation. Options are listed [here](@ref opstate_list)"
    status::OperationalStates.Value
    "Bus that this component is connected to"
    bus::ACBus
    "Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used"
    active_power::Float64
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Maximum AC side output power rating of the unit. Stored in per unit of the device and not to be confused with base_power"
    rating::Float64
    "Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)"
    prime_mover_type::PrimeMovers.Value
    "Prime mover fuel according to EIA 923. Options are listed [here](@ref tf_list)"
    fuel::ThermalFuels.Value
    "Minimum and maximum stable active power levels (MW)"
    active_power_limits::MinMax
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable"
    reactive_power_limits::Union{Nothing, MinMax}
    "Ramp up and ramp down limits (MW/min)"
    ramp_limits::Union{Nothing, UpDown}
    "Power trajectory the unit will take during the start-up and shut-down ramp process"
    power_trajectory::Union{Nothing, StartUpShutDown}
    "Minimum up and Minimum down time limits in minutes"
    time_limits::Union{Nothing, UpDown}
    "Time limits for start-up based on turbine temperature in minutes"
    start_time_limits::Union{Nothing, StartUpStages}
    "Number of start-up based on turbine temperature, where `1` = *hot*, `2` = *warm*, and `3` = *cold*"
    start_types::Int
    "[`OperationalCost`](@ref) of generation"
    operation_cost::OperationalCost
    "Base power of the unit (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "Time (e.g., `Minutes(360)`) the unit has been in its current `status`"
    time_at_status::Float64
    "Commitment mode of the unit. Options are listed [here](@ref commit_list)"
    commitment_mode::CommitmentModes.Value
    "Time it takes the unit to switch ONLINE or OFFLINE after a start or shut-down is initiated, in minutes"
    switching_times::Union{Nothing, UpDown}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function LogicalGenerationUnit(name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services=Device[], time_at_status=INFINITE_TIME, commitment_mode=CommitmentModes.COMMITTED, switching_times=nothing, ext=Dict{String, Any}(), )
    LogicalGenerationUnit(name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services, time_at_status, commitment_mode, switching_times, ext, InfrastructureSystemsInternal(), )
end

function LogicalGenerationUnit(; name, available, status, bus, active_power, reactive_power, rating, prime_mover_type, fuel, active_power_limits, reactive_power_limits, ramp_limits, power_trajectory, time_limits, start_time_limits, start_types, operation_cost, base_power, services=Device[], time_at_status=INFINITE_TIME, commitment_mode=CommitmentModes.COMMITTED, switching_times=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), input_basis::Unitful.Units, )
    value = LogicalGenerationUnit(name, available, status, bus, _placeholder(active_power), _placeholder(reactive_power), _placeholder(rating), prime_mover_type, fuel, _placeholder(active_power_limits), _placeholder(reactive_power_limits), _placeholder(ramp_limits), _placeholder(power_trajectory), time_limits, start_time_limits, start_types, operation_cost, base_power, services, time_at_status, commitment_mode, switching_times, ext, internal, )
    set_active_power!(value, _tag(active_power, input_basis, Val(:mw)))
    set_reactive_power!(value, _tag(reactive_power, input_basis, Val(:mvar)))
    set_rating!(value, _tag(rating, input_basis, Val(:mva)))
    set_active_power_limits!(value, _tag(active_power_limits, input_basis, Val(:mw)))
    set_reactive_power_limits!(value, _tag(reactive_power_limits, input_basis, Val(:mvar)))
    set_ramp_limits!(value, _tag(ramp_limits, input_basis, Val(:mw_per_minute)))
    set_power_trajectory!(value, _tag(power_trajectory, input_basis, Val(:mw)))
    return value
end
_takes_input_basis(::Type{<:LogicalGenerationUnit}) = true

# Constructor for demo purposes; non-functional.
function LogicalGenerationUnit(::Nothing)
    LogicalGenerationUnit(;
        name="init",
        available=false,
        status=OperationalStates.OFFLINE,
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
        operation_cost=ThermalGenerationCost(nothing),
        base_power=100.0,
        services=Device[],
        time_at_status=INFINITE_TIME,
        commitment_mode=CommitmentModes.UNCOMMITTED,
        switching_times=nothing,
        ext=Dict{String, Any}(),
        input_basis=u"CU",
    )
end

"""Get [`LogicalGenerationUnit`](@ref) `name`."""
get_name(value::LogicalGenerationUnit) = value.name
"""Get [`LogicalGenerationUnit`](@ref) `available`."""
get_available(value::LogicalGenerationUnit) = value.available
"""Get [`LogicalGenerationUnit`](@ref) `status`."""
get_status(value::LogicalGenerationUnit) = value.status
"""Get [`LogicalGenerationUnit`](@ref) `bus`."""
get_bus(value::LogicalGenerationUnit) = value.bus
"""Get [`LogicalGenerationUnit`](@ref) `active_power` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_active_power_unitful`](@ref)."""
get_active_power(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:active_power), Val(:mw), units))
"""Get [`LogicalGenerationUnit`](@ref) `active_power` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_active_power`](@ref)."""
get_active_power_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:active_power), Val(:mw), units)
get_active_power(value::LogicalGenerationUnit) = _units_arg_required(get_active_power, value, :active_power, Val(:mw))
get_active_power_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_active_power_unitful, value, :active_power, Val(:mw))
InfrastructureSystems.display_units_arg(::typeof(get_active_power), ::Type{LogicalGenerationUnit}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_active_power_unitful), ::Type{LogicalGenerationUnit}) = u"SU"
"""Get [`LogicalGenerationUnit`](@ref) `reactive_power` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_reactive_power_unitful`](@ref)."""
get_reactive_power(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:reactive_power), Val(:mvar), units))
"""Get [`LogicalGenerationUnit`](@ref) `reactive_power` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_reactive_power`](@ref)."""
get_reactive_power_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:reactive_power), Val(:mvar), units)
get_reactive_power(value::LogicalGenerationUnit) = _units_arg_required(get_reactive_power, value, :reactive_power, Val(:mvar))
get_reactive_power_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_reactive_power_unitful, value, :reactive_power, Val(:mvar))
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power), ::Type{LogicalGenerationUnit}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_unitful), ::Type{LogicalGenerationUnit}) = u"SU"
"""Get [`LogicalGenerationUnit`](@ref) `rating` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_rating_unitful`](@ref)."""
get_rating(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating), Val(:mva), units))
"""Get [`LogicalGenerationUnit`](@ref) `rating` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_rating`](@ref)."""
get_rating_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:rating), Val(:mva), units)
get_rating(value::LogicalGenerationUnit) = _units_arg_required(get_rating, value, :rating, Val(:mva))
get_rating_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_rating_unitful, value, :rating, Val(:mva))
InfrastructureSystems.display_units_arg(::typeof(get_rating), ::Type{LogicalGenerationUnit}) = u"CU"
InfrastructureSystems.display_units_arg(::typeof(get_rating_unitful), ::Type{LogicalGenerationUnit}) = u"CU"
"""Get [`LogicalGenerationUnit`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::LogicalGenerationUnit) = value.prime_mover_type
"""Get [`LogicalGenerationUnit`](@ref) `fuel`."""
get_fuel(value::LogicalGenerationUnit) = value.fuel
"""Get [`LogicalGenerationUnit`](@ref) `active_power_limits` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_active_power_limits_unitful`](@ref)."""
get_active_power_limits(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:active_power_limits), Val(:mw), units))
"""Get [`LogicalGenerationUnit`](@ref) `active_power_limits` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_active_power_limits`](@ref)."""
get_active_power_limits_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:active_power_limits), Val(:mw), units)
get_active_power_limits(value::LogicalGenerationUnit) = _units_arg_required(get_active_power_limits, value, :active_power_limits, Val(:mw))
get_active_power_limits_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_active_power_limits_unitful, value, :active_power_limits, Val(:mw))
InfrastructureSystems.display_units_arg(::typeof(get_active_power_limits), ::Type{LogicalGenerationUnit}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_active_power_limits_unitful), ::Type{LogicalGenerationUnit}) = u"SU"
"""Get [`LogicalGenerationUnit`](@ref) `reactive_power_limits` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_reactive_power_limits_unitful`](@ref)."""
get_reactive_power_limits(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:reactive_power_limits), Val(:mvar), units))
"""Get [`LogicalGenerationUnit`](@ref) `reactive_power_limits` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_reactive_power_limits`](@ref)."""
get_reactive_power_limits_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:reactive_power_limits), Val(:mvar), units)
get_reactive_power_limits(value::LogicalGenerationUnit) = _units_arg_required(get_reactive_power_limits, value, :reactive_power_limits, Val(:mvar))
get_reactive_power_limits_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_reactive_power_limits_unitful, value, :reactive_power_limits, Val(:mvar))
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_limits), ::Type{LogicalGenerationUnit}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_limits_unitful), ::Type{LogicalGenerationUnit}) = u"SU"
"""Get [`LogicalGenerationUnit`](@ref) `ramp_limits` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_ramp_limits_unitful`](@ref)."""
get_ramp_limits(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:ramp_limits), Val(:mw_per_minute), units))
"""Get [`LogicalGenerationUnit`](@ref) `ramp_limits` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_ramp_limits`](@ref)."""
get_ramp_limits_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:ramp_limits), Val(:mw_per_minute), units)
get_ramp_limits(value::LogicalGenerationUnit) = _units_arg_required(get_ramp_limits, value, :ramp_limits, Val(:mw_per_minute))
get_ramp_limits_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_ramp_limits_unitful, value, :ramp_limits, Val(:mw_per_minute))
InfrastructureSystems.display_units_arg(::typeof(get_ramp_limits), ::Type{LogicalGenerationUnit}) = u"SU/minute"
InfrastructureSystems.display_units_arg(::typeof(get_ramp_limits_unitful), ::Type{LogicalGenerationUnit}) = u"SU/minute"
"""Get [`LogicalGenerationUnit`](@ref) `power_trajectory` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_power_trajectory_unitful`](@ref)."""
get_power_trajectory(value::LogicalGenerationUnit, units) = InfrastructureSystems._strip_units(get_value(value, Val(:power_trajectory), Val(:mw), units))
"""Get [`LogicalGenerationUnit`](@ref) `power_trajectory` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_power_trajectory`](@ref)."""
get_power_trajectory_unitful(value::LogicalGenerationUnit, units) = get_value(value, Val(:power_trajectory), Val(:mw), units)
get_power_trajectory(value::LogicalGenerationUnit) = _units_arg_required(get_power_trajectory, value, :power_trajectory, Val(:mw))
get_power_trajectory_unitful(value::LogicalGenerationUnit) = _units_arg_required(get_power_trajectory_unitful, value, :power_trajectory, Val(:mw))
InfrastructureSystems.display_units_arg(::typeof(get_power_trajectory), ::Type{LogicalGenerationUnit}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_power_trajectory_unitful), ::Type{LogicalGenerationUnit}) = u"SU"
"""Get [`LogicalGenerationUnit`](@ref) `time_limits`."""
get_time_limits(value::LogicalGenerationUnit) = value.time_limits
"""Get [`LogicalGenerationUnit`](@ref) `start_time_limits`."""
get_start_time_limits(value::LogicalGenerationUnit) = value.start_time_limits
"""Get [`LogicalGenerationUnit`](@ref) `start_types`."""
get_start_types(value::LogicalGenerationUnit) = value.start_types
"""Get [`LogicalGenerationUnit`](@ref) `operation_cost`."""
get_operation_cost(value::LogicalGenerationUnit) = value.operation_cost

_get_base_power(value::LogicalGenerationUnit) = value.base_power
"""Get [`LogicalGenerationUnit`](@ref) `services`."""
get_services(value::LogicalGenerationUnit) = value.services
"""Get [`LogicalGenerationUnit`](@ref) `time_at_status`."""
get_time_at_status(value::LogicalGenerationUnit) = value.time_at_status
"""Get [`LogicalGenerationUnit`](@ref) `commitment_mode`."""
get_commitment_mode(value::LogicalGenerationUnit) = value.commitment_mode
"""Get [`LogicalGenerationUnit`](@ref) `switching_times`."""
get_switching_times(value::LogicalGenerationUnit) = value.switching_times
"""Get [`LogicalGenerationUnit`](@ref) `ext`."""
get_ext(value::LogicalGenerationUnit) = value.ext
"""Get [`LogicalGenerationUnit`](@ref) `internal`."""
get_internal(value::LogicalGenerationUnit) = value.internal

"""Set [`LogicalGenerationUnit`](@ref) `available`."""
set_available!(value::LogicalGenerationUnit, val) = value.available = val
"""Set [`LogicalGenerationUnit`](@ref) `status`."""
set_status!(value::LogicalGenerationUnit, val) = value.status = val
"""Set [`LogicalGenerationUnit`](@ref) `bus`."""
set_bus!(value::LogicalGenerationUnit, val) = value.bus = val
"""Set [`LogicalGenerationUnit`](@ref) `active_power`."""
set_active_power!(value::LogicalGenerationUnit, val) = value.active_power = set_value(value, Val(:active_power), val, Val(:mw))
set_active_power!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_active_power!, value, :active_power, Val(:mw), val)
"""Set [`LogicalGenerationUnit`](@ref) `reactive_power`."""
set_reactive_power!(value::LogicalGenerationUnit, val) = value.reactive_power = set_value(value, Val(:reactive_power), val, Val(:mvar))
set_reactive_power!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_reactive_power!, value, :reactive_power, Val(:mvar), val)
"""Set [`LogicalGenerationUnit`](@ref) `rating`."""
set_rating!(value::LogicalGenerationUnit, val) = value.rating = set_value(value, Val(:rating), val, Val(:mva))
set_rating!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_rating!, value, :rating, Val(:mva), val)
"""Set [`LogicalGenerationUnit`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::LogicalGenerationUnit, val) = value.prime_mover_type = val
"""Set [`LogicalGenerationUnit`](@ref) `fuel`."""
set_fuel!(value::LogicalGenerationUnit, val) = value.fuel = val
"""Set [`LogicalGenerationUnit`](@ref) `active_power_limits`."""
set_active_power_limits!(value::LogicalGenerationUnit, val) = value.active_power_limits = set_value(value, Val(:active_power_limits), val, Val(:mw))
set_active_power_limits!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_active_power_limits!, value, :active_power_limits, Val(:mw), val)
set_active_power_limits!(value::LogicalGenerationUnit, val::NamedTuple{(:min, :max), <:Tuple{Vararg{_UntaggedNumber}}}) = _units_tag_required(set_active_power_limits!, value, :active_power_limits, Val(:mw), val)
"""Set [`LogicalGenerationUnit`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::LogicalGenerationUnit, val) = value.reactive_power_limits = set_value(value, Val(:reactive_power_limits), val, Val(:mvar))
set_reactive_power_limits!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_reactive_power_limits!, value, :reactive_power_limits, Val(:mvar), val)
set_reactive_power_limits!(value::LogicalGenerationUnit, val::NamedTuple{(:min, :max), <:Tuple{Vararg{_UntaggedNumber}}}) = _units_tag_required(set_reactive_power_limits!, value, :reactive_power_limits, Val(:mvar), val)
"""Set [`LogicalGenerationUnit`](@ref) `ramp_limits`."""
set_ramp_limits!(value::LogicalGenerationUnit, val) = value.ramp_limits = set_value(value, Val(:ramp_limits), val, Val(:mw_per_minute))
set_ramp_limits!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_ramp_limits!, value, :ramp_limits, Val(:mw_per_minute), val)
set_ramp_limits!(value::LogicalGenerationUnit, val::NamedTuple{(:up, :down), <:Tuple{Vararg{_UntaggedNumber}}}) = _units_tag_required(set_ramp_limits!, value, :ramp_limits, Val(:mw_per_minute), val)
"""Set [`LogicalGenerationUnit`](@ref) `power_trajectory`."""
set_power_trajectory!(value::LogicalGenerationUnit, val) = value.power_trajectory = set_value(value, Val(:power_trajectory), val, Val(:mw))
set_power_trajectory!(value::LogicalGenerationUnit, val::_UntaggedNumber) = _units_tag_required(set_power_trajectory!, value, :power_trajectory, Val(:mw), val)
set_power_trajectory!(value::LogicalGenerationUnit, val::NamedTuple{(:startup, :shutdown), <:Tuple{Vararg{_UntaggedNumber}}}) = _units_tag_required(set_power_trajectory!, value, :power_trajectory, Val(:mw), val)
"""Set [`LogicalGenerationUnit`](@ref) `time_limits`."""
set_time_limits!(value::LogicalGenerationUnit, val) = value.time_limits = val
"""Set [`LogicalGenerationUnit`](@ref) `start_time_limits`."""
set_start_time_limits!(value::LogicalGenerationUnit, val) = value.start_time_limits = val
"""Set [`LogicalGenerationUnit`](@ref) `start_types`."""
set_start_types!(value::LogicalGenerationUnit, val) = value.start_types = val
"""Set [`LogicalGenerationUnit`](@ref) `operation_cost`."""
set_operation_cost!(value::LogicalGenerationUnit, val) = value.operation_cost = val
"""Set [`LogicalGenerationUnit`](@ref) `services`."""
set_services!(value::LogicalGenerationUnit, val) = value.services = val
"""Set [`LogicalGenerationUnit`](@ref) `time_at_status`."""
set_time_at_status!(value::LogicalGenerationUnit, val) = value.time_at_status = val
"""Set [`LogicalGenerationUnit`](@ref) `commitment_mode`."""
set_commitment_mode!(value::LogicalGenerationUnit, val) = value.commitment_mode = val
"""Set [`LogicalGenerationUnit`](@ref) `switching_times`."""
set_switching_times!(value::LogicalGenerationUnit, val) = value.switching_times = val
"""Set [`LogicalGenerationUnit`](@ref) `ext`."""
set_ext!(value::LogicalGenerationUnit, val) = value.ext = val


function from_openapi(po::PO.LogicalGenerationUnit, refs::OpenAPIRefs, ::ComponentBaseUnit)
    return LogicalGenerationUnit(;
        name = po.name,
        available = po.available,
        status = OperationalStates.Value(po.status.value),
        bus = resolve_ref(refs, po.bus, ACBus),
        active_power = po.active_power,
        reactive_power = po.reactive_power,
        rating = po.rating,
        prime_mover_type = PrimeMovers.Value(po.prime_mover_type.value),
        fuel = ThermalFuels.Value(po.fuel.value),
        active_power_limits = _or_default(po.active_power_limits, nothing),
        reactive_power_limits = _or_default(po.reactive_power_limits, nothing),
        ramp_limits = _or_default(po.ramp_limits, nothing),
        power_trajectory = _or_default(po.power_trajectory, nothing),
        time_limits = _or_default(po.time_limits, nothing),
        start_time_limits = _or_default(po.start_time_limits, nothing),
        start_types = po.start_types,
        operation_cost = convert_cost(po.operation_cost.value)::OperationalCost,
        base_power = po.base_power,
        time_at_status = _or_default(po.time_at_status, INFINITE_TIME),
        commitment_mode = _or_default(po.commitment_mode, CommitmentModes.COMMITTED),
        switching_times = _or_default(po.switching_times, nothing),
        input_basis = u"CU",
    )
end

function from_openapi(po::PO.LogicalGenerationUnit, refs::OpenAPIRefs, ::NaturalUnit)
    return LogicalGenerationUnit(;
        name = po.name,
        available = po.available,
        status = OperationalStates.Value(po.status.value),
        bus = resolve_ref(refs, po.bus, ACBus),
        active_power = po.active_power / po.base_power,
        reactive_power = po.reactive_power / po.base_power,
        rating = po.rating / po.base_power,
        prime_mover_type = PrimeMovers.Value(po.prime_mover_type.value),
        fuel = ThermalFuels.Value(po.fuel.value),
        active_power_limits = _or_default(po.active_power_limits, nothing, (/), po.base_power),
        reactive_power_limits = _or_default(po.reactive_power_limits, nothing, (/), po.base_power),
        ramp_limits = _or_default(po.ramp_limits, nothing, (/), po.base_power),
        power_trajectory = _or_default(po.power_trajectory, nothing, (/), po.base_power),
        time_limits = _or_default(po.time_limits, nothing),
        start_time_limits = _or_default(po.start_time_limits, nothing),
        start_types = po.start_types,
        operation_cost = convert_cost(po.operation_cost.value)::OperationalCost,
        base_power = po.base_power,
        time_at_status = _or_default(po.time_at_status, INFINITE_TIME),
        commitment_mode = _or_default(po.commitment_mode, CommitmentModes.COMMITTED),
        switching_times = _or_default(po.switching_times, nothing),
        input_basis = u"CU",
    )
end

function from_openapi(po::PO.LogicalGenerationUnit, refs::OpenAPIRefs)
    return from_openapi(po, refs, _power_units_marker("LogicalGenerationUnit", po.id, po.power_units))
end

function to_openapi(value::LogicalGenerationUnit, refs::OpenAPIRefs, ::ComponentBaseUnit)
    return PO.LogicalGenerationUnit(;
        id = component_id(refs, value),
        name = get_name(value),
        available = get_available(value),
        status = PO.OperationalStates(string(get_status(value))),
        bus = component_id(refs, get_bus(value)),
        active_power = get_active_power(value, u"CU"),
        reactive_power = get_reactive_power(value, u"CU"),
        rating = get_rating(value, u"CU"),
        prime_mover_type = PO.PrimeMovers(string(get_prime_mover_type(value))),
        fuel = PO.ThermalFuels(string(get_fuel(value))),
        active_power_limits = _minmax_po(get_active_power_limits(value, u"CU")),
        reactive_power_limits = _minmax_po_optional(get_reactive_power_limits(value, u"CU")),
        ramp_limits = _updown_po_optional(get_ramp_limits(value, u"CU/minute")),
        power_trajectory = _startup_shutdown_po_optional(get_power_trajectory(value, u"CU")),
        time_limits = _updown_po_optional(get_time_limits(value)),
        start_time_limits = _startup_stages_po_optional(get_start_time_limits(value)),
        start_types = get_start_types(value),
        operation_cost = PO.LogicalGenerationUnitOperationCost(convert_cost_to_openapi(get_operation_cost(value))),
        base_power = _get_base_power(value),
        time_at_status = get_time_at_status(value),
        commitment_mode = PO.CommitmentModes(string(get_commitment_mode(value))),
        switching_times = _updown_po_optional(get_switching_times(value)),
        power_units = _power_units_string(CU),
    )
end

function to_openapi(value::LogicalGenerationUnit, refs::OpenAPIRefs, ::NaturalUnit)
    return PO.LogicalGenerationUnit(;
        id = component_id(refs, value),
        name = get_name(value),
        available = get_available(value),
        status = PO.OperationalStates(string(get_status(value))),
        bus = component_id(refs, get_bus(value)),
        active_power = get_active_power(value, u"CU") * _get_base_power(value),
        reactive_power = get_reactive_power(value, u"CU") * _get_base_power(value),
        rating = get_rating(value, u"CU") * _get_base_power(value),
        prime_mover_type = PO.PrimeMovers(string(get_prime_mover_type(value))),
        fuel = PO.ThermalFuels(string(get_fuel(value))),
        active_power_limits = _minmax_po_scaled(get_active_power_limits(value, u"CU"), _get_base_power(value)),
        reactive_power_limits = _minmax_po_scaled_optional(get_reactive_power_limits(value, u"CU"), _get_base_power(value)),
        ramp_limits = _updown_po_scaled_optional(get_ramp_limits(value, u"CU/minute"), _get_base_power(value)),
        power_trajectory = _startup_shutdown_po_scaled_optional(get_power_trajectory(value, u"CU"), _get_base_power(value)),
        time_limits = _updown_po_optional(get_time_limits(value)),
        start_time_limits = _startup_stages_po_optional(get_start_time_limits(value)),
        start_types = get_start_types(value),
        operation_cost = PO.LogicalGenerationUnitOperationCost(convert_cost_to_openapi(get_operation_cost(value))),
        base_power = _get_base_power(value),
        time_at_status = get_time_at_status(value),
        commitment_mode = PO.CommitmentModes(string(get_commitment_mode(value))),
        switching_times = _updown_po_optional(get_switching_times(value)),
        power_units = _power_units_string(NU),
    )
end
