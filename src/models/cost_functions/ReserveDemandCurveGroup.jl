"""
$(TYPEDEF)
$(TYPEDFIELDS)

    ReserveDemandCurveGroup{T}(variable, name, available, time_frame, sustained_time, max_participation_factor, deployed_fraction, contributing_services, ext, internal)
    ReserveDemandCurveGroup{T}(; variable, name, available, time_frame, sustained_time, max_participation_factor, deployed_fraction, contributing_services, ext)

A group reserve product priced by a single Ancillary Service Demand Curve (ASDC) whose demand is
met by the awards of a set of `contributing_services` (its sub-type reserves). It combines the
demand-curve pricing of [`ReserveDemandCurve`](@ref) with the service aggregation of
[`ConstantReserveGroup`](@ref): the group carries one elastic demand and clears at one price
(MCPC), while the per-sub-type caps and offers live on the contributing services.

Example: ERCOT Responsive Reserve (RRS), whose single ASDC/MCPC is met by the PFR, FFR, and UFR
sub-type services, each with its own offers and capability caps.

The demand curve is a discretized set of `(Reserve capacity (MW), Price (\$/MWh))` steps; the
`ReserveDirection` `T` sets whether the group is [`ReserveUp`](@ref), [`ReserveDown`](@ref), or
[`ReserveSymmetric`](@ref).
"""
mutable struct ReserveDemandCurveGroup{T <: ReserveDirection, U <: IS.AbstractUnitSystem} <:
               Service
    "Group Ancillary Service Demand Curve (ASDC)"
    variable::CostCurve{PiecewiseIncrementalCurve, U}
    "Name of the component"
    name::String
    "Indicator of whether the component is connected and online"
    available::Bool
    "The saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "The time in seconds that the reserve contribution must be sustained at a specified level"
    sustained_time::Float64
    "The maximum portion [0, 1.0] of the reserve that can be contributed per device"
    max_participation_factor::Float64
    "Fraction of service procurement that is assumed to be actually deployed"
    deployed_fraction::Float64
    "The sub-type reserve services whose awards meet this group's demand"
    contributing_services::Vector{Service}
    "An extra dictionary for users to add metadata that are not used in simulation"
    ext::Dict{String, Any}
    "PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function ReserveDemandCurveGroup{T}(
    variable,
    name,
    available,
    time_frame,
    sustained_time = 3600.0,
    max_participation_factor = 1.0,
    deployed_fraction = 0.0,
    contributing_services = Vector{Service}(),
    ext = Dict{String, Any}(),
) where {T <: ReserveDirection}
    U = typeof(get_power_units(variable))
    ReserveDemandCurveGroup{T, U}(
        variable, name, available, time_frame, sustained_time,
        max_participation_factor, deployed_fraction, contributing_services, ext,
        InfrastructureSystemsInternal(),
    )
end

function ReserveDemandCurveGroup{T}(;
    variable,
    name,
    available,
    time_frame,
    sustained_time = 3600.0,
    max_participation_factor = 1.0,
    deployed_fraction = 0.0,
    contributing_services = Vector{Service}(),
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
) where {T <: ReserveDirection}
    U = typeof(get_power_units(variable))
    ReserveDemandCurveGroup{T, U}(
        variable, name, available, time_frame, sustained_time,
        max_participation_factor, deployed_fraction, contributing_services, ext, internal,
    )
end

# Kwarg constructor on the fully-parameterized type — needed by deserialization, which resolves
# `ReserveDemandCurveGroup{T, U}` from metadata and calls it with kwargs.
function ReserveDemandCurveGroup{T, U}(;
    variable,
    name,
    available,
    time_frame,
    sustained_time = 3600.0,
    max_participation_factor = 1.0,
    deployed_fraction = 0.0,
    contributing_services = Vector{Service}(),
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
) where {T <: ReserveDirection, U <: IS.AbstractUnitSystem}
    ReserveDemandCurveGroup{T, U}(
        variable, name, available, time_frame, sustained_time,
        max_participation_factor, deployed_fraction, contributing_services, ext, internal,
    )
end

# Constructor for demo purposes; non-functional.
function ReserveDemandCurveGroup{T}(::Nothing) where {T <: ReserveDirection}
    ReserveDemandCurveGroup{T}(;
        variable = ZERO_OFFER_CURVE,
        name = "init",
        available = false,
        time_frame = 0.0,
        sustained_time = 0.0,
        max_participation_factor = 1.0,
        deployed_fraction = 0.0,
        contributing_services = Vector{Service}(),
    )
end

"""Get [`ReserveDemandCurveGroup`](@ref) `variable`."""
get_variable(value::ReserveDemandCurveGroup) = value.variable
"""Get [`ReserveDemandCurveGroup`](@ref) `name`."""
get_name(value::ReserveDemandCurveGroup) = value.name
"""Get [`ReserveDemandCurveGroup`](@ref) `available`."""
get_available(value::ReserveDemandCurveGroup) = value.available
"""Get [`ReserveDemandCurveGroup`](@ref) `time_frame`."""
get_time_frame(value::ReserveDemandCurveGroup) = value.time_frame
"""Get [`ReserveDemandCurveGroup`](@ref) `sustained_time`."""
get_sustained_time(value::ReserveDemandCurveGroup) = value.sustained_time
"""Get [`ReserveDemandCurveGroup`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::ReserveDemandCurveGroup) =
    value.max_participation_factor
"""Get [`ReserveDemandCurveGroup`](@ref) `deployed_fraction`."""
get_deployed_fraction(value::ReserveDemandCurveGroup) = value.deployed_fraction
"""Get [`ReserveDemandCurveGroup`](@ref) `contributing_services`."""
get_contributing_services(value::ReserveDemandCurveGroup) = value.contributing_services
"""Get [`ReserveDemandCurveGroup`](@ref) `ext`."""
get_ext(value::ReserveDemandCurveGroup) = value.ext
"""Get [`ReserveDemandCurveGroup`](@ref) `internal`."""
get_internal(value::ReserveDemandCurveGroup) = value.internal

"""Set [`ReserveDemandCurveGroup`](@ref) `variable`."""
set_variable!(value::ReserveDemandCurveGroup, val) = value.variable = val
"""Set [`ReserveDemandCurveGroup`](@ref) `available`."""
set_available!(value::ReserveDemandCurveGroup, val) = value.available = val
"""Set [`ReserveDemandCurveGroup`](@ref) `time_frame`."""
set_time_frame!(value::ReserveDemandCurveGroup, val) = value.time_frame = val
"""Set [`ReserveDemandCurveGroup`](@ref) `sustained_time`."""
set_sustained_time!(value::ReserveDemandCurveGroup, val) = value.sustained_time = val
"""Set [`ReserveDemandCurveGroup`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::ReserveDemandCurveGroup, val) =
    value.max_participation_factor = val
"""Set [`ReserveDemandCurveGroup`](@ref) `deployed_fraction`."""
set_deployed_fraction!(value::ReserveDemandCurveGroup, val) = value.deployed_fraction = val
"""Set [`ReserveDemandCurveGroup`](@ref) `contributing_services`."""
set_contributing_services!(value::ReserveDemandCurveGroup, val) =
    value.contributing_services = val
"""Set [`ReserveDemandCurveGroup`](@ref) `ext`."""
set_ext!(value::ReserveDemandCurveGroup, val) = value.ext = val
