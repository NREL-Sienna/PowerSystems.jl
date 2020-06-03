
"""
    make_pf(sys)

Create the objects needed to solve an powerflow case using NLsolve.jl solvers. Returns
an anonymous function with the powerflow equations, initial conditions and a dict to link the
solutions to the original system. Only supports systems with a single generator per bus and
currently doesn't support distributed slack buses and doesn't enforce reactive power limits.

## Example
```julia
pf!, x0 = make_pf(sys)
res = NLsolve.nlsolve(pf!, x0)
```

# Arguments
    * `sys`::System : a PowerSystems.jl system

"""
function make_pf(system)

end
