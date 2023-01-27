
function get_expected_buses(::Type{T}, sys::System) where {T <: AggregationTopology}
    expected_buses = Dict{String, Vector{String}}()
    for bus in get_components(ACBus, sys)
        agg = get_aggregation_topology_accessor(T)(bus)
        name = get_name(agg)
        if !haskey(expected_buses, name)
            expected_buses[name] = Vector{String}()
        end
        push!(expected_buses[name], get_name(bus))
    end

    return expected_buses
end

function test_aggregation_topologies(sys::System, expected_areas, expected_zones)
    expected_buses_by_area = get_expected_buses(Area, sys)
    expected_buses_by_zone = get_expected_buses(LoadZone, sys)

    areas = collect(get_components(Area, sys))
    @test length(areas) == expected_areas
    area_mapping = get_aggregation_topology_mapping(Area, sys)
    for area in areas
        area_name = get_name(area)
        buses = sort!([get_name(x) for x in get_buses(sys, area)])
        @test buses == sort(expected_buses_by_area[area_name])
        @test buses == sort!([get_name(x) for x in area_mapping[area_name]])
    end

    zones = collect(get_components(LoadZone, sys))
    zone_mapping = get_aggregation_topology_mapping(LoadZone, sys)
    @test length(zones) == expected_zones
    for zone in zones
        zone_name = get_name(zone)
        buses = sort!([get_name(x) for x in get_buses(sys, zone)])
        @test buses == sort(expected_buses_by_zone[zone_name])
        @test buses == sort!([get_name(x) for x in zone_mapping[zone_name]])
    end
end

@testset "Test topology mappings" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecast = false)
    test_aggregation_topologies(sys, 3, 3)
end

@testset "Test PM areas and load zones" begin
    sys = PSB.build_system(MatpowerTestSystems, "matpower_RTS_GMLC_sys")
    test_aggregation_topologies(sys, 3, 21)
end

@testset "Test get_components_in_aggregation_topology" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecast = false)
    areas = collect(get_components(Area, sys))
    @test !isempty(areas)
    area = areas[1]
    generators = get_components_in_aggregation_topology(ThermalStandard, sys, area)

    for gen in generators
        bus = get_bus(gen)
        @test IS.get_uuid(get_area(bus)) == IS.get_uuid(area)
    end
end
