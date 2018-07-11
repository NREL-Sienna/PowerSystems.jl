function build_ptdf(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1] ) where {T<:Branch}

    buscount = length(nodes)
    linecount = length(branches)
    num_bus = Dict{Int,Int}()
    Theta = zeros(Float64,buscount);
    for (ix,b) in enumerate(nodes)
        if b.number < -1
            error("buses must be numbered consecutively in the bus/node matrix")
        end
        num_bus[b.number] = ix
        Theta[ix] = b.angle
    end

    A = zeros(Float64,buscount,linecount);
    inv_X = zeros(Float64,linecount,linecount);

   #build incidence matrix
   #incidence_matrix = A

    for (ix,b) in enumerate(branches)

        isa(b,DCLine) ? continue : true

        A[num_bus[b.connectionpoints.from.number], ix] =  1;

        A[num_bus[b.connectionpoints.to.number], ix] = -1;

        if isa(b,Transformer2W)
            inv_X[ix,ix] = 1/b.x;

        elseif isa(b,TapTransformer)
            inv_X[ix,ix] = 1/b.x*b.tap;

        elseif isa(b, Line)
            inv_X[ix,ix] = 1/b.x;

        elseif isa(b,PhaseShiftingTransformer)
            y = 1 / (b.r + b.x * 1im)
            y_a = y / (b.tap * exp(b.α * 1im * (π / 180)))
            inv_X[ix,ix] = 1/imag(y_a)
        end
    end
    slacks = [num_bus[n.number] for n in nodes if n.bustype == "SF"]
    slack_position = slacks[1]
    B = gemm('N','T', gemm('N','N',A[setdiff(1:end, slacks[1]),1:end] ,inv_X), A[setdiff(1:end, slacks[1]),1:end])

    if dist_slack[1] == 0.1 && length(dist_slack) ==1
        (B, bipiv, binfo) = getrf!(B)
        S_ = gemm('N','N', gemm('N','T', inv_X, A[setdiff(1:end, slack_position), :]), getri!(B, bipiv) )
        S = hcat(S_[:,1:slack_position-1],zeros(linecount,),S_[:,slack_position:end])

    elseif dist_slack[1] != 0.1 && length(dist_slack)  == buscount
        println("Distributed bus")
        (B, bipiv, binfo) = getrf!(B)
        S_ = gemm('N','N', gemm('N','T', inv_X, A[setdiff(1:end, slack_position), :]), getri!(B, bipiv) )
        S = hcat(S_[:,1:slack_position-1],zeros(linecount,),S_[:,slack_position:end])
        slack_array =dist_slack/sum(dist_slack)
        slack_array = reshape(slack_array,buscount,1)
        S = S - gemm('N','N',gemm('N','N',S,slack_array),ones(1,buscount))

    elseif length(slack_position) == 0
        warn("Slack bus not identified in the Bus/Nodes list, can't build PTLDF")
        S = nothing
    end
    return  S , A

end