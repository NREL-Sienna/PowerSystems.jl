import UUIDs

@testset "Test internal values" begin
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    sys_rts = System(cdm_dict)
    rts_da = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["DA"])
    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])

    PowerSystems.add_forecast!(sys_rts, :DA=>rts_da)
    PowerSystems.add_forecast!(sys_rts, :RT=>rts_rt)

    sys_rts_rt = System(cdm_dict)
    sys = ConcreteSystem(sys_rts)

    # Every type should have a UUID.
    @test PowerSystems.get_uuid(sys) isa UUIDs.UUID
    for component in get_components(Component, sys)
        @test PowerSystems.get_uuid(component) isa UUIDs.UUID
    end

    for (key, val) in sys.forecasts
        for forecast in val
            @test PowerSystems.get_uuid(forecast) isa UUIDs.UUID
        end
    end
end
