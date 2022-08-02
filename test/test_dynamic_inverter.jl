@testset "Inverter Components" begin
    converter = AverageConverter(690.0, 2750000.0) #S_rated goes in Watts
    @test converter isa PowerSystems.DynamicComponent
    dc_source = FixedDCSource(600.0) #Not in the original data, guessed.
    @test dc_source isa PowerSystems.DynamicComponent
    filter = LCLFilter(0.08, 0.003, 0.074, 0.2, 0.01)
    @test filter isa PowerSystems.DynamicComponent
    pll = KauraPLL(500.0, 0.084, 4.69)
    @test pll isa PowerSystems.DynamicComponent
    reduced_pll = ReducedOrderPLL(500.0, 0.084, 4.69)
    @test reduced_pll isa PowerSystems.DynamicComponent
    virtual_H = VirtualInertia(2.0, 400.0, 20.0, 2 * pi * 50.0)
    @test virtual_H isa PowerSystems.DeviceParameter
    P_control = ActivePowerDroop(0.2, 1000.0)
    @test P_control isa PowerSystems.DeviceParameter
    P_control_PI = ActivePowerPI(2.0, 20.0, 50.0)
    @test P_control_PI isa PowerSystems.DeviceParameter
    P_VOC = ActiveVirtualOscillator(0.0033, pi / 4)
    @test P_VOC isa PowerSystems.DeviceParameter
    Q_control = ReactivePowerDroop(0.2, 1000.0)
    @test Q_control isa PowerSystems.DeviceParameter
    Q_control_PI = ReactivePowerPI(2.0, 20.0, 50.0)
    @test Q_control_PI isa PowerSystems.DeviceParameter
    Q_VOC = ReactiveVirtualOscillator(0.0796)
    @test Q_VOC isa PowerSystems.DeviceParameter
    outer_control = OuterControl(virtual_H, Q_control)
    @test outer_control isa PowerSystems.DynamicComponent
    test_accessors(outer_control)
    outer_control_droop = OuterControl(P_control, Q_control)
    @test outer_control_droop isa PowerSystems.DynamicComponent
    test_accessors(outer_control_droop)
    outer_control_PI = OuterControl(P_control_PI, Q_control_PI)
    @test outer_control_PI isa PowerSystems.DynamicComponent
    test_accessors(outer_control_PI)
    outer_control_VOC = OuterControl(P_VOC, Q_VOC)
    @test outer_control_PI isa PowerSystems.DynamicComponent
    test_accessors(outer_control_PI)
    
    vsc = VoltageModeControl(0.59, 736.0, 0.0, 0.0, 0.2, 1.27, 14.3, 0.0, 50.0, 0.2)
    @test vsc isa PowerSystems.DynamicComponent
    vsc2 = VoltageModeControl(0.59, 736.0, 0.0, 0.0, 0.2, 1.27, 14.3, 0.0, 50.0, 0.2)
    @test vsc2 isa PowerSystems.DynamicComponent
    vsc3 = CurrentModeControl(1.27, 14.3, 0.0)
    @test vsc3 isa PowerSystems.DynamicComponent
    BESS_source = ZeroOrderBESS(
        (sqrt(8) / sqrt(3)) * 690.0,
        (sqrt(3) / sqrt(8)) * 2750000.0,
        370.0,
        0.001,
        4.63,
        3200.0,
        0.6,
        4.0,
        0.39,
        10.34,
        1.08,
    )
    @test BESS_source isa PowerSystems.DynamicComponent
end

@testset "Dynamic Inverter" begin
    sys = create_system_with_dynamic_inverter()
    inverters = collect(get_components(DynamicInverter, sys))
    @test length(inverters) == 1
    test_inverter = inverters[1]
    @test test_inverter isa PowerSystems.Component
    test_accessors(test_inverter)
end

@testset "Generic Renewable Models" begin
    converter_regca1 = RenewableEnergyConverterTypeA(
        T_g = 0.02,
        Rrpwr = 10.0,
        Brkpt = 0.9,
        Zerox = 0.4,
        Lvpl1 = 1.22,
        Vo_lim = 1.2,
        Lv_pnts = (0.5, 0.9),
        Io_lim = -1.3,
        T_fltr = 0.2,
        K_hv = 0.0,
        Iqr_lims = (-100.0, 100.0),
        Accel = 0.7,
        Lvpl_sw = 0,
    )
    @test converter_regca1 isa PowerSystems.DynamicComponent
    filt_current = RLFilter(rf = 0.0, lf = 0.1)
    @test filt_current isa PowerSystems.DynamicComponent
    inner_ctrl_typeB = RECurrentControlB(
        Q_Flag = 0,
        PQ_Flag = 0,
        Vdip_lim = (-99.0, 99.0),
        T_rv = 0.02,
        dbd_pnts = (-1.0, 1.0),
        K_qv = 0.0,
        Iqinj_lim = (-1.1, 1.1),
        V_ref0 = 0.0,
        K_vp = 10.0,
        K_vi = 60.0,
        T_iq = 0.02,
        I_max = 1.11,
    )
    @test inner_ctrl_typeB isa PowerSystems.DynamicComponent
    # Creates 2^5 = 32 combinations of flags for an outer control
    for (F_flag, VC_flag, R_flag, PF_flag, V_flag) in
        reverse.(Iterators.product(fill(0:1, 5)...))[:]
        P_control_typeAB = ActiveRenewableControllerAB(
            bus_control = 0,
            from_branch_control = 0,
            to_branch_control = 0,
            branch_id_control = "0",
            Freq_Flag = F_flag,
            K_pg = 1.0,
            K_ig = 0.05,
            T_p = 0.25,
            fdbd_pnts = (-1.0, 1.0),
            fe_lim = (-99.0, 99.0),
            P_lim = (0.0, 1.2),
            T_g = 0.1,
            D_dn = 0.0,
            D_up = 0.0,
            dP_lim = (-99.0, 99.0),
            P_lim_inner = (0.0, 1.2),
            T_pord = 0.02,
        )
        Q_control_typeAB = ReactiveRenewableControllerAB(
            bus_control = 0,
            from_branch_control = 0,
            to_branch_control = 0,
            branch_id_control = "0",
            VC_Flag = VC_flag,
            Ref_Flag = R_flag,
            PF_Flag = PF_flag,
            V_Flag = V_flag,
            T_fltr = 0.02,
            K_p = 18.0,
            K_i = 5.0,
            T_ft = 0.0,
            T_fv = 0.05,
            V_frz = 0.0,
            R_c = 0.0,
            X_c = 0.0,
            K_c = 0.0,
            e_lim = (-0.1, 0.1),
            dbd_pnts = (-1.0, 1.0),
            Q_lim = (-0.43, 0.43),
            T_p = 0.0,
            Q_lim_inner = (-0.44, 0.44),
            V_lim = (0.9, 1.05),
            K_qp = 0.0,
            K_qi = 0.01,
        )
        @test P_control_typeAB isa PowerSystems.DeviceParameter
        @test Q_control_typeAB isa PowerSystems.DeviceParameter
        outer_control_typeAB = OuterControl(P_control_typeAB, Q_control_typeAB)
        @test outer_control_typeAB isa PowerSystems.DynamicComponent
        test_accessors(outer_control_typeAB)
    end
end
