# MarketBidCost has two variable costs, here we mean the incremental one
get_generation_variable_cost(cost::MarketBidCost) = get_incremental_offer_curves(cost)
set_generation_variable_cost!(cost::MarketBidCost, val) =
    set_incremental_offer_curves!(cost, val)
get_generation_variable_cost(cost::OperationalCost) = get_variable_cost(cost)
set_generation_variable_cost!(cost::OperationalCost, val) = set_variable_cost(cost, val)

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
    # TODO initially this was mapping PiecewiseLinearSlopeData over the raw data. Now the
    # data is PiecewiseLinearData. Has something been lost in translation?
    return data
    # return TimeSeries.TimeArray(
    #     time_stamps,
    #     map(PiecewiseLinearSlopeData, TimeSeries.values(data)),
    # )
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
    cost::OperationalCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_generation_variable_cost(cost)
    if isnothing(time_series_key)
        error(
            "Cost component is empty, please use `set_variable_cost!` to add variable cost forecast.",
        )
    end
    raw_data = IS.get_time_series_by_key(
        time_series_key,
        device;
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
    raw_data = IS.get_time_series_by_key(
        time_series_key,
        service;
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
    variable_ts_key = get_generation_variable_cost(cost)
    service_ts_key = IS.TimeSeriesKey(variable_ts_key.time_series_type, get_name(service))
    raw_data = IS.get_time_series_by_key(
        service_ts_key,
        device;
        start_time = start_time,
        len = len,
        count = 1,
    )
    cost = get_variable_cost(raw_data, device, start_time, len)
    return cost
end

"""
Adds energy market bids time-series to the MarketBidCost.

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
    add_time_series!(sys, component, time_series_data)
    key = IS.TimeSeriesKey(time_series_data)
    market_bid_cost = get_operation_cost(component)
    set_generation_variable_cost!(market_bid_cost, key)
    return
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
    add_time_series!(sys, component, time_series_data)
    key = IS.TimeSeriesKey(time_series_data)
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
    if get_name(time_series_data) != get_name(service)
        error(
            "Name provided in the TimeSeries Data $(get_name(time_series_data)), doesn't match the Service $(get_name(service)).",
        )
    end
    verify_device_eligibility(sys, component, service)
    add_time_series!(sys, component, time_series_data)
    ancillary_services = get_ancillary_services(get_operation_cost(component))
    push!(ancillary_services, service)
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
