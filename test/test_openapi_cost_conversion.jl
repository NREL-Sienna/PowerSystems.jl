# Cost/curve shapes constructed directly from PowerCoreOpenAPIModels kwargs (PC = PSY.PC),
# matching what PowerTableDataParser's `src/openapi/cost.jl` and `.../generation.jl` emit.

_po_linear_io(prop, const_) = PSY.PC.InputOutputCurve(;
    function_data = PSY.PC.InputOutputCurveFunctionData(
        PSY.PC.LinearFunctionData(; proportional_term = prop, constant_term = const_),
    ),
)

_po_cost_curve(; power_units = "NATURAL_UNITS", vom_cost = nothing) = PSY.PC.CostCurve(;
    power_units = power_units,
    value_curve = PSY.PC.ValueCurve(_po_linear_io(10.0, 5.0)),
    vom_cost = vom_cost,
)

@testset "convert_cost: FunctionData variants" begin
    @test PSY.convert_cost(
        PSY.PC.LinearFunctionData(; proportional_term = 2.0, constant_term = 3.0),
    ) == LinearFunctionData(2.0, 3.0)

    @test PSY.convert_cost(
        PSY.PC.QuadraticFunctionData(;
            quadratic_term = 1.0,
            proportional_term = 2.0,
            constant_term = 3.0,
        ),
    ) == QuadraticFunctionData(1.0, 2.0, 3.0)

    @test PSY.convert_cost(
        PSY.PC.PiecewiseLinearData(;
            points = [
                PSY.PC.XYCoords(; x = 0.0, y = 0.0),
                PSY.PC.XYCoords(; x = 10.0, y = 100.0),
            ],
        ),
    ) == PiecewiseLinearData([(x = 0.0, y = 0.0), (x = 10.0, y = 100.0)])

    @test PSY.convert_cost(
        PSY.PC.PiecewiseStepData(; x_coords = [0.0, 10.0, 20.0], y_coords = [5.0, 6.0]),
    ) == PiecewiseStepData([0.0, 10.0, 20.0], [5.0, 6.0])

    @test_throws ErrorException PSY.convert_cost(nothing)
end

@testset "convert_cost: ValueCurve variants" begin
    io = PSY.convert_cost(_po_linear_io(10.0, 5.0))
    @test io == InputOutputCurve(LinearFunctionData(10.0, 5.0))

    inc = PSY.convert_cost(
        PSY.PC.IncrementalCurve(;
            function_data = PSY.PC.IncrementalCurveFunctionData(
                PSY.PC.PiecewiseStepData(; x_coords = [0.0, 10.0], y_coords = [5.0]),
            ),
            initial_input = 50.0,
        ),
    )
    @test inc == IncrementalCurve(PiecewiseStepData([0.0, 10.0], [5.0]), 50.0)

    avg = PSY.convert_cost(
        PSY.PC.AverageRateCurve(;
            function_data = PSY.PC.IncrementalCurveFunctionData(
                PSY.PC.LinearFunctionData(; proportional_term = 1.0, constant_term = 0.0),
            ),
            initial_input = 20.0,
        ),
    )
    @test avg == AverageRateCurve(LinearFunctionData(1.0, 0.0), 20.0)
end

@testset "convert_cost: power_units marker mapping" begin
    # The wire enum is DEVICE_BASE/NATURAL_UNITS only — there is no system-base member.
    for (str, marker) in (
        ("NATURAL_UNITS", NaturalUnit()),
        ("DEVICE_BASE", DeviceBaseUnit()),
    )
        curve = PSY.convert_cost(_po_cost_curve(; power_units = str))
        @test get_power_units(curve) == marker
        @test PSY._power_units_to_string(marker, curve) == str
    end
    # Tested directly against the marker helper: PC.CostCurve's own OpenAPI-generated
    # enum validator would reject "BOGUS"/"SYSTEM_BASE" at construction time, before
    # convert_cost ever runs.
    @test_throws ErrorException PSY._power_units_marker("BOGUS")
    @test_throws ErrorException PSY._power_units_marker("SYSTEM_BASE")
    @test_throws ErrorException PSY._power_units_marker(nothing)

    # A SystemBaseUnit curve has no valid wire value and no reachable base_power to
    # rescale against, so export errors rather than silently relabelling it DEVICE_BASE.
    sb_curve = CostCurve(LinearCurve(10.0, 5.0), SystemBaseUnit())
    @test_throws ErrorException PSY.convert_cost_to_openapi(sb_curve)
end

@testset "convert_cost: CostCurve and FuelCurve" begin
    cc = PSY.convert_cost(_po_cost_curve())
    @test cc isa CostCurve{LinearCurve, NaturalUnit}
    @test get_function_data(get_value_curve(cc)) == LinearFunctionData(10.0, 5.0)
    @test get_vom_cost(cc) == LinearCurve(0.0)

    cc_with_vom = PSY.convert_cost(_po_cost_curve(; vom_cost = _po_linear_io(2.0, 0.0)))
    @test get_vom_cost(cc_with_vom) == LinearCurve(2.0, 0.0)

    fc = PSY.convert_cost(
        PSY.PC.FuelCurve(;
            power_units = "NATURAL_UNITS",
            value_curve = PSY.PC.ValueCurve(
                PSY.PC.IncrementalCurve(;
                    function_data = PSY.PC.IncrementalCurveFunctionData(
                        PSY.PC.PiecewiseStepData(;
                            x_coords = [0.0, 10.0, 20.0],
                            y_coords = [5.0, 6.0],
                        ),
                    ),
                    initial_input = 50.0,
                ),
            ),
            fuel_cost = 3.5,
        ),
    )
    @test fc isa FuelCurve
    @test get_fuel_cost(fc) == 3.5
    @test get_vom_cost(fc) == LinearCurve(0.0)
end

@testset "convert_cost: vom_cost must be LINEAR" begin
    bad = _po_cost_curve(;
        vom_cost = PSY.PC.InputOutputCurve(;
            function_data = PSY.PC.InputOutputCurveFunctionData(
                PSY.PC.QuadraticFunctionData(;
                    quadratic_term = 1.0,
                    proportional_term = 1.0,
                    constant_term = 1.0,
                ),
            ),
        ),
    )
    @test_throws ErrorException PSY.convert_cost(bad)
end

@testset "convert_cost: ThermalGenerationCost" begin
    po = PSY.PC.ThermalGenerationCost(;
        fixed = 100.0,
        shut_down = 50.0,
        start_up = 200.0,
        variable = PSY.PC.ProductionVariableCostCurve(_po_cost_curve()),
    )
    cost = PSY.convert_cost(po)
    @test cost isa ThermalGenerationCost
    @test get_fixed(cost) == 100.0
    @test get_shut_down(cost) == 50.0
    @test get_start_up(cost) == 200.0
    @test get_function_data(get_value_curve(get_variable(cost))) ==
          LinearFunctionData(10.0, 5.0)

    po_stages = PSY.PC.ThermalGenerationCost(;
        fixed = 0.0,
        shut_down = 0.0,
        start_up = PSY.PC.ThermalGenerationCostStartUp(
            PSY.PC.StartUpStages(; hot = 1.0, warm = 2.0, cold = 3.0),
        ),
        variable = PSY.PC.ProductionVariableCostCurve(_po_cost_curve()),
    )
    cost_stages = PSY.convert_cost(po_stages)
    @test get_start_up(cost_stages) == (hot = 1.0, warm = 2.0, cold = 3.0)

    po_missing_variable = PSY.PC.ThermalGenerationCost(;
        fixed = 0.0,
        shut_down = 0.0,
        start_up = 0.0,
        variable = nothing,
    )
    @test_throws ErrorException PSY.convert_cost(po_missing_variable)
end

@testset "convert_cost: RenewableGenerationCost" begin
    po = PSY.PC.RenewableGenerationCost(; variable = _po_cost_curve(), fixed = 10.0)
    cost = PSY.convert_cost(po)
    @test cost isa RenewableGenerationCost
    @test get_fixed(cost) == 10.0
    @test get_curtailment_cost(cost) == zero(CostCurve)
    @test get_function_data(get_value_curve(get_variable(cost))) ==
          LinearFunctionData(10.0, 5.0)
end

@testset "convert_cost: HydroGenerationCost" begin
    po = PSY.PC.HydroGenerationCost(;
        fixed = 1.0,
        variable = PSY.PC.ProductionVariableCostCurve(_po_cost_curve()),
    )
    cost = PSY.convert_cost(po)
    @test cost isa HydroGenerationCost
    @test get_fixed(cost) == 1.0
end

@testset "convert_cost: HydroReservoirCost" begin
    po = PSY.PC.HydroReservoirCost(;
        level_shortage_cost = 1.0,
        level_surplus_cost = 2.0,
        spillage_cost = 3.0,
    )
    cost = PSY.convert_cost(po)
    @test cost isa HydroReservoirCost
    @test get_level_shortage_cost(cost) == 1.0
    @test get_level_surplus_cost(cost) == 2.0
    @test get_spillage_cost(cost) == 3.0
end

@testset "convert_cost: StorageCost" begin
    po = PSY.PC.StorageCost(;
        charge_variable_cost = nothing,
        discharge_variable_cost = _po_cost_curve(),
        fixed = 5.0,
        shut_down = 0.0,
        start_up = PSY.PC.StorageCostStartUp(
            PSY.PC.StorageCostStartUpOneOf(; charge = 1.0, discharge = 2.0),
        ),
        energy_shortage_cost = 3.0,
        energy_surplus_cost = 4.0,
    )
    cost = PSY.convert_cost(po)
    @test cost isa StorageCost
    @test get_charge_variable_cost(cost) == zero(CostCurve)
    @test get_function_data(get_value_curve(get_discharge_variable_cost(cost))) ==
          LinearFunctionData(10.0, 5.0)
    @test get_start_up(cost) == (charge = 1.0, discharge = 2.0)
    @test get_energy_shortage_cost(cost) == 3.0
    @test get_energy_surplus_cost(cost) == 4.0
end

@testset "convert_reserve_variable: reserve Operating Reserve Demand Curve" begin
    @test PSY.convert_reserve_variable(nothing) === PSY.ZERO_OFFER_CURVE

    po_ordc = PSY.PC.CostCurve(;
        power_units = "NATURAL_UNITS",
        value_curve = PSY.PC.ValueCurve(
            PSY.PC.IncrementalCurve(;
                function_data = PSY.PC.IncrementalCurveFunctionData(
                    PSY.PC.PiecewiseStepData(; x_coords = [0.0, 100.0], y_coords = [10.0]),
                ),
                initial_input = 0.0,
            ),
        ),
    )
    ordc = PSY.convert_reserve_variable(po_ordc)
    @test ordc isa CostCurve{PiecewiseIncrementalCurve}

    @test_throws ErrorException PSY.convert_reserve_variable(_po_cost_curve())
end

@testset "convert_cost: fuel_cost time-series reference not implemented" begin
    @test_throws ErrorException PSY.convert_cost(
        PSY.PC.FuelCurve(;
            power_units = "NATURAL_UNITS",
            value_curve = PSY.PC.ValueCurve(_po_linear_io(1.0, 0.0)),
            fuel_cost = "some_time_series_ref",
        ),
    )
end
