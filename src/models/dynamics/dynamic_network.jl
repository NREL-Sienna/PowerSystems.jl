export DynamicNetwork

struct DynamicNetwork
    StaticNetwork :: Network
    Branches :: Array{T} where {T<:Branch}
    Nodes :: Array{Bus}
    Generators :: Array{Any}
    SysParams :: SystemParam
    NumberVariables :: Int32
    BusVariableIndexes ::Array{Int32}
    Model :: Function
    function DynamicNetwork(SysParams::SystemParam, Branches::Array{<:Branch}, Nodes::Array{Bus}, Generators :: Array{Any})
        StaticNetwork = Network(SysParams, Branches, Nodes)
        Model, BusVariableIndexes, NumberVariables = dynamic_network_model(Branches, Nodes, Generators, StaticNetwork.ybus)
        new(StaticNetwork, Branches, Nodes, Generators, SysParams, NumberVariables, BusVariableIndexes,Model)
    end
end


