# [Building a System from CSV Files](@id system_from_csv)

### Dependencies

```julia
using PowerSystems
using CSV
using DataFrames
```

### Build the base of the system with appropriate base power.

Begin by building the base system using the base power.

### Read in all component data

Read in the CSV files that contain the data for building the system. In this
example, the line, bus, and generator data are found in the following CSV files.

The generator data is stored in the `gen_params` dataframe. Create dataframes characterized by the generator type Thermal
generators, hydro generators and renewable generators are different types of
components, and therefore built differently.

### Build the buses - parsing data from `bus_params`

The first building block are the buses in the system. We can define variables
describing the buses using columns found in the `bus_params.csv` file.

We can build the buses using the [`ACBus`](@ref) function.

### Build the lines and transformers - parsing data from `line_params`

The next step is to build the lines and transformers in the system which are
both stored in the `line_params` dataframe. A branch is a [`Line`](@ref) if the buses
being connected have the same base voltage, and a [`Transformer2W`](@ref) if they have
different base voltages.

Begin by defining variables describing the lines/transformers using the columns
found in the `line_params` dataframe.

Build the lines and transformers using the [`Line`](@ref) and [`Transformer2W`](@ref) functions.

### Establishing resolution of time series

The following time series are hourly resolution for the year 2023, plus one day
into the following year for a total of 366 days. The following steps show how
to read in and add time series data to renewable and hydro generators, and
powerloads.

Begin by defining the resolution and the first time step.

### Reading in Solar Time Series

Read in the time series data for the solar generators, normalize the data, and create a [`SingleTimeSeriesArray`](@ref) component.

### Reading in Wind Time Series

Read in the time series data for the wind generators, normalize the data, and create a [`SingleTimeSeriesArray`](@ref) component.

### Reading in Hydro Time Series

Read in the time series data for the hydro generators, normalize the data, and create a [`SingleTimeSeriesArray`](@ref) component.

# Building `PowerLoad` Components and Reading in Their Time Series

In this case loads are sorted into three regions. But before building the loads
we first must define their time series, adding each region's time series into
a vector to be later indexed into.

Next, add the loads to the system using the [`PowerLoad`](@ref) function according to their regions.
Read in the load data and vectors to sort the loads by regions:

Create a file directory, and create variables describing the column names that will be used to build the loads.

Build the loads using the [`PowerLoad`](@ref) function, and sort them into the vectors.

Construct a vector containing the loads, and use the
[`bulk_add_time_series!`](@ref) function to attach the respective loads' time
series to every load in a region at once.

# Building Generator Components

As established at the beginning of the How-To, we have four dataframes
containing the four types of generation. Build the generators by parsing data
from `gen_params`. Define variables describing the generators using columns
found in `thermal_gens`, `hydro_gens`, `solar_gens`, and `wind_gens`.

## Building Thermal Generators

Build the thermal generator components using the [`ThermalStandard`](@ref) function and data stored in the
`thermal_gens` dataframe.

# Build solar generators - parsing data from the `solar_gens` data frame

Build the solar generators and
wind generators using the [`RenewableDispatch`](@ref) function, and attach the respective time series.

### Build wind generators - parsing data from the `wind_gens` data frame

### Build hydro generators - parsing data from the `hydro_gens` data frame

Build the hydro generators using the [`HydroDispatch`](@ref) function and attach the respective time series.

# Building `RenewableGenerationCost`, `HydroGenerationCost` and `ThermalGenerationCost` functions

Build and attach the respective cost function to the
generators. The cost function data can be found in the respective generator
data frames.

### `RenewableGenerationCost`

For the renewable generators assume zero marginal cost by using [`zero(CostCurve)`](@ref). Use the [`set_operation_cost!`](@ref) function to attach the [`RenewableGenerationCost`](@ref) to the respective generators.

For more information regarding renewable cost function please reference [`RenewableGenerationCost`](@ref).

### `HydroGenerationCost`

Hydro generation costs are defined by a fixed and variable cost. In this
example assume both are zero. Use the [`LinearCurve`](@ref) and [`CostCurve`](@ref) function to describe the variable cost.

For more information regarding hydro cost functions please reference
[`HydroGenerationCost`](@ref).

### `ThermalGenerationCost`

Thermal generator cost is defined by [`FuelCuve`](@ref). Import and parse the CSV that describes fuel costs.

Create a dictionary of fuel types and costs.

Assign a fuel type and price to the generators based on their name.

### Parse heat rates, load points and heat rate bases.

Heat rates, load points, and heat rate bases are used to construct [`LinearCurve`](@ref) and
[`PiecewiseIncrementalCurve`](@ref) that describe the operational cost of the thermal units.

Use the heat rate bases, heat rates, load points and fuel costs to
construct the thermal generation cost functions using the [`FuelCurve`](@ref) and [`PiecewiseIncrementalCurve`](@ref) functions.

For more information regarding thermal cost functions please visit
[`ThermalGenerationCost`](@ref).
