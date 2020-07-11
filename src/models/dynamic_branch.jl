mutable struct DynamicBranch <: ACBranch
    branch::ACBranch
    n_states::Int64
    states::Vector{Symbol}
    internal::IS.InfrastructureSystemsInternalinternal::IS.InfrastructureSystemsInternal
    function DynamicLine(branch::T) where {T <: ACBranch}
        IS.@forward((DynamicBranch, :device), T)
        n_states = 2
        states = [
            :Il_R
            :Il_I
        ]
        new(branch, n_states, states, IS.InfrastructureSystemsInternal())
    end
end
