

const Max_Min = @NT(max::Float64, min::Float64)
const From_To_Float = @NT(from::Float64, to::Float64)
const From_To_Bus = @NT(from::Bus, to::Bus)
const FromTo_ToFrom_Float = @NT(from_to::Float64, to_from::Float64)


struct Line <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    r::Float64 #[pu]
    x::Float64 #[pu]
    b::From_To_Float # [pu]
    rate::FromTo_ToFrom_Float #MW
    anglelimits::Max_Min #Degrees
end

function Line(name::String, available::Bool, connectionpoints::From_To_Bus,
              r::Float64, x::Float64, b::From_To_Float, rate::FromTo_ToFrom_Float, anglelimits::Float64)
        anglelimits = Max_Min(anglelimits, anglelimits)
        return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

function Line(name::String, available::Bool, connectionpoints::From_To_Bus,
              r::Float64, x::Float64, b::From_To_Float, rate::Float64, anglelimits::Max_Min)
        rate =  FromTo_ToFrom_Float(rate, rate)
        return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

function Line(name::String, available::Bool, connectionpoints::From_To_Bus,
              r::Float64, x::Float64, b::From_To_Float, rate::Float64, anglelimits::Float64)
        rate =  FromTo_ToFrom_Float(rate, rate)
        anglelimits = Max_Min(anglelimits, anglelimits)
        return Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
end

Line(; name = "init",
       available = false,
       connectionpoints = From_To_Bus(Bus(), Bus()),
       r = 0.0,
       x = 0.0,
       b = From_To_Float(0.0, 0.0),
       rate = FromTo_ToFrom_Float(0.0, 0.0),
       anglelimits = Max_Min(90.0, -90.0)
    ) = Line(name, available, connectionpoints, r, x, b, rate, anglelimits)
