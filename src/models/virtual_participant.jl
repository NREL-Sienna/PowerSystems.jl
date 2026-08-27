"""
Add `hub` to `vp` without checking that both are attached to the same system.
"""
function add_trading_hub_internal!(vp::VirtualParticipant, hub::TradingHub)
    if has_trading_hub(vp, hub)
        error("Hub $(get_name(hub)) is already associated with $(get_name(vp))")
    end
    push!(get_trading_hubs(vp), hub)
    return nothing
end

"""
Return true if `hub` is associated with `vp`.
"""
function has_trading_hub(vp::VirtualParticipant, hub::TradingHub)
    for _hub in get_trading_hubs(vp)
        if IS.get_id(_hub) == IS.get_id(hub)
            return true
        end
    end
    return false
end

"""
Remove `hub` from `vp` if it is associated; return whether it was removed.
"""
function _remove_trading_hub!(vp::VirtualParticipant, hub::TradingHub)
    removed = false
    hubs = get_trading_hubs(vp)
    for (i, _hub) in enumerate(hubs)
        if IS.get_id(_hub) == IS.get_id(hub)
            deleteat!(hubs, i)
            removed = true
            break
        end
    end
    return removed
end

"""
Remove `hub` from `vp`.

Throws ArgumentError if the hub is not associated with `vp`.
"""
function remove_trading_hub!(vp::VirtualParticipant, hub::TradingHub)
    if !_remove_trading_hub!(vp, hub)
        throw(
            ArgumentError(
                "hub $(get_name(hub)) was not associated with $(get_name(vp))",
            ),
        )
    end
    return
end

"""
Remove all trading hubs associated with `vp`.
"""
function clear_trading_hubs!(vp::VirtualParticipant)
    empty!(get_trading_hubs(vp))
    return
end
