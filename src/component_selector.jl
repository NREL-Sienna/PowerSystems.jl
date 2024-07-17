# Most of this is implemented by wrapping the IS versions, replacing
# InfrastructureSystemsComponent with Component and SystemData with System

"""
Get the components of the System that make up the ComponentSelector.
"""
get_components(e::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_components(e, sys.data; filterby = filterby)

"""
Get the sub-selectors that make up the ComponentSelectorSet.
"""
get_subselectors(e::ComponentSelectorSet, sys::System; filterby = nothing) =
    IS.get_subselectors(e, sys.data; filterby = filterby)

# SingleComponentSelector
# Construction
"""
Make a ComponentSelector pointing to a Component with the given subtype and name. Optionally
provide a name for the ComponentSelector.
"""
select_components(
    component_subtype::Type{<:Component},
    component_name::AbstractString,
    name::Union{String, Nothing} = nothing,
) = IS.select_components(component_subtype, component_name, name)

"""
Construct a ComponentSelector from a Component reference, pointing to Components in any
System with the given Component's subtype and name.
"""
select_components(component_ref::Component, name::Union{String, Nothing} = nothing) =
    IS.select_components(component_ref, name)

# ListComponentSelector
# Construction
select_components(content::ComponentSelector...; name::Union{String, Nothing} = nothing) =
    IS.select_components(content...; name)

# SubtypeComponentSelector
# Construction
"""
Make a ComponentSelector from a subtype of Component. Optionally provide a name for the
ComponentSelectorSet.
"""
# name needs to be a kwarg to disambiguate from SingleComponentSelector's select_components
select_components(
    component_subtype::Type{<:Component};
    name::Union{String, Nothing} = nothing,
) = IS.select_components(component_subtype; name)

# FilterComponentSelector
# Construction
"""
Make a ComponentSelector from a filter function and a subtype of Component. Optionally
provide a name for the ComponentSelector. The filter function must accept instances of
component_subtype as a sole argument and return a Bool.
"""
function select_components(
    filter_fn::Function,
    component_subtype::Type{<:Component},
    name::Union{String, Nothing} = nothing,
)
    return IS.select_components(filter_fn, component_subtype, name)
end

# TopologyComponentSelector
# This one is wholly implemented in PowerSystems rather than in IS because it depends on AggregationTopology
"ComponentSelectorSet represented by an AggregationTopology and a subtype of Component."
struct TopologyComponentSelector <: ComponentSelectorSet
    topology_subtype::Type{<:AggregationTopology}
    topology_name::AbstractString
    component_subtype::Type{<:Component}
    name::Union{String, Nothing}
end

# Construction
"""
Make a ComponentSelector from an AggregationTopology and a subtype of Component. Optionally
provide a name for the ComponentSelector.
"""
select_components(
    topology_subtype::Type{<:AggregationTopology},
    topology_name::AbstractString,
    component_subtype::Type{<:Component},
    name::Union{String, Nothing} = nothing,
) = TopologyComponentSelector(
    topology_subtype,
    topology_name,
    component_subtype,
    name,
)

# Naming
IS.default_name(e::TopologyComponentSelector) =
    component_to_qualified_string(e.topology_subtype, e.topology_name) * NAME_DELIMETER *
    subtype_to_string(e.component_subtype)

# Contents
function get_subselectors(e::TopologyComponentSelector, sys::System; filterby = nothing)
    return Iterators.map(select_components, get_components(e, sys; filterby = filterby))
end

function get_components(e::TopologyComponentSelector, sys::System; filterby = nothing)
    agg_topology = get_component(e.topology_subtype, sys, e.topology_name)
    isnothing(agg_topology) &&
        (return Iterators.filter(x -> false, get_components(e.component_subtype, sys)))
    components = get_components_in_aggregation_topology(
        e.component_subtype,
        sys,
        agg_topology,
    )
    isnothing(filterby) && (return components)
    return Iterators.filter(filterby, components)
end

# Unfortunately, there is no way to implement `in` for TopologyComponentSelector without a
# System reference, since the aggregation topology reference is System-dependent
function Base.in(
    c::IS.InfrastructureSystemsComponent,
    e::TopologyComponentSelector,
    sys::System;
    filterby = nothing,
)
    (!isnothing(filterby) && !filterby(c)) && return false
    agg_topology = get_component(e.topology_subtype, sys, e.topology_name)
    isnothing(agg_topology) && return false
    return (c isa e.component_subtype) &&
           is_component_in_aggregation_topology(c, agg_topology)
end
