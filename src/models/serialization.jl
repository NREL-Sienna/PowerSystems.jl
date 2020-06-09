
# Enables deserialization of VariableCost. The default implementation can't figure out the
# variable Union.

function JSON2.read(io::IO, ::Type{VariableCost})
    data = JSON2.read(io)
    if data.cost isa Real
        return VariableCost(Float64(data.cost))
    elseif data.cost[1] isa Array
        variable = Vector{Tuple{Float64, Float64}}()
        for array in data.cost
            push!(variable, Tuple{Float64, Float64}(array))
        end
    else
        @assert data.cost isa Tuple || data.cost isa Array
        variable = Tuple{Float64, Float64}(data.cost)
    end

    return VariableCost(variable)
end

const COMPOSED_COMPONENTS = (Area, Bus, LoadZone)

function JSON2.write(io::IO, component::T) where {T <: Component}
    return JSON2.write(io, encode_components_with_uuids(component, COMPOSED_COMPONENTS))
end

function JSON2.write(component::T) where {T <: Component}
    return JSON2.write(encode_components_with_uuids(component, COMPOSED_COMPONENTS))
end

function encode_components_with_uuids(component::T, types_as_uuids) where {T}
    fields = fieldnames(T)
    vals = []

    for name in fields
        val = getfield(component, name)
        if mapreduce(x -> val isa x, |, types_as_uuids)
            push!(vals, IS.get_uuid(val))
        else
            push!(vals, val)
        end
    end

    return NamedTuple{fields}(vals)
end

# Default JSON conversion for Component to handle composed components stored as UUIDs.
# Keep in sync with COMPOSED_COMPONENTS.

function IS.convert_type(
    ::Type{T},
    data::NamedTuple,
    component_cache::Dict,
) where {T <: Component}
    @debug T data
    values = []
    for (fieldname, fieldtype) in zip(fieldnames(T), fieldtypes(T))
        val = getfield(data, fieldname)
        if !isnothing(val) && (
            fieldtype <: Union{Nothing, Area} ||
            fieldtype <: Union{Nothing, LoadZone} ||
            fieldtype <: Bus
        )
            uuid = Base.UUID(val.value)
            component = component_cache[uuid]
            push!(values, component)
        elseif fieldtype <: Component
            # Recurse.
            push!(values, IS.convert_type(fieldtype, val, component_cache))
        else
            obj = IS.convert_type(fieldtype, val)
            push!(values, obj)
        end
    end

    return T(values...)
end
