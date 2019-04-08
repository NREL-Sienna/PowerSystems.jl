abstract type Storage <: PowerSystemDevice end
StorageDevices = Array{<: Storage, 1}
const OptionalStorage = Union{Nothing, StorageDevices}

include("storage/batteries.jl")
