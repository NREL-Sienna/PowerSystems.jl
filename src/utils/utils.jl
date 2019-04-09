
"""Returns an array of all subtypes of T in the module."""
function get_subtypes(::Type{T}, module_::Module) where T
    subtypes = []

    for name in names(module_)
        ps_type = getfield(module_, name)
        if isconcretetype(ps_type) && ps_type <: T
            @debug "$name is a subtype of $T"
            push!(subtypes, ps_type)
        end
    end

    return subtypes
end
