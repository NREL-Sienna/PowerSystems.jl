# PowerSystems [`MarketBidCost`](@ref)

Is an `OperationalCost` data structure that allows the user to run a production
cost model that is very similar to most US electricity market auctions with bids for energy
and ancillary services jointly. This page showcases how to create data for this cost function.

## Adding Energy bids to MarketBidCost

### Step 1: Constructiong device with MarketBidCost

When using [`MarketBidCost`](@ref), the user can add the cost struct to the device specifying
only certain elements, at this point the actual energy cost bids don't need to be populated/passed.

The code below shows an example how we can create a thermal device with MarketBidCost.

```@repl market_bid_cost
using PowerSystems, Dates
bus = ACBus(1, "nodeE", "REF", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing)

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
            no_load = 0.0,
            start_up = (hot = 0.0, warm = 0.0, cold = 0.0),
            shut_down = 0.0,
        ),
        base_power = 100.0,
    )
```

### Step 2: Creating the `TimeSeriesData` for the Market Bid

The user is expected to pass the `TimeSeriesData` that holds the energy bid data which can be
of any type (i.e. `SingleTimeSeries` or `Deterministic`) and data can be `Array{Float64}`,
`Array{Tuple{Float64, Float64}}` or `Array{Array{Tuple{Float64,Float64}}`. If the data is
just floats then the cost in the optimization is seen as a constant variable cost, but if
data is a Tuple or `Array{Tuple}` then the model expects the tuples to be cost & power-point
pairs (cost in $/p.u-hr & power-point in p.u-hr), which is modeled same as TwoPartCost or
ThreePartCost. Code below shows an example of how to build a TimeSeriesData.

```@repl market_bid_cost
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
```

**NOTE:** Due to [limitations in DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl/issues/239),
in `PowerSystems.jl` when creating Forecasts or TimeSeries for your MarketBidCost, you need
to define your data as in the example or with a very explicit container. Otherwise, it won't
discern the types properly in the constructor and will return `SortedDict{Any,Any,Base.Order.ForwardOrdering}` which causes the constructor in `PowerSystems.jl` to fail. For instance, you need to define
the `Dict` with the data as follows:

```julia
    # Very verbose dict definition
    data = Dict{DateTime,Array{Array{Tuple{Float64,Float64},1},1}}()
    for t in range(initial_time_sys; step = Hour(1), length = window_count)
        data[t] = MY_BID_DATA
    end
```

### Step 3a: Adding Energy Bid TimeSeriesData to the device

To add energy market bids time-series to the `MarketBidCost`, the use of `set_variable_cost!`
is recommended. The arguments for `set_variable_cost!` are:

- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::TimeSeriesData`: TimeSeriesData

```@repl market_bid_cost
sys = System(100.0, [bus], [generator])
set_variable_cost!(sys, generator, time_series_data)
```

### Step 3b: Adding Service Bid TimeSeriesData to the device

Similar to adding energy market bids, for adding bids for ancillary services the use of
`set_service_bid!` is recommended.

```@repl market_bid_cost
service = VariableReserve{ReserveUp}("example_reserve", true, 0.6, 2.0)
add_service!(sys, service, get_component(ThermalStandard, sys, "Brighton"))
data =
    Dict(Dates.DateTime("2020-01-01") => [650.3, 750.0])
time_series_data = Deterministic(
    name = get_name(service),
    data = data,
    resolution = Dates.Hour(1)
)
set_service_bid!(sys, generator, service, time_series_data)
```
