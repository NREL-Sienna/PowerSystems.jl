@testset "FACTSControlDevice first-class fields" begin
    sys = System(100.0)
    b = ACBus(;
        number = 1,
        name = "b1",
        available = true,
        bustype = ACBusTypes.PV,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 138.0,
    )
    add_component!(sys, b)
    fd = FACTSControlDevice(;
        name = "F1", available = true, bus = b,
        control_mode = FACTSOperationModes.NML,
        voltage_setpoint = 1.0,
        max_shunt_current = 0.5,          # PSS/E SHMX
        max_reactive_power = 0.6,         # independent MVA ceiling
        shunt_control_type = FACTSShuntControlType.STATCOM,
        regulated_bus_number = 13,
        reactive_power_required = 0.0,
    )
    add_component!(sys, fd)
    g = get_component(FACTSControlDevice, sys, "F1")
    @test get_shunt_control_type(g) == FACTSShuntControlType.STATCOM
    @test get_regulated_bus_number(g) == 13
    @test get_max_reactive_power(g) == 0.6
    @test get_max_shunt_current(g) == 0.5
    set_reactive_power_required!(g, 0.42)
    @test get_reactive_power_required(g) == 0.42

    # Locks the positional-constructor fix: voltage_setpoint must occupy its own slot
    # (after control_mode) rather than being shifted out by a field with an
    # internal_default, which previously misaligned every field after it.
    fd_pos = FACTSControlDevice("F2", true, b, FACTSOperationModes.NML, 1.05)
    @test get_voltage_setpoint(fd_pos) == 1.05
    @test get_max_shunt_current(fd_pos) == 9999.0
    @test get_max_reactive_power(fd_pos) == 9999.0
end
