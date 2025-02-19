# [Building a System from CSV Files](@id system_from_csv)

### Dependencies

```julia
using PowerSystems
using CSV
using DataFrames
```

### Build the base of the system with appropriate base power.

Begin by building the base system using the base power.

```julia
sys = System(100)
```

### Read in all component data

Read in the CSV files that contain the data for building the system. In this
example, the line, bus, and generator data are found in the following CSV files.

```julia
bus_params = CSV.read("Scripts-and-Data/Buses.csv", DataFrame)
line_params = CSV.read("Scripts-and-Data/Lines.csv", DataFrame)
gen_params = CSV.read("Scripts-and-Data/gen.csv", DataFrame)
```

The generator data is stored in the `gen_params` dataframe. Create dataframes characterized by the generator type Thermal
generators, hydro generators and renewable generators are different types of
components, and therefore built differently.

```julia
thermal_gens = [];
hydro_gens = [];
solar_gens = [];
wind_gens = [];
for row in eachrow(gen_params)
    if row["type"] == "Thermal "
        push!(thermal_gens, row; promote = true)
    elseif row["type"] == "Hydro"
        push!(hydro_gens, row; promote = true)
    elseif row["type"] == "Solar"
        push!(solar_gens, row; promote = true)
    elseif row["type"] == "Wind"
        push!(wind_gens, row; promote = true)
    end
end
```

### Build the buses - parsing data from `bus_params`

The first building block are the buses in the system. We can define variables
describing the buses using columns found in the `bus_params.csv` file.

```julia
min_voltage_col_name = "Voltage-Min (pu)"
max_voltage_col_name = "Voltage-Max (pu)"
base_voltage_col_name = "Base Voltage"
bus_number_col_name = "Number"
```

We can build the buses using the [`ACBus`](@ref) function.
If the input data you have available in your `bus_params.csv` file does not include all the required parameters of [`ACBus`](@ref), you can hard code in the necessary data in the `for` loop. We have done that here for e.g., the [`bustype`](@ref acbustypes_list) and `angle`.
```julia
for row in eachrow(bus_params)
    num = row[bus_number_col_name]
    min_volt = row[min_voltage_col_name]
    max_volt = row[max_voltage_col_name]
    base_volt = row[base_voltage_col_name]
    bus = ACBus(;
        number = row[number],
        name = "bus$row",
        bustype = ACBusTypes.PQ,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = min_volt, max = max_volt),
        base_voltage = base_volt,
    )
    add_component!(sys, bus)
end
```

### Build the lines and transformers - parsing data from `line_params`

The next step is to build the lines and transformers in the system which are
both stored in the `line_params` dataframe. In this example, we only have two branch types: is a [`Line`](@ref) if the buses
being connected have the same base voltage, and a [`Transformer2W`](@ref) if they have
different base voltages. You may need to implement additional logic if you have other branch types as well.

Begin by defining variables describing the lines/transformers using the columns
found in the `line_params` dataframe.

```julia
bus_from_col = "Bus from"
bus_to_col = "Bus to"
reactance = "Reactance (p.u.)"
resistance = "Resistance (p.u.)"
max_flow = "Max Flow (MW)"
active_flow = "Active Power Flow"
reactive_flow = "Reactive Power Flow"
b_from = "Shunt Susceptance From"
b_to = "Shunt Susceptance To"
max_lim = "Angle Limit Max"
min_lim = "Angle Limit Min"
shunt = "Primary Shunt"
number = "Number"
```

Build the lines and transformers using the [`Line`](@ref) and [`Transformer2W`](@ref) functions.
Again, if you don't have all of these parameters available in your file, customize the `for` loop to hard code whatever parameters you are missing (e.g., `r = 0.0` if no resistance data is available). 
```julia
for row in eachrow(line_params)
    num = row[number]
    bus_from = parse(Int, row[bus_from_col][4:6])
    bus_to = parse(Int, row[bus_to_col][4:6])
    if bus_params[bus_to, "Base Voltage kV"] == bus_params[bus_from, "Base Voltage kV"]
        local line = Line(;
            name = "line$num",
            available = true,
            active_power_flow = row[active_flow],
            reactive_power_flow = row[reactive_flow],
            arc = Arc(; from = get_bus(sys, bus_from), to = get_bus(sys, bus_to)),
            r = row[resistance],
            x = row[reactance],
            b = (from = row[b_from], to = row[b_to]),
            rating = row[max_flow] / 100,
            angle_limits = (min = min_lim, max = max_lim),
        )
        add_component!(sys, line)
    else # if the base voltages of the connecting buses do not match build a transformer
        local tline = Transformer2W(;
            name = "tline$num",
            available = true,
            active_power_flow = row[active_flow],
            reactive_power_flow = row[reactive_flow],
            arc = Arc(; from = get_bus(sys, bus_from), to = get_bus(sys, bus_to)),
            r = row[resistance],
            x = row[reactance],
            primary_shunt = row[shunt],
            rating = row[max_flow] / 100,
        )
        add_component!(sys, tline)
    end
end
```

# Reading in Time Series Data

### Establishing resolution of time series

The following time series are hourly resolution for the year 2023, plus one day
into the following year for a total of 366 days. The following steps show how
to read in and add time series data to renewable and hydro generators, and
powerloads.

Begin by defining the resolution and the first time step.

```julia
resolution = Dates.Hour(1);
timestamps = range(DateTime("2023-01-01T00:00:00"); step = resolution, length = 8784);
```

### Reading in Solar Time Series

Read in the time series data for the solar generators, normalize the data, and create a [`SingleTimeSeries`](@ref) component.

```julia
solar_RT_TS = []
file_dir = "Scripts-and-Data/TimeSeries/RT/Solar"
for row in eachrow(solar_gens)
    solardf = CSV.read("$file_dir/Solar$(i)RT.csv", DataFrame) # read in data
    norm = maximum(solardf[:, 2])
    solar_array = TimeArray(timestamps, (solardf[:, 2] ./ norm) / 100) # normalize and per-unitize data
    solar_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = solar_array,
        scaling_factor_multiplier = get_max_active_power, # max active power
    )
    push!(solar_RT_TS, solar_TS)
end
```

### Reading in Wind Time Series

Read in the time series data for the wind generators, normalize the data, and create a [`SingleTimeSeries`](@ref) component.

```julia
wind_RT_TS = []
file_dir = "Scripts-and-Data/TimeSeries/RT/Wind"

for row in eachrow(wind_gens)
    winddf = CSV.read("$file_dir/Wind$(i)RT.csv", DataFrame) # read in data
    norm = maximum(winddf[:, 2])
    wind_array = TimeArray(timestamps, (winddf[:, 2] ./ norm) / 100) # normalize and per-unitize data
    wind_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = wind_array,
        scaling_factor_multiplier = 0, # max active power
    )
    push!(wind_RT_TS, wind_TS)
end
```

### Reading in Hydro Time Series

Read in the time series data for the hydro generators, normalize the data, and create a [`SingleTimeSeries`](@ref) component.

```julia
hydro_RT_TS = []
file_path = "Scripts-and-Data/TimeSeries/RT/Hydro"
for row in eachrow(hydro_gens)
    hydrodf = CSV.read("$file_path/Hydro$(i)RT.csv", DataFrame) # read in data
    norm = maximum(hydrodf[:, 2])
    hydro_array = TimeArray(timestamps, (hydrodf[:, 2] ./ norm) / 100) # normalize and per-unitize data
    hydro_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = hydro_array,
        scaling_factor_multiplier = get_max_active_power, # max active power
    )
    push!(hydro_RT_TS, hydro_TS)
end
```

# Building `PowerLoad` Components and Reading in Their Time Series

In this example loads are sorted into three regions. But before building the loads
we first must define their time series, adding each region's time series into
a vector to be later indexed into.

```julia
load_RT_TS = []
for i in 1:3
    local loaddf =
        CSV.read("Scripts-and-Data/TimeSeries/RT/Load/LoadR$(i)RT.csv", DataFrame)
    local load_array = TimeArray(timestamps, (loaddf[:, 2] ./ maximum(loaddf[:, 2])))
    local load_TS = SingleTimeSeries(;
        name = "max_active_power",
        data = load_array,
        scaling_factor_multiplier = get_max_active_power, #assumption?
    )
    push!(load_RT_TS, load_TS)
end
```

Next, add the loads to the system using the [`PowerLoad`](@ref) function according to their regions.
Read in the load data and vectors to sort the loads by regions:

```julia
load_data = sort!(CSV.read("Scripts-and-Data/Loads.csv", DataFrame));
loads_R1_RT = []
loads_R2_RT = []
loads_R3_RT = []
```

Create a file directory, and create variables describing the column names that will be used to build the loads.

```julia
file_path = "Scripts-and-Data/TimeSeries/RT/Load"
region = "Region"
factor = "Load Participation Factor"
number = "Number"
```

Build the loads using the [`PowerLoad`](@ref) function, and sort them into the vectors.

```julia
for row in eachrow(load_data)
    num = row[number]
    i = parse(Int, row[region][2])
    RTdf = CSV.read("$(file_path)/LoadR$(i)RT.csv", DataFrame)
    max = maximum(RTdf[:, 2])
    load = PowerLoad(;
        name = "load$num",
        available = true,
        bus = get_bus(sys, num),
        active_power = 0.0, #per-unitized by device base_power
        reactive_power = 0.0, #per-unitized by device base_power
        base_power = 100.0, # MVA, for loads match system
        max_active_power = (max) * (row[factor]) / 100, #per-unitized by device base_power?
        max_reactive_power = 0.0,
    )
    add_component!(sys, load)
    if i == 1
        push!(loads_R1_RT, load)
    elseif i == 2
        push!(loads_R2_RT, load)
    elseif i == 3
        push!(loads_R3_RT, load)
    end
end
```

Construct a vector containing the loads, and use the
[`bulk_add_time_series!`](@ref) function to attach the respective loads' time
series to every load in a region at once.

```julia
loads_RT = [loads_R1_RT, loads_R2_RT, loads_R3_RT]
for i in 1:3
    associations = (
        InfrastructureSystems.TimeSeriesAssociation(
            load,
            load_RT_TS[i])
        for load in loads_RT[i]
    )
    bulk_add_time_series!(sys_RT, associations)
end
```

# Building Generator Components

As established at the beginning of the How-To, we have four dataframes
containing the four types of generation. Build the generators by parsing data
from `thermal_gens`, `hydro_gens`, `solar_gens`, and `wind_gens`. First, establish
variables for the column names in `gen_params`.

```julia
name = "Generator Name"
bus_connection = "bus of connection"
rate = "Rating"
min_active_power = "Min Stable Level (MW)"
max_active_power = "Max Capacity (MW)"
ramp_up = "Max Ramp Up (MW/min)"
ramp_down = "Max Ramp Down (MW/min)"
min_down = "Min Down Time (h)"
min_up = "Min Up Time (h)"
prime_move = "PrimeMoveType"
```

## Building Thermal Generators

Build the thermal generator components using the [`ThermalStandard`](@ref) function and data stored in the
`thermal_gens` dataframe.

```julia
for row in eachrow(thermal_gens)
    thermal_bus = row[bus_connection]
    local thermal = ThermalStandard(;
        name = row[name],
        available = true,
        status = true,
        bus = get_bus(sys, bus),
        active_power = 0,
        reactive_power = 0,
        rating = row[rate],
        active_power_limits = (
            min = row[min_active_power],
            max = row[max_active_power],
        )
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = row[ramp_up], down = row[ramp_down]),
        operation_cost = ThermalGenerationCost(nothing),
        base_power = 100,
        time_limits = (up = row[min_up], down = row[min_down]),
        prime_mover_type = row[prime_move],
        fuel = row[fuel],
    )
    add_component!(sys, thermal)
end
```

### Building Renewable Generators

Build the solar generators and
wind generators using the [`RenewableDispatch`](@ref) function, and attach the respective time series.

# Build solar generators - parsing data from the `solar_gens` data frame

```julia
for row in eachrow(solar_gens)
    solar_bus = row[bus_connection]
    local solar = RenewableDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, bus),
        active_power = 0,
        reactive_power = 0,
        rating = row[rate],
        prime_mover_type = PrimeMovers.PVe,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = RenewableGenerationCost(nothing),
        base_power = 100,
    )
    add_component!(sys, solar)
    add_time_series!(sys, solar, solar_RT_TS[i])
end
```

# Build wind generators - parsing data from the `wind_gens` data frame

```julia
for row in eachrow(wind_gens)
    wind_bus = row[bus_connection]
    local wind = RenewableDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, bus),
        active_power = 0,
        reactive_power = 0,
        rating = row[rate],
        prime_mover_type = PrimeMovers.WT,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = RenewableGenerationCost(nothing),
        base_power = 100,
    )
    add_component!(sys, wind)
    add_time_series!(sys, wind, wind_RT_TS[i])
end
```

### Build hydro generators - parsing data from the `hydro_gens` data frame

Build the hydro generators using the [`HydroDispatch`](@ref) function and attach the respective time series.

```julia
for row in eachrow(hydro_gens)
    hydro_bus = row[bus_connection]
    local hydro = HydroDispatch(;
        name = row[name],
        available = true,
        bus = get_bus(sys, bus),
        active_power = 0.0,
        reactive_power = 0.0,
        rating = row[rate],
        prime_mover_type = PrimeMovers.HA,
        active_power_limits = (
            min = row[min_active_power] / 100,
            max = row[min_active_power] / 100,
        ),
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = row[ramp_up], down = row[ramp_down]),
        time_limits = (up = row[min_up], down = row[min_down]),
        base_power = 100,
        operation_cost = HydroGenerationCost(nothing),
    )
    add_component!(sys, hydro)
    add_time_series!(sys, hydro, hydro_RT_TS[i])
end
```

# Building `RenewableGenerationCost`, `HydroGenerationCost` and `ThermalGenerationCost` functions

Build and attach the respective cost function to the
generators. The cost function data can be found in the respective generator
data frames.

### `RenewableGenerationCost`

For the renewable generators assume zero marginal cost by using [`zero(CostCurve)`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#Base.zero-Tuple%7BUnion%7BType%7BInfrastructureSystems.CostCurve%7D,%20InfrastructureSystems.CostCurve%7D%7D). Use the [`set_operation_cost!`](@ref) function to attach the [`RenewableGenerationCost`](@ref) to the respective generators.

```julia
ren_gens = collect(get_components(RenewableDispatch, sys))
for i in length(ren_gens)
    cost_curve = zero(CostCurve)
    cost_ren = RenewableGenerationCost(cost_curve)
    ren_gen = ren_gens[i]
    set_operation_cost!(ren_gen, cost_ren)
end
```

For more information regarding renewable cost function please reference [`RenewableGenerationCost`](@ref).

### `HydroGenerationCost`

Hydro generation costs are defined by a fixed and variable cost. In this
example assume both are zero. Use the [`LinearCurve`](@ref) and [`CostCurve`](@ref) function to describe the variable cost.

```julia
hydrogens = collect(get_components(HydroDispatch, sys)) #collect hydro generators
for i in length(hydrogens)
    curve = LinearCurve(0.0)
    fixed = 0.0
    cost_hydro = HydroGenerationCost(; variable = value_curve, fixed)
    hydrogen = hydrogens[i]
    set_operation_cost!(hydrogens[i], cost_hydro)
end
```

For more information regarding hydro cost functions please reference
[`HydroGenerationCost`](@ref).

### `ThermalGenerationCost`

Thermal generator cost is defined by [`FuelCurve`](@ref). Import and parse the CSV that describes fuel costs.

Create a dictionary of fuel types and costs.

```julia
fuel_params = CSV.read("Scripts-and-Data\\Fuels and emission rates.csv", DataFrame)
fuel_cost = Dict(
    "coal" => fuel_params[1, 2],
    "ng" => fuel_params[2, 2],
    "oil" => fuel_params[3, 2],
    "bio" => fuel_params[4, 2],
    "geo" => fuel_params[5, 2],
)
```

Assign a fuel type and price to the generators based on their name.

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

### Parse heat rates, load points and heat rate bases.

Heat rates, load points, and heat rate bases are used to construct [`LinearCurve`](@ref) and
[`PiecewiseIncrementalCurve`](@ref) that describe the operational cost of the thermal units.

```julia
heat_rate_base = thermal_gens[:, "Heat Rate Base (MMBTU/hr)"]
heat_rate = thermal_gens[:, "Heat Rate (MMBTU/hr)"]
load_point = thermal_gens[:, "Load Point Band (MW)"]
fixed_cost = thermal_gens[:, "Fixed Cost"]
start_up_cost = thermal_gens[:, "Start Up Cost"]
shut_down_cost = thermal_gens[:, "Shut Down Cost"]
```

Use the heat rate bases, heat rates, load points and fuel costs to construct
the thermal generation cost functions using the [`FuelCurve`](@ref) and
[`PiecewiseIncrementalCurve`](@ref) functions.

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
