#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroTopology <: AggregationTopology
        name::String
        topology::MutableLinkedList{HydroReservoir}
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A hydro topology representation.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `topology::MutableLinkedList{HydroReservoir}`: Hydro Topology network
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct HydroTopology <: AggregationTopology
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Hydro Topology network"
    topology::MutableLinkedList{HydroReservoir}
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function HydroTopology(name, topology, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    HydroTopology(name, topology, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function HydroTopology(; name, topology, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    HydroTopology(name, topology, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroTopology(::Nothing)
    HydroTopology(;
        name="init",
        topology=false,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`HydroTopology`](@ref) `name`."""
get_name(value::HydroTopology) = value.name
"""Get [`HydroTopology`](@ref) `topology`."""
get_topology(value::HydroTopology) = value.topology
"""Get [`HydroTopology`](@ref) `services`."""
get_services(value::HydroTopology) = value.services
"""Get [`HydroTopology`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HydroTopology) = value.dynamic_injector
"""Get [`HydroTopology`](@ref) `ext`."""
get_ext(value::HydroTopology) = value.ext
"""Get [`HydroTopology`](@ref) `internal`."""
get_internal(value::HydroTopology) = value.internal

"""Set [`HydroTopology`](@ref) `topology`."""
set_topology!(value::HydroTopology, val) = value.topology = val
"""Set [`HydroTopology`](@ref) `services`."""
set_services!(value::HydroTopology, val) = value.services = val
"""Set [`HydroTopology`](@ref) `ext`."""
set_ext!(value::HydroTopology, val) = value.ext = val
