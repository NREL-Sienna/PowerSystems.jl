function buildlodf(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1] ) where {T<:Branch}
    linecount = length(branches)
    ptdf , a = PowerSystems.buildptdf(branches,nodes,dist_slack)
    H = zeros(Float64,linecount,linecount)
    H = gemm('N','N',ptdf,a)
    h = diag(H)
    h = reshape(h,(linecount,1))
    LODF = H ./ (ones(Float64,linecount,linecount) - gemm('N','T',ones(Float64,linecount,1),h))
    LODF = LODF - Array(Diagonal(LODF)) - eye(linecount,linecount) 
    return LODF
end
