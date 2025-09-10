function set_reservoirs!(turbine::HydroTurbine, reservoir::HydroReservoir)
    set_reservoirs!(turbine, [reservoir])
    return
end
