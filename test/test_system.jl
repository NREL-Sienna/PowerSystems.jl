
@testset "Test functionality of ConcreteSystem" begin
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    sys_rts = System(cdm_dict)
    rts_da = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["DA"])
    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])

    PowerSystems.add_forecast!(sys_rts, :DA=>rts_da)
    PowerSystems.add_forecast!(sys_rts, :RT=>rts_rt)

    sys_rts_rt = PowerSystems._System(cdm_dict)
    @test length(sys_rts_rt.branches) == length(collect(get_components(Branch, sys_rts)))
    @test length(sys_rts_rt.loads) == length(collect(get_components(ElectricLoad, sys_rts)))
    @test length(sys_rts_rt.storage) == length(collect(get_components(Storage, sys_rts)))
    @test length(sys_rts_rt.generators.thermal) == length(collect(get_components(ThermalGen, sys_rts)))
    @test length(sys_rts_rt.generators.renewable) == length(collect(get_components(RenewableGen, sys_rts)))
    @test length(sys_rts_rt.generators.hydro) == length(collect(get_components(HydroGen, sys_rts)))
    @test length(collect(get_components(Bus, sys_rts))) > 0
    @test length(collect(get_components(ThermalDispatch, sys_rts))) > 0
    summary(devnull, sys_rts_rt)

    # Negative test of missing type.
    components = Vector{ThermalGen}()
    for subtype in PowerSystems.subtypes(ThermalGen)
        if haskey(sys_rts.components, subtype)
            for component in pop!(sys_rts.components, subtype)
                push!(components, component)
            end
        end
    end

    @test length(collect(get_components(ThermalGen, sys_rts))) == 0
    @test length(collect(get_components(ThermalDispatch, sys_rts))) == 0

    # For the next test to work there must be at least one component to add back.
    @test length(components) > 0
    for component in components
        add_component!(sys_rts, component)
    end

    @test length(collect(get_components(ThermalGen, sys_rts))) > 0
end
