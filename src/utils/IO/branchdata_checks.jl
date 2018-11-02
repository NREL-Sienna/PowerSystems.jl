
# function check_angle_limits(anglelimits::(max::Float64, min::Float64))
function checkanglelimits!(branches::Array{<:Branch,1})
    for (ix,l) in enumerate(branches)
        if isa(l,Union{MonitoredLine,Line})
            orderedlimits(l.anglelimits, "Angles")

            hist = (false,l.anglelimits)
            new_max = 1.57
            new_min = -1.57

            if (l.anglelimits.max/1.57 > 3) | (-1*l.anglelimits.min/1.57 > 3)

                @warn "The angle limits provided is larger than 3π/2 radians.\n PowerSystems infered the data provided in degrees and will transform it to radians"

                (l.anglelimits.max/1.57 >= 0.99) ? new_max = min(l.anglelimits.max*(π/180),new_max) : new_max = min(l.anglelimits.max,new_max)

                (-1*l.anglelimits.min/1.57 > 0.99) ? new_min = max(l.anglelimits.min*(π/180),new_min) : new_min = max(l.anglelimits.min,new_min)


                hist = (true,(min = new_min, max = new_max))

            else

                (l.anglelimits.max >= 1.57 && l.anglelimits.min <= -1.57) ? hist = (true,(min = -1.57,max = 1.57)) : true
                (l.anglelimits.max >= 1.57 && l.anglelimits.min >= -1.57) ? hist =(true, (min = l.anglelimits.min,max = 1.57)) : true
                (l.anglelimits.max <= 1.57 && l.anglelimits.min <= -1.57) ? hist = (true,(min = -1.57,max = l.anglelimits.max)) : true
                (l.anglelimits.max == 0.0 && l.anglelimits.min == 0.0) ? hist = (true,(min = -1.57,max = 1.57)) : true

            end

            if hist[1]

                branches[ix] = Line(deepcopy(l.name),deepcopy(l.available),
                                    deepcopy(l.connectionpoints),deepcopy(l.r),
                                    deepcopy(l.x),deepcopy(l.b),deepcopy(l.rate),
                                    hist[2])
            end
        end
    end
end

function linerate_calculation(l::Line)
    theta_max = max(abs(l.anglelimits.min), abs(l.anglelimits.max))
    g =  l.r / (l.r^2 + l.x^2)
    b = -l.x / (l.r^2 + l.x^2)
    y_mag = sqrt(g^2 + b^2)
    fr_vmax = l.connectionpoints.from.voltagelimits.max
    to_vmax =  l.connectionpoints.to.voltagelimits.max

    if isa(fr_vmax,Nothing) || isa(to_vmax,Nothing)
        fr_vmax = 1.0
        to_vmax = 0.9
        diff_angle = abs(l.connectionpoints.from.angle -l.connectionpoints.to.angle)
        new_rate = y_mag*fr_vmax*to_vmax*cos(theta_max)
    else

        m_vmax = max(fr_vmax, to_vmax)
        c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2*fr_vmax*to_vmax*cos(theta_max))
        new_rate = y_mag*m_vmax*c_max

    end

    return new_rate

end

function calculatethermallimits!(branches::Array{<:Branch,1},basemva::Float64)
    for (ix,l) in enumerate(branches)

        if isa(l,Line)

            flag = false

            #This is the same check as implemented in PowerModels
            if l.rate <= 0.0
                (flag, rate) = (true,linerate_calculation(l))
            elseif l.rate > linerate_calculation(l)
                    (flag, rate) = (true,linerate_calculation(l))
            else
                rating= l.rate
            end

            if (l.rate/basemva) > 20
                @warn "Data for line rating is 20 times larger than the base MVA for the system\n. Power Systems infered the Data Provided is in MVA and will transform it using a base of $("basemva")"
                (flag, rate) = (true,l.rate/basemva)
            end

            if flag
                branches[ix] = Line(deepcopy(l.name),deepcopy(l.available),
                                    deepcopy(l.connectionpoints),deepcopy(l.r),
                                    deepcopy(l.x),deepcopy(l.b),
                                    rate,deepcopy(l.anglelimits))
            end
        end
    end
end