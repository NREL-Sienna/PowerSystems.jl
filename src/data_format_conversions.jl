# This file contains code to convert serialized data from old formats to work with newer
# code.

#
# In version 1.0.1 the DeterministicMetadata struct added field time_series type.
# Deserialization needs to add this field and value.
#

# List of structs that have a "variable" field that requires 3.0.0 VariableCost -> 4.0.0 FunctionData conversion
const COST_CONTAINERS =
    ["MultiStartCost", "StorageManagementCost", "ThreePartCost", "TwoPartCost"]

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("2.0.0")},
    ::Val{Symbol("3.0.0")},
)
    for component in raw["data"]["components"]
        if component["__metadata__"]["type"] == "Bus"
            component["__metadata__"]["type"] = "ACBus"
            continue
        end
        if component["__metadata__"]["type"] == "HVDCLine"
            component["__metadata__"]["type"] = "TwoTerminalHVDCLine"
            continue
        end
        if component["__metadata__"]["type"] == "VSCDCLine"
            component["__metadata__"]["type"] = "TwoTerminalVSCDCLine"
            continue
        end
        if haskey(component, "prime_mover") && haskey(component, "dynamic_injector")
            component["prime_mover_type"] = pop!(component, "prime_mover")
        end
    end
    return
end

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("1.0.0")},
    ::Val{Symbol("3.0.0")},
)
    _convert_data!(raw, Val{Symbol("1.0.0")}(), Val{Symbol("2.0.0")}())
    _convert_data!(raw, Val{Symbol("2.0.0")}(), Val{Symbol("3.0.0")}())
    return
end

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("1.0.1")},
    ::Val{Symbol("3.0.0")},
)
    _convert_data!(raw, Val{Symbol("2.0.0")}(), Val{Symbol("3.0.0")}())
    return
end

_convert_cost(old_cost::Real) = LinearFunctionData(old_cost)

_convert_cost((squared_term, proportional_term)::Tuple{<:Real, <:Real}) =
    QuadraticFunctionData(squared_term, proportional_term, 0)

function _convert_cost(points::Vector)
    # We can't rely on the typing to be nice after deserialization, so "dispatch" on the structure
    ((length(points) == 2) && all(typeof.(points) .<: Real)) &&
        return _convert_cost(Tuple(points))

    @assert all(length.(points) .== 2)
    @assert all([all(typeof.(point) .<: Real) for point in points])
    # NOTE: old representation stored points as (y, x); new representation is (x, y)
    return PiecewiseLinearData([(x, y) for (y, x) in points])
end

# _convert_op_cost: take a component type, an old operational cost type, and old operational
# cost data; and create the proper new operational cost struct. Some of these cost structs
# no longer exist, so we dispatch instead on symbols.
_convert_op_cost(::Val{:ThermalStandard}, ::Val{:ThreePartCost}, op_cost::Dict) =
    ThermalGenerationCost(
        CostCurve(InputOutputCurve(op_cost["variable"])),
        op_cost["fixed"],
        op_cost["start_up"],
        op_cost["shut_down"],
    )

# TODO implement remaining _convert_op_cost methods 

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("3.0.0")},
    ::Val{Symbol("4.0.0")},
)
    for component in vcat(raw["data"]["components"], raw["data"]["masked_components"])
        # Convert costs: all old cost structs are in fields named `operation_cost`
        if haskey(component, "operation_cost")
            op_cost = component["operation_cost"]
            # Step 1: insert a FunctionData
            if op_cost["__metadata__"]["type"] in COST_CONTAINERS &&
               haskey(op_cost["variable"], "cost")
                old_cost = op_cost["variable"]["cost"]
                new_cost = _convert_cost(old_cost)
                op_cost["variable"] = new_cost
            end
            # Step 2: convert TwoPartCost/ThreePartCost to new domain-specific cost structs
            comp_type = Val{Symbol(component["__metadata__"]["type"])}()
            op_cost_type = Val{Symbol(op_cost["__metadata__"]["type"])}()
            new_op_cost = IS.serialize(_convert_op_cost(comp_type, op_cost_type, op_cost))
            component["operation_cost"] = new_op_cost
        end
    end
end

function _convert_data!(
    raw::Dict{String, Any},
    from::Val,
    ::Val{Symbol("4.0.0")},
)
    _convert_data!(raw, from, Val{Symbol("3.0.0")}())
    _convert_data!(raw, Val{Symbol("3.0.0")}(), Val{Symbol("4.0.0")}())
    return
end

# Conversions to occur immediately after the data is loaded from disk
function pre_read_conversion!(raw)
    if VersionNumber(raw["data_format_version"]) < v"4.0.0"
        haskey(raw["data"], "subsystems") ||
            (raw["data"]["subsystems"] = Dict{String, Any}())
        haskey(raw["data"], "attributes") || (raw["data"]["attributes"] = Any[])
    end
end

# Conversions to occur before deserialize_components!
function pre_deserialize_conversion!(raw, sys::System)
    old = raw["data_format_version"]
    if old == DATA_FORMAT_VERSION
        return
    else
        _convert_data!(raw, Val{Symbol(old)}(), Val{Symbol(DATA_FORMAT_VERSION)}())
        @warn(
            "System loaded in the data format version $old will be automatically upgraded to $DATA_FORMAT_VERSION upon saving"
        )
    end
end

# Conversions to occur at the end of deserialization
function post_deserialize_conversion!(sys::System, raw)
    old = raw["data_format_version"]
    if old == "1.0.1" || old == "2.0.0" || old == "3.0.0"
        # Version 1.0.1 can be converted
        raw["data_format_version"] = DATA_FORMAT_VERSION
        @warn(
            "System loaded in the data format version $old will be automatically upgraded to $DATA_FORMAT_VERSION upon saving"
        )
        return
    else
        error("Conversion of data from $old to $DATA_FORMAT_VERSION is not supported")
    end
end
