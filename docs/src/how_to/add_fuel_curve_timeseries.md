# [Add Time Series Fuel Cost Data](@id fuel_curve_timeseries)

This how-to guide demonstrates how to build a power system that uses time-varying fuel costs
in a [`ThermalGenerationCost`](@ref) with a [`FuelCurve`](@ref). This is useful when fuel
prices vary over time, such as with natural gas prices that change throughout the day or
across seasons.

```@setup fuelcosts
using PowerSystems
using Dates
using TimeSeries
using DataStructures: SortedDict
```

## Overview

When modeling thermal generators with fuel-based costs, you have two options:

1. **Scalar fuel cost**: A single, constant fuel price (e.g., \$5.0/GJ)
2. **Time series fuel cost**: Fuel prices that vary over time

This guide focuses on the second option, showing you how to:

- Create a thermal generator with a [`FuelCurve`](@ref)
- Add time series data for fuel costs
- Attach the time series to the correct component

## Step 1: Create a System and Components

First, let's create a basic power system with a bus and a thermal generator. The generator
will use a [`ThermalGenerationCost`](@ref) with a [`FuelCurve`](@ref) to represent its
variable cost.

```@repl fuelcosts
# Create a bus
bus = ACBus(;
    number = 1,
    name = "bus1",
    available = true,
    bustype = ACBusTypes.REF,
    angle = 0.0,
    magnitude = 1.0,
    voltage_limits = (min = 0.9, max = 1.1),
    base_voltage = 230.0,
)

# Define the heat rate curve
# This represents the fuel consumption (GJ/MWh) at different power outputs
heat_rate_curve = PiecewisePointCurve([
    (100.0, 7.0),   # At 100 MW: 7 GJ/MWh
    (200.0, 8.0),   # At 200 MW: 8 GJ/MWh
    (300.0, 9.5),   # At 300 MW: 9.5 GJ/MWh
])

# Create a FuelCurve with an initial scalar fuel cost
# We'll replace this with time series data in the next step
fuel_curve = FuelCurve(;
    value_curve = heat_rate_curve,
    fuel_cost = 5.0,  # Initial fuel cost: $5.0/GJ
)

# Create the ThermalGenerationCost
thermal_cost = ThermalGenerationCost(;
    variable = fuel_curve,
    fixed = 10.0,        # Fixed cost: $10/hr
    start_up = 5000.0,   # Start-up cost: $5000
    shut_down = 2000.0,  # Shut-down cost: $2000
)

# Create the thermal generator
generator = ThermalStandard(;
    name = "generator1",
    available = true,
    status = true,
    bus = bus,
    active_power = 250.0,
    reactive_power = 50.0,
    rating = 300.0,
    prime_mover_type = PrimeMovers.ST,
    fuel = ThermalFuels.NATURAL_GAS,
    active_power_limits = (min = 50.0, max = 300.0),
    reactive_power_limits = (min = -50.0, max = 100.0),
    ramp_limits = (up = 5.0, down = 5.0),
    time_limits = (up = 2.0, down = 1.0),
    operation_cost = thermal_cost,
    base_power = 100.0,
)
```

## Step 2: Create the System

Now create a system and add the components:

```@repl fuelcosts
# Create the system
sys = System(100.0)  # 100 MVA base power

# Add components
add_component!(sys, bus)
add_component!(sys, generator)

# Verify the system
sys
```

At this point, the generator has a constant fuel cost of \$5.0/GJ. Let's verify:

```@repl fuelcosts
get_fuel_cost(generator)
```

## Step 3: Create Time Series Fuel Cost Data

Now we'll create time series data representing fuel costs that vary throughout a day.
This could represent hourly natural gas prices, for example.

For time-varying fuel costs, PowerSystems supports two types of time series:

- **SingleTimeSeries**: A single sequence of values over time (simplest option)
- **Deterministic**: Forecast windows that can be useful for day-ahead scheduling

Let's start with the simpler `SingleTimeSeries`:

```@repl fuelcosts
# Define the initial time and resolution
initial_time = DateTime("2024-01-01T00:00:00")
resolution = Hour(1)

# Create hourly fuel cost data for 24 hours
# Prices are higher during peak hours (midday to early evening) and lower at night
fuel_cost_data = [
    4.5, 4.3, 4.2, 4.1, 4.2, 4.5,  # 00:00 - 05:00 (low overnight prices)
    5.0, 5.5, 6.0, 6.5, 7.0, 7.5,  # 06:00 - 11:00 (morning ramp)
    8.0, 8.0, 7.8, 7.8, 7.5, 7.0,  # 12:00 - 17:00 (afternoon peak)
    6.5, 6.0, 5.5, 5.0, 4.8, 4.6,  # 18:00 - 23:00 (evening decline)
]

# Create timestamps for each data point
timestamps = collect(initial_time:resolution:(initial_time + Hour(length(fuel_cost_data) - 1)))

# Create a TimeArray with timestamps and data
time_array = TimeArray(timestamps, fuel_cost_data)

# Create a SingleTimeSeries from the TimeArray
fuel_cost_timeseries = SingleTimeSeries(;
    name = "fuel_cost",
    data = time_array,
)
```

## Step 4: Attach Time Series to the Generator

Finally, use the [`set_fuel_cost!`](@ref) function to attach the time series data
to the generator component:

```@repl fuelcosts
# Add the time series fuel cost to the generator
set_fuel_cost!(sys, generator, fuel_cost_timeseries)
```

## Step 5: Verify and Retrieve Time Series Data

Now the generator has time-varying fuel costs. You can retrieve the time series data:

```@repl fuelcosts
# Get the fuel cost time series starting at the initial time
fuel_forecast = get_fuel_cost(generator; start_time = initial_time)

# Display the first few values
first(TimeSeries.values(fuel_forecast), 6)
```

You can also query for a specific time window:

```@repl fuelcosts
# Get fuel costs for a specific 12-hour period starting at 6 AM
morning_time = DateTime("2024-01-01T06:00:00")
fuel_forecast_morning = get_fuel_cost(generator; start_time = morning_time, len = 12)

# Display these values
TimeSeries.values(fuel_forecast_morning)
```

## Alternative: Using Deterministic for Forecast Windows

If you're doing day-ahead scheduling with rolling horizons, [`Deterministic`](@ref) time
series can be more appropriate. Unlike `SingleTimeSeries`, `Deterministic` represents
forecast windows where each forecast has a specific horizon length.

```@repl fuelcosts
# Create a new generator for this example
generator3 = ThermalStandard(;
    name = "generator3",
    available = true,
    status = true,
    bus = bus,
    active_power = 180.0,
    reactive_power = 35.0,
    rating = 200.0,
    prime_mover_type = PrimeMovers.CT,
    fuel = ThermalFuels.NATURAL_GAS,
    active_power_limits = (min = 30.0, max = 200.0),
    reactive_power_limits = (min = -30.0, max = 60.0),
    ramp_limits = (up = 5.0, down = 5.0),
    time_limits = (up = 1.5, down = 1.0),
    operation_cost = ThermalGenerationCost(;
        variable = FuelCurve(;
            value_curve = LinearCurve(7.8),
            fuel_cost = 5.0,
        ),
        fixed = 9.0,
        start_up = 3500.0,
        shut_down = 1500.0,
    ),
    base_power = 100.0,
)

add_component!(sys, generator3)

# Create Deterministic time series with a 24-hour forecast horizon
# For this example, we'll create a single forecast window
deterministic_data = SortedDict(initial_time => fuel_cost_data)

fuel_cost_deterministic = Deterministic(;
    name = "fuel_cost",
    data = deterministic_data,
    resolution = resolution,
)

set_fuel_cost!(sys, generator3, fuel_cost_deterministic)

# Retrieve the forecast starting at the initial time
fuel_det_forecast = get_fuel_cost(generator3; start_time = initial_time)
first(TimeSeries.values(fuel_det_forecast), 6)
```

## Key Points to Remember

1. **Start with a FuelCurve**: When creating a [`ThermalGenerationCost`](@ref), you must
   use a [`FuelCurve`](@ref) (not a [`CostCurve`](@ref)) if you want to add time series
   fuel costs. The initial `fuel_cost` value in the `FuelCurve` will be replaced by the
   time series.

2. **Use `set_fuel_cost!`**: Always use the [`set_fuel_cost!`](@ref) function to attach
   time series fuel cost data. This function ensures the data is properly validated and
   attached to the correct component.

3. **Choose the right time series type**:
   - Use [`SingleTimeSeries`](@ref) for simple time-varying data (e.g., historical prices)
   - Use [`Deterministic`](@ref) for forecast windows (e.g., day-ahead scheduling with
     rolling horizons)

4. **Match time series resolution**: Ensure your time series resolution matches the
   intended simulation resolution. Common resolutions are hourly (Hour(1)) or sub-hourly
   (Minute(5), Minute(15)).

5. **Units matter**: Fuel cost should be in \$/GJ (or \$/MBtu, etc.) and the heat rate
   in the `FuelCurve` should be in GJ/MWh (or MBtu/MWh). The product of these gives
   the effective cost in \$/MWh.

6. **System must exist first**: You must add the component to the system before you can
   attach time series data to it using `set_fuel_cost!`.

## See Also

- [Add an Operating Cost](@ref cost_how_to) - General guide for adding operational costs
- [Parse Time Series Data from .csv files](@ref parsing_time_series) - How to load time series from CSV files
- [Working with Time Series](@ref) - Tutorial on time series data in PowerSystems
- [`ThermalGenerationCost`](@ref) - API reference for thermal generation costs
- [`FuelCurve`](@ref) - API reference for fuel curves
