# Most of this is implemented by wrapping the IS versions, replacing
# InfrastructureSystemsComponent with Component and SystemData with System

#=
PowerSystems-specific `ComponentSelector` extension notes:
See InfrastructureSystems.jl for the main interface.
=#

# TopologyComponentSelector
# This one is wholly implemented in PowerSystems rather than in InfrastructureSystems because it depends on `PSY.AggregationTopology`
"""
`PluralComponentSelector` represented by an `AggregationTopology` and a type of `Component`.
"""
@kwdef struct TopologyComponentSelector <: DynamicallyGroupedComponentSelector
    component_type::Type{<:Component}
    topology_type::Type{<:AggregationTopology}
    topology_name::AbstractString
    groupby::Union{Symbol, Function}
    name::String

    TopologyComponentSelector(
        component_type::Type{<:InfrastructureSystemsComponent},
        topology_type::Type{<:AggregationTopology},
        topology_name::AbstractString,
        groupby::Union{Symbol, Function},
        name::String,
    ) =
        new(
            component_type,
            topology_type,
            topology_name,
            IS.validate_groupby(groupby),
            name,
        )
end

# Construction
TopologyComponentSelector(
    component_type::Type{<:InfrastructureSystemsComponent},
    topology_type::Type{<:AggregationTopology},
    topology_name::AbstractString,
    groupby::Union{Symbol, Function},
    name::Nothing = nothing,
) =
    TopologyComponentSelector(
        component_type,
        topology_type,
        topology_name,
        groupby,
        component_to_qualified_string(topology_type, topology_name) *
        COMPONENT_NAME_DELIMITER * subtype_to_string(component_type),
    )

"""
Make a `ComponentSelector` from an `AggregationTopology` and a type of component. Optionally
provide a name and/or grouping behavior for the `ComponentSelector`.
"""
make_selector(
    component_type::Type{<:Component},
    topology_type::Type{<:AggregationTopology},
    topology_name::AbstractString;
    groupby::Union{Symbol, Function} = IS.DEFAULT_GROUPBY,
    name::Union{String, Nothing} = nothing,
) = TopologyComponentSelector(
    component_type,
    topology_type,
    topology_name,
    groupby,
    name,
)

# Contents
function IS.get_components(
    selector::TopologyComponentSelector,
    sys::System;
    kwargs...,
)
    agg_topology = get_component(selector.topology_type, sys, selector.topology_name)
    isnothing(agg_topology) && return IS._make_empty_iterator(selector.component_type)

    scope_limiter = get(kwargs, :scope_limiter, nothing)
    combo_filter = if isnothing(scope_limiter)
        x -> is_component_in_aggregation_topology(x, agg_topology)
    else
        x -> scope_limiter(x) && is_component_in_aggregation_topology(x, agg_topology)
    end
    return IS.get_components(combo_filter, selector.component_type, sys)
end

# Alternative functions for only available components
IS.get_available_components(selector::ComponentSelector, sys::System) =
    IS.get_components(selector, sys; scope_limiter = get_available)

IS.get_available_component(selector::SingularComponentSelector, sys::System) =
    IS.get_component(selector, sys; scope_limiter = get_available)

IS.get_available_groups(selector::ComponentSelector, sys::System) =
    get_groups(selector, sys; scope_limiter = get_available)
