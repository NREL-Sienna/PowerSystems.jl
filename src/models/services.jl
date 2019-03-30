
abstract type Service <: PowerSystemComponent end

include("products/reserves.jl")
include("products/transfers.jl")