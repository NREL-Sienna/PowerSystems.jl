# "smart" summary and REPL printing

# Generic print for power system components (a new type that includes generation
# technology types). The long version simply prints every field of the
# device. Tailored versions can be made for specific devices, if/when
# desired. JJS 11/15/18
function printPST(pst::Union{Component, GenClasses}, short = false,
                  io::IO = stdout)
    if short
        pst_summary = Base.summary(pst)
        # objects of type TechnicalParams do not have a 'name' field
        if in(:name, fieldnames(typeof(pst)))
            print(io, "$pst_summary(name=\"$(pst.name)\")")
        else
            print(io, "$pst_summary")
        end
    else
        print(io, Base.summary(pst),":")
        fnames = fieldnames(typeof(pst))
        for i = 1:nfields(fnames)
            thefield = getfield(pst, i)
            # avoid warning about printing nothing
            if thefield==nothing
                print(io, "\n   ", fnames[i], ": nothing")
            else
                print(io, "\n   ", fnames[i], ": ", thefield)
            end
        end
    end
end
# overload Base.show with printPST function defined above
# single-line format
Base.show(io::IO, pst::Union{Component, GenClasses}) = printPST(pst, true, io)
# Multi-line format for plaintext (e.g. from repl); can specify for HTML and
# others too
Base.show(io::IO, ::MIME"text/plain", pst::Union{Component, GenClasses}) =
    printPST(pst, false, io)

# provide limited additional information to summary of GenClasses
function summaryGenClasses(gens::GenClasses)
    ntherm = gens.thermal isa Nothing ? 0 : length(gens.thermal)
    nrenew = gens.renewable isa Nothing ? 0 : length(gens.renewable)
    nhydro = gens.hydro isa Nothing ? 0 : length(gens.hydro)
    return "GenClasses(T:$ntherm,R:$nrenew,H:$nhydro)"
end
Base.summary(gens::GenClasses) = summaryGenClasses(gens::GenClasses)


# improve output for System

# overload Base.summary for System to be useful, e.g., in output of
# varinfo(); also used now in printPowerSystem, JJS 11/26/18
function summaryPowerSystem(system::System)
    busstr = string("buses:", length(system.buses))
    genstr = Base.summary(system.generators)
    loadstr = string("loads:", length(system.loads))
    branchstr = system.branches isa Nothing ? "nothing" :
        string("branches:", length(system.branches))
    # is storage an array? not sure yet, JJS 11/28/18
    storstr = system.storage isa Nothing ? "nothing" :
        string("storage:", length(system.storage))
    # include some output for basepower or time_periods? currently not doing so
    output = string("System($busstr,$genstr,$loadstr,$branchstr,$storstr)")
    return output
end
Base.summary(system::System) = summaryPowerSystem(system::System)

# print function for System type
function printPowerSystem(system::System, short = false,
                  io::IO = stdout)
    if short
        print(io, Base.summary(system))
    else
        print(io, "System:")
        fnames = fieldnames(typeof(system))
        for i = 1:nfields(fnames)
            fname = fnames[i]
            thefield = getfield(system, i)
            if thefield==nothing
                print(io, "\n   ", fname, ": nothing")
            elseif fname==:generators
                # print out long version for generators
                print(io, "\n   ", fname, ": \n     ")
                printPST(system.generators, false, io)
                print(io, "\n     (end generators)")
            else
                print(io, "\n   ", fname, ": ", thefield)
            end
        end
    end
end
Base.show(io::IO, system::System) = printPowerSystem(system, true, io)
Base.show(io::IO, ::MIME"text/plain", system::System) =
    printPowerSystem(system, false, io)

