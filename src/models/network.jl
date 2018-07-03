# TODO: Consider a dynamic rate problem, add time series in the rate calculations.

struct Network
    branches::Array{Branch}
    ybus::SparseMatrixCSC{Complex{Float64},Int64}
    ptdf::Union{Array{Float64},Nothing}
    incidence::Array{Int}
end

function Network(branches::Array{T}, nodes::Array{Bus}) where {T<:Branch}
    ybus = BuildYbus(length(nodes),branches);
    ptdf, A = BuildPTDF(branches, nodes)

    return Network(branches, ybus, ptdf, A)

end

