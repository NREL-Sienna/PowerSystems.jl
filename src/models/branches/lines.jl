struct Line <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]
    b::@NT(from::Float64, to::Float64) # [pu]
    rate::@NT(from_to::Float64, to_from::Float64) #MW
    anglelimits::@NT(max::Float64, min::Float64) #Degrees
end

function Line(name::String, available::Bool, connectionpoints::@NT(from::Bus, to::Bus), r::Float64, x::Float64, b::@NT(from::Float64, to::Float64), rate::Float64,anglelimits::Float64)
    return Line(name, available, connectionpoints, r, x, b, @NT(from_to=rate, to_from=rate), @NT(max=anglelimits, min=-1*anglelimits))
end


Line(;  name = "init",
        available = false,
        connectionpoints = @NT(from = Bus(), to = Bus()),
        r = 0.0,
        x = 0.0,
        b = @NT(from = 0.0, to = 0.0),
        rate = 0.0,
        anglelimits = @NT(max = 90.0, min = -90.0)
    ) = Line(name, available, connectionpoints, r, x, b, rate, anglelimits)