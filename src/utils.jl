export orderedlimits

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") : limits