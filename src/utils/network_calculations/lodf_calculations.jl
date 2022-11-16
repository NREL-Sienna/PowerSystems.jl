"""
Line Outage Distribution Factors (LODFs) are a sensitivity measure of how a change in
a line’s flow affects the flows on other lines in the system.
"""
struct LODF{Ax, L <: NTuple{2, Dict}} <: PowerNetworkMatrix{Float64}
    data::Array{Float64, 2}
    axes::Ax
    lookup::L
end

function _buildlodf(branches, nodes, dist_slack::Array{Float64} = [0.1])
    linecount = length(branches)
    ptdf, a = PowerSystems._buildptdf(branches, nodes, dist_slack)
    H = gemm('N', 'N', ptdf, a)
    ptdf_denominator = H
    for iline in 1:linecount
        if (1.0 - ptdf_denominator[iline, iline]) < 1.0E-06
            ptdf_denominator[iline, iline] = 0.0
        end
    end
    (Dem, dipiv, dinfo) = getrf!(
        Matrix{Float64}(LinearAlgebra.I, linecount, linecount) -
        Array(LinearAlgebra.Diagonal(ptdf_denominator)),
    )
    lodf = gemm('N', 'N', H, getri!(Dem, dipiv))
    lodf =
        lodf - Array(LinearAlgebra.Diagonal(lodf)) -
        Matrix{Float64}(LinearAlgebra.I, linecount, linecount)
    return lodf
end

"""
Builds the LODF matrix from a group of branches and nodes. The return is a LOLDF array indexed with the branch name.

# Keyword arguments
- `dist_slack::Vector{Float64}`: Vector of weights to be used as distributed slack bus.
    The distributed slack vector has to be the same length as the number of buses
"""
function LODF(branches, nodes, dist_slack::Vector{Float64} = [0.1])

    #Get axis names
    line_ax = [branch.name for branch in branches]
    lodf = _buildlodf(branches, nodes, dist_slack)

    axes = (line_ax, line_ax)
    look_up = (_make_ax_ref(line_ax), _make_ax_ref(line_ax))

    return LODF(lodf, axes, look_up)
end

"""
Builds the LODF matrix from a system. The return is a LOLDF array indexed with the branch name.

# Keyword arguments
- `dist_slack::Vector{Float64}`: Vector of weights to be used as distributed slack bus.
    The distributed slack vector has to be the same length as the number of buses
"""
function LODF(sys::System, dist_slack::Vector{Float64} = [0.1])
    branches = sort!(
        collect(get_components(ACBranch, sys));
        by = x -> (get_number(get_arc(x).from), get_number(get_arc(x).to)),
    )
    nodes = sort!(collect(get_components(Bus, sys)); by = x -> get_number(x))
    return LODF(branches, nodes, dist_slack)
end
