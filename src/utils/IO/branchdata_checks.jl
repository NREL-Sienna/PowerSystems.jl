
function check_branches!(branches)
    check_angle_limits!(branches)
end

function check_angle_limits!(branches)
    max_limit = 1.57
    min_limit = -1.57

    for line in branches
        if line isa Union{MonitoredLine,Line}
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
    end
end

function linerate_calculation(l::Line)
    theta_max = max(abs(l.anglelimits.min), abs(l.anglelimits.max))
    g =  l.r / (l.r^2 + l.x^2)
    b = -l.x / (l.r^2 + l.x^2)
    y_mag = sqrt(g^2 + b^2)
    fr_vmax = l.arch.from.voltagelimits.max
    to_vmax =  l.arch.to.voltagelimits.max

    if isa(fr_vmax,Nothing) || isa(to_vmax,Nothing)
        fr_vmax = 1.0
        to_vmax = 0.9
        diff_angle = abs(l.arch.from.angle -l.arch.to.angle)
        new_rate = y_mag*fr_vmax*to_vmax*cos(theta_max)
    else

        m_vmax = max(fr_vmax, to_vmax)
        c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2*fr_vmax*to_vmax*cos(theta_max))
        new_rate = y_mag*m_vmax*c_max

    end

    return new_rate

end

function calculate_thermal_limits!(branches, basemva::Float64)
    for branch in branches
        if branch isa Line
            # This is the same check as implemented in PowerModels.
            if branch.rate <= 0.0
                branch.rate = linerate_calculation(branch)
            elseif branch.rate > linerate_calculation(branch)
                branch.rate = linerate_calculation(branch)
            end

            if (branch.rate / basemva) > 20
                @warn "Data for line rating is 20 times larger than the base MVA for the system\n. " *
                      "Power Systems inferred the Data Provided is in MVA and will transform it using a base of $("basemva")" maxlog=PS_MAX_LOG
                branch.rate /= basemva
            end
        end
    end
end
