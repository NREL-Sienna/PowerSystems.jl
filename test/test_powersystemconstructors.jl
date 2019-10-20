
include(joinpath(DATA_DIR,"data_5bus_pu.jl"))
include(joinpath(DATA_DIR,"data_14bus_pu.jl"))

checksys = false

@testset "Test System constructors from .jl files" begin
    tPowerSystem = System(nothing)

    for i in nodes5
          nodes5[i].angle = deg2rad(nodes5[i].angle)
    end

    # Components with forecasts cannot be added to multiple systems, so clear them on each
    # test.

    sys5 = System(nodes5, thermal_generators5, loads5, nothing, nothing,  100.0, nothing,
                  nothing; runchecks = checksys)
    clear_components!(sys5)

    sys5b = System(nodes5, thermal_generators5, loads5, nothing, battery5,  100.0, nothing,
                   nothing; runchecks = checksys)
    clear_components!(sys5b)

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys5b = PowerSystems._System(nodes5, thermal_generators5, loads5, nothing, battery5,
    #                              100.0, forecasts5, nothing, nothing)
    #sys5b = System(_sys5b)

    sys5bh = System(nodes5, vcat(thermal_generators5, hydro_generators5), loads5, branches5,
                    battery5,  100.0, nothing, nothing; runchecks = checksys)
    clear_components!(sys5bh)

    sys5bh = System(; buses=nodes5,
                    generators=vcat(thermal_generators5, hydro_generators5),
                    loads=loads5,
                    branches=branches5,
                    storage=battery5,
                    basepower=100.0,
                    services=nothing,
                    annex=nothing,
                    runchecks = checksys)
    clear_components!(sys5bh)

    # Test Data for 14 Bus

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys14 = PowerSystems._System(nodes14, thermal_generators14, loads14, nothing, nothing,
    #                            100.0, Dict{Symbol,Vector{<:Forecast}}(),nothing,nothing)
    #sys14 = System(_sys14)

    for i in nodes14
          nodes14[i].angle = deg2rad(nodes14[i].angle)
    end

    sys14b = PowerSystems.System(nodes14, thermal_generators14, loads14, nothing,
                                 battery14, 100.0, nothing, nothing; runchecks = checksys)
    clear_components!(sys14b)
    sys14b = PowerSystems.System(nodes14, thermal_generators14, loads14, branches14,
                                 battery14, 100.0, nothing, nothing; runchecks = checksys)
    clear_components!(sys14b)
end

@testset "Test System constructor from Matpower" begin
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))
end
