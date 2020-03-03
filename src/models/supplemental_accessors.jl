
get_aggregation_topology_accessor(::Type{Area}) = get_area
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

set_load_zone!(bus::Bus, load_zone::LoadZone) = bus.load_zone = load_zone
