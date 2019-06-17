
include(joinpath(DATA_DIR,"data_5bus_pu.jl"))
include(joinpath(DATA_DIR,"data_14bus_pu.jl"))

@testset "Test System constructors from .jl files" begin
    tPowerSystem = System()

    sys5 = System(nodes5, thermal_generators5, loads5, nothing, nothing,  100.0, nothing,
                  nothing, nothing)

    sys5b = System(nodes5, thermal_generators5, loads5, nothing, battery5,  100.0, nothing,
                   nothing, nothing)

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys5b = PowerSystems._System(nodes5, thermal_generators5, loads5, nothing, battery5,
    #                              100.0, forecasts5, nothing, nothing)
    #sys5b = System(_sys5b)

    sys5bh = System(nodes5, vcat(thermal_generators5, hydro_generators5), loads5, branches5,
                    battery5,  100.0, nothing, nothing, nothing)

    # Test Data for 14 Bus

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys14 = PowerSystems._System(nodes14, thermal_generators14, loads14, nothing, nothing, 
    #                            100.0, Dict{Symbol,Vector{<:Forecast}}(),nothing,nothing)
    #sys14 = System(_sys14)

    _sys14b = PowerSystems._System(nodes14, thermal_generators14, loads14, nothing,
                                            battery14, 100.0, nothing, nothing, nothing)
    sys14b = System(_sys14b)
    _sys14b = PowerSystems._System(nodes14, thermal_generators14, loads14, branches14, 
                                            battery14, 100.0, nothing, nothing, nothing)
    sys14b = System(_sys14b)
end

@testset "Test System constructor from Matpower" begin
    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "case5_re.m"))
    sys = System(ps_dict)
end
