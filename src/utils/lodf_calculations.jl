function buildlodf(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1] ) where {T<:Branch}
    linecount = length(branches)
    ptdf , a = PowerSystems.buildptdf(branches,nodes,dist_slack)
    H = gemm('N','N',ptdf,a)
    h = reshape(diag(gemm('N','N',ptdf,a)),(linecount,1))
    (Dem, dipiv, dinfo) = getrf!(eye(Float64,linecount,linecount) - Array(Diagonal(H)))
    LODF = gemm('N','N',H,getri!(Dem,dipiv))
    LODF = LODF - Array(Diagonal(LODF)) - eye(linecount,linecount) 
    return LODF
end
