include("branches.jl")
include("ybus_calculations.jl")
include("ptdf_calculations.jl")

export Network

# To Do
# 1. Consider a dynamic rate problem, add time series in the rate calculations.

struct Network
    branches::Array{Branch}
    ybus::SparseMatrixCSC{Complex{Float64},Int64}
    ptdf::Union{Array{Float64},Nothing}
    incidence::Array{Int}
end

function Network(branches::Array{T}, nodes::Array{Bus}) where {T<:Branch}
    buscount = length(nodes)
    ybus = PowerSystems.build_ybus(buscount,branches);
    ptdf, A = PowerSystems.build_ptdf(buscount, branches, nodes)

    return Network(branches, ybus, ptdf, A) 
    
end

