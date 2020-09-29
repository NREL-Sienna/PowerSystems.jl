#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct StaticReserveNonSpinning <: ReserveNonSpinning
        name::String
        available::Bool
        time_frame::Float64
        requirement::Float64
        ext::Dict{String, Any}
        operation_cost::Union{Nothing, TwoPartCost}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a non-spinning reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`
- `operation_cost::Union{Nothing, TwoPartCost}`: Cost for providing reserves  [`TwoPartCost`](@ref)
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserveNonSpinning <: ReserveNonSpinning
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "Cost for providing reserves  [`TwoPartCost`](@ref)"
    operation_cost::Union{Nothing, TwoPartCost}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserveNonSpinning(name, available, time_frame, requirement, ext=Dict{String, Any}(), operation_cost=nothing, )
    StaticReserveNonSpinning(name, available, time_frame, requirement, ext, operation_cost, InfrastructureSystemsInternal(), )
end

function StaticReserveNonSpinning(; name, available, time_frame, requirement, ext=Dict{String, Any}(), operation_cost=nothing, internal=InfrastructureSystemsInternal(), )
    StaticReserveNonSpinning(name, available, time_frame, requirement, ext, operation_cost, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserveNonSpinning(::Nothing)
    StaticReserveNonSpinning(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        operation_cost=TwoPartCost(nothing),
    )
end


InfrastructureSystems.get_name(value::StaticReserveNonSpinning) = value.name
"""Get [`StaticReserveNonSpinning`](@ref) `available`."""
get_available(value::StaticReserveNonSpinning) = value.available
"""Get [`StaticReserveNonSpinning`](@ref) `time_frame`."""
get_time_frame(value::StaticReserveNonSpinning) = value.time_frame
"""Get [`StaticReserveNonSpinning`](@ref) `requirement`."""
get_requirement(value::StaticReserveNonSpinning) = value.requirement
"""Get [`StaticReserveNonSpinning`](@ref) `ext`."""
get_ext(value::StaticReserveNonSpinning) = value.ext
"""Get [`StaticReserveNonSpinning`](@ref) `operation_cost`."""
get_operation_cost(value::StaticReserveNonSpinning) = value.operation_cost
"""Get [`StaticReserveNonSpinning`](@ref) `internal`."""
get_internal(value::StaticReserveNonSpinning) = value.internal


InfrastructureSystems.set_name!(value::StaticReserveNonSpinning, val) = value.name = val
"""Set [`StaticReserveNonSpinning`](@ref) `available`."""
set_available!(value::StaticReserveNonSpinning, val) = value.available = val
"""Set [`StaticReserveNonSpinning`](@ref) `time_frame`."""
set_time_frame!(value::StaticReserveNonSpinning, val) = value.time_frame = val
"""Set [`StaticReserveNonSpinning`](@ref) `requirement`."""
set_requirement!(value::StaticReserveNonSpinning, val) = value.requirement = val
"""Set [`StaticReserveNonSpinning`](@ref) `ext`."""
set_ext!(value::StaticReserveNonSpinning, val) = value.ext = val
"""Set [`StaticReserveNonSpinning`](@ref) `operation_cost`."""
set_operation_cost!(value::StaticReserveNonSpinning, val) = value.operation_cost = val
"""Set [`StaticReserveNonSpinning`](@ref) `internal`."""
set_internal!(value::StaticReserveNonSpinning, val) = value.internal = val

