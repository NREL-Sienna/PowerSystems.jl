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
 
# Contents
function get_components(e::SingleComponentSelector, sys::System)
    com = get_component(e.component_subtype, sys, e.component_name)
    return (com === nothing || !get_available(com)) ? [] : [com]
end

# ListComponentSelector
#Contents
function get_components(e::ListComponentSelector, sys::System)
    sub_components = Iterators.map(x -> get_components(x, sys), e.content)
    return Iterators.filter(
        get_available,
        Iterators.flatten(sub_components),
    )
end

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
) = IS.select_components(component_subtype, name)

# Contents
function get_subselectors(e::SubtypeComponentSelector, sys::System)
    return IS.get_subselectors(e, sys.data)
end

function get_components(e::SubtypeComponentSelector, sys::System)
    return Iterators.filter(get_available, get_components(e.component_subtype, sys.data))
end

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

# Contents
function get_subselectors(e::FilterComponentSelector, sys::System)
    return IS.get_subselectors(e, sys.data)
end

function get_components(e::FilterComponentSelector, sys::System)
    return Iterators.filter(
        get_available,
        IS.get_components(e.filter_fn, e.component_subtype, sys.data),
    )
end

# TopologyComponentSelector
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
default_name(e::TopologyComponentSelector) =
    component_to_qualified_string(e.topology_subtype, e.topology_name) * NAME_DELIMETER *
    subtype_to_string(e.component_subtype)

get_name(e::TopologyComponentSelector) = (e.name !== nothing) ? e.name : default_name(e)

# Contents
function get_subselectors(e::TopologyComponentSelector, sys::System)
    return Iterators.map(select_components, get_components(e, sys))
end

function get_components(e::TopologyComponentSelector, sys::System)
    agg_topology = get_component(e.topology_subtype, sys, e.topology_name)
    return Iterators.filter(
        get_available,
        get_components_in_aggregation_topology(
            e.component_subtype,
            sys,
            agg_topology,
        ),
    )
end