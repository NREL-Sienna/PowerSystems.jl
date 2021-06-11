@testset "Test deprecated accessors for BatteryEMS" begin
    #TODO: use PSCB test system after PR#12 is merge and delete battery device
    # c_sys5_bat = PSB.build_system(PSITestSystems, "c_sys5_bat_ems");
    # batt = get_component(BatteryEMS, c_sys5_bat, "Bat2");
    batt = BatteryEMS(;
        name = "Bat2",
        prime_mover = PrimeMovers.BA,
        available = true,
        bus = Bus(nothing),
        initial_energy = 5.0,
        state_of_charge_limits = (min = 0.10, max = 7.0),
        rating = 7.0,
        active_power = 2.0,
        input_active_power_limits = (min = 0.0, max = 2.0),
        output_active_power_limits = (min = 0.0, max = 2.0),
        efficiency = (in = 0.80, out = 0.90),
        reactive_power = 0.0,
        reactive_power_limits = (min = -2.0, max = 2.0),
        base_power = 100.0,
        storage_target = 0.2,
        operation_cost = StorageManagementCost(
            variable = VariableCost(0.0),
            fixed = 0.0,
            start_up = 0.0,
            shut_down = 0.0,
            energy_shortage_cost = 50.0,
            energy_surplus_cost = 40.0,
        ),
    )
    dummy_value = 99.9
    @test @test_deprecated(set_energy_value!(batt, dummy_value)) == dummy_value
    @test @test_deprecated(set_penalty_cost!(batt, dummy_value)) == dummy_value

    @test @test_deprecated(get_energy_value(batt)) ==
          get_energy_surplus_cost(get_operation_cost(batt))
    @test @test_deprecated(get_penalty_cost(batt)) ==
          get_energy_shortage_cost(get_operation_cost(batt))
end

@testset "Test deprecated CurrentControl" begin
    @test_deprecated(CurrentControl(
        0.59, #kpv:: Voltage controller proportional gain
        736.0, #kiv:: Voltage controller integral gain
        0.0, #kffv:: Binary variable enabling the voltage feed-forward in output of current controllers
        0.0, #rv:: Virtual resistance in pu
        0.2, #lv: Virtual inductance in pu
        1.27, #kpc:: Current controller proportional gain
        14.3, #kiv:: Current controller integral gain
        0.0, #kffi:: Binary variable enabling the current feed-forward in output of current controllers
        50.0, #ωad:: Active damping low pass filter cut-off frequency
        0.2, #kad:: Active damping gain
    ))
end
