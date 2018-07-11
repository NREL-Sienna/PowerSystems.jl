function build_ptdf(branches::Array{T}, nodes::Array{Bus}) where {T<:Branch}

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

        elseif isa(b,Transformer3W)
            error("3W Transformer not implemented about PTDF")
        end
    end
    slack_position = [num_bus[n.number] for n in nodes if n.bustype == "SF"]
                
    B = gemm('N','T', gemm('N','N',A[setdiff(1:end, slack_position),1:end] ,inv_X), A[setdiff(1:end, slack_position),1:end])

    if length(slack_position) == 1
        slack_position = slack_position[1]
        (B, bipiv, binfo) = getrf!(B)
        S_ = gemm('N','N', gemm('N','T', inv_X, A[setdiff(1:end, slack_position), :]), getri!(B, bipiv) )
        S = hcat(S_[:,1:slack_position-1],zeros(linecount,),S_[:,slack_position:end])
    elseif length(slack_position) > 1
        (B, bipiv, binfo) = getrf!(B)
        S_ = gemm('N','N', gemm('N','T', inv_X, A[setdiff(1:end, slack_position), :]), getri!(B, bipiv) )
        slack_array = [x in slack_position ? 1 : 0 for x in 1:buscount]
        slack_array =slack_array/sum(slack_array)
        S = S_*ones(buscount,buscount) - slack_array*ones(1,buscount)
    elseif length(slack_position) == 0
        warn("Slack bus not identified in the Bus/Nodes list, can't build PTLDF")
        S = nothing
    end
    return  S , A

end