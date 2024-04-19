#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct RenewableFix <: RenewableGen
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover_type::PrimeMovers
        power_factor::Float64
        base_power::Float64
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

A must-take renewable generator whose output is *fixed* the value or profile in the rating argument. Example uses include: an aggregation of behind-the-meter distributed energy resources like rooftop solar or a utility-scale generator whose PPA does not allow curtailment. For curtailable or downward dispatachable generation, see [`RenewableDispatch`](@ref)

# Arguments
- `name::String`
- `available::Bool`
- `bus::ACBus`
- `active_power::Float64`
- `reactive_power::Float64`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923
- `power_factor::Float64`, validation range: `(0, 1)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Prime mover technology according to EIA 923"
    prime_mover_type::PrimeMovers
    power_factor::Float64
    "Base power of the unit in MVA"
    base_power::Float64
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

function RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover_type, power_factor, base_power, dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover_type, power_factor, base_power, dynamic_injector, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function RenewableFix(; name, available, bus, active_power, reactive_power, rating, prime_mover_type, power_factor, base_power, dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover_type, power_factor, base_power, dynamic_injector, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover_type=PrimeMovers.OT,
        power_factor=1.0,
        base_power=0.0,
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`RenewableFix`](@ref) `name`."""
get_name(value::RenewableFix) = value.name
"""Get [`RenewableFix`](@ref) `available`."""
get_available(value::RenewableFix) = value.available
"""Get [`RenewableFix`](@ref) `bus`."""
get_bus(value::RenewableFix) = value.bus
"""Get [`RenewableFix`](@ref) `active_power`."""
get_active_power(value::RenewableFix) = get_value(value, value.active_power)
"""Get [`RenewableFix`](@ref) `reactive_power`."""
get_reactive_power(value::RenewableFix) = get_value(value, value.reactive_power)
"""Get [`RenewableFix`](@ref) `rating`."""
get_rating(value::RenewableFix) = get_value(value, value.rating)
"""Get [`RenewableFix`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::RenewableFix) = value.prime_mover_type
"""Get [`RenewableFix`](@ref) `power_factor`."""
get_power_factor(value::RenewableFix) = value.power_factor
"""Get [`RenewableFix`](@ref) `base_power`."""
get_base_power(value::RenewableFix) = value.base_power
"""Get [`RenewableFix`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::RenewableFix) = value.dynamic_injector
"""Get [`RenewableFix`](@ref) `ext`."""
get_ext(value::RenewableFix) = value.ext
"""Get [`RenewableFix`](@ref) `time_series_container`."""
get_time_series_container(value::RenewableFix) = value.time_series_container
"""Get [`RenewableFix`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::RenewableFix) = value.supplemental_attributes_container
"""Get [`RenewableFix`](@ref) `internal`."""
get_internal(value::RenewableFix) = value.internal

"""Set [`RenewableFix`](@ref) `available`."""
set_available!(value::RenewableFix, val) = value.available = val
"""Set [`RenewableFix`](@ref) `bus`."""
set_bus!(value::RenewableFix, val) = value.bus = val
"""Set [`RenewableFix`](@ref) `active_power`."""
set_active_power!(value::RenewableFix, val) = value.active_power = set_value(value, val)
"""Set [`RenewableFix`](@ref) `reactive_power`."""
set_reactive_power!(value::RenewableFix, val) = value.reactive_power = set_value(value, val)
"""Set [`RenewableFix`](@ref) `rating`."""
set_rating!(value::RenewableFix, val) = value.rating = set_value(value, val)
"""Set [`RenewableFix`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::RenewableFix, val) = value.prime_mover_type = val
"""Set [`RenewableFix`](@ref) `power_factor`."""
set_power_factor!(value::RenewableFix, val) = value.power_factor = val
"""Set [`RenewableFix`](@ref) `base_power`."""
set_base_power!(value::RenewableFix, val) = value.base_power = val
"""Set [`RenewableFix`](@ref) `ext`."""
set_ext!(value::RenewableFix, val) = value.ext = val
"""Set [`RenewableFix`](@ref) `time_series_container`."""
set_time_series_container!(value::RenewableFix, val) = value.time_series_container = val
"""Set [`RenewableFix`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::RenewableFix, val) = value.supplemental_attributes_container = val
