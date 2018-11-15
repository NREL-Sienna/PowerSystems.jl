# Generic print for power system components (a new type that includes genration
# technology types). The long version simply prints every field of the
# device. Tailored versions can be made for specific devices, if/when
# desired. JJS 11/15/18
function printPST(pst::PowerSystemComponent, short = false,
                  io::IO = stdout)
    if short
        pst_type = typeof(pst)
        # objects of type TechnicalParams do not have a 'name' field
        if in(:name, fieldnames(typeof(pst)))
            print(io, "$pst_type(name=\"$(pst.name)\")")
        else
            print(io, "$pst_type")
        end
    else
        print(typeof(pst),":")
        fnames = fieldnames(typeof(pst))
        for i = 1:nfields(fnames)
            thefield = getfield(pst, i)
            # avoid warning about printing nothing
            if thefield==nothing
                print("\n   ", fnames[i], ": nothing")
            else
                print("\n   ", fnames[i], ": ", getfield(pst, i))
            end
        end
    end
end
# overload Base.show with printPST function defined above
# single-line format
Base.show(io::IO, pst::PowerSystemComponent) = printPST(pst, true, io)
# Multi-line format for plaintext (e.g. from repl); can specify for HTML and
# others too
Base.show(io::IO, ::MIME"text/plain", pst::PowerSystemComponent) =
    printPST(pst, false, io)




function printPowerSystem(io::IO, system::PowerSystem)
    number_of_buses = length(system.buses)
    isa(system.branches,Nothing) ? number_of_branches = 0 : number_of_branches = length(system.branches)
    #number_of_generators = length(collect(Iterators.flatten(values(system.generators))))
    print(io, "$(typeof(system))(buses=$number_of_buses, branches=$number_of_branches)")
end

Base.show(io::IO, system::PowerSystem) = printPowerSystem(io, system)
