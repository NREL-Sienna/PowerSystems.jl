export Branch
export Line
export Transformer
export Network

abstract type 
    Branch
end

struct Line <: Branch
    number::Int
    status::Bool
    connectionpoints::Tuple{Bus,Bus}
    basevoltage::Float64 #[kV]    
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::Float64 #[pu]
    rate::Float64  #[MVA]
end

struct Transformer <: Branch
    number::Int
    status::Bool
    connectionpoints::Tuple{Bus,Bus}    
    basevoltage::Float64 #[kV]
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::Float64 #[pu]
    rate::Float64  #[MVA]
end

function build_ybus(sys::SystemParam, branches::Array{Branch})

    Ybus = spzeros(Complex{Float64},sys.busquantity,sys.busquantity)
    max_flows = Array{Float64,2}(length(branches),2)
    
    for b in branches

        Y11 = (1/(b.r + b.x*1im) + (1im*b.b)/2)*b.status;
        Ybus[b.connectionpoints[1].number,
             b.connectionpoints[1].number] += Y11;
        Y12 = (-1./(b.r + b.x*1im))*b.status;
        Ybus[b.connectionpoints[1].number, 
             b.connectionpoints[2].number] += Y12;
        #Y21 = Y12
        Ybus[b.connectionpoints[2].number, 
             b.connectionpoints[1].number] += Y12;
        #Y22 = Y11;
        Ybus[b.connectionpoints[2].number,
             b.connectionpoints[2].number] += Y11;    

        max_flows[b.number,1] = b.rate
             
    end

    return Ybus, max_flows

end 

function build_ptdf(sys::SystemParam, branches::Array{Branch}, nodes::Array{Bus})

    n_b = length(branches)
    
    slack_position = -9; 

    for n in nodes
        if n.bustype == "SF"
            slack_position = n.number
        end
    end

    if slack_position == -9 
        error("Slack bus not identified")
    end

    n_n = sys.busquantity;

    A = spzeros(Float64,n_n,n_b);
    B = zeros(n_n,n_n);
    X = zeros(n_b,n_b);

    for b in branches

        A[b.connectionpoints[1].number, b.number] =  1;

        A[b.connectionpoints[2].number, b.number] = -1;

        X[b.number,b.number] = b.X;

        Y11 = (1/b.X)*b.status;
        B[b.connectionpoints[1].number,
            b.connectionpoints[1].number] += Y11;
        Y12 = -1*Y11;
        B[b.connectionpoints[1].number, 
            b.connectionpoints[2].number] += Y12;
        #Y21 = Y1
        B[b.connectionpoints[2].number, 
            b.connectionpoints[1].number] += Y12;
        #Y22 = Y11;
        B[b.connectionpoints[2].number,
            b.connectionpoints[2].number] += Y11;

    end

    incidence_matrix = A;

    B = B[setdiff(1:end, slack_position), setdiff(1:end, slack_position)]

    A = A[setdiff(1:end, slack_position), :]

    S = inv(X)*A'*inv(B);
    
    S = hcat(S[:,1:slack_position-1],zeros(n_b,),S[:,slack_position:end-1])

    return S, incidence_matrix

end

struct Network 
    linequantity::Int
    ybus::SparseMatrixCSC{Complex{Float64},Int64}
    ptdlf::Array{Float64} 
    incidence::Array{Int}
    maxflows::Array{Float64,2} 

    function Network(sys::SystemParam, branches::Array{Branch}, nodes::Array{Bus})
        ybus, maxflow = build_ybus(sys,branches);
        ptdfl, A = build_ptdf(sys, branches, nodes)    
        new(length(branches),
            ybus, 
            ptdlf,
            A,
            maxflow)
    end

end

