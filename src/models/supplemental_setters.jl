function set_upstream_turbine!(reservoir::HydroReservoir, turbine::HydroUnit)
    set_upstream_turbines!(reservoir, [turbine])
    return
end

function set_downstream_turbine!(reservoir::HydroReservoir, turbine::HydroUnit)
    set_downstream_turbines!(reservoir, [turbine])
    return
end
