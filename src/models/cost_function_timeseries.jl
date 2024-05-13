# VALIDATORS
function _validate_market_bid_cost(cost, context)
    (cost isa MarketBidCost) || throw(TypeError(
        StackTraces.stacktrace()[2].func, context, MarketBidCost, cost))
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
_process_get_cost(_, _, cost::Nothing, _, _, _, _) = throw(
    ArgumentError(
        "This cost component is empty, please use the corresponding setter to add cost data.",
    ),
)

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
Retrieve the variable cost bid for a `StaticInjection` device with a `MarketBidCost`. If
this field is a time series, the user may specify `start_time` and `len` and the function
returns a `TimeArray` of `CostCurve`s; if the field is not a time series, the function
returns a single `CostCurve`.
"""
get_variable_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(CostCurve{PiecewiseIncrementalCurve}, device,
    get_incremental_offer_curves(cost), make_market_bid_curve, start_time, len)

"""
Retrieve the variable cost data for a `ReserveDemandCurve`. The user may specify
`start_time` and `len` and the function returns a `TimeArray` of `CostCurve`s.
"""
get_variable_cost(
    service::ReserveDemandCurve;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(CostCurve{PiecewiseIncrementalCurve}, service, get_variable(service),
    make_market_bid_curve, start_time, len)

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
    converted = read_and_convert_ts(ts, service, start_time, len, make_market_bid_curve)
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
Retrieve the no-load cost data for a `StaticInjection` device with a `MarketBidCost`. If
this field is a time series, the user may specify `start_time` and `len` and the function
returns a `TimeArray` of `Float64`s; if the field is not a time series, the function
returns a single `Float64`.
"""
get_no_load_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) = _process_get_cost(Float64, device,
    get_no_load_cost(cost), nothing, start_time, len)

"""
Retrieve the no-load cost data for a `StaticInjection` device with a `MarketBidCost`. If
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
Set the variable cost bid for a `StaticInjection` device with a `MarketBidCost`.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::Union{Nothing, IS.TimeSeriesData,
  CostCurve{PiecewiseIncrementalCurve}},`: the data. If a time series, must be of eltype
  `PiecewiseStepData`.
"""
function set_variable_cost!(
    sys::System,
    component::StaticInjection,
    data::Union{Nothing, IS.TimeSeriesData, CostCurve{PiecewiseIncrementalCurve}},
)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")
    to_set = _process_set_cost(
        CostCurve{PiecewiseIncrementalCurve},
        PiecewiseStepData,
        sys,
        component,
        data,
    )
    set_incremental_offer_curves!(market_bid_cost, to_set)
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
Set the no-load cost for a `StaticInjection` device with a `MarketBidCost` to either a single number or a time series.

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
    to_set = _process_set_cost(Float64, Float64, sys, component, data)
    set_no_load_cost!(market_bid_cost, to_set)
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
    verify_device_eligibility(sys, component, service)
    add_time_series!(sys, component, time_series_data)
    ancillary_service_offers = get_ancillary_service_offers(get_operation_cost(component))
    push!(ancillary_service_offers, service)
    return
end
