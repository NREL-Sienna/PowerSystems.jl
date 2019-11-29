
"""Enables deserialization of VariableCost. The default implementation can't figure out the
variable Union.
"""
function JSON2.read(io::IO, ::Type{VariableCost})
    data = JSON2.read(io)
    if data.cost isa Real
        return VariableCost(Float64(data.cost))
    elseif data.cost[1] isa Array
        variable = Vector{Tuple{Float64,Float64}}()
        for array in data.cost
            push!(variable, Tuple{Float64,Float64}(array))
        end
    else
        @assert data.cost isa Tuple || data.cost isa Array
        variable = Tuple{Float64,Float64}(data.cost)
    end

    return VariableCost(variable)
end
