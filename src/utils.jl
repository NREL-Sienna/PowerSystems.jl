export orderedlimits
export PlotLoadStackplot

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") :limits

orderedlimits(limits::NamedTuple) = limits.max < limits.min ? error("Limits not in ascending order") : limits

orderedlimits(limits::Nothing) = warn("Limits defined as nothing")

function PlotLoadStackplot(gens::Array{Any,1})
    """
    Plots a stackplot of the scaling factors (i.e. loads) of an array of renewable generators.
    Timestamps of the scaling factors must all be the same. Will error otherwise.
    Most bottom line in the plot is the scaling factors of the generator with the biggest sum of scaling factors.
    """
    # Check if timestamps are the same.
    ReGenTimeIndexCheck(gens)

    # Sort generators by their sum of scaling factors 
    gens = sort(gens, by=TotalLoadOfGen, rev=true)

    # Create array of traces of plot through PlotlyJS
    traces = Array{PlotlyBase.GenericTrace{Dict{Symbol,Any}},1}()

    idx = 0
    prev_vals = 0

    # Create a trace for every generator
    for g in gens
        load = g.scalingfactor

        # Determine fill behavior in the plot
        if idx == 0
            fillcode = "tozeroy"
        else
            fillcode = "tonexty"
        end

        # This line effectively does a cumulative sum of the scaling factors to create a stackplot
        vals = load.values + prev_vals

        # Create the trace for the current generator
        trace = scatter(;
            x = load.timestamp,
            y = vals,
            fill = fillcode,
            name = g.name)

        push!(traces, trace)
        prev_vals = vals
        idx += 1
    end

    layout = Layout(;
        xaxis_title = GetTimestep(gens[1].scalingfactor.timestamp),
        yaxis_title = "MW"
    )

    # Plot the array of traces created above
    plot(traces, layout)
end

##################################
# Utility Functions for plotting #
##################################

function TotalLoadOfGen(gen)
    """
    Returns sum of scaling factors of the given renewable generator.
    """
    return sum(gen.scalingfactor.values)
end

function ReGenTimeIndexCheck(gens::Array{Any,1})
    """
    Checks if an array of renewable generators have the same timestamps 
    in their scaling factors.
    """
    stamps = gens[1].scalingfactor.timestamp
    for g in gens[2:end]
        if stamps != g.scalingfactor.timestamp
            error("The timestamps of $(g.name)'s scaling factor aren't the same as that of $(gens[1])'s scaling factor!")
        end
    end
end

function GetTimestep(datetimes)
    """
    Given an array of datetimes, returns a string denoting the timestep.
    Assumes that the datetimes have timestep of either:
    1 second
    1 minute
    1 hour
    1 day 

    Assumes the array has length of at least 2 and ordered in 
    increasing order and that the datetimes are equally spaced. 
    """
    ref = DateTime(2000, 1, 1, 0, 0, 0) 
    sec = DateTime(2000, 1, 1, 0, 0, 1) - ref
    min = DateTime(2000, 1, 1, 0, 1, 0) - ref
    hr = DateTime(2000, 1, 1, 1, 0, 0) - ref
    day = DateTime(2000, 1, 2, 0, 0, 0) - ref

    diff = datetimes[2] - datetimes[1]

    if diff == sec
        return "Second"
    elseif diff == min
        return "Minute"
    elseif diff == hr
        return "Hour"
    elseif diff == day
        return "Day"
    end
end

