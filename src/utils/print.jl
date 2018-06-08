function printPST(io::IO, pst::PowerSystems.PowerSystemType)
    pst_type = typeof(pst)
    print(io, "$pst_type(name=\"$(pst.name)\")")
end

Base.show(io::IO, pst::PowerSystems.PowerSystemType) = printPST(io, pst)

function printPowerSystem(io::IO, system::PowerSystems.PowerSystem)
    number_of_buses = length(system.buses)
    number_of_branches = length(system.network.branches)
    number_of_generators = length(collect(Iterators.flatten(values(system.generators))))
    print(io, "$(typeof(system))(buses=$number_of_buses, generators=$number_of_generators, branches=$number_of_branches)")
end

Base.show(io::IO, system::PowerSystems.PowerSystem) = printPowerSystem(io, system)
