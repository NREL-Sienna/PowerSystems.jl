
""" Supertype for all branches"""
abstract type Branch <: Device end

""" Supertype for all AC branches (branches connecting AC nodes or Areas)"""
abstract type ACBranch <: Branch end

""" Supertype for all AC transmission devices (devices connecting AC nodes only)"""
abstract type ACTransmission <: ACBranch end

""" Supertype for all Two Terminal HVDC transmission devices between AC Buses. Not to be confused with [DCBranch](@ref)"""
abstract type TwoTerminalHVDC <: ACBranch end

""" Supertype for all DC branches (branches that connect only DC nodes)"""
abstract type DCBranch <: Branch end

get_from_bus(b::T) where {T <: Branch} = b.arc.from
get_to_bus(b::T) where {T <: Branch} = b.arc.to
