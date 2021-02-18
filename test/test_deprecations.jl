@testset "Test deprecated accessors for BatteryEMS" begin
    c_sys5_bat = PSB.build_system(PSITestSystems, "c_sys5_bat_ems");
    batt = get_component(BatteryEMS, c_sys5_bat, "Bat2");
    dummy_value = 99.9
    @test @test_deprecated(set_energy_value!(batt, dummy_value)) == dummy_value
    @test @test_deprecated(set_penalty_cost!(batt, dummy_value)) == dummy_value

    @test @test_deprecated(get_energy_value(batt)) == get_energy_surplus_cost(get_operation_cost(batt))
    @test @test_deprecated(get_penalty_cost(batt)) == get_energy_shortage_cost(get_operation_cost(batt))
end
