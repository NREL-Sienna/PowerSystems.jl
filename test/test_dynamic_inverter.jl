@testset "Inverter Components" begin
    converter = AvgCnvFixedDC(690.0, 2750000.0) #S_rated goes in Watts
    @test converter isa PowerSystems.DynamicComponent
    dc_source = FixedDCSource(600.0) #Not in the original data, guessed.
    @test dc_source isa PowerSystems.DynamicComponent
    filter = LCLFilter(0.08, 0.003, 0.074, 0.2, 0.01)
    @test filter isa PowerSystems.DynamicComponent
    pll = PLL(500.0, 0.084, 4.69)
    @test pll isa PowerSystems.DynamicComponent
    virtual_H = VirtualInertia(2.0, 400.0, 20.0, 2*pi*50.0)
    @test virtual_H isa PowerSystems.DeviceParameter
    Q_control = ReactivePowerDroop(0.2, 1000.0)
    @test Q_control isa PowerSystems.DeviceParameter
    outer_control = VirtualInertiaQdroop(virtual_H, Q_control)
    @test outer_control isa PowerSystems.DynamicComponent
    vsc = CombinedVIwithVZ(1.27, 14.3, 0.59, 736.0, 50.0, 0.5, 0.2, 0.00)
end

@testset "Dynamic Inverter" begin
    nodes_OMIB= [Bus(1 , #number
                    "Bus 1", #Name
                    "REF" , #BusType (REF, PV, PQ)
                    0, #Angle in radians
                    1.06, #Voltage in pu
                    (min=0.94, max=1.06), #Voltage limits in pu
                    69), #Base voltage in kV
                    Bus(2 , "Bus 2"  , "PV" , 0 , 1.045 , (min=0.94, max=1.06), 69)]

    converter = AvgCnvFixedDC(690.0, 2750000.0) #S_rated goes in Watts
    dc_source = FixedDCSource(600.0) #Not in the original data, guessed.
    filter = LCLFilter(0.08, 0.003, 0.074, 0.2, 0.01)
    pll = PLL(500.0, 0.084, 4.69)
    virtual_H = VirtualInertia(2.0, 400.0, 20.0, 2*pi*50.0)
    Q_control = ReactivePowerDroop(0.2, 1000.0)
    outer_control = VirtualInertiaQdroop(virtual_H, Q_control)
    vsc = CombinedVIwithVZ(1.27, 14.3, 0.59, 736.0, 50.0, 0.5, 0.2, 0.00)

    test_inverter = DynInverter(1,
                                :DARCO,
                                nodes_OMIB[2],
                                1.0,
                                1.0,
                                0.4,
                                0.0,
                                2.75e3,
                                converter,
                                outer_control,
                                vsc,
                                dc_source,
                                pll,
                                filter)
    @test test_inverter isa PowerSystems.Component
end
