const LOSS_CURVE_FIELDS = [
    (TwoTerminalGenericHVDCLine, get_loss, set_loss!),
    (TwoTerminalLCCLine, get_loss, set_loss!),
    (InterconnectingConverter, get_loss_function, set_loss_function!),
]

@testset "Loss curve field types" begin
    for T in (TwoTerminalGenericHVDCLine, TwoTerminalLCCLine)
        @test fieldtype(T, :loss) ==
              Union{LossCurve{LinearCurve}, LossCurve{PiecewiseIncrementalCurve}}
    end
    @test fieldtype(InterconnectingConverter, :loss_function) ==
          Union{LossCurve{LinearCurve}, LossCurve{QuadraticCurve}}
    for field in (:converter_loss_from, :converter_loss_to)
        @test fieldtype(TwoTerminalVSCLine, field) ==
              Union{LossCurve{LinearCurve}, LossCurve{QuadraticCurve}}
    end
end

@testset "Loss curve fields default to a LossCurve in natural units" begin
    for (T, getter, _) in LOSS_CURVE_FIELDS
        curve = getter(T(nothing))
        @test get_power_units(curve) == IS.NaturalUnit()
        @test get_value_curve(curve) == LinearCurve(0.0)
    end

    vsc = TwoTerminalVSCLine(nothing)
    for curve in (get_converter_loss_from(vsc), get_converter_loss_to(vsc))
        @test get_power_units(curve) == IS.NaturalUnit()
    end
end

@testset "Loss curves round-trip their unit system through the accessors" begin
    for (T, getter, setter) in LOSS_CURVE_FIELDS
        device = T(nothing)
        for U in (IS.NaturalUnit(), IS.SystemBaseUnit(), IS.DeviceBaseUnit())
            setter(device, LossCurve(LinearCurve(0.02, 1.5), U))
            @test get_power_units(getter(device)) == U
            @test get_value_curve(getter(device)) == LinearCurve(0.02, 1.5)
        end
    end
end

@testset "Loss curves survive serialization with their unit system" begin
    loss = LossCurve(QuadraticCurve(0.001, 0.02, 0.0), IS.SystemBaseUnit())

    sys = System(100.0)
    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    bus.bustype = ACBusTypes.REF  # This prevents an error log message
    add_component!(sys, bus)
    dc_bus = DCBus(nothing)
    dc_bus.name = "dc_bus1"
    dc_bus.number = 2
    add_component!(sys, dc_bus)

    converter = InterconnectingConverter(nothing)
    converter.name = "converter1"
    converter.bus = bus
    converter.dc_bus = dc_bus
    set_loss_function!(converter, loss)
    add_component!(sys, converter)

    sys2 = from_json(to_json(sys), System)
    round_tripped = get_component(InterconnectingConverter, sys2, "converter1")
    @test get_loss_function(round_tripped) == loss
    @test get_power_units(get_loss_function(round_tripped)) == IS.SystemBaseUnit()
end
