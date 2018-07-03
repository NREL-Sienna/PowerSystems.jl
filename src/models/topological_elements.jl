#TODO: Update to named tuples when Julia 0.7 becomes available

struct Bus <: PowerSystemDevice
    number::Int
    name::String
    bustype::Union{String,Nothing} # [PV, PQ, SF]
    angle::Union{Float64,Nothing} # [degrees]
    voltage::Union{Float64,Nothing} # [pu]
    voltagelimits::Union{@NT(min::Float64, max::Float64),Nothing} # [pu]
    basevoltage::Union{Float64,Nothing} # [kV]
end

Bus(;   number = 0,
        name = "init",
        bustype = nothing,
        angle = nothing,
        voltage = nothing,
        voltagelimits = nothing,
        basevoltage = nothing
    ) = Bus(number, name, bustype, angle, voltage, orderedlimits(voltagelimits, "Voltage"), basevoltage)

struct LoadZones  <: PowerSystemDevice
    number::Int
    name::String
    buses::Array{Bus,1}
    maxrealpower::Float64
    maxreactivepower::Float64
end

LoadZones(;   number = 0,
        name = "init",
        buses = [Bus()],
        maxrealpower = 0.0,
        maxreactivepower = 0.0
    ) = LoadZones(number, name, buses, maxrealpower, maxreactivepower)
