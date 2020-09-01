const _ENCODE_AS_UUID_A = (
    Union{Nothing, Arc},
    Union{Nothing, Area},
    Union{Nothing, Bus},
    Union{Nothing, LoadZone},
    Union{Nothing, DynamicInjection},
    Vector{Service},
)

const _ENCODE_AS_UUID_B = (Arc, Area, Bus, LoadZone, DynamicInjection, Vector{Service})
@assert length(_ENCODE_AS_UUID_A) == length(_ENCODE_AS_UUID_B)

should_encode_as_uuid(val) = any(x -> val isa x, _ENCODE_AS_UUID_B)
should_encode_as_uuid(::Type{T}) where {T} = any(x -> T <: x, _ENCODE_AS_UUID_A)

function IS.serialize(component::T) where {T <: Component}
    data = Dict{String, Any}()
    for name in fieldnames(T)
        data[string(name)] = serialize_uuid_handling(getfield(component, name))
    end

    return data
end

"""
Serialize the value, encoding as UUIDs where necessary.
"""
function serialize_uuid_handling(val)
    if should_encode_as_uuid(val)
        if val isa Array
            value = [IS.get_uuid(x) for x in val]
        elseif val === nothing
            value = nothing
        else
            value = IS.get_uuid(val)
        end
    else
        value = val
    end

    return serialize(value)
end

function IS.deserialize(::Type{T}, data::Dict, component_cache::Dict) where {T <: Component}
    @debug T data
    vals = Dict{Symbol, Any}()
    for (name, type) in zip(fieldnames(T), fieldtypes(T))
        vals[name] =
            deserialize_uuid_handling(type, name, data[string(name)], component_cache)
    end

    if !isempty(T.parameters)
        return deserialize_parametric_type(T, PowerSystems, vals)
    end

    return T(; vals...)
end

function IS.deserialize(::Type{Device}, data::Any)
    error("This form of IS.deserialize is not supported for Devices")
end

function IS.deserialize_parametric_type(
    ::Type{T},
    mod::Module,
    data::Dict,
) where {T <: Service}
    # This exists because Services need to be constructed with the parametric type included.
    # VariableReserve{ReserveUp}(...)
    return T(; data...)
end

"""
Deserialize the value, converting UUIDs to components where necessary.
"""
function deserialize_uuid_handling(field_type, field_name, val, component_cache)
    if val === nothing
        value = val
    elseif should_encode_as_uuid(field_type)
        if field_type <: Vector
            _vals = field_type()
            for _val in val
                uuid = deserialize(Base.UUID, _val)
                component = component_cache[uuid]
                push!(_vals, component)
            end
            value = _vals
        else
            uuid = deserialize(Base.UUID, val)
            component = component_cache[uuid]
            value = component
        end
    elseif field_type <: Component
        value = IS.deserialize(field_type, val, component_cache)
    elseif field_type <: Union{Nothing, Component}
        value = IS.deserialize(field_type.b, val, component_cache)
    elseif field_type <: InfrastructureSystemsType
        value = deserialize(field_type, val)
    elseif field_type <: Union{Nothing, InfrastructureSystemsType}
        value = deserialize(field_type.b, val)
    elseif field_type <: Enum
        value = get_enum_value(field_type, val)
    elseif field_type <: Union{Nothing, Enum}
        value = get_enum_value(field_type.b, val)
    else
        value = deserialize(field_type, val)
    end

    return value
end

function get_component_type(component_type::String)
    # This function will ensure that `component_type` contains a valid type expression,
    # so it should be safe to eval.
    return eval(IS.parse_serialized_type(component_type))
end
