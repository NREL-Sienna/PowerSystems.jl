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

    @test PowerSystems.get_bustype(bus) == ACBusTypes.REF
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

@testset "TwoTerminalVSCLine remote-control / rated-DC-voltage fields" begin
    # Defaults come from the `::Nothing` demo constructor.
    default_vsc = TwoTerminalVSCLine(nothing)
    @test get_rated_dc_voltage(default_vsc) == 0.0
    @test isnothing(get_remote_bus_control_from(default_vsc))
    @test isnothing(get_remote_bus_control_to(default_vsc))
    @test get_rmpct_from(default_vsc) == 100.0
    @test get_rmpct_to(default_vsc) == 100.0

    arc = Arc(ACBus(nothing), ACBus(nothing))
    vsc = TwoTerminalVSCLine(;
        name = "vsc",
        available = true,
        arc = arc,
        active_power_flow = 0.1,
        rating = 2.0,
        active_power_limits_from = (min = -2.0, max = 2.0),
        active_power_limits_to = (min = -2.0, max = 2.0),
        rated_dc_voltage = 320.0,
        remote_bus_control_from = 7,
        remote_bus_control_to = 9,
        rmpct_from = 75.0,
        rmpct_to = 50.0,
    )
    @test get_rated_dc_voltage(vsc) == 320.0
    @test get_remote_bus_control_from(vsc) == 7
    @test get_remote_bus_control_to(vsc) == 9
    @test get_rmpct_from(vsc) == 75.0
    @test get_rmpct_to(vsc) == 50.0

    set_rated_dc_voltage!(vsc, 500.0)
    set_remote_bus_control_from!(vsc, 11)
    set_remote_bus_control_to!(vsc, 13)
    set_rmpct_from!(vsc, 60.0)
    set_rmpct_to!(vsc, 40.0)
    @test get_rated_dc_voltage(vsc) == 500.0
    @test get_remote_bus_control_from(vsc) == 11
    @test get_remote_bus_control_to(vsc) == 13
    @test get_rmpct_from(vsc) == 60.0
    @test get_rmpct_to(vsc) == 40.0
end

@testset "InterconnectingConverter VSC remote-control / voltage-limit fields" begin
    default_ic = InterconnectingConverter(nothing)
    @test isnothing(get_remote_bus_control(default_ic))
    @test get_rmpct(default_ic) == 100.0

    ic = InterconnectingConverter(;
        name = "ipc",
        available = true,
        bus = ACBus(nothing),
        dc_bus = DCBus(nothing),
        active_power = 0.0,
        rating = 1.0,
        active_power_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
        remote_bus_control = 5,
        rmpct = 75.0,
        power_factor_weighting_fraction = 0.25,
        voltage_limits = (min = 0.9, max = 1.1),
    )
    @test get_remote_bus_control(ic) == 5
    @test get_rmpct(ic) == 75.0
    @test get_power_factor_weighting_fraction(ic) == 0.25
    @test get_voltage_limits(ic) == (min = 0.9, max = 1.1)

    set_remote_bus_control!(ic, 8)
    set_rmpct!(ic, 55.0)
    set_power_factor_weighting_fraction!(ic, 0.75)
    set_voltage_limits!(ic, (min = 0.95, max = 1.05))
    @test get_remote_bus_control(ic) == 8
    @test get_rmpct(ic) == 55.0
    @test get_power_factor_weighting_fraction(ic) == 0.75
    @test get_voltage_limits(ic) == (min = 0.95, max = 1.05)

    # remote_bus_control is a bus number: nothing regulates the own bus, any set value must be > 0.
    sys = System(100.0; runchecks = false)
    bad_ic = InterconnectingConverter(;
        name = "bad_ic",
        available = true,
        bus = ACBus(nothing),
        dc_bus = DCBus(nothing),
        active_power = 0.0,
        rating = 1.0,
        active_power_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
        remote_bus_control = 0,
    )
    @test_logs (:error, "Invalid range") match_mode = :any @test_throws IS.InvalidValue PowerSystems.check_component(
        sys,
        bad_ic,
    )
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
