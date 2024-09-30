# Most of this is implemented by wrapping the IS versions, replacing
# InfrastructureSystemsComponent with Component and SystemData with System

"""
    get_components(selector, sys; filterby = nothing)
Get the components of the `System` that make up the `ComponentSelector`.
 - `filterby`: optional filter function to apply after evaluating the `ComponentSelector`
"""
get_components(selector::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_components(selector, sys; filterby = filterby)

"""
    get_components(filterby, selector, sys)
Get the components of the `System` that make up the `ComponentSelector`.
 - `filterby`: optional filter function to apply after evaluating the `ComponentSelector`
"""
get_components(
    filterby::Union{Nothing, Function},
    selector::ComponentSelector,
    sys::System,
) =
    get_components(selector, sys; filterby = filterby)

# This would be cleaner if `IS.get_components === PSY.get_components` (see
# https://github.com/NREL-Sienna/InfrastructureSystems.jl/issues/388)
IS.get_components(selector::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_components(selector, sys.data; filterby = filterby)

"""
    get_component(selector, sys; filterby = nothing)
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
 - `filterby`: optional filter function to apply after evaluating the `ComponentSelector`
"""
get_component(selector::SingularComponentSelector, sys::System; filterby = nothing) =
    IS.get_component(selector, sys.data; filterby = filterby)

"""
    get_component(filterby, selector, sys)
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
 - `filterby`: optional filter function to apply after evaluating the `ComponentSelector`
"""
get_component(
    filterby::Union{Nothing, Function},
    selector::SingularComponentSelector,
    sys::System,
) =
    get_component(selector, sys; filterby = filterby)

IS.get_component(selector::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_component(selector, sys.data; filterby = filterby)

"""
    get_groups(selector, sys; filterby = nothing)
Get the groups that make up the `ComponentSelector`.
 - `filterby`: optional filter function to apply after evaluating the `ComponentSelector`
"""
get_groups(selector::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_groups(selector, sys; filterby = filterby)

"""
    get_groups(filterby, selector, sys)
Get the groups that make up the `ComponentSelector`.
 - `filterby`: optional filter function to apply after evaluating the `ComponentSelector`
"""
get_groups(filterby::Union{Nothing, Function}, selector::ComponentSelector, sys::System) =
    get_groups(selector, sys; filterby = filterby)

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
    filterby = nothing,
)
    agg_topology = get_component(selector.topology_type, sys, selector.topology_name)
    isnothing(agg_topology) &&
        (return Iterators.filter(x -> false, get_components(selector.component_type, sys)))
    components = get_components_in_aggregation_topology(
        selector.component_type,
        sys,
        agg_topology,
    )
    isnothing(filterby) && (return components)
    return Iterators.filter(filterby, components)
end
