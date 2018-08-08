function printPST(io::IO, pst::PowerSystemDevice)
    pst_type = typeof(pst)
    print(io, "$pst_type(name=\"$(pst.name)\")")
end

Base.show(io::IO, pst::PowerSystemDevice) = printPST(io, pst)

function printPowerSystem(io::IO, system::PowerSystem)
    number_of_buses = length(system.buses)
    isa(system.branches,Nothing) ? number_of_branches = 0 : number_of_branches = length(system.branches)
    #number_of_generators = length(collect(Iterators.flatten(values(system.generators))))
    print(io, "$(typeof(system))(buses=$number_of_buses, branches=$number_of_branches)")
end

Base.show(io::IO, system::PowerSystem) = printPowerSystem(io, system)
