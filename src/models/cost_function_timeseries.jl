# VALIDATORS
function _validate_market_bid_cost(cost, context)
    (cost isa MarketBidCost) || throw(TypeError(
        StackTraces.stacktrace()[2].func, context, MarketBidCost, cost))
end

function _validate_reserve_demand_curve(cost, name)
    !(cost isa CostCurve{PiecewiseIncrementalCurve}) && throw(
        ArgumentError(
            "Reserve curve of type $(typeof(cost)) on $name cannot represent an ORDC curve, use CostCurve{PiecewiseIncrementalCurve} instead",
        ),
    )
    value_curve = get_value_curve(cost)
    function_data = get_function_data(value_curve)
    x_coords = get_x_coords(function_data)
    slopes = get_y_coords(function_data)
    if first(x_coords) != 0
        error(
            "Reserve demand curve from $name is starting at $(first(x_coords)) and must start at zero.",
        )
    end
    for ix in 1:(length(slopes) - 1)
        if slopes[ix + 1] > slopes[ix]
            error(
                "Reserve demand curve from $name has increasing derivatives and should be non-increasing.",
            )
        end
    end
end

function _validate_fuel_curve(component::Component)
    op_cost = get_operation_cost(component)
    var_cost = get_variable(op_cost)
    !(var_cost isa FuelCurve) && throw(
        ArgumentError(
            "Variable cost of type $(typeof(var_cost)) cannot represent a fuel cost, use FuelCurve instead",
        ),
    )
    return var_cost
end

"""
Validates if a device is eligible to contribute to a service.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `service::Service,`: Service for which the device is eligible to contribute
"""
function verify_device_eligibility(
    sys::System,
    component::StaticInjection,
    service::Service,
)
    if !has_service(component, service)
        error(
            "Device $(get_name(component)) isn't eligible to contribute to service $(get_name(service)).",
        )
    end
    return
end

# GETTER HELPER FUNCTIONS
"""
Call get_time_series_array on the given time series and return a TimeArray of the results,
values mapped by `transform_fn` if it is not nothing
"""
function read_and_convert_ts(
    ts::IS.TimeSeriesData,
    component::Component,
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
    transform_fn = nothing,
)
    isnothing(start_time) && (start_time = IS.get_initial_timestamp(ts))
    isnothing(transform_fn) && (transform_fn = (x -> x))
    data = IS.get_time_series_array(component, ts, start_time; len = len)
    time_stamps = TimeSeries.timestamp(data)
    return TimeSeries.TimeArray(
        time_stamps,
        map(transform_fn, TimeSeries.values(data)),
    )
end

"""
Helper function for cost getters.

# Arguments
- `T`: type/eltype we expect
- `component::Component`: the component
- `cost`: the data: either a single element of type `T` or a `TimeSeriesKey`
- `transform_fn`: a function to apply to the elements of the time series
- `start_time`: as in `get_time_series`
- `len`: as in `get_time_series`
"""
function _process_get_cost(::Type{T}, _, cost::T, transform_fn,
    start_time::Union{Nothing, Dates.DateTime},
    len::Union{Nothing, Int},
) where {T}
    !isnothing(start_time) &&
        throw(ArgumentError("Got non-nothing start_time but this cost is a scalar"))
    !isnothing(len) &&
        throw(ArgumentError("Got non-nothing len but this cost is a scalar"))
    return cost
end

function _process_get_cost(::Type{T}, component::Component, cost::TimeSeriesKey,
    transform_fn,
    start_time::Union{Nothing, Dates.DateTime},
    len::Union{Nothing, Int},
) where {T}
    ts = get_time_series(component, cost, start_time, len, 1)
    converted = read_and_convert_ts(ts, component, start_time, len, transform_fn)
    return converted
end

# GETTER IMPLEMENTATIONS
"""
Retrieve the variable cost bid for a `StaticInjection` device with a `MarketBidCost`. If any
of the relevant fields (`incremental_offer_curves`, `initial_input`, `no_load_cost`) are
time series, the user may specify `start_time` and `len` and the function returns a
`TimeArray` of `CostCurve`s; if the field is not a time series, the function returns a
single `CostCurve`.
"""
function get_variable_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    if typeof(get_incremental_offer_curves(cost)) <: CostCurve
        return get_incremental_offer_curves(cost)
    end
    function_data = if (get_incremental_offer_curves(cost) isa TimeSeriesKey)
        get_incremental_offer_curves(device, cost; start_time = start_time, len = len)
    else
        get_incremental_offer_curves(device, cost)
    end
    initial_input = if (get_incremental_initial_input(cost) isa TimeSeriesKey)
        get_incremental_initial_input(device, cost; start_time = start_time, len = len)
    else
        get_incremental_initial_input(device, cost)
    end
    input_at_zero = if (get_no_load_cost(cost) isa TimeSeriesKey)
        get_no_load_cost(device, cost; start_time = start_time, len = len)
    else
        get_no_load_cost(device, cost)
    end
    params::Vector{Any} = [function_data, initial_input, input_at_zero]
    first_time_series = findfirst(isa.(params, TimeSeries.TimeArray))
    if !isnothing(first_time_series)
        timestamps = TimeSeries.timestamp(params[first_time_series])
        for (i, param) in enumerate(params)
            if !(param isa TimeSeries.TimeArray)
                params[i] =
                    TimeSeries.TimeArray(timestamps, fill(param, length(timestamps)))
            end
        end
        !allequal(TimeSeries.timestamp.(params)) &&
            throw(
                ArgumentError(
                    "Time series mismatch between incremental_offer_curves, incremental_initial_input, and no_load_cost",
                ),
            )
        #@show collect(zip(collect.(TimeSeries.values.(params))...)) |> length
        #@show first(collect(zip(collect.(TimeSeries.values.(params))...)))
        return TimeSeries.TimeArray(TimeSeries.timestamp(function_data),
            [
                _make_market_bid_curve(fd; initial_input = ii, input_at_zero = iaz) for
                (fd, ii, iaz) in collect(zip(collect.(TimeSeries.values.(params))...))
            ])
    end
    return make_market_bid_curve(
        function_data,
        initial_input;
        input_at_zero = input_at_zero,
    )
end

"""
Retrieve the variable cost bid for a `StaticInjection` device with a `MarketBidCost`. If any
of the relevant fields (`incremental_offer_curves`, `initial_input`, `no_load_cost`) are
time series, the user may specify `start_time` and `len` and the function returns a
`TimeArray` of `CostCurve`s; if the field is not a time series, the function returns a
single `CostCurve`.
"""
function get_incremental_variable_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    return get_variable_cost(
        device,
        cost;
        start_time = start_time,
        len = len,
    )
end

"""
Retrieve the variable cost bid for a `StaticInjection` device with a `MarketBidCost`. If any
of the relevant fields (`decremental_offer_curves`, `initial_input`, `no_load_cost`) are
time series, the user may specify `start_time` and `len` and the function returns a
`TimeArray` of `CostCurve`s; if the field is not a time series, the function returns a
single `CostCurve`.
"""
function get_decremental_variable_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    if typeof(get_decremental_offer_curves(cost)) <: CostCurve
        return get_decremental_offer_curves(cost)
    end
    function_data = if (get_decremental_offer_curves(cost) isa TimeSeriesKey)
        get_decremental_offer_curves(device, cost; start_time = start_time, len = len)
    else
        get_decremental_offer_curves(device, cost)
    end
    initial_input = if (get_decremental_initial_input(cost) isa TimeSeriesKey)
        get_decremental_initial_input(device, cost; start_time = start_time, len = len)
    else
        get_decremental_initial_input(device, cost)
    end
    input_at_zero = if (get_no_load_cost(cost) isa TimeSeriesKey)
        get_no_load_cost(device, cost; start_time = start_time, len = len)
    else
        get_no_load_cost(device, cost)
    end
    params::Vector{Any} = [function_data, initial_input, input_at_zero]
    first_time_series = findfirst(isa.(params, TimeSeries.TimeArray))
    if !isnothing(first_time_series)
        timestamps = TimeSeries.timestamp(params[first_time_series])
        for (i, param) in enumerate(params)
            if !(param isa TimeSeries.TimeArray)
                params[i] =
                    TimeSeries.TimeArray(timestamps, fill(param, length(timestamps)))
            end
        end
        !allequal(TimeSeries.timestamp.(params)) &&
            throw(
                ArgumentError(
                    "Time series mismatch between incremental_offer_curves, incremental_initial_input, and no_load_cost",
                ),
            )
        #@show collect(zip(collect.(TimeSeries.values.(params))...)) |> length
        #@show first(collect(zip(collect.(TimeSeries.values.(params))...)))
        return TimeSeries.TimeArray(TimeSeries.timestamp(function_data),
            [
                _make_market_bid_curve(fd; initial_input = ii, input_at_zero = iaz) for
                (fd, ii, iaz) in collect(zip(collect.(TimeSeries.values.(params))...))
            ])
    end
    return make_market_bid_curve(
        function_data,
        initial_input;
        input_at_zero = input_at_zero,
    )
end

"""
Retrieve the variable cost data for a `ReserveDemandCurve`. The user may specify
`start_time` and `len` and the function returns a `TimeArray` of `CostCurve`s.
"""
get_variable_cost(
    service::ReserveDemandCurve;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(CostCurve{PiecewiseIncrementalCurve}, service, get_variable(service),
    _make_market_bid_curve, start_time, len)

"""
Return service bid time series data for a `StaticInjection` device with a `MarketBidCost`.
The user may specify `start_time` and `len` and the function returns a `TimeArray` of
`CostCurve`s.
"""
function get_services_bid(
    device::StaticInjection,
    cost::MarketBidCost,
    service::Service;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    variable_ts_key = get_incremental_offer_curves(cost)
    ts = get_time_series(
        variable_ts_key.time_series_type,
        device,
        get_name(service);
        start_time = start_time,
        len = len,
        count = 1,
    )
    converted = read_and_convert_ts(ts, service, start_time, len, _make_market_bid_curve)
    return converted
end

"Get the fuel cost of the component's variable cost, which must be a `FuelCurve`."
function get_fuel_cost(component::StaticInjection;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    var_cost = _validate_fuel_curve(component)
    return _process_get_cost(
        Float64,
        component,
        get_fuel_cost(var_cost),
        nothing,
        start_time,
        len,
    )
end

"""
Retrieve the `incremental_offer_curves` for a `StaticInjection` device with a
`MarketBidCost`. If this field is a time series, the user may specify `start_time` and `len`
and the function returns a `TimeArray` of `Float64`s; if the field is not a time series, the
function returns a single `Float64` or `Nothing`.
"""
get_incremental_offer_curves(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(Union{PiecewiseStepData, CostCurve{PiecewiseIncrementalCurve}},
    device, get_incremental_offer_curves(cost), nothing, start_time, len)

"""
Retrieve the `decremental_offer_curves` for a `StaticInjection` device with a
`MarketBidCost`. If this field is a time series, the user may specify `start_time` and `len`
and the function returns a `TimeArray` of `Float64`s; if the field is not a time series, the
function returns a single `Float64` or `Nothing`.
"""
get_decremental_offer_curves(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(Union{PiecewiseStepData, CostCurve{PiecewiseIncrementalCurve}},
    device, get_decremental_offer_curves(cost), nothing, start_time, len)

"""
Retrieve the no-load cost data for a `StaticInjection` device with a `MarketBidCost`. If
this field is a time series, the user may specify `start_time` and `len` and the function
returns a `TimeArray` of `Float64`s; if the field is not a time series, the function
returns a single `Float64` or `Nothing`.
"""
get_no_load_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(Union{Nothing, Float64}, device,
    get_no_load_cost(cost), nothing, start_time, len)

"""
Retrieve the `incremental_initial_input` for a `StaticInjection` device with a `MarketBidCost`.
"""
get_incremental_initial_input(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(Union{Nothing, Float64}, device,
    get_incremental_initial_input(cost), nothing, start_time, len)

"""
Retrieve the `decremental_initial_input` for a `StaticInjection` device with a `MarketBidCost`.
"""
get_decremental_initial_input(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(Union{Nothing, Float64}, device,
    get_decremental_initial_input(cost), nothing, start_time, len)

"""
Retrieve the startup cost data for a `StaticInjection` device with a `MarketBidCost`. If
this field is a time series, the user may specify `start_time` and `len` and the function
returns a `TimeArray` of `Float64`s; if the field is not a time series, the function
returns a single `Float64`.
"""
get_start_up(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(StartUpStages, device,
    get_start_up(cost), StartUpStages, start_time, len)

# SETTER HELPER FUNCTIONS
"""
Helper function for cost setters.

# Arguments
- `T1`: type we expect if it's not a time series
- `T2`: eltype we expect if it is a time series
- `sys::System`: the system
- `component::Component`: the component
- `cost`: the data: either a single element of type `T1` or a `IS.TimeSeriesData` of eltype `T2`
"""
_process_set_cost(_, _, _, _, ::Nothing) = nothing

_process_set_cost(::Type{T}, _, _, _, cost::T) where {T} = cost

function _process_set_cost(
    ::Type{_},
    ::Type{T},
    sys::System,
    component::Component,
    cost::IS.TimeSeriesData,
) where {_, T}
    data_type = IS.eltype_data(cost)
    !(data_type <: T) && throw(TypeError(_process_set_cost, T, data_type))
    key = add_time_series!(sys, component, cost)
    return key
end

# SETTER IMPLEMENTATIONS
"""
Set the incremental variable cost bid for a `StaticInjection` device with a `MarketBidCost`.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Nothing, IS.TimeSeriesData,
  CostCurve{PiecewiseIncrementalCurve}},`: the data. If using a time series, must be of eltype
  `PiecewiseStepData`. `PiecewiseIncrementalCurve` is only accepted for single CostCurve and
  not accepted for time series data.
- `power_units::UnitSystem`: Units to be used for data. Must be NATURAL_UNITS.
"""
function set_variable_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Nothing, IS.TimeSeriesData, CostCurve{PiecewiseIncrementalCurve}},
    power_units::UnitSystem,
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")
    if (typeof(data) <: CostCurve{PiecewiseIncrementalCurve}) &&
       (data.power_units != power_units)
        throw(
            ArgumentError(
                "Units specified in CostCurve data differs from the units specified in the set cost.",
            ),
        )
    end
    if (typeof(data) <: IS.TimeSeriesData) && (power_units != UnitSystem.NATURAL_UNITS)
        throw(ArgumentError("Time Series data for MarketBidCost must be in NATURAL_UNITS."))
    end
    to_set = _process_set_cost(
        CostCurve{PiecewiseIncrementalCurve},
        PiecewiseStepData,
        sys,
        component,
        data,
    )

    set_incremental_offer_curves!(market_bid_cost, to_set)
    return
end

function set_variable_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Nothing, IS.TimeSeriesData, CostCurve{PiecewiseIncrementalCurve}},
)
    @warn "Variable Cost UnitSystem not specificied for $(get_name(component)). set_variable_cost! assumes data is in UnitSystem.NATURAL_UNITS"
    set_variable_cost!(sys, component, data, UnitSystem.NATURAL_UNITS)
    return
end

"""
Set the incremental variable cost bid for a `StaticInjection` device with a `MarketBidCost`.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Nothing, IS.TimeSeriesData,
  CostCurve{PiecewiseIncrementalCurve}},`: the data. If using a time series, must be of eltype
  `PiecewiseStepData`. `PiecewiseIncrementalCurve` is only accepted for single CostCurve and
  not accepted for time series data.
- `power_units::UnitSystem`: Units to be used for data.
"""
function set_incremental_variable_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Nothing, IS.TimeSeriesData, CostCurve{PiecewiseIncrementalCurve}},
    power_units::UnitSystem,
)
    set_variable_cost!(sys, component, data, power_units)
    return
end

"""
Set the decremental variable cost bid for a `StaticInjection` device with a `MarketBidCost`.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Nothing, IS.TimeSeriesData,
  CostCurve{PiecewiseIncrementalCurve}},`: the data. If using a time series, must be of eltype
  `PiecewiseStepData`. `PiecewiseIncrementalCurve` is only accepted for single CostCurve and
  not accepted for time series data.
- `power_units::UnitSystem`: Units to be used for data.
"""
function set_decremental_variable_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Nothing, IS.TimeSeriesData, CostCurve{PiecewiseIncrementalCurve}},
    power_units::UnitSystem,
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")

    if (typeof(data) <: CostCurve{PiecewiseIncrementalCurve}) &&
       (data.power_units != power_units)
        throw(
            ArgumentError(
                "Units specified in CostCurve data differs from the units specified in the set cost.",
            ),
        )
    end
    if (typeof(data) <: IS.TimeSeriesData) && (power_units != UnitSystem.NATURAL_UNITS)
        throw(ArgumentError("Time Series data for MarketBidCost must be in NATURAL_UNITS."))
    end
    to_set = _process_set_cost(
        CostCurve{PiecewiseIncrementalCurve},
        PiecewiseStepData,
        sys,
        component,
        data,
    )

    set_decremental_offer_curves!(market_bid_cost, to_set)
    return
end

"""
Adds energy market bids time-series to the ReserveDemandCurve.

# Arguments
- `sys::System`: PowerSystem System
- `component::ReserveDemandCurve`: the curve
- `time_series_data::IS.TimeSeriesData`: TimeSeriesData
"""
function set_variable_cost!(
    sys::System,
    component::ReserveDemandCurve,
    data::Union{Nothing, IS.TimeSeriesData},
)
    # TODO what type checking should be enforced on this time series?
    to_set = _process_set_cost(Any, Any, sys, component, data)
    set_variable!(component, to_set)
end

"""
Adds fixed energy market bids to the ReserveDemandCurve.

# Arguments
- `sys::System`: PowerSystem System
- `component::ReserveDemandCurve`: the curve
- `time_series_data::CostCurve{PiecewiseIncrementalCurve}
"""
function set_variable_cost!(
    ::System,
    component::ReserveDemandCurve,
    data::CostCurve{PiecewiseIncrementalCurve},
)
    name = get_name(component)
    _validate_reserve_demand_curve(data, name)
    set_variable!(component, data)
end

"Set the fuel cost of the component's variable cost, which must be a `FuelCurve`."
function set_fuel_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Float64, IS.TimeSeriesData},
)
    var_cost = _validate_fuel_curve(component)
    to_set = _process_set_cost(Float64, Float64, sys, component, data)
    op_cost = get_operation_cost(component)
    new_var_cost =
        FuelCurve(get_value_curve(var_cost), get_power_units(var_cost), to_set)
    set_variable!(op_cost, new_var_cost)
end

"""
Set the no-load cost for a `StaticInjection` device with a `MarketBidCost` to either a scalar or a time series.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Float64, IS.TimeSeriesData},`: the data. If a time series, must be of eltype `Float64`.
"""
function set_no_load_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Float64, IS.TimeSeriesData},
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")
    to_set = _process_set_cost(Union{Float64, Nothing}, Float64, sys, component, data)
    set_no_load_cost!(market_bid_cost, to_set)
end

"""
Set the `incremental_initial_input` for a `StaticInjection` device with a `MarketBidCost` to either a scalar or a time series.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Float64, IS.TimeSeriesData},`: the data. If a time series, must be of eltype `Float64`.
"""
function set_incremental_initial_input!(
    sys::System,
    component::StaticInjection,
    data::Union{Float64, IS.TimeSeriesData},
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")
    to_set = _process_set_cost(Union{Float64, Nothing}, Float64, sys, component, data)
    set_incremental_initial_input!(market_bid_cost, to_set)
end

"""
Set the `decremental_initial_input` for a `StaticInjection` device with a `MarketBidCost` to either a scalar or a time series.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Float64, IS.TimeSeriesData},`: the data. If a time series, must be of eltype `Float64`.
"""
function set_decremental_initial_input!(
    sys::System,
    component::StaticInjection,
    data::Union{Float64, IS.TimeSeriesData},
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")
    to_set = _process_set_cost(Union{Float64, Nothing}, Float64, sys, component, data)
    set_decremental_initial_input!(market_bid_cost, to_set)
end

"""
Set the startup cost for a `StaticInjection` device with a `MarketBidCost` to either a single `StartUpStages` or a time series.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{StartUpStages, IS.TimeSeriesData},`: the data. If a time series, must be of eltype `NTuple{3, Float64}`.
"""
function set_start_up!(
    sys::System,
    component::StaticInjection,
    data::Union{StartUpStages, IS.TimeSeriesData},
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")
    to_set = _process_set_cost(StartUpStages, NTuple{3, Float64}, sys, component, data)
    set_start_up!(market_bid_cost, to_set)
end

"""
Adds service bids time-series data to the MarketBidCost.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `service::Service,`: Service for which the device is eligible to contribute
- `time_series_data::IS.TimeSeriesData`: TimeSeriesData
"""
function set_service_bid!(
    sys::System,
    component::StaticInjection,
    service::Service,
    time_series_data::IS.TimeSeriesData,
    power_units::UnitSystem,
)
    data_type = IS.eltype_data(time_series_data)
    !(data_type <: PiecewiseStepData) &&
        throw(TypeError(set_service_bid!, PiecewiseStepData, data_type))
    _validate_market_bid_cost(
        get_operation_cost(component),
        "get_operation_cost(component)",
    )
    if get_name(time_series_data) != get_name(service)
        error(
            "Name provided in the TimeSeries Data $(get_name(time_series_data)), doesn't match the Service $(get_name(service)).",
        )
    end
    if power_units != UnitSystem.NATURAL_UNITS
        throw(
            ArgumentError(
                "Power Unit specified for service market bids must be NATURAL_UNITS",
            ),
        )
    end
    verify_device_eligibility(sys, component, service)
    add_time_series!(sys, component, time_series_data)
    ancillary_service_offers = get_ancillary_service_offers(get_operation_cost(component))
    push!(ancillary_service_offers, service)
    return
end
