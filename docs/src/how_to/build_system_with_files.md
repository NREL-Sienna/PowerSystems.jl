# [Building a System from CSV Files](@id system_from_csv)

## Prerequisites

In this example, we show how to build a [`System`](@ref), assuming you have
input data on the component specifications and time series data formatted in
CSV files. Moreover, it is assumed that the CSV files are stored in a directory
called `MyData`. These formatting expectations are more clearly specified in
the following sections of this how-to, where the components and time series are
built.

These are the depedencies needed for this how-to:

```julia
using PowerSystems
using InfrastructureSystems
const IS = InfrastructureSystems
using CSV
using DataFrames
using Dates
using TimeSeries
```

## Build the base [`System`](@ref)

```julia
system_base_power = 100.0
sys = System(system_base_power)
```

Begin by building the base [`System`](@ref) using the base power in MVA.

## Add Buses and Network Topology

The first building block of a system are the buses. In this example, we assume
that the component data for the buses are contained in a CSV file, `Buses.csv`.
Each row is an individual bus, and there is a column for each input parameter:

| Bus Number | BusType | Magnitude (p.u.) | Voltage-Max (p.u.) | Voltage-Min (p.u.) | Base Voltage (kV) | Region |
|:---------- |:------- |:---------------- |:------------------ |:------------------ |:----------------- |:------ |
| 1          | ref     | 1                | 1.06               | 0.94               | 138               | R1     |
| 2          | ref     | 1                | 1.06               | 0.94               | 138               | R1     |
| 3          | ref     | 1                | 1.06               | 0.94               | 345               | R2     |
| ...        | ...     | ...              | ...                | ...                | ...               | ...    |

Ensure your data follows this row-column format before beginning, and that your
data are in the given units. Exact data columns and column names can be
customized based on what you have available.

Read in the contents of the CSV file `Buses.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
bus_params = CSV.read("MyData/Buses.csv", DataFrame)

min_volt = "Voltage-Min (p.u.)"
max_volt = "Voltage-Max (p.u.)"
base_volt = "Base Voltage (kV)"
bus_number = "Bus Number"
region = "Region"
```

In this example, we assume that the buses are sorted into `Areas`, where
[`Area`](@ref) is an optional parameter in the [`ACBus`](@ref) constructor.
Because we will be sorting our buses into these areas as we construct the
buses, we must first attach the areas to our [`System`](@ref).

```julia
regions = unique(bus_params[:, region])

for reg in regions
    area = Area(reg)
    add_component!(sys, area)
end
```

You could similarly add [`LoadZone`](@ref)s at this point, if they are relevant
for your system.

Now, we are ready to build the buses using the [`ACBus`](@ref) constructor. If
the input data you have available in your `Buses.csv` file does not include all
the required parameters of [`ACBus`](@ref), you can hard code in the necessary
data in the `for` loop. We have done that here for `bustype`, `angle`, and
`magnitude`.

```julia
for row in eachrow(bus_params)
    bus = ACBus(;
        number = row[bus_number],
        name = "bus$(row[bus_number])",
        bustype = ACBusTypes.PQ,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = row[min_volt], max = row[max_volt]),
        base_voltage = row[base_volt],
        area = get_component(Area, sys, row[region]),
    )
    add_component!(sys, bus)
end
```

## Add Branches

The next step is to build the [`Branch`](@ref) components in the system. In this
example, we only have two branch types: a [`Line`](@ref), if the connecting buses
have the same base voltage; and a [`Transformer2W`](@ref) if they
have different base voltages. You may need to implement additional logic if you
have other branch types as well.

We assume the data for each [`Branch`](@ref) is contained in a `Branches.csv`
with the following format and in the given units that your data should follow
as well. Each row is a branch, and each column represents an input parameter.
The conventions used in `Bus from` and `Bus to` must be consistent with the
conventions used in the `Bus Number` column of `Buses.csv`.

| Branch Number | Bus from | Bus to | Reactance (p.u.) | Resistance (p.u.) | Max Flow (MW) | Min Flow (MW) |
|:------------- |:-------- |:------ |:---------------- |:----------------- |:------------- |:------------- |
| 1             | 1        | 2      | 0.0999           | 0.0303            | 600           | -600          |
| 2             | 1        | 3      | 0.0424           | 0.0129            | 600           | -600          |
| 3             | 4        | 5      | 0.00798          | 0.00176           | 1700          | -1700         |
| ...           | ...      | ...    | ...              | ...               | ...           | ...           |

Read in the contents of the CSV file `Branches.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
branch_params = CSV.read("MyData/Branches.csv", DataFrame)

branch_num = "Branch Number"
bus_from_col = "Bus from"
bus_to_col = "Bus to"
reactance = "Reactance (p.u.)"
resistance = "Resistance (p.u.)"
max_flow = "Max Flow (MW)"
```

Build the lines and transformers using the [`Line`](@ref) and
[`Transformer2W`](@ref) constructors.  Again, if you don't have all of these
parameters available in your file, customize the `for` loop to hard code
whatever parameters you are missing. For instance, the example data does not
specify `rating`, so we hard code `rating` to be the `max_flow` of the branch,
per-unitized by the `system_base_power`.

```julia
for row in eachrow(branch_params)
    bus_from = get_bus(sys, row[bus_from_col])
    bus_to = get_bus(sys, row[bus_to_col])
    if get_base_voltage(bus_to) == get_base_voltage(bus_from)
        branch = Line(;
            name = "line$(row[branch_num])",
            available = true,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(; from = bus_from, to = bus_to),
            r = row[resistance],
            x = row[reactance],
            b = (from = 0.0, to = 0.0),
            rating = row[max_flow] / system_base_power,
            angle_limits = (min = 0.0, max = 0.0),
        )
    else
        branch = Transformer2W(;
            name = "tline$(row[branch_num])",
            available = true,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(; from = bus_from, to = bus_to),
            r = row[resistance],
            x = row[reactance],
            primary_shunt = 0.0,
            rating = row[max_flow] / system_base_power,
        )
    end
    add_component!(sys, branch)
end
```

## Adding Thermal Generators and their Costs

### Build Thermal Generators

We assume the data needed to build each [`ThermalStandard`](@ref) unit is found
in a CSV file `Thermal_Gens.csv`, with a row for each generator, and columns
for the generators' input parameters. Ensure that your data are in the given
format and units. The following table is a snapshot of the first 7 columns of
an example `Thermal_Gens.csv`:

| Gen Name   | Bus | Rating (MVA) | Min Stable Level (MW) | Max Capacity (MW) | PrimeMoveType | Fuel Type    | ... |
|:---------- |:--- |:------------ |:--------------------- |:----------------- |:------------- |:------------ |:--- |
| Biomass 01 | 12  | 3            | 0.9                   | 3.0               | OT            | AG_BIPRODUCT | ... |
| Biomass 02 | 12  | 3            | 0.9                   | 3.0               | OT            | AG_BIPRODUCT | ... |
| Biomass 03 | 103 | 1.2          | 0.36                  | 1.2               | OT            | AG_BIPRODUCT | ... |
| ...        | ... | ...          | ...                   | ...               | ...           | ...          | ... |

The convention used for the contents of the `Bus` column must be consistent
with the convention used in the `Bus Number` column of `Buses.csv`.

Read in the contents of the CSV file `Thermal_Gens.csv` to a data frame and
customize the parameter names based on the column names in your CSV file.  Note
that the [`PrimeMovers`](@ref pm_list) in the `thermal_gens` data frame are
consistent with EIA Form 923, and the `Fuel Type` column data are consistent
with the [`ThermalFuels`](@ref tf_list) naming convention.

```julia
thermal_gens = CSV.read("MyData/Thermal_Gens.csv", DataFrame)

name = "Gen Name"
bus_connection = "Bus"
rate = "Rating (MVA)"
min_active_power = "Min Stable Level (MW)"
max_active_power = "Max Capacity (MW)"
ramp_up = "Max Ramp Up (MW/min)"
ramp_down = "Max Ramp Down (MW/min)"
min_up = "Min Up Time (h)"
min_down = "Min Down Time (h)"
prime_move = "PrimeMoveType"
fuel = "Fuel Type"
```

Build the thermal generator components using the [`ThermalStandard`](@ref)
constructor and data stored in the `thermal_gens` data frame, again customizing
the `for` loop to hard code any parameters you are missing. Since the example
data is missing base power, we set base power equal to the rating data, and the
rating parameter to 1.0:

```julia
for row in eachrow(thermal_gens)
    base = row[rate]
    thermal = ThermalStandard(;
        name = row[name],
        available = true,
        status = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 1.0,
        active_power_limits = (
            min = row[min_active_power] / base,
            max = row[max_active_power] / base,
        ),
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = row[ramp_up] / base, down = row[ramp_down] / base),
        operation_cost = ThermalGenerationCost(nothing),
        base_power = base,
        time_limits = (up = row[min_up], down = row[min_down]),
        prime_mover_type = IS.deserialize(PrimeMovers, row[prime_move]),
        fuel = IS.deserialize(ThermalFuels, row[fuel]),
    )
    add_component!(sys, thermal)
end
```

### Add [`ThermalGenerationCost`](@ref)

In this example the [`ThermalGenerationCost`](@ref) constructor is defined by a
[`FuelCurve`](@ref). We are also assuming that the data needed to build each
[`FuelCurve`](@ref) can be found in two separate CSV files. The first,
`Thermal_Gens.csv`, has already been defined in the previous step. The second,
`Thermal_Fuel_Rates.csv`, contains information regarding the [`FuelType`](@ref
tf_list) and its cost. The following table is a demonstrates the format of the
example `Thermal_Fuel_Rates.csv`:

| Fuel Type    | Fuel Price | CO2 rate | NOX rate | SO2 rate |
|:------------ |:---------- |:-------- |:-------- |:-------- |
| COAL         | 1.8        | 203.5    | 0.382    | 0.33     |
| NATURAL_GAS  | 5.4        | 118      | 0.079    | 0.001    |
| OIL          | 21         | 123.1    | 0.176    | 0.006    |
| AG_BIPRODUCT | 2.4        | 130      | 0.177    | 0.006    |
| GEOTHERMAL   | 0          | 0        | 0.177    | 0.006    |

Read in `Thermal_Fuel_Rates.csv`, customize parameter names based on
the column names in your CSV file, and create a dictionary pairing fuel types
and fuel prices. Ensure that the strings populating the `Fuel Type` column
match the strings populating the `Fuel Type` column of the `thermal_gens`
data frame.

```julia
fuel_params = CSV.read("MyData/Thermal_Fuels_Rates.csv", DataFrame)

type = "Fuel Type"
price = "Fuel Price"

fuel_cost_dict = Dict{ThermalFuels, Float64}()
for row in eachrow(fuel_params)
    fuel_cost_dict[IS.deserialize(ThermalFuels, row[type])] = row[price]
end
```

Next, we will create column name variables for heat rate bases, heat rates,
load points, fixed, start up, and shut down costs from the thermal_gens
data frame.  Use this data to build the [`PiecewiseIncrementalCurve`](@ref) and
the [`FuelCurve`](@ref) functions, and add them to their associated thermal
generator.

```julia
gen_name = "Generator Name"
heat_rate_base = "Heat Rate Base (MMBTU/hr)"
heat_rate = "Heat Rate (MMBTU/hr)"
load_point = "Load Point Band (MW)"
fixed_cost = "Fixed Cost (dollar)"
start_up_cost = "Start Up Cost (dollar)"
shut_down_cost = "Shut Down Cost (dollar)"

for row in eachrow(thermal_gens)
    thermal = get_component(ThermalStandard, sys, row[gen_name])
    heat_rate_curve =
        PieceWiseIncrementalCurve(row[heat_rate_base], row[load_point], row[heat_rate])
    fuel_curve =
        FuelCurve(;
            value_curve = heat_rate_curve,
            fuel_cost = fuel_cost_dict[get_fuel(thermal)],
        )
    cost_thermal = ThermalGenerationCost(;
        variable = fuel_curve,
        fixed = row[fixed_cost],
        start_up = row[start_up_cost],
        shut_down = row[shut_down_cost],
    )
    set_operation_cost!(thermal, cost_thermal)
end
```

For more information regarding thermal cost functions please visit
[`ThermalGenerationCost`](@ref).

## Adding Renewable Generators and Their Time Series

The following section demonstrates how to add solar generators and their time
series to a [`System`]. However, if you desire to add other
[`RenewableDispatch`] generator types, such as wind, the process is exactly the
same, with the only change needed to the prime mover type, from `PrimeMovers.PVe` to
`PrimeMovers.WT`.

We assume the data needed to build each solar powered
[`RenewableDispatch`](@ref) unit is found in the CSV file `Solar_Gens.csv`,
with a row for each generator, and columns for the generators' input
parameters. The convention used for the contents of the `Bus` column must be
consistent with the convention used in the `Bus Number` column of `Buses.csv`.
The following table is a snapshot of the first 3 rows of our `Solar_Gens.csv`:

| Gen Name | Number | Bus | Rating (MVA) |
|:-------- |:------ |:--- |:------------ |
| Solar 01 | 1      | 32  | 746.76       |
| Solar 02 | 2      | 92  | 369.26       |
| Solar 03 | 3      | 54  | 264.47       |
| ...      | ...    | ... | ...          |

Read in the contents of the CSV file `Solar_Gens.csv` to a data frame, ensuring
your data are in the given units, and customize the parameter names based on
the column names in your CSV file. Also create a variable for the prime mover
type of these generators.

```julia
solar_gens = CSV.read("MyData/Solar_Gens.csv", DataFrame)

name = "Gen Name"
num = "Number"
bus_connection = "Bus"
rate = "Rating (MVA)"
prime_mover = PrimeMovers.PVe
```

Before building the solar generators, we must also set up the solar generators'
time series. In this example, we assume that each solar generator has a unique
time series, and all of these time series are contained in one file:
`MyData/Solar_Time_Series.csv`. We assume that our time series are not
normalized, and so we will normalize them in a later step. Here is a snapshot
of this time series CSV file, where the first column contains time stamps, and
the remaining columns are titled with its respective generator's name, and
contain the time series values in MW for each solar generator:

| Time Stamp  | Solar 01 | Solar 02 | Solar 03 | ... |
|:----------- |:-------- |:-------- |:-------- |:--- |
| 1/1/23 0:00 | 0.0      | 0.0      | 0.0      | ... |
| 1/1/23 1:00 | 0.0      | 0.0      | 0.0      | ... |
| 1/1/23 2:00 | 0.0      | 0.0      | 0.0      | ... |
| ...         | ...      | ...      | ...      | ... |

Each time series for its respective solar generator has an hourly resolution,
and is for the year 2023, plus one full day into 2024, for a total of 366 days,
and 8784 values per column. Ensure that your time series file is similarly
formatted.

Create a data frame from `Solar_Time_Series.csv` and define variables for the
aforementioned resolution and time stamps:

```julia
solar_time_series = CSV.read("MyData/Solar_Time_Series.csv", DataFrame)

resolution = Dates.Hour(1);
timestamps = range(DateTime("2023-01-01T00:00:00"); step = resolution, length = 8784);
```

In the same `for` loop, we will build the solar generator components using the
[`RenewableDispatch`](@ref) constructor and data stored in the `solar_gens`
data frame, and build and attach each solar generator's time series. In this
example, we assume that the [`RenewableGenerationCost`](@ref) is at zero
marginal cost. If the marginal cost is not zero, follow similar steps to
building the [`ThermalGenerationCost`](@ref) constructor from above, but for
the [`RenewableGenerationCost`](@ref) constructor instead. Since the example
data is missing base power, we set base power equal to the rating data, and the
rating parameter to 1.0:

```julia
for row in eachrow(solar_gens)
    norm = maximum(solar_time_series[:, row[name]])
    solar_array = TimeArray(timestamps, (solar_time_series[:, row[name]] ./ norm)) # normalize data
    solar_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = solar_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    solar = RenewableDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 1.0,
        prime_mover_type = prime_mover,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = RenewableGenerationCost(zero(CostCurve)),
        base_power = row[rate],
    )
    add_component!(sys, solar)
    add_time_series!(sys, solar, solar_TS)
end
```

## Adding Hydro Generators and Their Time Series

We assume the data needed to build each [`HydroDispatch`](@ref) unit is found
in a CSV file `Hydro_Gens.csv`, with a row for each generator, and columns for
the generators' input parameters. The convention used for the contents of the
`Bus` column must be consistent with the convention used in the `Bus Number`
column of `Buses.csv`. The following table is a snapshot of the first 5 columns
of our `Hydro_Gens.csv`:

| Gen Name | Number | Bus | Min Stable Level (MW) | Max Capacity (MW) | Max Ramp Up (MW/min) | ... |
|:-------- |:------ |:--- |:--------------------- |:----------------- |:-------------------- |:--- |
| Hydro 01 | 1      | 56  | 0.0                   | 75.0              | 0.83                 | ... |
| Hydro 02 | 2      | 56  | 0.0                   | 75.0              | 0.83                 | ... |
| Hydro 03 | 3      | 66  | 0.0                   | 77.0              | 0.86                 | ... |
| ...      | ...    | ... | ...                   | ...               | ...                  | ... |

Ensure that your data are in the given units. Then read in the contents of the
CSV file `Hydro_Gens.csv` to a data frame and customize the parameter names
based on the column names in your CSV file.

```julia
hydro_gens = CSV.read("MyData/Hydro_Gens.csv", DataFrame)

name = "Gen Name"
bus_connection = "Bus"
num = "Number"
rate = "Rating (MVA)"
min_active_power = "Min Stable Level (MW)"
max_active_power = "Max Capacity (MW)"
ramp_up = "Max Ramp Up (MW/min)"
ramp_down = "Max Ramp Down (MW/min)"
min_up = "Min Up Time (h)"
min_down = "Min Down Time (h)"
```

Before building the hydro generators, we must also set up the hydro generators'
time series. In this example, we assume that each hydro generator has a unique
time series, and all of these time series are contained in one file:
`MyData/Hydro_Time_Series.csv`. We assume that our time series are not
normalized, and so we will normalize them in a later step. Here is a snapshot
of this time series CSV file, where the first column contains time stamps, and
the remaining columns are titled with its respective generator's name, and
contain the time series values in MW for each hydro generator:

| Time Stamp  | Hydro 01 | Hydro 02 | Hydro 03 | ... |
|:----------- |:-------- |:-------- |:-------- |:--- |
| 1/1/23 0:00 | 0.325386 | 0.325409 | 0.314454 | ... |
| 1/1/23 1:00 | 0.325386 | 0.325409 | 0.314454 | ... |
| 1/1/23 2:00 | 0.325386 | 0.325409 | 0.314454 | ... |
| ...         | ...      | ...      | ...      | ... |

Each time series for its respective hydro generator has an hourly resolution,
and is for the year 2023, plus one full day into 2024, for a total of 366 days,
and 8784 values per column. Ensure that your time series file is similarly
formatted.

Create a data frame from `Hydro_Time_Series.csv` and define variables for the
aforementioned resolution and time stamps:

```julia
hydro_time_series = CSV.read("MyData/Hydro_Time_Series.csv", DataFrame)

resolution = Dates.Hour(1);
timestamps = range(DateTime("2023-01-01T00:00:00"); step = resolution, length = 8784);
```

In the same `for` loop, we will build the hydro generator components using the
[`HydroDispatch`](@ref) constructor and data stored in the `hydro_gens` data
frame, and build and attach each hydro generator's time series. In this
example, we assume that the [`HydroGenerationCost`](@ref) has both zero fixed
and variable costs. Since the example data is missing base power, we set base
power equal to the rating data, and the rating parameter to 1.0:

```julia
for row in eachrow(hydro_gens)
    norm = maximum(hydro_time_series[:, row[name]])
    hydro_array = TimeArray(timestamps, (hydro_time_series[:, row[name]] ./ norm)) # normalize data
    hydro_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = hydro_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    base = row[rate]
    hydro = HydroDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 1.0,
        prime_mover_type = PrimeMovers.HA,
        active_power_limits = (
            min = row[min_active_power] / base,
            max = row[max_active_power] / base,
        ),
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = row[ramp_up] / base, down = row[ramp_down] / base),
        time_limits = (up = row[min_up], down = row[min_down]),
        base_power = base,
        operation_cost = HydroGenerationCost(zero(LinearCurve), 0.0),
    )
    add_component!(sys, hydro)
    add_time_series!(sys, hydro, hydro_TS)
end
```

## Adding Loads and Their Time Series

In this example, we assume that all loads will be represented as
[`PowerLoad`](@ref) components, and that the loads are located in three
regions. Each region has one unique time series, and every load in each region
is assigned its region's respective time series.

The data needed to build each [`PowerLoad`](@ref) unit is found in the CSV file
`Loads.csv`, with a row for each load, and columns for the loads' input
parameters. The convention used for the contents of the `Bus` column must be
consistent with the convention used in the `Bus Number` column of `Buses.csv`,
and similarly for the `Region` column. The following table is a snapshot of the
first 3 rows of our `Loads.csv`:

| Load Number | Bus | Region | Participation Factor |
|:----------- |:--- |:------ |:-------------------- |
| 1           | 1   | R1     | 0.047168669          |
| 2           | 2   | R1     | 0.0184963            |
| 3           | 3   | R1     | 0.0360691            |
| ...         | ... | ...    | ...                  |

Read in the contents of the CSV file `Loads.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
load_params = CSV.read("MyData/Loads.csv", DataFrame)

region = "Region"
bus_connection = "Bus"
factor = "Load Participation Factor"
number = "Load Number"
```

Before building the loads, we must also set up the loads' time series. In this
example, we assume that each load region has a unique time series, and all of
these time series are contained in one file: `MyData/Load_Time_Series.csv`.
Here is a snapshot of this time series CSV file, where the first column
contains time stamps, and the remaining columns are titled with its respective
region's name, and contain the time series values in MW for each region:

| Time Stamp  | R1         | R2         | R3         |
|:----------- |:---------- |:---------- |:---------- |
| 1/1/23 0:00 | 5465.7296  | 1904.4448  | 2486.38409 |
| 1/1/23 1:00 | 4994.53821 | 1726.22134 | 2273.63274 |
| 1/1/23 2:00 | 4825.94679 | 1694.14112 | 2256.41587 |
| ...         | ...        | ...        | ...        |

Each time series for its respective load region has an hourly resolution, and
is for the year 2023, plus one full day into 2024, for a total of 366 days, and
8784 values per column. Ensure that your time series file is similarly
formatted.

Create a data frame from `Load_Time_Series.csv` and define variables for the
aforementioned resolution and time stamps:

```julia
load_time_series = CSV.read("MyData/Load_Time_Series.csv", DataFrame)

resolution = Dates.Hour(1);
timestamps = range(DateTime("2023-01-01T00:00:00"); step = resolution, length = 8784);
```

Construct and attach the loads to the system using the [`PowerLoad`](@ref)
constructor according to their regions.  Because these loads are defined by
region, the `max_active_power` of each load will depend on the maximum time
series value of its region, according to the mathematical relationship seen in
the code block below.

```julia
for row in eachrow(load_params)
    num = row[number]
    max = maximum(load_time_series[:, row[region]])
    load = PowerLoad(;
        name = "load$num",
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        base_power = system_base_power,
        max_active_power = (max) * (row[factor]) / system_base_power,
        max_reactive_power = 0.0,
    )
    add_component!(sys, load)
end
```

In a `for` loop, iterate over the regions in your [`System`](@ref), and use the
[`begin_time_series_update`](@ref) function to create and attach the
respective loads' time series to every load in a region at once.

```julia
regions = unique(load_params[:, region])

for reg in regions
    load_array = TimeArray(
        timestamps,
        (load_time_series[:, reg] ./ maximum(load_time_series[:, reg])),
    )
    load_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = load_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    region = get_component(Area, sys, reg)
    begin_time_series_update(sys) do
        for component in get_components_in_aggregation_topology(PowerLoad, sys, region)
            add_time_series!(sys, component, load_TS)
        end
    end
end
```
