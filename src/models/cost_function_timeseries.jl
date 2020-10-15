function get_variable_cost(ts::IS.TimeSeriesData, ::MarketBidCost)
    data = TimeSeries.TimeArray(TimeSeries.timestamp(ts), map(VariableCost, ts.data))
    return data
end

function get_variable_cost(
    device::Generator,
    cost::MarketBidCost;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_variable(cost)
    ts_contanier = IS.get_time_series_container(device)
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
    device::Generator,
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
    component::Generator,
    time_series_data::IS.TimeSeriesData,
)
    add_time_series!(sys, component, time_series_data)
    metadata_type = IS.time_series_data_to_metadata(typeof(time_series_data))
    key = IS.TimeSeriesKey(metadata_type, get_name(time_series_data))
    market_bid_cost = get_operation_cost(component)
    set_variable!(market_bid_cost, key)
    return
end

function set_service_bid!(
    sys::System,
    component::Generator,
    service::Service,
    time_series_data::IS.TimeSeriesData,
)
    @assert get_name(time_series_data) == get_name(service)
    add_time_series!(sys, component, time_series_data)
    metadata_type = IS.time_series_data_to_metadata(typeof(time_series_data))
    market_bid_cost = get_operation_cost(component)
    services_dict = get_ancillary_services(market_bid_cost)
    services_dict[get_name(service)] = metadata_type
    return
end
