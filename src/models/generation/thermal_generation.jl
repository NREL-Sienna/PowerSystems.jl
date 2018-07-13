"Abstract struct for thermal generation technologies"
abstract type
    ThermalGen <: Generator
end

"""
    TechThermal(realpower::Float64,
            realpowerlimits::@NT(min::Float64, max::Float64),
            reactivepower::Union{Float64,Nothing},
            reactivepowerlimits::Union{@NT(min::Float64,max::Float64),Nothing},
            ramplimits::Union{@NT(up::Float64, down::Float64),Nothing},
            timelimits::Union{@NT(min::Float64, max::Float64),Nothing})

Data Structure for the economical parameters of thermal generation technologies.
    The data structure can be called calling all the fields directly or using named fields.
    Two examples are provided one with minimal data definition and a more comprenhensive one

    # Examples

    ```jldoctest

    julia> Tech = TechThermal(realpower = 100.0, realpowerlimits = @NT(min = 50.0, max = 200.0))
    WARNING: Limits defined as nothing
    Tech Gen:
        Real Power: 100.0
        Real Power Limits: (min = 50.0, max = 200.0)
        Reactive Power: nothing
        Reactive Power Limits: nothing
        Ramp Limits: nothing
        Time Limits: nothing






"""
struct TechThermal
    realpower::Float64 # [MW]
    realpowerlimits::@NT(min::Float64, max::Float64)
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing}
    ramplimits::Union{@NT(up::Float64, down::Float64),Nothing}
    timelimits::Union{@NT(up::Float64, down::Float64),Nothing}
    function TechThermal(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

        new(realpower, PowerSystems.orderedlimits(realpowerlimits, "Real Power"), reactivepower, PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"), ramplimits, timelimits)

    end
end

#define different  constructors depending on the data available.
# Update to named tuples when Julia 0.7 becomes available

TechThermal(; realpower = 0.0,
          realpowerlimits = @NT(min = 0.0, max = 0.0),
          reactivepower = nothing,
          reactivepowerlimits = nothing,
          ramplimits = nothing,
          timelimits = nothing
        ) = TechThermal(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

""""



Data Structure for the economical parameters of thermal generation technologies.
    The data structure can be called calling all the fields directly or using named fields.
    All the limits are defined by NamedTuples and some fields can take ```nothing```

    ## Examples




"""
struct EconThermal
    capacity::Float64                       # [MW]
    variablecost::Union{Function,Array{Tuple{Float64, Float64}}}                         # [$/MWh]
    fixedcost::Float64            # [$/h]
    startupcost::Float64          # [$]
    shutdncost::Float64           # [$]
    annualcapacityfactor::Union{Float64,Nothing}  # [0-1]
end

EconThermal(;   capacity = 0.0,
            variablecost = [(0.0,1.0)],
            fixedcost = 0.0,
            startupcost = 0.0,
            shutdncost = 0.0,
            annualcapacityfactor = nothing
        ) = EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor)

""""
Data Structure for thermal generation technologies.
    The data structure contains all the information for technical and economical modeling.
    The data fields can be filled using named fields or directly.

    Examples




"""
struct ThermalDispatch <: ThermalGen
    name::String
    available::Bool
    bus::Bus
    tech::Union{TechThermal,Nothing}
    econ::Union{EconThermal,Nothing}
end

ThermalDispatch(; name = "init",
                status = false,
                bus = Bus(),
                tech = nothing,
                econ = nothing) = ThermalDispatch(name, status, bus, tech, econ)




""""
Data Structure for thermal generation technologies subjecto to seasonality constraints.
    The data structure contains all the information for technical and economical modeling and an extra field for a time series.
    The data fields can be filled using named fields or directly.

    Examples

"""
struct ThermalGenSeason <: ThermalGen
    name::String
    available::Bool
    bus::Bus
    tech::Union{TechThermal,Nothing}
    econ::Union{EconThermal,Nothing}
    scalingfactor::TimeSeries.TimeArray
end

ThermalGenSeason(; name = "init",
                status = false,
                bus = Bus(),
                tech = nothing,
                econ = nothing,
                scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = ThermalGenSeason(name, status, bus, tech, econ, scalingfactor)
