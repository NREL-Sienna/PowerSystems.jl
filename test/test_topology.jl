
function get_expected_buses(::Type{T}, sys::System) where {T <: AggregationTopology}
    expected_buses = Dict{String, Vector{Int}}()
    for bus in get_components(Bus, sys)
        agg = get_aggregation_topology_accessor(T)(bus)
        name = get_name(agg)
        if !haskey(expected_buses, name)
            expected_buses[name] = Vector{Int}()
        end
        push!(expected_buses[name], get_number(bus))
    end

    return expected_buses
end

function test_aggregation_topologies(sys::System, expected_areas, expected_zones)
    expected_buses_by_area = get_expected_buses(Area, sys)
    expected_buses_by_zone = get_expected_buses(LoadZone, sys)

    areas = collect(get_components(Area, sys))
    @test length(areas) == expected_areas
    for area in areas
        buses = sort!([get_number(x) for x in get_buses(sys, area)])
        @test buses == sort(expected_buses_by_area[get_name(area)])
    end

    zones = collect(get_components(LoadZone, sys))
    @test length(zones) == expected_zones
    for zone in zones
        buses = sort!([get_number(x) for x in get_buses(sys, zone)])
        @test buses == sort(expected_buses_by_zone[get_name(zone)])
    end
end

@testset "Test topology mappings" begin
    sys = create_rts_system()
    test_aggregation_topologies(sys, 3, 21)
end

@testset "Test PM areas and load zones" begin
    path = joinpath(DATA_DIR, "matpower", "RTS_GMLC.m")
    pm_dict = PowerSystems.parse_file(path)
    sys = PowerSystems.pm2ps_dict(pm_dict)
    test_aggregation_topologies(sys, 3, 21)
end
