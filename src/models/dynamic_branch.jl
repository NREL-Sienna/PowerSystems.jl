mutable struct DynamicBranch <: ACBranch
    branch::ACBranch
    n_states::Int64
    states::Vector{Symbol}
    internal::IS.InfrastructureSystemsInternal
    function DynamicBranch(branch::T) where {T <: ACBranch}
        IS.@forward((DynamicBranch, :branch), T)
        n_states = 2
        states = [
            :Il_R
            :Il_I
        ]
        new(branch, n_states, states, IS.InfrastructureSystemsInternal())
    end
end
