
### Utility Functions needed for the construction of the Power System, mostly used for consistency checking ####

## Time Series Length ##

function TimeSeriesCheckLoad(loads::Array{T}) where {T<:ElectricLoad}
    t = length(loads[1].scalingfactor)
    for l in loads
        if t == length(l.scalingfactor)
            continue
        else
            error("Inconsistent load scaling factor time series length")
        end
    end
    return t
end

function TimeSeriesCheckSources(generators::Array{T}, t) where {T<:Generator}
    if !isa(generators,Nothing)
        for g in generators
            if t == length(g.scalingfactor)
                continue
            else
                error("Inconsistent generation scaling factor time series length")
            end
        end
    end
end

## Check that all the buses have a type defintion ##

function BusCheckAC(buses::Array{Bus})
    for b in buses
        if b.bustype == nothing
            warn("Bus/Nodes data does not contain information to build an AC network")
        end
    end
end

## Slack Bus Definition ##

function SlackBusCheck(buses::Array{Bus})
    slack = -9
    for b in buses
        if b.bustype == "SF"
            slack = b.number
        end
    end
    if slack == -9
        error("Model doesn't contain a slack bus")
    end
end

### PV Bus Check ###

function PVBusCheck(buses::Array{Bus}, generators::Array{T}) where {T<:Generator}
    pv_list = -1*ones(Int64, length(generators))
    for (ix,g) in enumerate(generators)
        g.bus.bustype == "PV" ? pv_list[ix] = g.bus.number : continue
    end

    for b in buses
        if b.bustype == "PV"
            b.number in pv_list ? continue : warn("The bus ", b.number, " is declared as PV without a generator connected to it")
        else
            continue
        end
    end
end

function check_angle_limits!(anglelimits::@NT(max::Float64, min::Float64))

    orderedlimits(anglelimits, "Angles")

    (anglelimits.max >= 90.0 && anglelimits.min <= -90.0) ? anglelimits = @NT(max = 90.0, min = -90.0) : true
    (anglelimits.max >= 90.0 && anglelimits.min >= -90.0) ? anglelimits = @NT(max = 90.0, min = anglelimits.min) : true
    (anglelimits.max <= 90.0 && anglelimits.min <= -90.0) ? anglelimits = @NT(max = anglelimits.max, min = -90.0) : true
    (anglelimits.max == 0.0 && anglelimits.min == 0.0) ? anglelimits = @NT(max = 90.0, min = -90.0): true

    return anglelimits

end

function calculate_thermal_limits!(r::Float64, x::Float64, rate::@NT(from_to::Float64, to_from::Float64), anglelimits::@NT(max::Float64, min::Float64), connectionpoints::@NT(from::Bus, to::Bus))
    theta_max = max(abs(anglelimits.min), abs(anglelimits.max))
    g =  r / (r^2 + x^2)
    b = -x / (r^2 + x^2)
    y_mag = sqrt(g^2 + b^2)
    fr_vmax = connectionpoints.from.voltagelimits.max
    to_vmax =  connectionpoints.to.voltagelimits.max
    if isa(fr_vmax,Nothing) || isa(to_vmax,Nothing)
        fr_vmax = 1.0
        to_vmax = 0.9
        diff_angle = abs(connectionpoints.from.angle -connectionpoints.to.angle)
        new_rate = y_mag*fr_vmax*to_vmax*cos(theta_max)
    else
    m_vmax = max(fr_vmax, to_vmax)
    c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2*fr_vmax*to_vmax*cos(theta_max))
    new_rate = y_mag*m_vmax*c_max
    end
    rate.from_to <= 0.0 ? rating_from_to = new_rate : rate.from_to > new_rate ? rating_from_to = new_rate : rating_from_to = rate.from_to
    rate.to_from <= 0.0 ? rating_to_from = new_rate : rate.to_from > new_rate ? rating_to_from = new_rate : rating_to_from = rate.to_from

    return @NT(from_to = rating_from_to, to_from = rating_to_from)
end

# TODO: Check for islanded Buses
# TODO: Check busses have same base voltage