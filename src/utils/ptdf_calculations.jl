# TODO: Enable distributed slack buses
function BuildPTDF(branches::Array{T}, nodes::Array{Bus}) where {T<:Branch}

    buscount = length(nodes)
    linecount = length(branches)

    for b in nodes
        if b.number < -1
            error("buses must be numbered consecutively in the bus/node matrix")
        end
    end

    A = spzeros(Float64,buscount,linecount);
    B = spzeros(Float64,buscount,buscount);
    X = spzeros(Float64,linecount,linecount);

   #build incidence matrix
   #incidence_matrix = A

    for (ix,b) in enumerate(branches)

        A[b.connectionpoints.from.number, ix] =  1;

        A[b.connectionpoints.to.number, ix] = -1;

        if isa(b,PowerSystems.Transformer2W)

            Y11 = 1/b.x;
            X[ix,ix] = b.x;

        elseif isa(b,PowerSystems.TapTransformer)

            Y11 = (1/(b.tap*b.x));
            X[ix,ix] = b.x*b.tap;

        elseif typeof(b) == PowerSystems.Line

            Y11 = (1/b.x);
            X[ix,ix] = b.x;

        elseif typeof(b) == PowerSystems.Transformer3W

            error("3W Transformer not implemented about PTDF")

        end

        B[b.connectionpoints.from.number,
            b.connectionpoints.from.number] += Y11;
        Y12 = -1*Y11;
        B[b.connectionpoints.from.number,
            b.connectionpoints.to.number] += Y12;
        #Y21 = Y1
        B[b.connectionpoints.to.number,
            b.connectionpoints.from.number] += Y12;
        #Y22 = Y11;
        B[b.connectionpoints.to.number,
            b.connectionpoints.to.number] += Y11;

    end

    slack_position = -9;

    for n in nodes
        if n.bustype == "SF"
            slack_position = n.number
        end
    end

    # TODO: Make speed-up improvements in the matrix operations.
    if slack_position != -9
        B = B[setdiff(1:end, slack_position), setdiff(1:end, slack_position)]

        S = inv(full(X))*A[setdiff(1:end, slack_position), :]'*inv(full(B));

        S = hcat(S[:,1:slack_position-1],zeros(linecount,),S[:,slack_position:end])

    elseif slack_position == -9

        warn("Slack bus not identified in the Bus/Nodes list, can't build PTLDF")
        S = nothing

    end

    return S, A

end
