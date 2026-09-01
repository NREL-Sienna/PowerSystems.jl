"""Return the member buses of `hub`."""
function get_associated_buses(hub::TradingHub)
    return get_buses(hub)
end

"""
Return true if `bus` is a member of `hub`.
"""
function has_hub_bus(hub::TradingHub, bus::ACBus)
    for _bus in get_associated_buses(hub)
        if IS.get_id(_bus) == IS.get_id(bus)
            return true
        end
    end
    return false
end

"""
Add `bus` to `hub`'s member buses without checking that both are attached to the same system.
"""
function add_hub_bus_internal!(hub::TradingHub, bus::ACBus)
    if has_hub_bus(hub, bus)
        throw(
            ArgumentError(
                "bus $(get_name(bus)) is already associated with $(get_name(hub))",
            ),
        )
    end
    push!(get_buses(hub), bus)
    return nothing
end
