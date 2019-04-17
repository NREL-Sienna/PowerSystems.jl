function buildlodf(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1] ) where {T<:Branch}
    linecount = length(branches)
    ptdf , a = PowerSystems._buildptdf(branches,nodes,dist_slack)
    H =  gemm('N','N',ptdf,a)
    ptdf_denominator = H;
    for iline = 1:linecount
        if (1.0 - ptdf_denominator[iline,iline] ) < 1.0E-06
            ptdf_denominator[iline,iline] = 0.0;
        end
    end
    (Dem, dipiv, dinfo) = getrf!(Matrix{Float64}(LinearAlgebra.I,linecount,linecount) - Array(LinearAlgebra.Diagonal(ptdf_denominator)))
    LODF = gemm('N','N',H,getri!(Dem,dipiv))
    LODF = LODF - Array(LinearAlgebra.Diagonal(LODF)) - Matrix{Float64}(LinearAlgebra.I,linecount,linecount)
    return LODF
end