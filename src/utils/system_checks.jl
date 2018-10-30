
### Utility Functions needed for the construction of the Power System, mostly used for consistency checking ####

## Time Series Length ##

function timeseriescheckload(loads::Array{T}) where {T<:ElectricLoad}
    t = length(loads[1].scalingfactor)
    for l in loads
        if t == length(l.scalingfactor)
            continue
        else
            @error "Inconsistent load scaling factor time series length"
        end
    end
    return t
end

function timeserieschecksources(generators::Array{T}, t) where {T<:Generator}
    for g in generators
        if t == length(g.scalingfactor)
            continue
        else
            @error "Inconsistent generation scaling factor time series length for $(g.name)"
        end
    end
end

## Check that all the buses have a type defintion ##

function buscheck(buses::Array{Bus})
    for b in buses
        if b.bustype == nothing
            @warn "Bus/Nodes data does not contain information to build an a network"
        end
    end
end

## Slack Bus Definition ##

function slackbuscheck(buses::Array{Bus})
    slack = -9
    for b in buses
        if b.bustype == "SF"
            slack = b.number
        end
    end
    if slack == -9
        @error "Model doesn't contain a slack bus"
    end
end

### PV Bus Check ###

function pvbuscheck(buses::Array{Bus}, generators::Array{T}) where {T<:Generator}
    pv_list = -1*ones(Int64, length(generators))
    for (ix,g) in enumerate(generators)
        g.bus.bustype == "PV" ? pv_list[ix] = g.bus.number : continue
    end

    for b in buses
        if b.bustype == "PV"
            b.number in pv_list ? continue : 0 #@warn "The bus ", b.number, " is declared as PV without a generator connected to it"
        else
            continue
        end
    end
end

# function check_angle_limits(anglelimits::(max::Float64, min::Float64))
function checkanglelimits!(branches::Array{<:Branch,1})
    for (ix,l) in enumerate(branches)
        if isa(l,Line)
            orderedlimits(l.anglelimits, "Angles")

            newanglelimits = l.anglelimits
            flag = 0
            (l.anglelimits.max >= 90.0 && l.anglelimits.min <= -90.0) ? (flag,newanglelimits) = (1,(min = -90.0,max = 90.0)) : true
            (l.anglelimits.max >= 90.0 && l.anglelimits.min >= -90.0) ? (flag,newanglelimits) =(1, (min = l.anglelimits.min,max = 90.0)) : true
            (l.anglelimits.max <= 90.0 && l.anglelimits.min <= -90.0) ? (flag,newanglelimits) = (1,(min = -90.0,max = l.anglelimits.max)) : true
            (l.anglelimits.max == 0.0 && l.anglelimits.min == 0.0) ? (flag,newanglelimits) = (1,(min = -90.0,max = 90.0)) : true
            if flag == 1
                branches[ix] = Line(deepcopy(l.name),deepcopy(l.available),
                                    deepcopy(l.connectionpoints),deepcopy(l.r),
                                    deepcopy(l.x),deepcopy(l.b),deepcopy(l.rate),
                                    newanglelimits)
            end
        end
    end
end

function calculatethermallimits!(branches::Array{<:Branch,1},basemva::Float64)
    for (ix,l) in enumerate(branches)
        if isa(l,Line)
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
            flag = 0
            #This is the same check as implemented in PowerModels
            if l.rate.from_to <= 0.0
                (flag, rating_from_to) = (1,new_rate*basemva)
            elseif l.rate.from_to > new_rate*basemva
                 (flag, rating_from_to) = (1,new_rate*basemva)
            else
                rating_from_to = l.rate.from_to
            end
            if l.rate.to_from <= 0.0
                (flag, rating_from_to) = (1,new_rate*basemva)
            elseif  l.rate.to_from > new_rate*basemva
                (flag, rating_from_to) = (1,new_rate*basemva)
            else
                 rating_to_from = l.rate.to_from
            end
            if flag == 1
                branches[ix] = Line(deepcopy(l.name),deepcopy(l.available),
                                    deepcopy(l.connectionpoints),deepcopy(l.r),
                                    deepcopy(l.x),deepcopy(l.b),
                                    (from_to = rating_from_to, to_from = rating_to_from),deepcopy(l.anglelimits))
            end
        end
    end
end

# TODO: Check for islanded Buses

# check for minimum timediff
function minimumtimestep(loads::Array{T})where {T<:ElectricLoad}
    if length(loads[1].scalingfactor) > 1
        timeseries = loads[1].scalingfactor
        n = length(timeseries)-1
        ts = []
        for i in 1:n
            push!(ts,timestamp(timeseries)[n+1]-timestamp(timeseries)[n])
        end
        return minimum(ts)
    else
        ts =Dates.Minute(1)
        return ts
    end
end

# convert generator ramp rates to a consistent denominator
function convertramp(ramplimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing}, ts::TimePeriod)
    if isa(ramplimits,NamedTuple)
        hr = typeof(ts)(Dates.Minute(1))
        scaling  = hr/ts
        up = ramplimits.up/scaling
        down = ramplimits.down/scaling
        R = (up = up, down = down)
        return R
    else
        return ramplimits
    end
end


# check for valid ramp limits
function checkramp(generators::Array{T}, ts::TimePeriod) where {T<:Generator}
    for (ix,g) in enumerate(generators)
        if isa(g,ThermalDispatch)
            R = convertramp(g.tech.ramplimits,ts)
            generators[ix] = ThermalDispatch(deepcopy(g.name),deepcopy(g.available),deepcopy(g.bus),
                                            TechThermal(deepcopy(g.tech.activepower),deepcopy(g.tech.activepowerlimits),
                                                        deepcopy(g.tech.reactivepower),deepcopy(g.tech.reactivepowerlimits),
                                                        R,deepcopy(g.tech.timelimits)),
                                            deepcopy(g.econ)
                                            )
            if isa(g.tech.ramplimits, NamedTuple)
                if g.tech.ramplimits.up >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @warn "The generator $(g.name) has a nonbinding ramp up limit."
                end
                if g.tech.ramplimits.down >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @warn "The generator $(g.name) has a nonbinding ramp down limit."
                end
            else
                @info "Ramp defined as nothing for $(g.name)"
            end
        elseif isa(g,ThermalGenSeason)
            R = convertramp(g.tech.ramplimits,ts)
            generators[ix] = ThermalGenSeason(deepcopy(g.name),deepcopy(g.available),deepcopy(g.bus),
                                            TechThermal(deepcopy(g.tech.activepower),deepcopy(g.tech.activepowerlimits),
                                                        deepcopy(g.tech.reactivepower),deepcopy(g.tech.reactivepowerlimits),
                                                        R,deepcopy(g.tech.timelimits)),
                                            deepcopy(g.econ),
                                            deepcopy(g.scalingfactor)
                                            )
            if isa(g.tech.ramplimits, NamedTuple)
                if g.tech.ramplimits.up >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @warn "The generator $(g.name) has a nonbinding ramp up limit."
                end
                if g.tech.ramplimits.down >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @warn "The generator $(g.name) has a nonbinding ramp down limit."
                end
            else
                @info "Ramp defined as nothing for $(g.name)"
            end
        elseif isa(g,HydroCurtailment)
            R = convertramp(g.tech.ramplimits,ts)
            generators[ix] = HydroCurtailment(deepcopy(g.name),deepcopy(g.available),deepcopy(g.bus),
                                            TechHydro(deepcopy(g.tech.installedcapacity),deepcopy(g.tech.activepower),deepcopy(g.tech.activepowerlimits),
                                                    deepcopy(g.tech.reactivepower),deepcopy(g.tech.reactivepowerlimits),
                                                    R,deepcopy(g.tech.timelimits)),
                                            deepcopy(g.econ.curtailpenalty),
                                            deepcopy(g.scalingfactor)
                                            )
            if isa(g.tech.ramplimits, NamedTuple)
                if g.tech.ramplimits.up >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @info "The generator $(g.name) has a nonbinding ramp up limit."
                end
                if g.tech.ramplimits.down >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @info "The generator $(g.name) has a nonbinding ramp down limit."
                end
            else
                @info "Ramp defined as nothing for $(g.name)"
            end
        elseif isa(g,HydroStorage)
            R = convertramp(g.tech.ramplimits,ts)
            generators[ix] = HydroStorage(deepcopy(g.name),deepcopy(g.available),deepcopy(g.bus),
                                            TechHydro(deepcopy(g.tech.installedcapacity),deepcopy(g.tech.activepower),deepcopy(g.tech.activepowerlimits),
                                                    deepcopy(g.tech.reactivepower),deepcopy(g.tech.reactivepowerlimits),
                                                    R,deepcopy(g.tech.timelimits)),
                                            deepcopy(g.econ),
                                            deepcopy(g.storagecapacity),
                                            deepcopy(g.scalingfactor)
                                            )
            if isa(g.tech.ramplimits, NamedTuple)
                if g.tech.ramplimits.up >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @info "The generator $(g.name) has a nonbinding ramp up limit."
                end
                if g.tech.ramplimits.down >= (g.tech.activepowerlimits.max - g.tech.activepowerlimits.min)
                    @info "The generator $(g.name) has a nonbinding ramp down limit."
                end
            else
                @info "Ramp defined as nothing for $(g.name)"
            end
        end
    end
    return generators
end

