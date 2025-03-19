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
using CSV
using DataFrames
using Dates
using TimeSeries
```

## Build the base of the [`System`](@ref) with appropriate base power.

Begin by building the base [`System`](@ref) using the base power.

```julia
system_base_mva = 100.0
sys = System(system_base_mva)
```

## Construct each [`Area`](@ref) and [`ACBus`](@ref) of the [`System`](@ref)

The first building block of a system are the buses. In this example, we assume
that the component data for the buses are contained in a CSV file. Each row is
an individual bus, and there is a column for each input parameter:

| Bus Number | BusType | Magnitude | Voltage-Max | Voltage-Min | Base Voltage | Region |
| ---------- | ------- | --------- | ----------- | ----------- | ------------ | ------ |
| 1          | ref      | 1         | 1.06        | 0.94        | 138          | 1      |
| 2          | ref      | 1         | 1.06        | 0.94        | 138          | 1      |
| 3          | ref      | 1         | 1.06        | 0.94        | 345          | 2      |
| ...        | ...     | ...       | ...         | ...         | ...          | ...    |

Ensure your data follows this format before beginning.

Read in the contents of the CSV file `Buses.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
bus_params = CSV.read("MyData/Buses.csv", DataFrame)

min_voltage_col = "Voltage-Min"
max_voltage_col = "Voltage-Max"
base_voltage_col = "Base Voltage"
bus_number_col = "Number"
region = "Region"
```

In this example, we assume that the buses are sorted into three `Areas`,
where [`Area`](@ref) is an optional parameter in the [`ACBus`](@ref) constructor. Because we
will be sorting our buses into these areas as we construct the buses, we must
first attach the areas to our [`System`](@ref).

```julia
num_regions = 3

for i in 1:num_regions
    area = Area("R$i")
    add_component!(sys, area)
end
```

Now, we are ready to build the buses using the [`ACBus`](@ref) constructor. If
the input data you have available in your `Buses.csv` file does not include all
the required parameters of [`ACBus`](@ref), you can hard code in the necessary
data in the `for` loop. We have done that here for e.g., the `bustype` and `angle`.

```julia
for row in eachrow(bus_params)
    num = row[bus_number_col]
    min_volt = row[min_voltage_col]
    max_volt = row[max_voltage_col]
    base_volt = row[base_voltage_col]
    bus = ACBus(;
        number = num,
        name = "bus$num",
        bustype = ACBusTypes.PQ,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = min_volt, max = max_volt),
        base_voltage = base_volt,
        area = get_component(Area, sys, "R$(row[region])")
    )
    add_component!(sys, bus)
end
```

## Build each [`Branch`](@ref) that connects [`ACBus`](@ref)es

The next step is to build the [`Branch`](@ref) components in the system. In this
example, we only have two branch types: a [`Line`](@ref), if the connecting buses
have the same base voltage; and a [`Transformer2W`](@ref) if they
have different base voltages. You may need to implement additional logic if you
have other branch types as well.

The data for each [`Branch`](@ref) is contained in the `Branches.csv` with the following format
that your data should follow as well. Each row is a branch, and each column represents an
input parameter.

| Branch Number | Bus from | Bus to | Reactance | Resistance | Max Flow (MW) | Min Flow (MW) |
| ------------- | -------- | ------ | --------- | ---------- | ------------- | ------------- |
| 1             | 1        | 2      | 0.0999    | 0.0303     | 600           | -600          |
| 2             | 1        | 3      | 0.0424    | 0.0129     | 600           | -600          |
| 3             | 4        | 5      | 0.00798   | 0.00176    | 1700          | -1700         |
| ...           | ...      | ...    | ...       | ...        | ...           | ...           |

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
whatever parameters you are missing (in this example, `active_power_flow`,
`reactive_power_flow`, and `primary_shunt` are not specified in our
`Branches.csv` file).

```julia
for row in eachrow(branch_params)
    num = row[branch_num]
    bus_from = row[bus_from_col]
    bus_to = row[bus_to_col]
    if bus_params[bus_to, base_voltage_col] == bus_params[bus_from, base_voltage_col]
        local line = Line(;
            name = "line$num",
            available = true,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(; from = get_bus(sys, bus_from), to = get_bus(sys, bus_to)),
            r = row[resistance],
            x = row[reactance],
            b = (from = 0.0, to = 0.0),
            rating = row[max_flow] / system_base_mva,
            angle_limits = (min = 0.0, max = 0.0),
        )
        add_component!(sys, line)
    else # if the base voltages of the connecting buses do not match build a transformer
        local tline = Transformer2W(;
            name = "tline$num",
            available = true,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(; from = get_bus(sys, bus_from), to = get_bus(sys, bus_to)),
            r = row[resistance],
            x = row[reactance],
            primary_shunt = 0.0,
            rating = row[max_flow] / system_base_mva,
        )
        add_component!(sys, tline)
    end
end
```

## Building Thermal Generators and Adding their Cost Functions


### Build Thermal Generators

The data needed to build each [`ThermalStandard`](@ref) unit is found in the
CSV file `Thermal_Gens.csv`, with a row for each generator, and columns for the
generators' input parameters. The following table is a snapshot of the first 6
columns of our `Thermal_Gens.csv`:

| Gen Name   | Bus | Rating | Min Stable Level (MW) | Max Capacity (MW) | Max Ramp Up (MW/min) | ... |
| ---------- | --- | ------ | --------------------- | ----------------- | -------------------- | --- |
| Biomass 01 | 12  | 3      | 0.9                   | 3.0               | 0.42                 | ... |
| Biomass 02 | 12  | 3      | 0.9                   | 3.0               | 0.42                 | ... |
| Biomass 03 | 103 | 1.2    | 0.36                  | 1.2               | 0.42                 | ... |
| ...        | ... | ...    | ...                   | ...               | ...                  | ... |

Read in the contents of the CSV file `Thermal_Gens.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
thermal_gens =  CSV.read("MyData/Thermal_Gens.csv", DataFrame)

name = "Gen Name"
bus_connection = "Bus"
rate = "Rating"
min_active_power = "Min Stable Level (MW)"
max_active_power = "Max Capacity (MW)"
ramp_up = "Max Ramp Up (MW/min)"
ramp_down = "Max Ramp Down (MW/min)"
min_up = "Min Up Time (h)"
min_down = "Min Down Time (h)"
prime_move = "PrimeMoveType"
fuel = "Fuel Type"
```

Build the thermal generator components using the [`ThermalStandard`](@ref) constructor and data stored in the
`thermal_gens` dataframe:

```julia
for row in eachrow(thermal_gens)
    local thermal = ThermalStandard(;
        name = row[name],
        available = true,
        status = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = row[rate],
        active_power_limits = (
            min = row[min_active_power],
            max = row[max_active_power],
        ),
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = row[ramp_up], down = row[ramp_down]),
        operation_cost = ThermalGenerationCost(nothing),
        base_power = system_base_mva,
        time_limits = (up = row[min_up], down = row[min_down]),
        prime_mover_type = row[prime_move],
        fuel = row[fuel],
    )
    add_component!(sys, thermal)
end
```

### Add [`ThermalGenerationCost`](@ref)

In this example the `ThermalGenerationCost` functions are defined by a [`FuelCurve`](@ref). The data needed to build each [`FuelCurve`](@ref) can be found in two separate CSV files. The first, `Thermal_Fuel_Rates.csv` contains information regarding the type of fuel and the cost. The second, `Thermal_Gens.csv` contains the rest of the data and has already been read in. Read in the `Thermal_Fuel_Rates.csv` CSV and create a dictionary of fuel types and associated costs. 

```julia
fuel_params = CSV.read("MyData/Thermal_Fuels_Rates.csv", DataFrame)

fuel_cost = Dict(
    "coal" => fuel_params[1, 2],
    "ng" => fuel_params[2, 2],
    "oil" => fuel_params[3, 2],
    "bio" => fuel_params[4, 2],
    "geo" => fuel_params[5, 2],
)
```
Assign a fuel type and price to the thermal generators based on their [`PrimeMover`](@ref) type which can be found in the thermal_gens dataframe. 

```julia
fuel_prices = []
fuel = []
for row in eachrow(thermal_gens)
    if row[prime_move] == "OT"
        push!(fuel_prices, bm_price)
        push!(fuel, ThermalFuels.AG_BIPRODUCT)
    elseif row[name] == "CC" || startswith(row[name], "CT NG") ||
           startswith(row[name], "ICE NG") || startswith(row[name], "ST NG")
        push!(fuel_prices, ng_price)
        push!(fuel, ThermalFuels.NATURAL_GAS)
    elseif startswith(row[name], "CT Oil")
        push!(fuel_prices, oil_price)
        push!(fuel, ThermalFuels.DISTILLATE_FUEL_OIL)
    elseif startswith(row[name], "ST Coal")
        push!(fuel_prices, coal_price)
        push!(fuel, ThermalFuels.COAL)
    elseif startswith(row[name], "Geo")
        push!(fuel_prices, geo_price)
        push!(fuel, ThermalFuels.GEOTHERMAL)
    elseif startswith(row[name], "ST Other 01")
        push!(fuel_prices, oil_price)
        push!(fuel, ThermalFuels.DISTILLATE_FUEL_OIL)
    elseif startswith(row[name], "ST Other 02")
        push!(fuel_prices, ng_price)
        push!(fuel, ThermalFuels.NATURAL_GAS)
    end
end
```
Next, we will parse heat rate bases, heat rates, load points, fixed, start up, and shut down costs from the thermal_gens dataframe. This data is used to construct [`LinearCurve`](@ref) and[`PiecewiseIncrementalCurve`](@ref), and subsequently [`FuelCurve`](@ref) functions that desribe the operation cost of the thermal units. 
 

```julia
heat_rate_base = thermal_gens[:, "Heat Rate Base (MMBTU/hr)"]
heat_rate = thermal_gens[:, "Heat Rate (MMBTU/hr)"]
load_point = thermal_gens[:, "Load Point Band (MW)"]
fixed_cost = thermal_gens[:, "Fixed Cost"]
start_up_cost = thermal_gens[:, "Start Up Cost"]
shut_down_cost = thermal_gens[:, "Shut Down Cost"]
```
Use this data to build the [`PiecewiseIncrementalCurve`](@ref) and the [`FuelCurve`](@ref) functions, and add them to their associated thermal generator. 

```julia
gen_name = "Generator Name"

for row in eachrow(thermal_gens)
    thermal = get_component(ThermalStandard, sys, row[gen_name])
    fuel_cost = row[fuel_prices]
    heat_rate_base = row[heat_rate_base]
    heat_rate = row[heat_rate]
    load_point = row[load_point]
    heat_rate_curve =
        PieceWiseIncrementalCurve(heat_rate_base, load_point, heat_rate)
    fuel_curve =
        FuelCurve(; value_curve = heat_rate_curve, fuel_cost = fuel_prices[rownumber(row)])
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

## Building Solar Generators and Adding their Time Series

The data needed to build each solar powered [`RenewableDispatch`](@ref) unit is
found in the CSV file `Solar_Gens.csv`, with a row for each generator, and
columns for the generators' input parameters. The following table is a snapshot
of the first 3 rows of our `Solar_Gens.csv`:

| Gen Name | Number | Bus | Rating |
| -------- | ------ | --- | ------ |
| Solar 01 | 1      | 32  | 746.76 |
| Solar 02 | 2      | 92  | 369.26 |
| Solar 03 | 3      | 54  | 264.47 |
| ...      | ...    | ... | ...    |

Read in the contents of the CSV file `Solar_Gens.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
solar_gens =  CSV.read("MyData/Solar_Gens.csv", DataFrame)

name = "Gen Name"
num = "Number"
bus_connection = "Bus"
rate = "Rating"
```

Before building the solar generators, we must also set up the solar generators'
time series. In this example, we assume that each solar generator has a unique
time series, and all of these time series are contained in one file:
`MyData/Solar_Time_Series.csv`.  Here is a snapshot of this time series CSV
file, where the first column contains time stamps, and the remaining columns
contain the time series values for each solar generator:

| Time Stamp  | Value - Solar 1 | Value - Solar 2 | Value - Solar 3 | ... |
| ----------- | --------------- | --------------- | --------------- | --- |
| 1/1/23 0:00 | 0.0             | 0.0             | 0.0             | ... |
| 1/1/23 1:00 | 0.0             | 0.0             | 0.0             | ... |
| 1/1/23 2:00 | 0.0             | 0.0             | 0.0             | ... |
| ...         | ...             | ...             | ...             | ... |

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
dataframe, and build and attach each solar generator's time series. In this example,
we assume that the [`RenewableGenerationCost`](@ref) is at zero marginal cost. If the marginal cost is not zero, follow similar steps to building the [`ThermalGenerationCost`](@ref) functions from above. 

```julia
for row in eachrow(solar_gens)
    norm = maximum(solar_time_series[:, row[num] + 1]) # plus 1 is to skip the timestamp column
    solar_array = TimeArray(timestamps, (solar_time_series[:, row[num] + 1] ./ norm) / system_base_mva) # normalize and per-unitize data
    solar_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = solar_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    local solar = RenewableDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = row[rate],
        prime_mover_type = PrimeMovers.PVe,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = RenewableGenerationCost(zero(CostCurve)),
        base_power = system_base_mva,
    )
    add_component!(sys, solar)
    add_time_series!(sys, solar, solar_TS)
end
```
## Building Wind Generators and Adding their Time Series

The data needed to build each wind powered [`RenewableDispatch`](@ref) unit is
found in the CSV file `Wind_Gens.csv`, with a row for each generator, and
columns for the generators' input parameters. The following table is a snapshot
of the first 3 rows of our `Wind_Gens.csv`:

| Gen Name | Number | Bus | Rating |
| -------- | ------ | --- | ------ |
| Wind 01  | 1      | 24  | 11.5   |
| Wind 02  | 2      | 24  | 38.0   |
| Wind 03  | 3      | 24  | 10.0   |
| ...      | ...    | ... | ...    |

Read in the contents of the CSV file `Wind_Gens.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
wind_gens =  CSV.read("MyData/Wind_Gens.csv", DataFrame)

name = "Gen Name"
num = "Number"
bus_connection = "Bus"
rate = "Rating"
```

Before building the wind generators, we must also set up the wind generators'
time series. In this example, we assume that each wind generator has a unique
time series, and all of these time series are contained in one file:
`MyData/Wind_Time_Series.csv`.  Here is a snapshot of this time series CSV
file, where the first column contains time stamps, and the remaining columns
contain the time series values for each wind generator:

| Time Stamp  | Value - Wind 1 | Value - Wind 2 | Value - Wind 3 | ... |
| ----------- | -------------- | -------------- | -------------- | --- |
| 1/1/23 0:00 | 0.45813515     | 3.72427362     | 2.47726658     | ... |
| 1/1/23 1:00 | 0.90083454     | 8.09024454     | 3.03120437     | ... |
| 1/1/23 2:00 | 2.41245919     | 13.3355967     | 3.08938011     | ... |
| ...         | ...            | ...            | ...            | ... |

Each time series for its respective wind generator has an hourly resolution,
and is for the year 2023, plus one full day into 2024, for a total of 366 days,
and 8784 values per column. Ensure that your time series file is similarly
formatted.

Create a data frame from `Wind_Time_Series.csv` and define variables for the
aforementioned resolution and time stamps:

```julia
wind_time_series = CSV.read("MyData/Wind_Time_Series.csv", DataFrame)

resolution = Dates.Hour(1);
timestamps = range(DateTime("2023-01-01T00:00:00"); step = resolution, length = 8784);
```

In the same `for` loop, we will build the wind generator components using the
[`RenewableDispatch`](@ref) constructor and data stored in the `wind_gens`
dataframe, and build and attach each wind generator's time series. In this example,
we assume that the [`RenewableGenerationCost`](@ref) is at zero marginal cost.

```julia
for row in eachrow(wind_gens)
    norm = maximum(wind_time_series[:, row[num] + 1]) # plus 1 is to skip the timestamp column
    wind_array = TimeArray(timestamps, (wind_time_series[:, row[num] + 1] ./ norm) / system_base_mva) # normalize and per-unitize data
    wind_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = wind_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    local wind = RenewableDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = row[rate],
        prime_mover_type = PrimeMovers.WT,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = RenewableGenerationCost(zero(CostCurve)),
        base_power = system_base_mva,
    )
    add_component!(sys, wind)
    add_time_series!(sys, wind, wind_TS)
end
```

## Building Hydro Generators and Adding their Time Series

The data needed to build each [`HydroDispatch`](@ref) unit is found in the
CSV file `Hydro_Gens.csv`, with a row for each generator, and columns for the
generators' input parameters. The following table is a snapshot of the first 5
columns of our `Hydro_Gens.csv`:

| Gen Name | Number | Bus | Min Stable Level (MW) | Max Capacity (MW) | Max Ramp Up (MW/min) | ... |
| -------- | ------ | --- | --------------------- | ----------------- | -------------------- | --- |
| Hydro 01 | 1      | 56  | 0.0                   | 75.0              | 0.83                 | ... |
| Hydro 02 | 2      | 56  | 0.0                   | 75.0              | 0.83                 | ... |
| Hydro 03 | 3      | 66  | 0.0                   | 77.0              | 0.86                 | ... |
| ...      | ...    | ... | ...                   | ...               | ...                  | ... |

Read in the contents of the CSV file `Hydro_Gens.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
hydro_gens =  CSV.read("MyData/Hydro_Gens.csv", DataFrame)

name = "Gen Name"
bus_connection = "Bus"
num = "Number"
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
`MyData/Hydro_Time_Series.csv`.  Here is a snapshot of this time series CSV
file, where the first column contains time stamps, and the remaining columns
contain the time series values for each hydro generator:

| Time Stamp  | Value - Hydro 1 | Value - Hydro 2 | Value - Hydro 3 | ... |
| ----------- | --------------- | --------------- | --------------- | --- |
| 1/1/23 0:00 | 0.325386        | 0.325409        | 0.314454        | ... |
| 1/1/23 1:00 | 0.325386        | 0.325409        | 0.314454        | ... |
| 1/1/23 2:00 | 0.325386        | 0.325409        | 0.314454        | ... |
| ...         | ...             | ...             | ...             | ... |

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
[`HydroDispatch`](@ref) constructor and data stored in the `hydro_gens`
dataframe, and build and attach each hydro generator's time series. In this example,
we assume that the [`HydroGenerationCost`](@ref) has both zero fixed and variable costs.

```julia
for row in eachrow(hydro_gens)
    norm = maximum(hydro_time_series[:, row[num] + 1]) # plus 1 is to skip the timestamp column
    hydro_array = TimeArray(timestamps, (hydro_time_series[:, row[num] + 1] ./ norm) / system_base_mva) # normalize and per-unitize data
    hydro_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = hydro_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    local hydro = HydroDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 0.0,
        prime_mover_type = PrimeMovers.HA,
        active_power_limits = (
            min = row[min_active_power] / system_base_mva,
            max = row[max_active_power] / system_base_mva,
        ),
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = row[ramp_up], down = row[ramp_down]),
        time_limits = (up = row[min_up], down = row[min_down]),
        base_power = system_base_mva,
        operation_cost = HydroGenerationCost(zero(LinearCurve), 0.0),
    )
    add_component!(sys, hydro)
    add_time_series!(sys, hydro, hydro_TS)
end
```

## Building [`PowerLoad`](@ref) Components and Reading in Their Time Series

In this example, we assume that all [`PowerLoad`](@ref) components are sorted
into three regions. Each region has one unique time series, and every load in each
region is assigned its regions's respective time series. 

The data needed to build each [`PowerLoad`](@ref) unit is found in the
CSV file `Loads.csv`, with a row for each load, and columns for the
loads' input parameters. The following table is a snapshot of the first 3
rows of our `Loads.csv`:

| Load Number | Bus | Region | Participation Factor |
| ----------- | --- | ------ | -------------------- |
| 1           | 1   | 1      | 0.047168669          |
| 2           | 2   | 1      | 0.0184963            |
| 3           | 3   | 1      | 0.0360691            | 
| ...         | ... | ...    | ...                  |

Read in the contents of the CSV file `Loads.csv` to a data frame and customize
the parameter names based on the column names in your CSV file.

```julia
load_params =  CSV.read("MyData/Loads.csv", DataFrame)

region = "Region"
bus_connection = "Bus"
factor = "Load Participation Factor"
number = "Load Number"
```

Before building the loads, we must also set up the loads' time series. In this
example, we assume that each load region has a unique time series, and all of
these time series are contained in one file: `MyData/Load_Time_Series.csv`.
Here is a snapshot of this time series CSV file, where the first column
contains time stamps, and the remaining columns contain the time series values
for each region:

| Time Stamp  | Value - Region 1 | Value - Region 2 | Value - Region 3 |
| ----------- | ---------------- | ---------------- | ---------------- |
| 1/1/23 0:00 | 5465.7296        | 1904.4448        | 2486.38409       |
| 1/1/23 1:00 | 4994.53821       | 1726.22134       | 2273.63274       |
| 1/1/23 2:00 | 4825.94679       | 1694.14112       | 2256.41587       |
| ...         | ...              | ...              | ...              |

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
    max = maximum(load_time_series[:, row[region] + 1]) # plus 1 in order to skip time stamp column
    load = PowerLoad(;
        name = "load$num",
        available = true,
        bus = get_bus(sys, row[bus_connection]),
        active_power = 0.0, #per-unitized by device base_power
        reactive_power = 0.0, #per-unitized by device base_power
        base_power = system_base_mva,
        max_active_power = (max) * (row[factor]) / system_base_mva,
        max_reactive_power = 0.0,
    )
    add_component!(sys, load)
end
```

In a `for` loop, iterate over the number of regions in your [`System`], and use
the [`begin_time_series_update()`](@ref) function to create and attach the
respective loads' time series to every load in a region at once.

```julia
for i in 1:num_regions
    local load_array = TimeArray(timestamps, (load_time_series[:, i+1] ./ maximum(load_time_series[:, i+1])))
    local load_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = load_array,
        scaling_factor_multiplier = get_max_active_power,
    )
    region = get_component(Area, sys, "R$i")
    begin_time_series_update(sys) do
        for component in get_components_in_aggregation_topology(PowerLoad, sys, region)
            add_time_series!(sys, component, load_TS)
        end 
    end
end
```
