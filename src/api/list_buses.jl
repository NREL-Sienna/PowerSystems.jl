
# TODO: filter by fields

function list_buses(sys::System)
    return JSON2.write(collect(make_ctm_bus(x) for x in get_components(Bus, sys)))
end

function get_ctm_buses(sys::System)
    return (make_ctm_bus(x) for x in get_components(Bus, sys))
end

function make_ctm_bus(bus::Bus)
    return CTM.Bus(;
        index = get_number(bus),
        status = 1,
        name = get_name(bus),
        base_kv = get_basevoltage(bus),
        vm = get_voltage(bus),
        va = get_angle(bus),
        type = Int(convert(MatpowerBusTypes.MatpowerBusType, get_bustype(bus))),
        vm_lb = get_voltagelimits(bus).min,
        vm_ub = get_voltagelimits(bus).max,
        area = parse(Int, get_name(get_area(bus))),
        zone = parse(Int, get_name(get_load_zone(bus))),
    )
end
