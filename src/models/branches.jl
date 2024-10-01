
""" Supertype for all branches"""
abstract type Branch <: Device end

""" Supertype for all AC branches (branches connecting at least one AC node)"""
abstract type ACBranch <: Branch end

""" Supertype for all DC branches (branches that connect only DC nodes)"""
abstract type DCBranch <: Branch end

get_from_bus(b::T) where {T <: Branch} = b.arc.from
get_to_bus(b::T) where {T <: Branch} = b.arc.to
