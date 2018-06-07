function printGenerator(io::IO, generator::PowerSystems.Generator)
    generator_type = typeof(generator)
    print(io, "$generator_type(name=\"$(generator.name)\")")
end

Base.show(io::IO, generator::PowerSystems.Generator) = printGenerator(io, generator)

function printPowerSystem(io::IO, system::PowerSystems.PowerSystem)
    number_of_buses = length(system.buses)
    number_of_branches = length(system.network.branches)
    number_of_generators = length(collect(Iterators.flatten(values(system.generators))))
    print(io, "$(typeof(system))(buses=$number_of_buses, generators=$number_of_generators, branches=$number_of_branches)")
end

Base.show(io::IO, system::PowerSystems.PowerSystem) = printPowerSystem(io, system)
