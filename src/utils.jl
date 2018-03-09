export orderedlimits
export PlotTimeSeries

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") : limits

function PlotTimeSeries

end
