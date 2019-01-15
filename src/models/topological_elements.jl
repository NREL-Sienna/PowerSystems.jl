"""
    Bus

A power-system bus. 

# Constructor
```julia
Bus(number, name, bustype, angle, voltage, voltagelimits, basevoltage)
```

# Arguments
* `number`::Int64 : number associated with the bus
* `name`::String : the name of the bus
* `bustype`::String : type of bus, [PV, PQ, SF]; may be `nothing`
* `angle`::Float64 : angle of the bus in degrees; may be `nothing`
* `voltage`::Float64 : (not sure what this means) [pu]; may be `nothing`
* `voltagelimits`::NamedTuple(min::Float64, max::Float64) : limits on the voltage variation; may be `nothing`
* `basevoltage`::Float64 : the base voltage in kV; may be `nothing`

"""
struct Bus <: PowerSystemDevice
    # field docstrings work here! (they are not for PowerSystem)
    """ number associated with the bus """
    number::Int64
    """ the name of the bus """
    name::String
    """ bus type, [PV, PQ, SF] """
    bustype::Union{String,Nothing} # [PV, PQ, SF]
    """ angle of the bus in degrees """
    angle::Union{Float64,Nothing} # [degrees]
    """ is this a multiple of the base voltage? [pu] """
    voltage::Union{Float64,Nothing} # [pu]
    """ limits on the voltage variation """
    voltagelimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [pu]
    """
    the base voltage in kV
    """
    basevoltage::Union{Float64,Nothing} # [kV]
end

Bus(;   number = 0,
        name = "init",
        bustype = nothing,
        angle = 0.0,
        voltage = 0.0,
        voltagelimits = (min = 0.0, max = 0.0),
        basevoltage = nothing
    ) = Bus(number, name, bustype, angle, voltage, orderedlimits(voltagelimits, "Voltage"), basevoltage)


struct LoadZones  <: PowerSystemDevice
    number::Int
    name::String
    buses::Array{Bus,1}
    maxactivepower::Float64
    maxreactivepower::Float64
end

LoadZones(;   number = 0,
        name = "init",
        buses = [Bus()],
        maxactivepower = 0.0,
        maxreactivepower = 0.0
    ) = LoadZones(number, name, buses, maxactivepower, maxreactivepower)
