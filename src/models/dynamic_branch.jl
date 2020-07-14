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

function DynamicBranch(; branch)
    DynamicBranch(branch)
end

function DynamicBranch(::Nothing)
    DynamicBranch(Line(nothing))
end

"Get branch"
get_branch(value::DynamicBranch) = value.branch
"Get n_states"
get_n_states(value::DynamicBranch) = value.n_states
"Get states"
get_states(value::DynamicBranch) = value.states

"Set branch"
set_branch!(value::DynamicBranch, val::ACBranch) = value.branch = val
"Set n_states"
set_n_states!(value::DynamicBranch, val::Int64) = value.n_states = val
"Set states"
set_states!(value::DynamicBranch, val::Vector{Symbol}) = value.states = val
