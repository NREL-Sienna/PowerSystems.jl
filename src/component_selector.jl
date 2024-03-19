# TODO: move parts of InfrastructureSystems.jl/src/component_selector.jl (which was copied directly from https://github.com/GabrielKS/PowerAnalytics.jl/tree/gks/entity-metric-redesign) to here

# TopologyComponentSelector
"ComponentSelectorSet represented by an AggregationTopology and a subtype of Component."
struct TopologyComponentSelector <: ComponentSelectorSet
    topology_subtype::Type{<:PSY.AggregationTopology}
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
    topology_subtype::Type{<:PSY.AggregationTopology},
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

# Contents
function get_subselectors(e::TopologyComponentSelector, sys::PSY.System)
    return Iterators.map(select_components, get_components(e, sys))
end

function get_components(e::TopologyComponentSelector, sys::PSY.System)
    agg_topology = get_component(e.topology_subtype, sys, e.topology_name)
    return Iterators.filter(
        get_available,
        PSY.get_components_in_aggregation_topology(
            e.component_subtype,
            sys,
            agg_topology,
        ),
    )
end
