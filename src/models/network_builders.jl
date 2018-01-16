export create_network
export build_ptdf
export build_ybus

function build_ybus(sys::system_param, branches::Array{branch})
# for now, this function only considers line elements. No transformers models yet. 

    Ybus = spzeros(Complex{Float64},sys.BusQuantity,sys.BusQuantity)
    max_flows = Array{Float64,2}(length(branches),2)
    
    for b in branches

        Y11 = (1/(b.R + b.X*1im) + (1im*b.B)/2)*b.status;
        Ybus[b.ConnectionPoints[1].Number,
             b.ConnectionPoints[1].Number] += Y11;
        Y12 = (-1./(b.R + b.X*1im))*b.status;
        Ybus[b.ConnectionPoints[1].Number, 
             b.ConnectionPoints[2].Number] += Y12;
        #Y21 = Y12
        Ybus[b.ConnectionPoints[2].Number, 
             b.ConnectionPoints[1].Number] += Y12;
        #Y22 = Y11;
        Ybus[b.ConnectionPoints[2].Number,
             b.ConnectionPoints[2].Number] += Y11;    

        max_flows[b.number,1] = b.MaxCapacity_forward
        max_flows[b.number,2] =b.MaxCapacity_backward
             
    end

    return Ybus, max_flows

end 

function build_ptdf(sys::system_param, branches::Array{branch}, nodes::Array{bus})

    n_b = length(branches)
    
    slack_position = -9; 

    for n in nodes
        if n.BusType == "SF"
            slack_position = n.Number
        end
    end

    if slack_position == -9 
        error("Slack bus not identified")
    end

    n_n = sys.BusQuantity;

    A = spzeros(Float64,n_n,n_b);
    B = zeros(n_n,n_n);
    X = zeros(n_b,n_b);

    for b in branches

        A[b.ConnectionPoints[1].Number, b.number] =  1;

        A[b.ConnectionPoints[2].Number, b.number] = -1;

        X[b.number,b.number] = b.X;

        Y11 = (1/b.X)*b.status;
        B[b.ConnectionPoints[1].Number,
            b.ConnectionPoints[1].Number] += Y11;
        Y12 = -1*Y11;
        B[b.ConnectionPoints[1].Number, 
            b.ConnectionPoints[2].Number] += Y12;
        #Y21 = Y1
        B[b.ConnectionPoints[2].Number, 
            b.ConnectionPoints[1].Number] += Y12;
        #Y22 = Y11;
        B[b.ConnectionPoints[2].Number,
            b.ConnectionPoints[2].Number] += Y11;

    end

    incidence_matrix = A;

    B = B[setdiff(1:end, slack_position), setdiff(1:end, slack_position)]

    A = A[setdiff(1:end, slack_position), :]

    S = inv(X)*A'*inv(B);
    
    S = hcat(S[:,1:slack_position-1],zeros(n_b,),S[:,slack_position:end-1])

    return S, incidence_matrix

end

function create_network(sys::system_param, branches::Array{branch}, nodes::Array{bus})

    ybus_result, max_flow = build_ybus(sys,branches);
    ptdfl, A = build_ptdf(sys, branches, nodes)

    net = network(length(branches), 
                    ybus_result,
                    ptdfl,
                    A,
                    max_flow)

    return net
end