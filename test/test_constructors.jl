@testset "Bus Constructors" begin
    tBus = ACBus(nothing)
    tLoadZone = LoadZone(nothing)

    bus = ACBus(
        1,
        "test",
        true,
        ACBusTypes.SLACK,
        0.0,
        0.0,
        (min = 0.0, max = 0.0),
        nothing,
        nothing,
        nothing,
    )

    # SLACK is preserved as an explicit area-slack marker; no longer collapsed to REF.
    @test PowerSystems.get_bustype(bus) == ACBusTypes.SLACK
end

@testset "Generation Constructors" begin
    for T in InteractiveUtils.subtypes(PSY.OperationalCost)
        isabstracttype(T) || (@test T(nothing) isa IS.InfrastructureSystemsType)
    end
    # TODO add concrete subtypes of ProductionVariableCostCurve?

    tThermalGen = ThermalStandard(nothing)
    @test tThermalGen isa PowerSystems.Component
    tHydroDispatch = HydroDispatch(nothing)
    @test tHydroDispatch isa PowerSystems.Component
    tRenewableNonDispatch = RenewableNonDispatch(nothing)
    @test tRenewableNonDispatch isa PowerSystems.Component
    tRenewableDispatch = RenewableDispatch(nothing)
    @test tRenewableDispatch isa PowerSystems.Component
    tRenewableDispatch = RenewableDispatch(nothing)
    @test tRenewableDispatch isa PowerSystems.Component
    tTurbine = HydroTurbine(nothing)
    @test tTurbine isa PowerSystems.Component
    tReservoir = HydroReservoir(nothing)
    @test tReservoir isa PowerSystems.Component
end

@testset "Source Constructors" begin
    tSource = Source(nothing)
    @test tSource isa PowerSystems.Component
end

@testset "Storage Constructors" begin
    tStorage = EnergyReservoirStorage(nothing)
    @test tStorage isa PowerSystems.Component
end

@testset "Load Constructors" begin
    tPowerLoad = PowerLoad(nothing)
    @test tPowerLoad isa PowerSystems.Component
    tStandardLoad = StandardLoad(nothing)
    @test tStandardLoad isa PowerSystems.Component
    tPowerLoad = PowerLoad("init", true, ACBus(nothing), 0.0, 0.0, 100.0, 0.0, 0.0)
    @test tPowerLoad isa PowerSystems.Component
    tLoad = InterruptiblePowerLoad(nothing)
    @test tLoad isa PowerSystems.Component
    tShiftableLoad = ShiftablePowerLoad(nothing)
    @test tShiftableLoad isa PowerSystems.Component
    tInterruptibleStandardLoad = InterruptibleStandardLoad(nothing)
    @test tInterruptibleStandardLoad isa PowerSystems.Component
end

@testset "Branch Constructors" begin
    tLine = Line(nothing)
    @test tLine isa PowerSystems.Component
    tMonitoredLine = MonitoredLine(nothing)
    @test tMonitoredLine isa PowerSystems.Component
    tTwoTerminalGenericHVDCLine = TwoTerminalGenericHVDCLine(nothing)
    @test tTwoTerminalGenericHVDCLine isa PowerSystems.Component
    tTwoTerminalLCCLine = TwoTerminalLCCLine(nothing)
    @test tTwoTerminalLCCLine isa PowerSystems.Component
    tTwoTerminalVSCLine = TwoTerminalVSCLine(nothing)
    @test tTwoTerminalVSCLine isa PowerSystems.Component
    tTransformer2W = Transformer2W(nothing)
    @test tTransformer2W isa PowerSystems.Component
    tTapTransformer = TapTransformer(nothing)
    @test tTapTransformer isa PowerSystems.Component
    tPhaseShiftingTransformer = PhaseShiftingTransformer(nothing)
    @test tPhaseShiftingTransformer isa PowerSystems.Component
    tTransformer3W = Transformer3W(nothing)
    @test tTransformer3W isa PowerSystems.Component
    tPhaseShiftingTransformer3W = PhaseShiftingTransformer3W(nothing)
    @test tPhaseShiftingTransformer3W isa PowerSystems.Component
    tGenericArcImpedance = GenericArcImpedance(nothing)
    @test tGenericArcImpedance isa PowerSystems.Component
end

@testset "Service Constructors" begin
    tConstantReserve = ConstantReserve{ReserveUp}(nothing)
    @test tConstantReserve isa PowerSystems.Service
    tVariableReserve = VariableReserve{ReserveDown}(nothing)
    @test tVariableReserve isa PowerSystems.Service
end

@testset "TimeSeriesData Constructors" begin
    tg = RenewableNonDispatch(nothing)
    data = PowerSystems.TimeSeries.TimeArray(
        [DateTime("01-01-01"), DateTime("01-01-01") + Hour(1)],
        [1.0, 1.0],
    )
    #SingleTimeSeries Tests
    ts = SingleTimeSeries("scalingfactor", Hour(1), DateTime("01-01-01"), 24)
    @test ts isa PowerSystems.TimeSeriesData
    ts = SingleTimeSeries(; name = "scalingfactor", data = data)
    @test ts isa PowerSystems.TimeSeriesData

    #Probabilistic Tests
    data = SortedDict(
        DateTime("01-01-01") => [1.0 1.0; 2.0 2.0],
        DateTime("01-01-01") + Hour(1) => [1.0 1.0; 2.0 2.0],
    )
    ts = Probabilistic("scalingfactor", data, [0.5, 0.5], Hour(1))
    @test ts isa PowerSystems.TimeSeriesData
    ts = Probabilistic(;
        name = "scalingfactor",
        percentiles = [1.0, 1.0],
        data = data,
        resolution = Hour(1),
    )
    @test ts isa PowerSystems.TimeSeriesData
    ##Scenario Tests
    ts = Scenarios("scalingfactor", data, Hour(1))
    @test ts isa PowerSystems.TimeSeriesData
end

@testset "Test VSC control mode enum values match the legacy Bool semantics" begin
    # A `Bool` in these fields resolves through IS's generic `convert(::Type{T}, ::Integer)`,
    # so the voltage-controlling mode must stay at 1 and its counterpart at 0. Reordering
    # either enum silently inverts every legacy value.
    @test convert(VSCDCControlModes, false) == VSCDCControlModes.DC_POWER
    @test convert(VSCDCControlModes, true) == VSCDCControlModes.DC_VOLTAGE
    @test convert(VSCACControlModes, false) == VSCACControlModes.AC_REACTIVE_POWER
    @test convert(VSCACControlModes, true) == VSCACControlModes.AC_VOLTAGE
end

@testset "Test TwoTerminalVSCLine construction with Bool control modes" begin
    bus_from = ACBus(1, "bus_from", true, ACBusTypes.REF, 0.0, 1.0,
        (min = 0.9, max = 1.1), 230.0)
    bus_to = ACBus(2, "bus_to", true, ACBusTypes.PV, 0.0, 1.0,
        (min = 0.9, max = 1.1), 230.0)
    vsc = TwoTerminalVSCLine(;
        name = "vsc",
        available = true,
        arc = Arc(bus_from, bus_to),
        active_power_flow = 0.0,
        rating = 2.0,
        active_power_limits_from = (min = -2.0, max = 2.0),
        active_power_limits_to = (min = -2.0, max = 2.0),
        dc_control_from = true,
        ac_control_from = false,
        dc_control_to = false,
        ac_control_to = true,
    )
    @test get_dc_control_from(vsc) == VSCDCControlModes.DC_VOLTAGE
    @test get_ac_control_from(vsc) == VSCACControlModes.AC_REACTIVE_POWER
    @test get_dc_control_to(vsc) == VSCDCControlModes.DC_POWER
    @test get_ac_control_to(vsc) == VSCACControlModes.AC_VOLTAGE

    set_dc_control_from!(vsc, false)
    set_ac_control_to!(vsc, false)
    @test get_dc_control_from(vsc) == VSCDCControlModes.DC_POWER
    @test get_ac_control_to(vsc) == VSCACControlModes.AC_REACTIVE_POWER
end
