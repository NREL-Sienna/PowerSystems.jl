export orderedlimits
export PlotTimeSeries

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") :limits

orderedlimits(limits::NamedTuple) = limits.max < limits.min ? error("Limits not in ascending order") : limits

orderedlimits(limits::Nothing) = warn("Limits defined as nothing")

function PlotTimeSeries()

end
