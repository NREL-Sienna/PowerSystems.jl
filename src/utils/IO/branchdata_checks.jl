
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

# Building Synthetic Power Transmission Networks of Many Voltage Levels, Spanning Multiple Areas
# https://scholarspace.manoa.hawaii.edu/server/api/core/bitstreams/47b28d1e-7019-415f-9a88-e1ed37556342/content
# https://www.mdpi.com/1996-1073/10/8/1233/htm
const MVA_LIMITS_LINES = Dict(
    69.0 => (min = 12.0, max = 115.0),
    115.0 => (min = 92.0, max = 255.0),
    138.0 => (min = 141.0, max = 344.0),
    161.0 => (min = 176.0, max = 410.0),
    230.0 => (min = 327.0, max = 797.0),
    345.0 => (min = 897.0, max = 1494.0),
    500.0 => (min = 1732.0, max = 3464.0))

# Building Synthetic Power Transmission Networks of Many Voltage Levels, Spanning Multiple Areas
# https://scholarspace.manoa.hawaii.edu/server/api/core/bitstreams/47b28d1e-7019-415f-9a88-e1ed37556342/content
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

# Helper function to validate a single rating field without dynamic field access
function _validate_line_rating_field(
    field_name::Symbol,
    rating_value::Union{Float64, Nothing},
    line_name::String,
    basemva::Float64,
    closest_v_level::Float64,
    closest_rate_range::NamedTuple,
)
    isnothing(rating_value) && return nothing

    if (rating_value >= 2.0 * closest_rate_range.max / basemva)
        @warn "$(field_name) $(round(rating_value*basemva; digits=2)) MW for $(line_name) is 2x larger than the max expected rating $(closest_rate_range.max) MW for Line at a $(closest_v_level) kV Voltage level." maxlog =
            PS_MAX_LOG
    elseif (rating_value >= closest_rate_range.max / basemva) ||
           (rating_value <= closest_rate_range.min / basemva)
        @info "$(field_name) $(round(rating_value*basemva; digits=2)) MW for $(line_name) is outside the expected range $(closest_rate_range) MW for Line at a $(closest_v_level) kV Voltage level." maxlog =
            PS_MAX_LOG
    end
    return nothing
end

function check_rating_values(line::Union{Line, MonitoredLine}, basemva::Float64)
    arc = get_arc(line)
    vrated = get_base_voltage(get_to(arc))
    voltage_levels = collect(keys(MVA_LIMITS_LINES))
    closestV_ix = findmin(abs.(voltage_levels .- vrated))
    closest_v_level = voltage_levels[closestV_ix[2]]
    closest_rate_range = MVA_LIMITS_LINES[closest_v_level]

    # Validate each rating field directly (no dynamic field access)
    line_name = get_name(line)
    _validate_line_rating_field(:rating, line.rating, line_name, basemva, closest_v_level, closest_rate_range)
    _validate_line_rating_field(:rating_b, line.rating_b, line_name, basemva, closest_v_level, closest_rate_range)
    _validate_line_rating_field(:rating_c, line.rating_c, line_name, basemva, closest_v_level, closest_rate_range)

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

# Helper function to correct a single rating field
# Accesses field directly to avoid stale value issues
function _correct_single_rate_limit!(
    field_name::Symbol,
    branch::Union{Line, MonitoredLine},
    theoretical_line_rate_pu::Float64,
)::Bool
    rating_value = getfield(branch, field_name)
    isnothing(rating_value) && return true

    if rating_value < 0.0
        @error "PowerSystems does not support negative line rates. $(field_name): $(rating_value)"
        return false
    end
    if rating_value == INFINITE_BOUND
        @warn "Data for branch $(summary(branch)) $(field_name) is set to INFINITE_BOUND. \
            PowerSystems will set a rate from line parameters to $(theoretical_line_rate_pu)" maxlog =
            PS_MAX_LOG
        setfield!(branch, field_name, theoretical_line_rate_pu)
    end
    return true
end

function correct_rate_limits!(branch::Union{Line, MonitoredLine}, basemva::Float64)
    theoretical_line_rate_pu = line_rating_calculation(branch)

    # Process each rating field via helper function
    _correct_single_rate_limit!(:rating, branch, theoretical_line_rate_pu) || return false
    _correct_single_rate_limit!(:rating_b, branch, theoretical_line_rate_pu) || return false
    _correct_single_rate_limit!(:rating_c, branch, theoretical_line_rate_pu) || return false

    return check_rating_values(branch, basemva)
end

function check_endpoint_voltages(line::Union{Line, MonitoredLine})
    is_valid = true
    arc = get_arc(line)
    from_voltage = get_base_voltage(get_from(arc))
    to_voltage = get_base_voltage(get_to(arc))
    percent_difference = abs(from_voltage - to_voltage) / ((from_voltage + to_voltage) / 2)
    if percent_difference > BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL
        is_valid = false
        @error "Voltage endpoints of $(get_name(line)) have more than $(BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL*100)% difference, cannot create Line. /
        Check if the data corresponds to transformer data."
    end

    return is_valid
end

const TYPICAL_XFRM_REACTANCE = (min = 0.05, max = 0.2) # per-unit

function validate_component_with_system(
    xfrm::TwoWindingTransformer,
    sys::System,
)
    is_valid_reactance = check_transformer_reactance(xfrm)
    is_valid_rating = check_rating_values(xfrm, get_base_power(sys))
    return is_valid_reactance && is_valid_rating
end

# Helper function to validate a single transformer rating field without dynamic field access
function _validate_transformer_rating_field(
    field_name::Symbol,
    rating_value::Union{Float64, Nothing},
    xfrm_name::String,
    device_base_power::Float64,
    closest_v_level::Float64,
    closest_rate_range::NamedTuple,
)
    isnothing(rating_value) && return nothing

    if (rating_value * device_base_power >= 2.0 * closest_rate_range.max)
        @warn "$(field_name) $(round(rating_value*device_base_power; digits=2)) MW for $(xfrm_name) is 2x larger than the max expected rating $(closest_rate_range.max) MW for Transformer at a $(closest_v_level) kV Voltage level." maxlog =
            PS_MAX_LOG
    elseif (rating_value * device_base_power >= closest_rate_range.max) ||
           (rating_value * device_base_power <= closest_rate_range.min)
        @info "$(field_name) $(round(rating_value*device_base_power; digits=2)) MW for $(xfrm_name) is outside the expected range $(closest_rate_range) MW for Transformer at a $(closest_v_level) kV Voltage level." maxlog =
            PS_MAX_LOG
    end
    return nothing
end

function check_rating_values(
    xfrm::TwoWindingTransformer,
    ::Float64,
)
    arc = get_arc(xfrm)
    v_from = get_base_voltage(get_from(arc))
    v_to = get_base_voltage(get_to(arc))
    vrated = max(v_from, v_to)
    voltage_levels = collect(keys(MVA_LIMITS_TRANSFORMERS))
    closestV_ix = findmin(abs.(voltage_levels .- vrated))
    closest_v_level = voltage_levels[closestV_ix[2]]
    closest_rate_range = MVA_LIMITS_TRANSFORMERS[closest_v_level]
    device_base_power = get_base_power(xfrm)

    # Validate each rating field directly (no dynamic field access)
    xfrm_name = get_name(xfrm)
    _validate_transformer_rating_field(:rating, xfrm.rating, xfrm_name, device_base_power, closest_v_level, closest_rate_range)
    _validate_transformer_rating_field(:rating_b, xfrm.rating_b, xfrm_name, device_base_power, closest_v_level, closest_rate_range)
    _validate_transformer_rating_field(:rating_c, xfrm.rating_c, xfrm_name, device_base_power, closest_v_level, closest_rate_range)

    return true
end

function check_transformer_reactance(
    xfrm::TwoWindingTransformer,
)
    x_pu = xfrm.x  # Direct field access for compile-time known field
    if x_pu < TYPICAL_XFRM_REACTANCE.min
        @warn "Transformer $(get_name(xfrm)) per-unit reactance $(x_pu) is lower than the typical range $(TYPICAL_XFRM_REACTANCE). \
            Check if the reactance source data is correct." maxlog = PS_MAX_LOG
    end
    if x_pu > TYPICAL_XFRM_REACTANCE.max
        @warn "Transformer $(get_name(xfrm)) per-unit reactance $(x_pu) is higher than the typical range $(TYPICAL_XFRM_REACTANCE). \
            Check if the reactance source data is correct." maxlog = PS_MAX_LOG
    end
    return true
end
