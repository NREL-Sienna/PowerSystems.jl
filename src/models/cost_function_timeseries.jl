function get_variable_cost(
    ts::IS.TimeSeriesData,
    component::Component,
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    if start_time === nothing
        start_time = IS.get_initial_timestamp(ts)
    end
    data = IS.get_time_series_array(component, ts, start_time, len = len)
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

function get_variable_cost(
    service::ReserveDemandCurve;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_variable(service)
    if isnothing(time_series_key)
        error("Cost component has a `nothing` stored in field `variable`, Please use `set_variable_cost!` to add variable cost forecast.")
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

function get_services_bid(
    device::StaticInjection,
    cost::MarketBidCost,
    service::Service;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
)
    time_series_key = get_variable(cost)
    raw_data = IS.get_time_series_by_key(
        time_series_key,
        device,
        get_name(service),
        start_time = start_time,
        len = len,
        count = 1,
    )
    cost = get_variable_cost(raw_data, device, start_time, len)
    return cost
end

function set_variable_cost!(
    sys::System,
    component::StaticInjection,
    time_series_data::IS.TimeSeriesData,
)
    add_time_series!(sys, component, time_series_data)
    key = IS.TimeSeriesKey(time_series_data)
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
    key = IS.TimeSeriesKey(time_series_data)
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
    ancillary_services = get_ancillary_services(get_operation_cost(component))
    push!(ancillary_services, service)
    return
end

function verify_device_eligibility(
    sys::System,
    component::StaticInjection,
    service::Service,
)
    contributing_devices = get_contributing_devices(sys, service)
    if !in(component, contributing_devices)
        error("Device $(get_name(component)) isn't eligible to contribute to service $(get_name(service)).")
    end
    return
end
