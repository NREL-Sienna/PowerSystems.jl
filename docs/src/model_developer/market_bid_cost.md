# PowerSystems MarketBidCost example

## MarketBidCost 
Is an [`OperationalCost`](@ref)  data structure that allows the user to run a production cost model that is very similar to most US electricity market auctions with bids for energy and ancillary services jointly.

## Adding Energy bids to MarketBidCost

### Step 1: Constructiong device with MarketBidCost
When using MarketBidCost, the user can add the cost struct to the , at this point the actual cost bids aren't expected to be populated/passed. The code below shows how we can create a thermal device with MarketBidCost.

```@example
Using PowerSystems
bus = Bus(1, "nodeE", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing)

generator = ThermalStandard(
        name = "Brighton",
        available = true,
        status = true,
        bus = bus,
        active_power = 6.0,
        reactive_power = 1.50,
        rating = 0.75,
        prime_mover = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 6.0),
        reactive_power_limits = (min = -4.50, max = 4.50),
        time_limits = (up = 0.015, down = 0.015),
        ramp_limits = (up = 5.0, down = 3.0),
        operation_cost = MarketBidCost(
            nothing, 
            0.0, 
            (hot = 393.28, warm = 455.37, cold = 703.76),, 
            0.75, 
            Vector{Service}()
            ),
        base_power = 100.0,
    ),

```
### Step 2: Creating the TimeSeriesData
The user is expected to pass the TimeSeriesData that holds the energy bid data which can be of any type (i.e. `SingleTimeSeries` or `Deterministic`) and data can be `Array{Float64}`, `Array{Tuple{Float64, Float64}}` or `Array{Array{Tuple{Float64,Float64}}`. If the data is just floats then the cost in the optimization is seen as a constant variable cost, but if data is a Tuple or Array{Tuple} then the model expects the tuples to be cost & power-point pairs (cost in $/p.u-hr & power-point in p.u-hr), which is modeled same as TwoPartCost or ThreePartCost. Code below shows an example of how to build a TimeSeriesData.

```@example
Using PowerSystems
data =
    Dict(Dates.DateTime("2020-01-01") => [
        [(0.0, 0.05), (290.1, 0.0733), (582.72, 0.0967), (894.1, 0.120)],
        [(0.0, 0.05), (300.1, 0.0733), (600.72, 0.0967), (900.1, 0.120)]
    )
time_series_data = Deterministic(
    name = "variable_cost",
    data = data, 
    resolution = Dates.Hour(1)
)
```

### Step 3a: Adding Energy Bid TimeSeriesData to the device
To add energy market bids time-series to the MarketBidCost, the use of `set_variable_cost!` is recommended. 

```@example
Using PowerSystems
bus = Bus(1, "nodeE", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing)
generator = ThermalStandard(
    name = "Brighton",
    available = true,
    status = true,
    bus = bus,
    active_power = 6.0,
    reactive_power = 1.50,
    rating = 0.75,
    prime_mover = PrimeMovers.ST,
    fuel = ThermalFuels.COAL,
    active_power_limits = (min = 0.0, max = 6.0),
    reactive_power_limits = (min = -4.50, max = 4.50),
    time_limits = (up = 0.015, down = 0.015),
    ramp_limits = (up = 5.0, down = 3.0),
    operation_cost = MarketBidCost(
        nothing, 
        0.0, 
        (hot = 393.28, warm = 455.37, cold = 703.76),
        0.75, 
        Vector{Service}()
        ),
    base_power = 100.0,
)
sys = System(100.0, [bus], [generator])
data =
    Dict(Dates.DateTime("2020-01-01") => [
        [(0.0, 0.05), (290.1, 0.0733), (582.72, 0.0967), (894.1, 0.120)],
        [(0.0, 0.05), (300.1, 0.0733), (600.72, 0.0967), (900.1, 0.120)],]
    )
time_series_data = Deterministic(
    name = "variable_cost",
    data = data, 
    resolution = Dates.Hour(1)
)
set_variable_cost!(sys, generator, time_series_data)
```
#### Arguments for set_variable_cost!
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::TimeSeriesData`: TimeSeriesData

### Step 3b: Adding Service Bid TimeSeriesData to the device
Similar to adding energy market bids,  for adding bids for ancillary services the use of `set_service_bid!` is recommended. 

```@example
using PowerSystems
using Dates
bus = Bus(1, "nodeE", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing)
service = VariableReserve{ReserveUp}("test_reserve", true, 0.6, 2.0)
generator = ThermalStandard(
    name = "Brighton",
    available = true,
    status = true,
    bus = bus,
    active_power = 6.0,
    reactive_power = 1.50,
    rating = 0.75,
    prime_mover = PrimeMovers.ST,
    fuel = ThermalFuels.COAL,
    active_power_limits = (min = 0.0, max = 6.0),
    reactive_power_limits = (min = -4.50, max = 4.50),
    time_limits = (up = 0.015, down = 0.015),
    ramp_limits = (up = 5.0, down = 3.0),
    operation_cost = MarketBidCost(
        nothing, 
        0.0,
        (hot = 393.28, warm = 455.37, cold = 703.76),
        0.75, 
        Vector{Service}()
        ),
    base_power = 100.0,
    services = Vector{Service}(),
)
sys = System(100.0, [bus], [generator])
add_service!(sys, service, get_components(ThermalStandard, sys))
data =
    Dict(Dates.DateTime("2020-01-01") => [650.3, 750.0])
time_series_data = Deterministic(
    name = get_name(service),
    data = data, 
    resolution = Dates.Hour(1)
)
set_service_bid!(sys, generator, service, time_series_data)
```
#### Arguments for set_service_bid!
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `service::Service,`: Service for which the device is eligible to contribute
- `time_series_data::IS.TimeSeriesData`: TimeSeriesData
