struct Line <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::@NT(from::Float64, to::Float64) #[pu]
    rate::@NT(from_to::Float64, to_from::Float64) #MW
    anglelimits::@NT(max::Float64, min::Float64) #Degrees

    function Line(name::String, available::Bool, connectionpoints::@NT(from::Bus, to::Bus), r::Float64, x::Float64, b::@NT(from::Float64, to::Float64), rate, anglelimits)

        anglelimits = check_angle_limits!(anglelimits)

        rating =  calculate_thermal_limits!(r, x,  @NT(from_to = rate, to_from = rate), anglelimits, connectionpoints)

        new(name, available, connectionpoints, r, x, b, rating, anglelimits)
    end

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

struct DCLine <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    realpowerlimits_from::@NT(min::Float64, max::Float64)
    realpowerlimits_to::@NT(min::Float64, max::Float64)
    reactivepowerlimits_from::@NT(min::Float64, max::Float64)
    reactivepowerlimits_to::@NT(min::Float64, max::Float64)
    loss::@NT(l0::Float64, l1::Float64)
end

DCLine(; name ="init",
        available = true,
        connectionpoints = @NT(from = Bus(), to = Bus()),
        realpowerlimits_from = @NT(min=0.0, max=0.0),
        realpowerlimits_to = @NT(min=0.0, max=0.0),
        reactivepowerlimits_from = @NT(min=0.0, max=0.0),
        reactivepowerlimits_to = @NT(min=0.0, max=0.0),
        loss = @NT(l0=0.0, l1=0.0)
    ) = DCLine(name, available, connectionpoints, realpowerlimits_from, realpowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to,loss )