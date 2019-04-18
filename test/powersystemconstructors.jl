@testset "Test System constructors from .jl files" begin
    tPowerSystem = System()

    sys5 = System(nodes5, thermal_generators5, loads5, nothing, nothing,  100.0, nothing, nothing, nothing)
    
    sys5 = System(nodes5, thermal_generators5, loads5, branches5, nothing,  100.0, nothing, nothing, nothing)

    sys5b = System(nodes5, thermal_generators5, loads5, nothing, battery5,  100.0, nothing, nothing, nothing)

    sys5b = System(nodes5, thermal_generators5, loads5, nothing, battery5,  100.0, forecasts5, nothing, nothing)

    sys5bh = System(nodes5, vcat(thermal_generators5, hydro_generators5), loads5, branches5, battery5,  100.0, nothing, nothing, nothing)

     #Test Data for 14 Bus

    sys14 = System(nodes14, thermal_generators14, loads14, nothing, nothing, 100.0, Dict{Symbol,Vector{<:Forecast}}(),nothing,nothing)
    
    # A removed method broke this test
    #sys14 = System(nodes14, thermal_generators14, loads14, branches14, nothing, 100.0, forecast_DA14, nothing, nothing)

    sys14b = System(nodes14, thermal_generators14, loads14, nothing, battery14, 100.0, nothing, nothing, nothing)
    sys14b = System(nodes14, thermal_generators14, loads14, branches14, battery14, 100.0, nothing, nothing, nothing)
end

@testset "Test System constructor from Matpower" begin
    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "case5_re.m"))
    sys = PowerSystems.System(ps_dict)
end
