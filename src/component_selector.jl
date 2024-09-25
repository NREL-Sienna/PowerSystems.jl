# Most of this is implemented by wrapping the IS versions, replacing
# InfrastructureSystemsComponent with Component and SystemData with System

"""
Get the components of the `System` that make up the `ComponentSelector`.
"""
get_components(e::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_components(e, sys.data; filterby = filterby)

"""
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
"""
get_component(e::SingularComponentSelector, sys::System; filterby = nothing) =
    IS.get_component(e, sys.data; filterby = filterby)

"""
Get the groups that make up the `ComponentSelector`.
"""
get_groups(e::ComponentSelector, sys::System; filterby = nothing) =
    IS.get_groups(e, sys.data; filterby = filterby)

# TopologyComponentSelector
# This one is wholly implemented in PowerSystems rather than in InfrastructureSystems because it depends on `PSY.AggregationTopology`
"""
`PluralComponentSelector` represented by an `AggregationTopology` and a subtype of
`Component`.
"""
struct TopologyComponentSelector <: DynamicallyGroupedPluralComponentSelector
    component_subtype::Type{<:Component}
    topology_subtype::Type{<:AggregationTopology}
    topology_name::AbstractString
    name::Union{String, Nothing}
    groupby::Union{Symbol, Function}  # TODO add validation
end

# Construction
"""
Make a `ComponentSelector` from an `AggregationTopology` and a type of component. Optionally
provide a name for the `ComponentSelector`.
"""
make_selector(
    component_subtype::Type{<:Component},
    topology_subtype::Type{<:AggregationTopology},
    topology_name::AbstractString;
    name::Union{String, Nothing} = nothing,
    groupby::Union{Symbol, Function} = :all,
) = TopologyComponentSelector(
    component_subtype,
    topology_subtype,
    topology_name,
    name,
    groupby,
)

# Naming
IS.default_name(e::TopologyComponentSelector) =
    component_to_qualified_string(e.topology_subtype, e.topology_name) *
    COMPONENT_NAME_DELIMETER *
    subtype_to_string(e.component_subtype)

# Contents
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
