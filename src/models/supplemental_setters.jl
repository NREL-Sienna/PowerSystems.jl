"""
Set a single upstream turbine for a [`HydroReservoir`](@ref).
"""
function set_upstream_turbine!(reservoir::HydroReservoir, turbine::HydroUnit)
    set_upstream_turbines!(reservoir, [turbine])
    return
end

"""
Set a single downstream turbine for a [`HydroReservoir`](@ref).
"""
function set_downstream_turbine!(reservoir::HydroReservoir, turbine::HydroUnit)
    set_downstream_turbines!(reservoir, [turbine])
    return
end

function set_head_to_volume_factor!(reservoir::HydroReservoir, val::Float64)
    return set_head_to_volume_factor!(reservoir, LinearCurve(val))
end

function _raise_if_attached_to_system(hybrid::HybridSystem)
    if !isnothing(IS.get_time_series_manager(hybrid))
        throw(
            ArgumentError(
                "Operation not allowed because the HybridSystem is attached to a system",
            ),
        )
    end
    return
end

"""Set [`HybridSystem`](@ref) thermal unit"""
function set_thermal_unit!(hybrid::HybridSystem, val::ThermalGen)
    _raise_if_attached_to_system(hybrid)
    hybrid.thermal_unit = val
    return
end

"""Set [`HybridSystem`](@ref) load"""
function set_electric_load!(hybrid::HybridSystem, val::ElectricLoad)
    _raise_if_attached_to_system(hybrid)
    hybrid.electric_load = val
    return
end

"""Set [`HybridSystem`](@ref) storage unit"""
function set_storage!(hybrid::HybridSystem, val::Storage)
    _raise_if_attached_to_system(hybrid)
    hybrid.storage = val
    return
end

"""Set [`HybridSystem`](@ref) renewable unit"""
function set_renewable_unit!(hybrid::HybridSystem, val::RenewableGen)
    _raise_if_attached_to_system(hybrid)
    hybrid.renewable_unit = val
    return
end
