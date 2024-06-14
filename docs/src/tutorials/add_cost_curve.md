# Adding an Operating Cost

This how-to guide covers the steps to select and add an operating cost to a component,
such as a generator, load, or energy storage system.

```@setup costcurve
using PowerSystems #hide
```

To begin, the user must make 2 or 3 decisions before defining the operating cost:
1. Select an appropriate [`OperationalCost`](@ref) from the [Operating Costs](@ref cost_library)
    options. In general, each operating cost has parameters to define fixed and variable costs.
    To be able to define an `OperationalCost`, you must first select a curve to represent the
    variable cost(s).
    1. If you selected [`ThermalGenerationCost`](@ref) or [`HydroGenerationCost`](@ref),
        select either a [`FuelCurve`](@ref) or [`CostCurve`](@ref) to represent the variable
        cost, based on the units of the generator's data.
        - If you have data in terms of heat rate or water flow, use [`FuelCurve`](@ref).
        - If you have data in units of currency, such as \$/MWh, use [`CostCurve`](@ref).
    If you selected another `OperationalCost` type, the variable cost is represented
        as a `CostCurve`.
2. Select a [`ValueCurve`](@ref) to represent the variable cost data by comparing the format
    of your variable cost data to the [Variable Cost Representations table](@ref curve_table)
    and the [`ValueCurve`](@ref value_curve_library) options.

Then, the user defines the cost by working backwards:
  1. Define the variable cost's `ValueCurve`
  2. Use the `ValueCurve` to define the selected `CostCurve` or `FuelCurve`
  3. Use the `CostCurve` or `FuelCurve` to define the `OperationalCost`

Let's look at a few examples. 

## Example 1: A Renewable Generator

We have a renewable unit that produces at \$22/MWh. 

Following the decision steps above:
1. We select [`RenewableGenerationCost`](@ref) to represent this renewable generator.
2. We select a [`LinearCurve`](@ref) to represent the \$22/MWh variable cost.

Following the implementation steps, we define `RenewableGenerationCost` by nesting the
definitions:
```@repl costcurve
RenewableGenerationCost(variable = CostCurve(value_curve = LinearCurve(22.0)))
```

!!! tip
    Note that most of these operational costs and value curves have keyword based
    constructors using [@kwdef](https://docs.julialang.org/en/v1.9-dev/base/base/#Base.@kwdef),
    so you only need to populate the data that you have. In this case, we ignore the
    `curtailment_cost` parameter for [`RenewableGenerationCost`](@ref).

## Example 2: A Thermal Generator

We have a thermal generating unit that has a heat rate of 7 GJ/MWh at 100 MW and 9 GJ/MWh at
200 MW, plus a fixed cost of \$6.0/hr, a start-up cost of \$2000, and a shut-down cost of
\$1000. Its fuel cost is \$20/GJ.

Following the decision steps above:
1. We select [`ThermalGenerationCost`](@ref) to represent this thermal generator.
2. We select [`FuelCurve`](@ref) because we have consumption in units of fuel (GJ/MWh)
    instead of currency.
3. We select a [`PiecewisePointCurve`](@ref) to represent the piecewise linear heat rate
    curve.

This time, we'll define each step individually, beginning with the heat rate curve:
```@repl costcurve
heat_rate_curve = PiecewisePointCurve([(100.0, 7.0), (200.0, 9.0)])
fuel_curve = FuelCurve(value_curve = heat_rate_curve, fuel_cost = 20.0)
cost = ThermalGenerationCost(variable = fuel_curve, fixed = 6.0, start_up = 2000.0, shut_down = 1000.0)
```
This `OperationalCost` can be used when defining a component or added to an existing component using
`set_operation_cost!`.