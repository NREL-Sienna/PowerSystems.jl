"""
Throws ArgumentError unless the terminal is a Topology or a TradingHub.
"""
_check_ptp_terminal(::Topology) = nothing
_check_ptp_terminal(::TradingHub) = nothing

function _check_ptp_terminal(c::Component)
    throw(
        ArgumentError(
            "PointToPointBid terminals must be a Topology or a TradingHub; got $(typeof(c)) $(get_name(c))",
        ),
    )
end
