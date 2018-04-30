export HydroGen
export NoDispatchHydro
export DispatchHydro
export TecHydro

abstract type
    HydroGen <: Generator
end


struct TechHydro
    realpower::Float64 # [MW]
    realpowerlimits::NamedTuple
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple,Nothing}
    ramplimits::Union{NamedTuple,Nothing}
    timelimits::Union{NamedTuple,Nothing}
    function TechHydro(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

        new(realpower, orderedlimits(realpowerlimits), reactivepower, orderedlimits(reactivepowerlimits), ramplimits, timelimits)

    end
end

TecHydro(; realpower = 0.0,
          realpowerlimits = @NT(max = 0.0, min = 0.0),
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
