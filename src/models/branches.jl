abstract type Branch <: Device end
abstract type ACBranch <: Branch end
abstract type DCBranch <: Branch end
abstract type ACLine <: ACBranch end
abstract type ACTransformer <: ACBranch end

get_from_bus(b::T) where {T <: Branch} = b.arc.from
get_to_bus(b::T) where {T <: Branch} = b.arc.to
