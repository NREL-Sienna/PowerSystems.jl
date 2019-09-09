
function validate_struct(sys::System, ps_struct::T) where T <: Union{MonitoredLine,Line}
    check_angle_limits!(ps_struct)
    calculate_thermal_limits!(ps_struct, sys.basepower)
    check_SIL(ps_struct, sys.basepower)
    return true
end

function check_angle_limits!(line)
    max_limit = pi/2
    min_limit = -pi/2

    orderedlimits(line.anglelimits, "Angles")

    if (line.anglelimits.max / max_limit > 3) ||
        (-1 * line.anglelimits.min / max_limit > 3)
        @warn "The angle limits provided is larger than 3π/2 radians.\n " *
                "PowerSystems inferred the data provided in degrees and will transform it to radians" maxlog=PS_MAX_LOG

        if line.anglelimits.max / max_limit >= 0.99
            line.anglelimits = (min=line.anglelimits.min,
                                max=min(line.anglelimits.max * (π / 180), max_limit))
        else
            line.anglelimits = (min=line.anglelimits.min,
                                max=min(line.anglelimits.max, max_limit))
        end

        if (-1 * line.anglelimits.min / max_limit > 0.99)
            line.anglelimits = (min=max(line.anglelimits.min * (π / 180), min_limit),
                                max=line.anglelimits.max)
        else
            line.anglelimits = (min=max(line.anglelimits.min, min_limit),
                                max=line.anglelimits.max)
        end
    else

        if line.anglelimits.max >= max_limit && line.anglelimits.min <= min_limit
            line.anglelimits = (min = min_limit,max = max_limit)
        elseif line.anglelimits.max >= max_limit && line.anglelimits.min >= min_limit
            line.anglelimits = (min=line.anglelimits.min, max=max_limit)
        elseif line.anglelimits.max <= max_limit && line.anglelimits.min <= min_limit
            line.anglelimits = (min=min_limit, max=line.anglelimits.max)
        elseif line.anglelimits.max == 0.0 && line.anglelimits.min == 0.0
            line.anglelimits = (min = min_limit,max = max_limit)
        end
    end
end

function linerate_calculation(l::Line)
    theta_max = max(abs(l.anglelimits.min), abs(l.anglelimits.max))
    g =  l.r / (l.r^2 + l.x^2)
    b = -l.x / (l.r^2 + l.x^2)
    y_mag = sqrt(g^2 + b^2)
    fr_vmax = l.arc.from.voltagelimits.max
    to_vmax =  l.arc.to.voltagelimits.max

    if isa(fr_vmax,Nothing) || isa(to_vmax,Nothing)
        fr_vmax = 1.0
        to_vmax = 0.9
        diff_angle = abs(l.arc.from.angle -l.arc.to.angle)
        new_rate = y_mag*fr_vmax*to_vmax*cos(theta_max)
    else

        m_vmax = max(fr_vmax, to_vmax)
        c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2*fr_vmax*to_vmax*cos(theta_max))
        new_rate = y_mag*m_vmax*c_max

    end

    return new_rate

end

function calculate_thermal_limits!(branch, basemva::Float64)
    # This is the same check as implemented in PowerModels.
    if branch.rate < 0.0
        #error
        throw(DataFormatError("PowerSystems does not support negative line rates"))

    elseif branch.rate == 0.0
        @warn "Data for line rating is not provided, PowerSystems will infer a rate from line parameters" maxlog=PS_MAX_LOG
        branch.rate = linerate_calculation(branch)

    elseif branch.rate > linerate_calculation(branch)
        mult = branch.rate/linerate_calculation(branch)
        @warn "Data for line rating is $(mult) times larger than the base MVA for the system\n. " *
        "PowerSystems inferred the Data Provided is in MVA and will transform it using a base of $("basemva")" maxlog=PS_MAX_LOG

        branch.rate = linerate_calculation(branch)
        branch.rate /= basemva
    end

end

const SIL_standards = Dict( #from https://neos-guide.org/sites/default/files/line_flow_approximation.pdf
                        69.0 => (min=12.0, max=13.0),
                        138.0 => (min=47.0, max=52.0),
                        230.0 => (min=134.0, max=145.0),
                        345.0 => (min=325.0, max=425.0),
                        500.0 => (min=850.0, max=1075.0),
                        765.0 => (min=2200.0, max=2300.0))


# calculation from https://neos-guide.org/sites/default/files/line_flow_approximation.pdf
function calculate_SIL(line, basemva::Float64)
    arc = get_arc(line)
    @assert get_from(arc) |> get_basevoltage == get_to(arc) |> get_basevoltage
    Vrated = (get_to(arc) |> get_basevoltage)

    Zbase = Vrated^2/basemva
    L = get_x(line)/(2*pi*60)*Zbase
    R = get_r(line)*Zbase
    C = get_b(line)/(2*pi*60*Zbase)
    Zc = sqrt((R+imag(2*pu*60*L))/imag(2*pi*60*C))
    SIL = Vrated^2/abs(Zc)
    return SIL
end

function check_SIL(line, basemva::Float64)
    closestV = findmin(abs.(keys(SIL_standards).-get_rate(line)))[1]
    closestSIL = SIL_standards[closestV]

    if !(get_rate(line) >= closestSIL.min && get_rate(line) <= closestSIL.max)
        # rate outside of expected SIL range
        SIL = calculate_SIL(line, basemva)
        @warn "Rate provided for $(line) is outside of the expected SIL range of $(closestSIL), and the expected value is $(SIL)." maxlog=PS_MAX_LOG

    end
end
