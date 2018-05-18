export Bus

# Update to named tuples when Julia 0.7 becomes available

struct Bus
    number::Int
    name::String
    bustype::Union{String,Nothing} # [PV, PQ, SF]
    angle::Union{Float64,Nothing} # [degrees]
    voltage::Union{Float64,Nothing} # [pu]
    voltagelims::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [pu]
    basevoltage::Union{Float64,Nothing} # [kV]
end

Bus(;   number = 0,
        name = "init",
        bustype = nothing,
        angle = nothing,
        voltage = nothing,
        voltagelims = nothing,
        basevoltage = nothing
    ) = Bus(number, name, bustype, angle, voltage, PowerSystems.orderedlimits(voltagelims, "Voltage"), basevoltage)

struct LoadZones
    number::Int
    name::String
end
