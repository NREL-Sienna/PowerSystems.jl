# [Variable Costs](@id curve_table)
Operating cost data typically includes both fixed and variable costs. See the how-to on [Adding an Operating Cost](@ref cost_how_to) for a demonstration of defining an operating cost.

In PowerSystems.jl, the *variable* portion of the operating cost can be represented as linear, quadratic, or piecewise input-output curves, potentially piecewise marginal heat rates, average heat rates, and more, as best fits the input data. 

This table shows each variable cost [`ValueCurve`](@ref) with an example. Each `ValueCurve` makes no assumption about units. The "Example interpretation" shown here, with currency units, assumes that the variable cost `ValueCurve` will be input to a [`CostCurve`](@ref). Note that all three `Piecewise` options here fundamentally represent the same curve.

| Type alias | Description | Constructor parameters | Example | Example interpretation |
| :--- | :--- | :--- | :--- | :--- |
| [`LinearCurve`](@ref) | Linear input-output curve with zero no-load cost (constant average rate) | Average/marginal rate | `LinearCurve(3.0)` | \$3/MWh |
| [`LinearCurve`](@ref) | Linear input-output curve with nonzero no-load cost (constant marginal rate) | Marginal rate, cost at zero production | `LinearCurve(3.0, 5.0)` | \$3/MWh + \$5/hr
| [`QuadraticCurve`](@ref) | Quadratic input-output curve, may have nonzero no-load cost | Quadratic, proportional, and constant terms of input-output curve | `QuadraticCurve(1.0, 1.0, 18.0)` | $C(P) = 1 P^2 + 1 P + 18$ where $C$ is \$/hr, $P$ is MW
| [`PiecewisePointCurve`](@ref) | Piecewise linear curve specified by cost values at production points | Vector of (production, cost) pairs | `PiecewisePointCurve([(1.0, 20.0), (2.0, 24.0), (3.0, 30.0)])` | \$20/hr @ 1 MW, \$24/hr @ 2 MW, \$30/hr @ 3 MW, linear  \$/hr interpolation between these points
| [`PiecewiseIncrementalCurve`](@ref) | Piecewise linear curve specified by marginal rates (slopes) between production points, may have nonzero initial value | Cost at minimum production point, vector of $n$ production points, vector of $n-1$ marginal rates/slopes of the curve segments between the points | `PiecewiseIncrementalCurve(20., [1.0, 2.0, 3.0], [4.0, 6.0])` | \$20/hr @ 1 MW plus additional \$4/MWh from 1 MW to 2 MW plus additional \$6/MWh from 2 MW to 3 MW
| [`PiecewiseAverageCurve`](@ref) | Piecewise linear curve specified by average rates between production points, may have nonzero initial value | Cost at minimum production point, vector of $n$ production points, vector of average rates at the $n-1$ latter points | `PiecewiseAverageCurve(20., [1.0, 2.0, 3.0], [12.0, 10.0])` | \$20/hr @ 1 MW, \$12/MWh @ 2 MW, \$10/MWh @ 3 MW, linear  \$/hr interpolation between these points
