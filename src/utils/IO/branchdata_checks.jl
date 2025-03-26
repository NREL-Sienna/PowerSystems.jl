
function sanitize_component!(line::Union{MonitoredLine, Line}, sys::System)
    sanitize_angle_limits!(line)
    return
end

function validate_component_with_system(line::Union{MonitoredLine, Line}, sys::System)
    is_valid = true
    if !check_endpoint_voltages(line)
        is_valid = false
    elseif !correct_rate_limits!(line, get_base_power(sys))
        is_valid = false
    end
    return is_valid
end

function sanitize_angle_limits!(line::Union{Line, MonitoredLine})
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

# https://scholarspace.manoa.hawaii.edu/bitstream/10125/50237/paper0350.pdf
# https://www.mdpi.com/1996-1073/10/8/1233/htm
const MVA_LIMITS_LINES = Dict(
    69.0 => (min = 12.0, max = 115.0),
    115.0 => (min = 92.0, max = 255.0),
    138.0 => (min = 141.0, max = 344.0),
    161.0 => (min = 176.0, max = 410.0),
    230.0 => (min = 327.0, max = 797.0),
    345.0 => (min = 897.0, max = 1494.0),
    500.0 => (min = 1732.0, max = 3464.0))

# https://scholarspace.manoa.hawaii.edu/bitstream/10125/50237/paper0350.pdf
# https://www.mdpi.com/1996-1073/10/8/1233/htm
const MVA_LIMITS_TRANSFORMERS = Dict(
    69.0 => (min = 7.0, max = 115.0),
    115.0 => (min = 17.0, max = 140.0),
    138.0 => (min = 15.0, max = 239.0),
    161.0 => (min = 30.0, max = 276.0),
    230.0 => (min = 50.0, max = 470.0),
    345.0 => (min = 160.0, max = 702.0),
    500.0 => (min = 150.0, max = 1383.0),
    765.0 => (min = 2200.0, max = 6900.0), # This value is 3x the SIL value from https://neos-guide.org/wp-content/uploads/2022/04/line_flow_approximation.pdf
)

function check_rating_values(line::Union{Line, MonitoredLine}, basemva::Float64)
    arc = get_arc(line)
    vrated = get_base_voltage(get_to(arc))
    voltage_levels = collect(keys(MVA_LIMITS_LINES))
    closestV = findmin(abs.(voltage_levels .- vrated))
    closest_rate_range = MVA_LIMITS_LINES[voltage_levels[closestV[2]]]

    # Assuming that the rate is in pu
    for field in [:rating, :rating_b, :rating_c]
        rating = getfield(line, field)
        if isnothing(rating)
            @assert field ∈ [:rating_b, :rating_c]
            continue
        end
        if (rating >= 2.0 * closest_rate_range.max / basemva)
            @error "$(field) $(round(rating*basemva; digits=2)) MW for $(get_name(line)) is 2x larger than the max expected rating $(closest_rate_range.max) MW for Line at a $closestV kV Voltage level." maxlog =
                PS_MAX_LOG
            return false
        elseif (rating >= closest_rate_range.max / basemva) ||
               (rating <= closest_rate_range.min / basemva)
            @warn "$(field) $(round(rating*basemva; digits=2)) MW for $(get_name(line)) is outside the expected range $(closest_rate_range) MW for Line at a $closestV kV Voltage level." maxlog =
                PS_MAX_LOG
        end
    end

    return true
end

"""
Calculates the line rating based on the formula for the maximum transfer limit over an impedance
"""
function line_rating_calculation(l::Union{Line, MonitoredLine})
    theta_max = max(abs(l.angle_limits.min), abs(l.angle_limits.max))

    g = l.r / (l.r^2 + l.x^2)
    b = -l.x / (l.r^2 + l.x^2)
    y_mag = sqrt(g^2 + b^2)

    from_voltage_limits = get_voltage_limits(get_arc(l).from)
    to_voltage_limits = get_voltage_limits(get_arc(l).to)

    fr_vmin = isnothing(from_voltage_limits) ? 0.9 : from_voltage_limits.min
    to_vmin = isnothing(to_voltage_limits) ? 0.9 : from_voltage_limits.min

    c_max = sqrt(fr_vmin^2 + to_vmin^2 - 2 * fr_vmin * to_vmin * cos(theta_max))
    new_rate = y_mag * max(fr_vmin, to_vmin) * c_max

    return new_rate
end

function correct_rate_limits!(branch::Union{Line, MonitoredLine}, basemva::Float64)
    if get_rating(branch) < 0.0
        @error "PowerSystems does not support negative line rates"
        return false
    end

    theoretical_line_rate_pu = line_rating_calculation(branch)
    for field in [:rating, :rating_b, :rating_c]
        if getfield(branch, field) == INFINITE_BOUND
            @warn "Data for branch $(summary(branch)) $(field) is set to INFINITE_BOUND. \
                PowerSystems will set a rate from line parameters to $(theoretical_line_rate_pu)" maxlog =
                PS_MAX_LOG
            setfield!(branch, field, theoretical_line_rate_pu)
        end
    end

    return check_rating_values(branch, basemva)
end

function check_endpoint_voltages(line::Union{Line, MonitoredLine})
    is_valid = true
    arc = get_arc(line)
    if get_base_voltage(get_from(arc)) != get_base_voltage(get_to(arc))
        is_valid = false
        @error "Voltage endpoints of $(line.name) are different, cannot create Line"
    end
    return is_valid
end
