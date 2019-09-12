
function IS.validate_struct(sys::System, ps_struct::T) where T <: Union{MonitoredLine,Line}
    is_valid = true
    if !check_endpoint_voltages(ps_struct)
        is_valid = false
    else
        check_angle_limits!(ps_struct)
        if !calculate_thermal_limits!(ps_struct, sys.basepower)
            is_valid = false
        end
    end
    return is_valid
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
        diff_angle = abs(l.arc.from.angle - l.arc.to.angle)
        new_rate = y_mag * fr_vmax * to_vmax * cos(theta_max)
    else

        m_vmax = max(fr_vmax, to_vmax)
        c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2 * fr_vmax*to_vmax*cos(theta_max))
        new_rate = y_mag*m_vmax*c_max

    end

    return new_rate

end

function calculate_thermal_limits!(branch, basemva::Float64)
    is_valid = true
    if get_rate(branch) < 0.0
        @error "PowerSystems does not support negative line rates"
        is_valid = false

    elseif get_rate(branch) == 0.0
        @warn "Data for line rating is not provided, PowerSystems will infer a rate from line parameters" maxlog=PS_MAX_LOG
        if get_anglelimits(branch) == get_anglelimits(Line(nothing))
            branch.rate = min(calculate_sil(branch, basemva), linerate_calculation(branch)) / basemva
        else
            branch.rate = linerate_calculation(branch)/basemva
        end

    elseif get_rate(branch) > linerate_calculation(branch)
        mult = get_rate(branch) / linerate_calculation(branch)
        if mult > 50
            @warn "Data for line rating is $(mult) times larger than the base MVA for the system" maxlog=PS_MAX_LOG
        end
    end

    check_SIL(branch, basemva)

    return is_valid
end

const SIL_STANDARDS = Dict( #from https://neos-guide.org/sites/default/files/line_flow_approximation.pdf
                        69.0 => (min=12.0, max=13.0),
                        138.0 => (min=47.0, max=52.0),
                        230.0 => (min=134.0, max=145.0),
                        345.0 => (min=325.0, max=425.0),
                        500.0 => (min=850.0, max=1075.0),
                        765.0 => (min=2200.0, max=2300.0))


# calculation from https://neos-guide.org/sites/default/files/line_flow_approximation.pdf
function calculate_sil(line, basemva::Float64)
    arc = get_arc(line)
    vrated = (get_to(arc) |> get_basevoltage)

    zbase = vrated^2 / basemva
    l = get_x(line) / (2 * pi * 60) * zbase
    r = get_r(line) * zbase
    c = sum(get_b(line)) / (2 * pi * 60 * zbase)
    zc = sqrt((r + im * 2 * pi * 60 * l) / (im * 2 * pi * 60 * c))
    sil = vrated^2 / abs(zc)
    return sil

end

function check_SIL(line, basemva::Float64)

    arc = get_arc(line)
    vrated = (get_to(arc) |> get_basevoltage)

    SIL_levels = collect(keys(SIL_STANDARDS))
    rate = get_rate(line)
    closestV = findmin(abs.(SIL_levels.-vrated))
    closestSIL = SIL_STANDARDS[SIL_levels[closestV[2]]]

    #Consisten with Ned Mohan Electric Power Systems: A First Course page 70
    if !(rate >= 3*closestSIL.max / vrated)
        # rate outside of expected SIL range
        sil = calculate_sil(line, basemva)
        mult = sil/closestSIL.max
        @warn "Rate provided for $(line) is $(rate*vrated), $(mult) times larger the expected SIL $(sil) in the range of $(closestSIL)." maxlog=PS_MAX_LOG

    end
end

function check_endpoint_voltages(line)
    is_valid = true
    arc = get_arc(line)
    if get_from(arc) |> get_basevoltage != get_to(arc) |> get_basevoltage
        is_valid = false
        @error "Voltage endpoints of $(line) are different, cannot create Line"
    end
    return is_valid
end
