export HydroGen
export NoDispatchHydro
export DispatchHydro
export TecHydro

abstract type
    HydroGen <: Generator
end


struct TechHydro
    realpower::Float64 # [MW]
    realpowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}}
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
    ramplimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
    timelimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
    function TechHydro(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

        new(realpower, PowerSystems.orderedlimits(realpowerlimits, "Real Power"), reactivepower, PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"), ramplimits, timelimits)

    end
end

TecHydro(; realpower = 0.0,
          realpowerlimits = (min = 0.0, max = 0.0),
          reactivepower = nothing,
          reactivepowerlimits = nothing,
          ramplimits = nothing,
          timelimits = nothing
        ) = TechHydro(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

struct NoDispatchHydro <: HydroGen
    name::String
    status::Bool
    bus::Bus
    tech::TechHydro
    scalingfactor::TimeSeries.TimeArray
end

struct DispatchHydro <: HydroGen
    name::String
    status::Bool
    bus::Bus
    tech::TechHydro
    storagecapacity::Float64
    scalingfactor::TimeSeries.TimeArray
end
