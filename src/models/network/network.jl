include("branches.jl")
include("ybus_calculations.jl")
include("ptdf_calculations.jl")

export Network

struct Network 
    branches::Array{Branch}
    linecount::Int
    ybus::SparseMatrixCSC{Complex{Float64},Int64}
    ptdf::Union{Array{Float64},Nothing}
    incidence::Array{Int}

    function Network(branches::Array{T}, nodes::Array{Bus}) where {T<:Branch}
        
        buscount = length(nodes)
        ybus = PowerSystems.build_ybus(buscount,branches);
        ptdf, A = PowerSystems.build_ptdf(buscount, branches, nodes)    
        new(branches,
            length(branches),
            ybus, 
            ptdf,
            A)
    end

end

