
struct LODF <: PowerNetworkMatrix
    data::Array{Float64,2}
    axes::NTuple{2,Array}
    lookup::NTuple{2,Dict}
end

function _buildlodf(branches, nodes, dist_slack::Array{Float64}=[0.1] )
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
    lodf = gemm('N','N',H,getri!(Dem,dipiv))
    lodf = lodf - Array(LinearAlgebra.Diagonal(lodf)) - Matrix{Float64}(LinearAlgebra.I,linecount,linecount)
    return lodf
end

function LODF(branches, nodes, dist_slack::Array{Float64}=[0.1])

    #Get axis names
    line_ax = [branch.name for branch in branches]
    lodf = _buildlodf(branches, nodes, dist_slack)

    axes = (line_ax, line_ax)
    look_up = (_make_ax_ref(line_ax),_make_ax_ref(line_ax))

    return LODF(lodf, axes, look_up)

end

function LODF(sys::System, dist_slack::Array{Float64}=[0.1])
    branches = get_components(ACBranch, sys)
    nodes = get_components(Bus, sys)

    return LODF(branches, nodes, dist_slack)

end
