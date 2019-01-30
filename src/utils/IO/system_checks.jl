
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

# TODO: Check for islanded Buses

# check for minimum timediff
function minimumtimestep(loads::Array{T})where {T<:ElectricLoad}
    if length(loads[1].scalingfactor) > 1
        timeseries = loads[1].scalingfactor
        n = length(timeseries)-1
        ts = []
        for i in 1:n
            push!(ts,TimeSeries.timestamp(timeseries)[n+1]-TimeSeries.timestamp(timeseries)[n])
        end
        return minimum(ts)
    else
        ts =Dates.Dates.Minute(1)
        return ts
    end
end

# convert generator ramp rates to a consistent denominator
function convertramp(ramplimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing}, ts::Dates.TimePeriod)
    if isa(ramplimits,NamedTuple)
        hr = typeof(ts)(Dates.Dates.Minute(1))
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
function checkramp(generators::Array{T}, ts::Dates.TimePeriod) where {T<:Generator}
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
