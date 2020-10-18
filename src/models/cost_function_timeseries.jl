function get_variable_cost(
    ts::IS.TimeSeriesData,
    component::Component,
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    data = IS.get_time_series_array(component, ts, start_time = start_time, len = len)
    time_stamps = TimeSeries.timestamp(data)
    return TimeSeries.TimeArray(time_stamps, map(VariableCost, TimeSeries.values(data)))
end

function get_variable_cost(
    device::StaticInjection,
    cost::OperationalCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_variable(cost)
    if isnothing(time_series_key)
        error("Cost component has a `nothing` stored in field `variable`, Please use `set_variable_cost!` to add variable cost forecast.")
    end
    raw_data = IS.get_time_series_values(
        time_series_key.time_series_type,
        device,
        time_series_key.name,
        start_time = start_time,
        len = len,
    )
    time_stamps = IS.get_time_series_timestamps(
        time_series_key.time_series_type,
        device,
        time_series_key.name,
        start_time = start_time,
        len = len,
    )
    return TimeSeries.TimeArray(time_stamps, map(VariableCost, raw_data))
end

function get_services_bid(
    device::StaticInjection,
    cost::MarketBidCost,
    service::Service;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    services_dict = get_ancillary_services(cost)
    time_series_type = services_dict[get_name(service)]
    raw_data = IS.get_time_series_values(
        time_series_type,
        device,
        get_name(service),
        start_time = start_time,
        len = len,
    )
    time_stamps = IS.get_time_series_timestamps(
        time_series_type,
        device,
        get_name(service),
        start_time = start_time,
        len = len,
    )
    return TimeSeries.TimeArray(time_stamps, map(VariableCost, raw_data))
end

function set_variable_cost!(
    sys::System,
    component::StaticInjection,
    time_series_data::IS.TimeSeriesData,
)
    add_time_series!(sys, component, time_series_data)
    metadata_type = IS.time_series_data_to_metadata(typeof(time_series_data))
    key = IS.TimeSeriesKey(metadata_type, get_name(time_series_data))
    market_bid_cost = get_operation_cost(component)
    set_variable!(market_bid_cost, key)
    return
end

function set_variable_cost!(
    sys::System,
    component::ReserveDemandCurve,
    time_series_data::IS.TimeSeriesData,
)
    add_time_series!(sys, component, time_series_data)
    metadata_type = IS.time_series_data_to_metadata(typeof(time_series_data))
    key = IS.TimeSeriesKey(metadata_type, get_name(time_series_data))
    set_variable!(component, key)
    return
end

function set_service_bid!(
    sys::System,
    component::StaticInjection,
    service::Service,
    time_series_data::IS.TimeSeriesData,
)
    if get_name(time_series_data) != get_name(service)
        error("Name provided in the TimeSeries Data $(get_name(time_series_data)), doesn't match the Service $(get_name(service)).")
    end
    verify_device_eligibility(sys, component, service)
    add_time_series!(sys, component, time_series_data)
    metadata_type = IS.time_series_data_to_metadata(typeof(time_series_data))
    market_bid_cost = get_operation_cost(component)
    services_dict = get_ancillary_services(market_bid_cost)
    services_dict[get_name(service)] = metadata_type
    return
end

function verify_device_eligibility(
    sys::System,
    component::StaticInjection,
    service::Service,
)
    contributing_devices = get_contributing_devices(sys, service)
    if !in(get_name(component), contributing_devices)
        error("Device $(get_name(component)) isn't eligible to contribute to service $(get_name(service)).")
    end
    return
end
