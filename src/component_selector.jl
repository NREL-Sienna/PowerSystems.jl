# Most of this is implemented by wrapping the IS versions, replacing
# InfrastructureSystemsComponent with Component and SystemData with System

"""
    get_components(selector, sys; scope_limiter = nothing)
Get the components of the `System` that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under
   consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on
   components marked available)
"""
get_components(selector::ComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_components(selector, sys; scope_limiter = scope_limiter)

"""
    get_components(scope_limiter, selector, sys)
Get the components of the `System` that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under
   consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on
   components marked available)
"""
get_components(
    scope_limiter::Union{Nothing, Function},
    selector::ComponentSelector,
    sys::System,
) =
    get_components(selector, sys; scope_limiter = scope_limiter)

# This would be cleaner if `IS.get_components === PSY.get_components` (see
# https://github.com/NREL-Sienna/InfrastructureSystems.jl/issues/388)
IS.get_components(selector::ComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_components(selector, sys.data; scope_limiter = scope_limiter)

"""
    get_component(selector, sys; scope_limiter = nothing)
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
 - `scope_limiter`: optional filter function to limit the scope of components under
   consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on
   components marked available)
"""
get_component(selector::SingularComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_component(selector, sys.data; scope_limiter = scope_limiter)

"""
    get_component(scope_limiter, selector, sys)
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
 - `scope_limiter`: optional filter function to limit the scope of components under
   consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on
   components marked available)
"""
get_component(
    scope_limiter::Union{Nothing, Function},
    selector::SingularComponentSelector,
    sys::System,
) =
    get_component(selector, sys; scope_limiter = scope_limiter)

IS.get_component(selector::ComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_component(selector, sys.data; scope_limiter = scope_limiter)

"""
    get_groups(selector, sys; scope_limiter = nothing)
Get the groups that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under
   consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on
   components marked available)
"""
get_groups(selector::ComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_groups(selector, sys; scope_limiter = scope_limiter)

"""
    get_groups(scope_limiter, selector, sys)
Get the groups that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under
   consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on
   components marked available)
"""
get_groups(
    scope_limiter::Union{Nothing, Function},
    selector::ComponentSelector,
    sys::System,
) =
    get_groups(selector, sys; scope_limiter = scope_limiter)

# TopologyComponentSelector
# This one is wholly implemented in PowerSystems rather than in InfrastructureSystems because it depends on `PSY.AggregationTopology`
"""
`PluralComponentSelector` represented by an `AggregationTopology` and a type of `Component`.
"""
struct TopologyComponentSelector <: DynamicallyGroupedComponentSelector
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
    groupby::Union{Symbol, Function} = :all,
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
    scope_limiter = nothing,
)
    agg_topology = get_component(selector.topology_type, sys, selector.topology_name)
    isnothing(agg_topology) && return IS._make_empty_iterator(selector.component_type)

    combo_filter = if isnothing(scope_limiter)
        x -> is_component_in_aggregation_topology(x, agg_topology)
    else
        x -> scope_limiter(x) && is_component_in_aggregation_topology(x, agg_topology)
    end
    return get_components(combo_filter, selector.component_type, sys)
end

# Alternative functions for only available components
get_available_components(selector::ComponentSelector, sys::System) =
    get_components(selector, sys; scope_limiter = get_available)

get_available_groups(selector::ComponentSelector, sys::System) =
    get_groups(selector, sys; scope_limiter = get_available)
