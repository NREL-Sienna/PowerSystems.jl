abstract type ProductionVariableCost end

IS.serialize(val::ProductionVariableCost) = IS.serialize_struct(val)
IS.deserialize(T::Type{<:ProductionVariableCost}, val::Dict) = IS.deserialize_struct(T, val)
