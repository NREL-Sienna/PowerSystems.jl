
get_aggregation_topology_accessor(::Type{Area}) = get_area
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

set_load_zone!(bus::Bus, load_zone::LoadZone) = bus.load_zone = load_zone
set_area!(bus::Bus, area::Area) = bus.area = area

"""
    removes the aggregation topology in a Bus
"""
_remove_aggregration_topology!(bus::Bus, ::LoadZone) = bus.load_zone = nothing
_remove_aggregration_topology!(bus::Bus, ::Area) = bus.area = nothing

"""
    calculates the admittance of AC branches
"""
get_admittance(b::ACBranch) = 1 / get_x(b)
get_admittance(b::TapTransformer) = 1 / (get_x(b) * get_tap(b))
function get_admittance(b::PhaseShiftingTransformer)
    y = 1 / (get_r(b) + get_x(b) * 1im)
    y_a = y / (get_tap(b) * exp(get_α(b) * 1im * (π / 180)))
    return 1 / imag(y_a)
end
