const Min_Max = NamedTuple{(:min, :max),Tuple{Float64,Float64}}
const From_To_Float = NamedTuple{(:from, :to),Tuple{Float64,Float64}}
const From_To_Bus =  NamedTuple{(:from, :to),Tuple{Bus,Bus}}
const FromTo_ToFrom_Float = NamedTuple{(:from_to, :to_from),Tuple{Float64,Float64}}


struct Line <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    r::Float64 #[pu]
    x::Float64 #[pu]
    b::From_To_Float # [pu]
    rate::FromTo_ToFrom_Float #MW
    anglelimits::Min_Max #Degrees
end

function Line(name::String, available::Bool, connectionpoints::From_To_Bus,
              r::Float64, x::Float64, b::From_To_Float, rate::FromTo_ToFrom_Float, anglelimits::Float64)
        anglelimits = (min = -anglelimits, max = anglelimits)
        return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

function Line(name::String, available::Bool, connectionpoints::From_To_Bus,
              r::Float64, x::Float64, b::From_To_Float, rate::Float64, anglelimits::Min_Max)
        rate =  (from_to = rate, to_from = rate)
        return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

function Line(name::String, available::Bool, connectionpoints::From_To_Bus,
              r::Float64, x::Float64, b::From_To_Float, rate::Float64, anglelimits::Float64)
        rate =  (from_to = rate, to_from = rate)
        anglelimits = (min = -anglelimits, max = anglelimits)
        return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

Line(; name = "init",
       available = false,
       connectionpoints = (from = Bus(), to = Bus()),
       r = 0.0,
       x = 0.0,
       b = (from=0.0, to =0.0),
       rate = (from_to=0.0, to_from=0.0),
       anglelimits = (min = -90, max = 90)
    ) = Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
