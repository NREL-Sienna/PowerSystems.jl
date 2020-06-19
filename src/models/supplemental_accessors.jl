
get_aggregation_topology_accessor(::Type{Area}) = get_area
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

set_load_zone!(bus::Bus, load_zone::LoadZone) = bus.load_zone = load_zone
set_area!(bus::Bus, area::Area) = bus.area = area

"""
    removes the aggregation topology in a Bus
"""
_remove_aggregration_topology!(bus::Bus, ::LoadZone) = bus.load_zone = nothing
_remove_aggregration_topology!(bus::Bus, ::Area) = bus.area = nothing
