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
    rate::Float64
    anglelimits::Min_Max #Degrees
    internal::PowerSystemInternal
end

function Line(name, available, connectionpoints, r, x, b, rate, anglelimits::Min_Max)
    return Line(name, available, connectionpoints, r, x, b, rate, anglelimits,
                PowerSystemInternal())
end

"""Accepts anglelimits as a Float64."""
function Line(name::String,
              available::Bool,
              connectionpoints::From_To_Bus,
              r::Float64,
              x::Float64,
              b::From_To_Float,
              rate::Float64,
              anglelimits::Float64)
    return Line(name, available, connectionpoints, r, x, b, rate,
                (min=-anglelimits, max=anglelimits))
end

function Line(; name="init",
              available=false,
              connectionpoints=From_To_Bus((from=Bus(), to=Bus())),
              r=0.0,
              x=0.0,
              b=(from=0.0, to=0.0),
              rate=0.0,
              anglelimits=(min=-1.57, max=1.57))
    return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

struct MonitoredLine <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    r::Float64 #[pu]
    x::Float64 #[pu]
    b::From_To_Float # [pu]
    flowlimits::FromTo_ToFrom_Float #MW
    rate::Float64
    anglelimits::Min_Max #Degrees
    internal::PowerSystemInternal
end

function MonitoredLine(name, available, connectionpoints, r, x, b, flowlimits, rate,
                       anglelimits)
    return MonitoredLine(name, available, connectionpoints, r, x, b, flowlimits, rate,
                         anglelimits, PowerSystemInternal())
end

function MonitoredLine(; name="init",
                       available=false,
                       connectionpoints=From_To_Bus((from=Bus(), to=Bus())),
                       r=0.0,
                       x=0.0,
                       b=(from=0.0, to=0.0),
                       rate=0.0,
                       anglelimits=(min=-90.0, max=90.0))
    return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end
