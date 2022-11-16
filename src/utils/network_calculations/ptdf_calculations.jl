"""
Power Transfer Distribution Factors (PTDF) indicate the incremental change in real power that occurs on transmission lines due to real power injections changes at the buses.

The PTDF struct is indexed using the Bus numbers and branch names
"""
struct PTDF{Ax, L <: NTuple{2, Dict}} <: PowerNetworkMatrix{Float64}
    data::Array{Float64, 2}
    axes::Ax
    lookup::L
end

function binfo_check(binfo::Int)
    if binfo != 0
        if binfo < 0
            error("Illegal Argument in Inputs")
        elseif binfo > 0
            error("Singular value in factorization. Possibly there is an islanded bus")
        else
            @assert false
        end
    end
    return
end

function _buildptdf(branches, nodes, dist_slack::Vector{Float64})
    buscount = length(nodes)
    linecount = length(branches)

    bus_lookup = _make_ax_ref(nodes)

    A = zeros(Float64, buscount, linecount)
    inv_X = zeros(Float64, linecount, linecount)

    #build incidence matrix
    for (ix, b) in enumerate(branches)
        if isa(b, DCBranch)
            @warn("PTDF construction ignores DC-Lines")
            continue
        end

        (fr_b, to_b) = get_bus_indices(b, bus_lookup)
        A[fr_b, ix] = 1
        A[to_b, ix] = -1

        inv_X[ix, ix] = get_series_susceptance(b)
    end

    slacks = [bus_lookup[get_number(n)] for n in nodes if get_bustype(n) == BusTypes.REF]
    isempty(slacks) && error("System must have a reference bus!")

    slack_position = slacks[1]
    B = gemm(
        'N',
        'T',
        gemm('N', 'N', A[setdiff(1:end, slack_position), 1:end], inv_X),
        A[setdiff(1:end, slack_position), 1:end],
    )
    if dist_slack[1] == 0.1 && length(dist_slack) == 1
        (B, bipiv, binfo) = getrf!(B)
        binfo_check(binfo)
        S = gemm(
            'N',
            'N',
            gemm('N', 'T', inv_X, A[setdiff(1:end, slack_position), :]),
            getri!(B, bipiv),
        )
        @views S =
            hcat(S[:, 1:(slack_position - 1)], zeros(linecount), S[:, slack_position:end])
    elseif dist_slack[1] != 0.1 && length(dist_slack) == buscount
        @info "Distributed bus"
        (B, bipiv, binfo) = getrf!(B)
        binfo_check(binfo)
        S = gemm(
            'N',
            'N',
            gemm('N', 'T', inv_X, A[setdiff(1:end, slack_position), :]),
            getri!(B, bipiv),
        )
        @views S =
            hcat(S[:, 1:(slack_position - 1)], zeros(linecount), S[:, slack_position:end])
        slack_array = dist_slack / sum(dist_slack)
        slack_array = reshape(slack_array, buscount, 1)
        S = S - gemm('N', 'N', gemm('N', 'N', S, slack_array), ones(1, buscount))
    elseif length(slack_position) == 0
        @warn("Slack bus not identified in the Bus/Nodes list, can't build PTDF")
        S = Array{Float64, 2}(undef, linecount, buscount)
    else
        @assert false
    end

    return S, A
end

"""
Builds the PTDF matrix from a group of branches and nodes. The return is a PTDF array indexed with the bus numbers.

# Keyword arguments
- `dist_slack::Vector{Float64}`: Vector of weights to be used as distributed slack bus.
    The distributed slack vector has to be the same length as the number of buses
"""
function PTDF(branches, nodes, dist_slack::Vector{Float64} = [0.1])
    #Get axis names
    line_ax = [get_name(branch) for branch in branches]
    bus_ax = [get_number(bus) for bus in nodes]
    S, A = _buildptdf(branches, nodes, dist_slack)

    axes = (line_ax, bus_ax)
    look_up = (_make_ax_ref(line_ax), _make_ax_ref(bus_ax))
    return PTDF(S, axes, look_up)
end

"""
Builds the PTDF matrix from a system. The return is a PTDF array indexed with the bus numbers.

# Keyword arguments
- `dist_slack::Vector{Float64}`: Vector of weights to be used as distributed slack bus.
    The distributed slack vector has to be the same length as the number of buses
"""
function PTDF(sys::System, dist_slack::Vector{Float64} = [0.1])
    branches = sort!(
        collect(get_components(ACBranch, sys));
        by = x -> (get_number(get_arc(x).from), get_number(get_arc(x).to)),
    )
    nodes = sort!(collect(get_components(Bus, sys)); by = x -> get_number(x))
    return PTDF(branches, nodes, dist_slack)
end
