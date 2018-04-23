export orderedlimits
export PlotTimeSeries

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") :limits

orderedlimits(limits::NamedTuple) = limits.max < limits.min ? error("Limits not in ascending order") : limits

orderedlimits(limits::Nothing) = warn("Limits defined as nothing")

# TODO: make Bus warning for no type

function PlotTimeSeries()

end


#=
Pretty-Printing
=#

# Conventional Gen

function printBus(short, io, b)
    print(io)
    if short
        print("Name: ", b.name)
        print(", Type: ", b.bustype)
    else
        print("Bus Number ", b.number, ":")
        print("\n   ", b) # Prints short version
        print("\n   Angle: ", b.angle)
        print("\n   Voltage: ", b.voltage)
        print("\n   Voltage Lims: ", b.voltagelims)
        print("\n   Base Voltage: ", b.basevoltage)
    end
end
# Single-line format
Base.show(io::IO, b::Bus) = printBus(true, io, b)
# Multi-line format for plaintext (e.g. from repl); can specify for HTML and others too
Base.show(io::IO, ::MIME"text/plain", b::Bus) = printBus(false, io, b)

function printTechGen(short, io, t)
    print(io)
    if short
        print("Tech Gen")
    else
        print(t, ":") # Prints short version
        print("\n   Real Power: ", t.realpower)
        print("\n   Real Power Lims: ", t.realpowerlimits)
        print("\n   Reactive Power: ", t.reactivepower)
        print("\n   Reactive Power Lims: ", t.reactivepowerlimits)
        print("\n   Ramp Lims: ", t.ramplimits)
        print("\n   Time Lims: ", t.timelimits)
    end
end
Base.show(io::IO, t::TechGen) = printTechGen(true, io, t)
Base.show(io::IO, ::MIME"text/plain", t::TechGen) = printTechGen(false, io, t)
           
function printEconGen(short, io, e)
    print(io)
    if short
        print("Econ Gen: ")
        print("\n   Capacity: ", e.capacity)
    else
        print(e) # Prints short version
        print("\n   Var Cost: ", e.variablecost)
        print("\n   Fixed Cost: ", e.fixedcost)
        print("\n   Startup Cost: ", e.startupcost)
        print("\n   Shutdown Cost: ", e.shutdncost)
        print("\n   Annual Capacity Factor: ", e.annualcapacityfactor)
    end
end
Base.show(io::IO, e::EconGen) = printEconGen(true, io, e)
Base.show(io::IO, ::MIME"text/plain", e::EconGen) = printEconGen(false, io, e)

function printThermalGen(short, io, t)
    print(io)
    if short
        print("Thermal Gen: ")
        print("\n   Name: ", t.name)
        print(", Status: ", t.status)
    else
        print(t) # Prints short version
        print("\n   Bus:\n      ", t.bus)
        if t.tech != nothing
            print("\n   Tech:\n      ", t.tech)
        else
            print("\n   No Tech")
        end
        if t.econ != nothing
            print("\n   Econ:\n      ", t.econ)
        else
            print("\n   No Econ")
        end
    end
end
Base.show(io::IO, t::ThermalGen) = printThermalGen(true, io, t)
Base.show(io::IO, ::MIME"text/plain", t::ThermalGen) = printThermalGen(false, io, t)

# Renewable Gen

function printTechRE(short, io, t)
    print(io)
    if short
        print("Tech RE: ")
        print("\n   Capacity: ", t.installedcapacity)
        print("\n   Power Limits: ", t.reactivepowerlimits)
        print("\n   Power Factor: ", t.powerfactor)
    else
        print(t) # Prints short version
    end
end
Base.show(io::IO, t::TechRE) = printTechRE(true, io, t)
Base.show(io::IO, ::MIME"text/plain", t::TechRE) = printTechRE(false, io, t)

function printEconRE(short, io, t)
    print(io)
    if short
        print("Econ RE: ")
        print("\n   Curtail Cost: ", t.curtailcost)
        print("\n   Interrupt Cost: ", t.interruptioncost)
    else
        print(t) # Prints short version
    end
end
Base.show(io::IO, t::EconRE) = printEconRE(true, io, t)
Base.show(io::IO, ::MIME"text/plain", t::EconRE) = printEconRE(false, io, t)

function printReFix(short, io, t)
    print(io)
    if short
        print("ReFix: ")
        print("\n   Name: ", t.name)
        print(", Status: ", t.status)
    else
        print(t) # Prints short version
        print("\n   Bus:\n      ", t.bus)
        if t.tech != nothing
            print("\n   Tech:\n      ", t.tech)
        else
            print("\n   No Tech")
        end
        print("\n   Scaling Factor: ", t.scalingfactor) # TODO: only print start, end, etc, not whole series
    end
end
Base.show(io::IO, t::ReFix) = printReFix(true, io, t)
Base.show(io::IO, ::MIME"text/plain", t::ReFix) = printReFix(false, io, t)

function printReCurtailment(short, io, t)
    print(io)
    if short
        print("ReCurtailment: ")
        print("\n   Name: ", t.name)
        print(", Status: ", t.status)
    else
        print(t) # Prints short version
        print("\n   Bus:\n      ", t.bus)
        if t.tech != nothing
            print("\n   Tech:\n      ", t.tech)
        else
            print("\n   No Tech")
        end
        if t.econ != nothing
            print("\n   Econ:\n      ", t.econ)
        else
            print("\n   No Econ")
        end
        print("\n   Scaling Factor: ", t.scalingfactor) # TODO: only print start, end, etc, not whole series
    end
end
Base.show(io::IO, t::ReCurtailment) = printReCurtailment(true, io, t)
Base.show(io::IO, ::MIME"text/plain", t::ReCurtailment) = printReCurtailment(false, io, t)

# Helpers

function printTimeSeries(ts)
    
end

# Base.show(io::IO, b::Branch) = print(io, "Name: ", b.name, ", Type: ", b.bustype)
# Base.show(io::IO, b::ElectricLoad) = print(io, "Bus ", b.name, " Type ", b.bustype)