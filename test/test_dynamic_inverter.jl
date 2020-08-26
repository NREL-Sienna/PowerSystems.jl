@testset "Inverter Components" begin
    converter = AverageConverter(690.0, 2750000.0) #S_rated goes in Watts
    @test converter isa PowerSystems.DynamicComponent
    dc_source = FixedDCSource(600.0) #Not in the original data, guessed.
    @test dc_source isa PowerSystems.DynamicComponent
    filter = LCLFilter(0.08, 0.003, 0.074, 0.2, 0.01)
    @test filter isa PowerSystems.DynamicComponent
    pll = KauraPLL(500.0, 0.084, 4.69)
    @test pll isa PowerSystems.DynamicComponent
    virtual_H = VirtualInertia(2.0, 400.0, 20.0, 2 * pi * 50.0)
    @test virtual_H isa PowerSystems.DeviceParameter
    Q_control = ReactivePowerDroop(0.2, 1000.0)
    @test Q_control isa PowerSystems.DeviceParameter
    outer_control = OuterControl(virtual_H, Q_control)
    @test outer_control isa PowerSystems.DynamicComponent
    vsc = CurrentControl(0.59, 736.0, 0.0, 0.0, 0.2, 1.27, 14.3, 0.0, 50.0, 0.2)
    @test vsc isa PowerSystems.DynamicComponent
    BESS_source = ZeroOrderBESS((sqrt(8)/sqrt(3))*690.0, (sqrt(3)/sqrt(8))*2750000.0, 370.0, 0.001, 4.63, 3200, 0.6, 4.0, 0.39, 10.34, 1.08)
    @test BESS_source isa PowerSystems.DynamicComponent
end

@testset "Dynamic Inverter" begin
    sys = create_system_with_dynamic_inverter()
    inverters = collect(get_components(DynamicInverter, sys))
    @test length(inverters) == 1
    test_inverter = inverters[1]
    @test test_inverter isa PowerSystems.Component
end
