# Most of this is implemented by wrapping the IS versions, replacing
# InfrastructureSystemsComponent with Component and SystemData with System

"""
    get_components(selector, sys; scope_limiter = nothing)
Get the components of the `System` that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on components marked available)
"""
get_components(selector::ComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_components(selector, sys; scope_limiter = scope_limiter)

"""
    get_components(scope_limiter, selector, sys)
Get the components of the `System` that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on components marked available)
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
 - `scope_limiter`: optional filter function to limit the scope of components under consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on components marked available)
"""
get_component(selector::SingularComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_component(selector, sys.data; scope_limiter = scope_limiter)

"""
    get_component(scope_limiter, selector, sys)
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
 - `scope_limiter`: optional filter function to limit the scope of components under consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on components marked available)
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
 - `scope_limiter`: optional filter function to limit the scope of components under consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on components marked available)
"""
get_groups(selector::ComponentSelector, sys::System; scope_limiter = nothing) =
    IS.get_groups(selector, sys; scope_limiter = scope_limiter)

"""
    get_groups(scope_limiter, selector, sys)
Get the groups that make up the `ComponentSelector`.
 - `scope_limiter`: optional filter function to limit the scope of components under consideration (e.g., pass `get_available` to only evaluate the `ComponentSelector` on components marked available)
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
    name::Union{String, Nothing}
    groupby::Union{Symbol, Function}  # TODO add validation
end

# Construction
"""
Make a `ComponentSelector` from an `AggregationTopology` and a type of component. Optionally
provide a name and/or grouping behavior for the `ComponentSelector`.
"""
make_selector(
    component_type::Type{<:Component},
    topology_type::Type{<:AggregationTopology},
    topology_name::AbstractString;
    name::Union{String, Nothing} = nothing,
    groupby::Union{Symbol, Function} = :all,
) = TopologyComponentSelector(
    component_type,
    topology_type,
    topology_name,
    name,
    IS.validate_groupby(groupby),
)

# Naming
IS.default_name(selector::TopologyComponentSelector) =
    component_to_qualified_string(selector.topology_type, selector.topology_name) *
    COMPONENT_NAME_DELIMITER *
    subtype_to_string(selector.component_type)

# Contents
function IS.get_components(
    selector::TopologyComponentSelector,
    sys::System;
    scope_limiter = nothing,
)
    agg_topology = get_component(selector.topology_type, sys, selector.topology_name)
    isnothing(agg_topology) &&
        (return Iterators.filter(x -> false, get_components(selector.component_type, sys)))
    components = get_components_in_aggregation_topology(
        selector.component_type,
        sys,
        agg_topology,
    )
    isnothing(scope_limiter) && (return components)
    return Iterators.filter(scope_limiter, components)
end
