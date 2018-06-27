function orderedlimits(limits::@NT(min::Float64, max::Float64), limsname::String)
    limits.max < limits.min ? error("'$limsname' limits not in ascending order") : limits
end

function orderedlimits(limits::Nothing,limsname::String)
    info("'$limsname' limits defined as nothing")
end