export DynamicsGenerator
export DynamicsPowerConverter

include("dynamics/synch_machine.jl")
include("dynamics/prime_movers.jl")
include("dynamics/control_dynamics.jl")


struct DynamicsGenerator
    generator::SynchronousMachine
    primermover::PrimeMover
    excitation::Any
    powercontrol::Any
    voltageregulator::Any
end

struct DynamicsPowerConverter

end