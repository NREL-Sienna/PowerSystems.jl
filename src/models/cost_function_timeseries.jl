function _validate_time_series_variable_cost(
    time_series_data::IS.TimeSeriesData;
    desired_type::Type = PiecewiseStepData,
)
    data_type = IS.eltype_data(time_series_data)
    (data_type <: desired_type) || throw(
        TypeError(
            StackTraces.stacktrace()[2].func, "time series data", desired_type,
            data_type),
    )
end

function _validate_market_bid_cost(cost, context)
    (cost isa MarketBidCost) || throw(TypeError(
        StackTraces.stacktrace()[2].func, context, MarketBidCost, cost))
end

"""
Returns variable cost bids time-series data.

# Arguments
- `ts::IS.TimeSeriesData`:TimeSeriesData
- `component::Component`: Component
- `start_time::Union{Nothing, Dates.DateTime} = nothing`: Time when the time-series data starts
- `len::Union{Nothing, Int} = nothing`: Length of the time-series to be returned
"""
function get_variable_cost(
    ts::IS.TimeSeriesData,
    component::Component,
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    if start_time === nothing
        start_time = IS.get_initial_timestamp(ts)
    end
    data = IS.get_time_series_array(component, ts, start_time; len = len)
    time_stamps = TimeSeries.timestamp(data)
    return TimeSeries.TimeArray(
        time_stamps,
        map(make_market_bid_curve, TimeSeries.values(data)),
    )
end

"""
Returns variable cost bids time-series data for MarketBidCost.

# Arguments
- `device::StaticInjection`: Static injection device
- `cost::MarketBidCost`: Operations Cost
- `start_time::Union{Nothing, Dates.DateTime} = nothing`: Time when the time-series data starts
- `len::Union{Nothing, Int} = nothing`: Length of the time-series to be returned
"""
function get_variable_cost(
    device::StaticInjection,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_incremental_offer_curves(cost)
    if isnothing(time_series_key)
        error(
            "Cost component is empty, please use `set_variable_cost!` to add variable cost forecast.",
        )
    end
    raw_data = get_time_series(
        get_time_series_type(time_series_key),
        device,
        get_name(time_series_key);
        start_time = start_time,
        len = len,
        count = 1,
    )
    cost = get_variable_cost(raw_data, device, start_time, len)
    return cost
end

"""
Returns variable cost time-series data for a ReserveDemandCurve.

# Arguments
- `service::ReserveDemandCurve`: ReserveDemandCurve
- `start_time::Union{Nothing, Dates.DateTime} = nothing`: Time when the time-series data starts
- `len::Union{Nothing, Int} = nothing`: Length of the time-series to be returned
"""
function get_variable_cost(
    service::ReserveDemandCurve;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_variable(service)
    if isnothing(time_series_key)
        error(
            "Cost component has a `nothing` stored in field `variable`, Please use `set_variable_cost!` to add variable cost forecast.",
        )
    end
    raw_data = get_time_series(
        get_time_series_type(time_series_key),
        service,
        get_name(time_series_key);
        start_time = start_time,
        len = len,
        count = 1,
    )
    cost = get_variable_cost(raw_data, service, start_time, len)
    return cost
end

"""
Returns service bids time-series data for a device that has MarketBidCost.

# Arguments
- `sys::System`: PowerSystem System
- `cost::MarketBidCost`: Operations Cost
- `service::Service`: Service
- `start_time::Union{Nothing, Dates.DateTime} = nothing`: Time when the time-series data starts
- `len::Union{Nothing, Int} = nothing`: Length of the time-series to be returned
"""
function get_services_bid(
    device::StaticInjection,
    cost::MarketBidCost,
    service::Service;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    variable_ts_key = get_incremental_offer_curves(cost)
    raw_data = get_time_series(
        variable_ts_key.time_series_type,
        device,
        get_name(service);
        start_time = start_time,
        len = len,
        count = 1,
    )
    cost = get_variable_cost(raw_data, device, start_time, len)
    return cost
end

"""
Adds energy market bid time series to the component's operation cost, which must be a MarketBidCost.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::IS.TimeSeriesData`: TimeSeriesData
"""
function set_variable_cost!(
    sys::System,
    component::StaticInjection,
    time_series_data::IS.TimeSeriesData,
)
    _validate_time_series_variable_cost(time_series_data)
    market_bid_cost = get_operation_cost(component)
    _validate_market_bid_cost(market_bid_cost, "get_operation_cost(component)")

    key = add_time_series!(sys, component, time_series_data)
    set_incremental_offer_curves!(market_bid_cost, key)
    return
end

function _process_fuel_cost(
    ::Component,
    fuel_cost::Float64,
    start_time::Union{Nothing, Dates.DateTime},
    len::Union{Nothing, Int},
)
    isnothing(start_time) && isnothing(len) && return fuel_cost
    throw(ArgumentError("Got time series start_time and/or len, but fuel cost is a scalar"))
end

function _process_fuel_cost(
    component::Component,
    ts_key::TimeSeriesKey,
    start_time::Union{Nothing, Dates.DateTime},
    len::Union{Nothing, Int},
)
    ts = get_time_series(component, ts_key, start_time, len)
    if start_time === nothing
        start_time = IS.get_initial_timestamp(ts)
    end
    return get_time_series_array(component, ts, start_time; len = len)
end

"Get the fuel cost of the component's variable cost, which must be a `FuelCurve`."
function get_fuel_cost(component::StaticInjection;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing)
    op_cost = get_operation_cost(component)
    var_cost = get_variable(op_cost)
    !(var_cost isa FuelCurve) && throw(
        ArgumentError(
            "Variable cost of type $(typeof(var_cost)) cannot represent a fuel cost, use FuelCurve instead",
        ),
    )
    return _process_fuel_cost(component, get_fuel_cost(var_cost), start_time, len)
end

function _set_fuel_cost!(component::StaticInjection, fuel_cost)
    op_cost = get_operation_cost(component)
    var_cost = get_variable(op_cost)
    !(var_cost isa FuelCurve) && throw(
        ArgumentError(
            "Variable cost of type $(typeof(var_cost)) cannot represent a fuel cost, use FuelCurve instead",
        ),
    )
    new_var_cost =
        FuelCurve(get_value_curve(var_cost), get_power_units(var_cost), fuel_cost)
    set_variable!(op_cost, new_var_cost)
end

"Set the fuel cost of the component's variable cost, which must be a `FuelCurve`, to a scalar value."
set_fuel_cost!(_::System, component::StaticInjection, fuel_cost::Real) =
# the System is not required, but we take it for consistency with the time series method of this function
    _set_fuel_cost!(component, Float64(fuel_cost))

"Set the fuel cost of the component's variable cost, which must be a `FuelCurve`, to a time series value."
function set_fuel_cost!(
    sys::System,
    component::StaticInjection,
    time_series_data::IS.TimeSeriesData,
)
    _validate_time_series_variable_cost(time_series_data; desired_type = Float64)
    key = add_time_series!(sys, component, time_series_data)
    _set_fuel_cost!(component, key)
end

"""
Adds energy market bids time-series to the ReserveDemandCurve.

# Arguments
- `sys::System`: PowerSystem System
- `component::StaticInjection`: Static injection device
- `time_series_data::IS.TimeSeriesData`: TimeSeriesData
"""
function set_variable_cost!(
    sys::System,
    component::ReserveDemandCurve,
    time_series_data::IS.TimeSeriesData,
)
    key = add_time_series!(sys, component, time_series_data)
    set_variable!(component, key)
    return
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
    _validate_time_series_variable_cost(time_series_data)
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
