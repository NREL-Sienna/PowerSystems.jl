# Most of the `ComponentSelector` functionality in PowerSystems.jl is implemented by
# wrapping the InfrastructureSystems.jl versions (that wrapping occurs in
# `component_selector_interface.jl`). An exception is `TopologyComponentSelector`, which is
# wholly implemented in PSY rather than in IS because it depends on
# `PSY.AggregationTopology`.

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
    scope_limiter::Union{Function, Nothing},
    selector::TopologyComponentSelector,
    sys::System,
)
    agg_topology = get_component(selector.topology_type, sys, selector.topology_name)
    isnothing(agg_topology) && return IS._make_empty_iterator(selector.component_type)

    combo_filter = IS.optional_and_fns(
        scope_limiter,
        Base.Fix2(is_component_in_aggregation_topology, agg_topology),
    )
    return IS.get_components(combo_filter, selector.component_type, sys)
end
