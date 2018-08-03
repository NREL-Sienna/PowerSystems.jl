function buildlodf(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1] ) where {T<:Branch}
    linecount = length(branches)
    ptdf , a = PowerSystems.buildptdf(branches,nodes,dist_slack)
    H = gemm('N','N',ptdf,a)
    h = reshape(diag(gemm('N','N',ptdf,a)),(linecount,1))
    LODF = gemm('N','N',ptdf,a) ./ (ones(Float64,linecount,linecount) - gemm('N','T',ones(Float64,linecount,1),h))
    LODF = LODF - Array(Diagonal(LODF)) - eye(linecount,linecount) 
    return LODF
end
