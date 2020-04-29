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
end

@testset "Dynamic Inverter" begin
    nodes_OMIB = [
        Bus(
            1, #number
            "Bus 1", #Name
            "REF", #BusType (REF, PV, PQ)
            0, #Angle in radians
            1.06, #Voltage in pu
            (min = 0.94, max = 1.06), #Voltage limits in pu
            69,
            nothing,
            nothing,
        ), #Base voltage in kV
        Bus(2, "Bus 2", "PV", 0, 1.045, (min = 0.94, max = 1.06), 69, nothing, nothing),
    ]

    battery = GenericBattery(
    name = "Battery",
    primemover = PrimeMovers.BA,
    available = true,
    bus = nodes_OMIB[2],
    energy = 5.0,
    capacity = (min = 5.0, max = 100.0),
    rating = 0.0275, #Value in per_unit of the system
    activepower = 0.01375,
    inputactivepowerlimits = (min = 0.0, max = 50.0),
    outputactivepowerlimits = (min = 0.0, max = 50.0),
    reactivepower = 0.0,
    reactivepowerlimits = (min = -50.0, max = 50.0),
    efficiency = (in = 0.80, out = 0.90),
)
    converter = AverageConverter(
        138.0, #Rated Voltage
        100.0,
    ) #Rated MVA

    branch_OMIB = [Line(
        "Line1", #name
        true, #available
        0.0, #active power flow initial condition (from-to)
        0.0, #reactive power flow initial condition (from-to)
        Arc(from = nodes_OMIB[1], to = nodes_OMIB[2]), #Connection between buses
        0.01, #resistance in pu
        0.05, #reactance in pu
        (from = 0.0, to = 0.0), #susceptance in pu
        18.046, #rate in MW
        1.04,
    )]  #angle limits (-min and max)

    dc_source = FixedDCSource(1500.0) #Not in the original data, guessed.

    filt = LCLFilter(
        0.08, #Series inductance lf in pu
        0.003, #Series resitance rf in pu
        0.074, #Shunt capacitance cf in pu
        0.2, #Series reactance rg to grid connection (#Step up transformer or similar)
        0.01,
    ) #Series resistance lg to grid connection (#Step up transformer or similar)

    pll = KauraPLL(
        500.0, #ω_lp: Cut-off frequency for LowPass filter of PLL filter.
        0.084, #k_p: PLL proportional gain
        4.69,
    ) #k_i: PLL integral gain

    virtual_H = VirtualInertia(
        2.0, #Ta:: VSM inertia constant
        400.0, #kd:: VSM damping coefficient
        20.0, #kω:: Frequency droop gain in pu
        2 * pi * 50.0,
    ) #ωb:: Rated angular frequency

    Q_control = ReactivePowerDroop(
        0.2, #kq:: Reactive power droop gain in pu
        1000.0,
    ) #ωf:: Reactive power cut-off low pass filter frequency

    outer_control = OuterControl(virtual_H, Q_control)

    vsc = CurrentControl(
        0.59, #kpv:: Voltage controller proportional gain
        736.0, #kiv:: Voltage controller integral gain
        0.0, #kffv:: Binary variable enabling the voltage feed-forward in output of current controllers
        0.0, #rv:: Virtual resistance in pu
        0.2, #lv: Virtual inductance in pu
        1.27, #kpc:: Current controller proportional gain
        14.3, #kiv:: Current controller integral gain
        0.0, #kffi:: Binary variable enabling the current feed-forward in output of current controllers
        50.0, #ωad:: Active damping low pass filter cut-off frequency
        0.2,
    ) #kad:: Active damping gain

    test_inverter = DynamicInverter(
        2, #number
        "DARCO", #name
        nodes_OMIB[1], #bus location
        1.0, #ω_ref
        1.02, #V_ref
        0.5, #P_ref
        0.0, #Q_ref
        100.0, #MVABase
        converter, #Converter
        outer_control, #OuterControl
        vsc, #Voltage Source Controller
        dc_source, #DC Source
        pll, #Frequency Estimator
        filt,
    ) #Output Filter

    @test test_inverter isa PowerSystems.Component

    sys = System(100)
    for bus in nodes_OMIB
        add_component!(sys, bus)
    end
    for lines in branch_OMIB
        add_component!(sys, lines)
    end
    add_component!(sys, battery)
    add_component!(sys, test_inverter)

    @test collect(get_components(DynamicInverter, sys))[1] == test_inverter

end
