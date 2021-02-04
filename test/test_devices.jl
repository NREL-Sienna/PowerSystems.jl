@testset "Test special accessors" begin
    cdmsys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    th = first(get_components(ThermalStandard, cdmsys))
    re = first(get_components(RenewableDispatch, cdmsys))

    @test get_max_active_power(th) == get_active_power_limits(th).max
    @test get_max_active_power(re) <= get_rating(re)
    @test isa(get_max_reactive_power(re), Float64)

    @test_throws ArgumentError get_max_active_power(TestDevice("foo"))
    @test_throws ArgumentError get_max_active_power(TestRenDevice("foo"))
end
