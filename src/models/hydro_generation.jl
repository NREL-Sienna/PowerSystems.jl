export HydroGen 
export NoDispatchHydro
export DispatchHydro

abstract type 
    HydroGen <: Generator
end


struct TechHydro 
    realpower::Real # [MW]
    realpowerlimits::NamedTuple
    reactivepower::Union{Real,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple,Nothing}
    ramplimits::Union{NamedTuple,Nothing}
    timelimits::Union{NamedTuple,Nothing}
    function TechHydro(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits) 

        new(realpower, orderedlimits(realpowerlimits), reactivepower, orderedlimits(reactivepowerlimits), ramplimits, timelimits)

    end
end

TecHydro(; realpower = 0.0, 
          realpowerlimits = (0.0,0.0), 
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
    storagecapacity::Real
    scalingfactor::TimeSeries.TimeArray
end