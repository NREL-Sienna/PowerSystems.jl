# PowerSystems Cost Functions

PowerSystems.jl provides an extensive type hierarchy to explicitly express relationships between power production and cost. This lets the modeler represent cost functions as linear, quadratic, or piecewise input-output curves, potentially piecewise marginal heat rates, average heat rates, and more, as best fits the input data.

To represent a cost for a particular [`Component`](@ref), the modeler first chooses one of the variable cost representations in the table below. Then, they wrap this [`ProductionVariableCost`](@ref) in either a [`CostCurve`](@ref) to indicate a cost in currency or in a [`FuelCurve`](@ref) to indicate a cost per unit of fuel plus a fuel cost. Finally, the user creates a domain-specific [`OperationalCost`](@ref) that contains this variable cost as well as other costs that may exist in that domain, such as a fixed cost that is always incurred when the unit is on. For instance, we may have `RenewableGenerationCost(CostCurve(TODO), 0.0)` to represent the cost of a renewable unit that produces at TODO, or `ThermalGenerationCost(; variable = FuelCurve(TODO), fixed = TODO, start_up = TODO, shut_down = TODO)` to represent the cost of a thermal unit that produces at TODO. Below, we give the options for `ProductionVariableCost`s. Information on what domain-specific cost must be provided for a given component type can be found in that component type's documentation.

## Variable Cost Representations
For more details, see the documentation page for each type.
| Type alias | Description | Constructor parameters | Example |
| --- | --- | --- | --- |
| `LinearCurve` | Linear input-output curve with zero no-load cost (constant average rate) | Average/marginal rate | `LinearCurve(3.0)` |
| `LinearCurve` | Linear input-output curve with nonzero no-load cost (constant marginal rate) | Marginal rate, cost at zero production | `LinearCurve(3.0, 5.0)` |
| `QuadraticCurve` | Quadratic input-output curve, may have nonzero no-load cost | Quadratic, proportional, and constant terms of input-output curve | `QuadraticCurve(1.0, 1.0, 18.0)` |
| `PiecewisePointCurve` | Piecewise linear curve specified by cost values at production points | Vector of (production, cost) pairs | `PiecewisePointCurve([(1.0, 20.), (2.0, 24.0), (3.0, 30.0)])` |
| `PiecewiseSlopeCurve` | Piecewise linear curve specified by marginal rates (slopes) between production points, may have nonzero initial value | Cost at minimum production point, vector of $n$ production points, vector of $n-1$ marginal rates/slopes of the curve segments between the points | `PiecewiseSlopeCurve(20., [1.0, 2.0, 3.0], [4.0, 6.0])` |
| `PiecewiseAverageCurve` | Piecewise linear curve specified by average rates between production points, may have nonzero initial value | Cost at minimum production point, vector of $n$ production points, vector of average rates at the $n-1$ latter points | `PiecewiseAverageCurve(20., [1.0, 2.0, 3.0], [12.0, 10.0])` |

