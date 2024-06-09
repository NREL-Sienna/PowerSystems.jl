
function sanitize_component!(line::Union{MonitoredLine, Line}, sys::System)
    sanitize_angle_limits!(line)
    return
end

function validate_component_with_system(line::Union{MonitoredLine, Line}, sys::System)
    is_valid = true
    if !check_endpoint_voltages(line)
        is_valid = false
    elseif !calculate_thermal_limits!(line, get_base_power(sys))
        is_valid = false
    end
    return is_valid
end

function sanitize_angle_limits!(line)
    max_limit = pi / 2
    min_limit = -pi / 2

    orderedlimits(line.angle_limits, "Angles")

    if (line.angle_limits.max / max_limit > 3) ||
       (-1 * line.angle_limits.min / max_limit > 3)
        @warn "The angle limits provided is larger than 3π/2 radians.\n " *
              "PowerSystems inferred the data provided in degrees and will transform it to radians" maxlog =
            PS_MAX_LOG

        if line.angle_limits.max / max_limit >= 0.99
            line.angle_limits = (
                min = line.angle_limits.min,
                max = min(line.angle_limits.max * (π / 180), max_limit),
            )
        else
            line.angle_limits =
                (min = line.angle_limits.min, max = min(line.angle_limits.max, max_limit))
        end

        if (-1 * line.angle_limits.min / max_limit > 0.99)
            line.angle_limits = (
                min = max(line.angle_limits.min * (π / 180), min_limit),
                max = line.angle_limits.max,
            )
        else
            line.angle_limits =
                (min = max(line.angle_limits.min, min_limit), max = line.angle_limits.max)
        end
    else
        if line.angle_limits.max >= max_limit && line.angle_limits.min <= min_limit
            line.angle_limits = (min = min_limit, max = max_limit)
        elseif line.angle_limits.max >= max_limit && line.angle_limits.min >= min_limit
            line.angle_limits = (min = line.angle_limits.min, max = max_limit)
        elseif line.angle_limits.max <= max_limit && line.angle_limits.min <= min_limit
            line.angle_limits = (min = min_limit, max = line.angle_limits.max)
        elseif line.angle_limits.max == 0.0 && line.angle_limits.min == 0.0
            line.angle_limits = (min = min_limit, max = max_limit)
        end
    end
    return
end

function linerate_calculation(l::Union{Line, MonitoredLine})
    theta_max = max(abs(l.angle_limits.min), abs(l.angle_limits.max))
    g = l.r / (l.r^2 + l.x^2)
    b = -l.x / (l.r^2 + l.x^2)
    y_mag = sqrt(g^2 + b^2)
    fr_vmax = isnothing(l.arc.from.voltage_limits) ? nothing : l.arc.from.voltage_limits.max
    to_vmax = isnothing(l.arc.to.voltage_limits) ? nothing : l.arc.to.voltage_limits.max

    if isa(fr_vmax, Nothing) || isa(to_vmax, Nothing)
        fr_vmax = 1.0
        to_vmax = 0.9
        diff_angle = abs(l.arc.from.angle - l.arc.to.angle)
        new_rate = y_mag * fr_vmax * to_vmax * cos(theta_max)
    else
        m_vmax = max(fr_vmax, to_vmax)
        c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2 * fr_vmax * to_vmax * cos(theta_max))
        new_rate = y_mag * m_vmax * c_max
    end

    return new_rate
end

function calculate_thermal_limits!(branch, basemva::Float64)
    is_valid = true
    if get_rating(branch) < 0.0
        @error "PowerSystems does not support negative line rates"
        is_valid = false

    elseif get_rating(branch) == 0.0
        @warn "Data for line rating is not provided, PowerSystems will infer a rate from line parameters" maxlog =
            PS_MAX_LOG
        if get_angle_limits(branch) == get_angle_limits(Line(nothing))
            branch.rating =
                min(calculate_sil(branch, basemva), linerate_calculation(branch)) / basemva
        else
            branch.rating = linerate_calculation(branch) / basemva
        end

    elseif get_rating(branch) > linerate_calculation(branch)
        mult = get_rating(branch) / linerate_calculation(branch)
        if mult > 50
            @warn "Data for line rating is $(mult) times larger than the base MVA for the system" maxlog =
                PS_MAX_LOG
        end
    end

    return is_valid
end

const SIL_STANDARDS = Dict( #from https://neos-guide.org/sites/default/files/line_flow_approximation.pdf
    69.0 => (min = 12.0, max = 13.0),
    138.0 => (min = 47.0, max = 52.0),
    230.0 => (min = 134.0, max = 145.0),
    345.0 => (min = 325.0, max = 425.0),
    500.0 => (min = 850.0, max = 1075.0),
    765.0 => (min = 2200.0, max = 2300.0),
)

# calculation from https://neos-guide.org/sites/default/files/line_flow_approximation.pdf
function calculate_sil(line, basemva::Float64)
    arc = get_arc(line)
    #Assumess voltage at both ends of the arc is the same
    vrated = get_base_voltage(get_to(arc))
    zbase = vrated^2 / basemva
    l = get_x(line) / (2 * pi * 60) * zbase
    r = get_r(line) * zbase
    c = sum(get_b(line)) / (2 * pi * 60 * zbase)
    # A line with no C doesn't allow calculation of SIL
    isapprox(c, 0.0) && return Inf
    zc = sqrt((r + im * 2 * pi * 60 * l) / (im * 2 * pi * 60 * c))
    sil = vrated^2 / abs(zc)
    return sil
end

function check_sil_values(line::Union{Line, MonitoredLine}, basemva::Float64)
    arc = get_arc(line)
    vrated = get_base_voltage(get_to(arc))
    SIL_levels = collect(keys(SIL_STANDARDS))
    rating = get_rating(line)
    closestV = findmin(abs.(SIL_levels .- vrated))
    closestSIL = SIL_STANDARDS[SIL_levels[closestV[2]]]
    is_valid = true

    # Assuming that the rate is in pu
    if (rating >= closestSIL.max / basemva)
        # rate outside of expected SIL range
        sil = calculate_sil(line, basemva)
        @warn "Rating $(round(rating*basemva; digits=2)) MW for $(line.name) is larger than the max expected in the range of $(closestSIL)." maxlog =
            PS_MAX_LOG
        is_valid = false
    end
    return is_valid
end

function check_endpoint_voltages(line)
    is_valid = true
    arc = get_arc(line)
    if get_base_voltage(get_from(arc)) != get_base_voltage(get_to(arc))
        is_valid = false
        @error "Voltage endpoints of $(line.name) are different, cannot create Line"
    end
    return is_valid
end
