function add_geographic_info!(sys::System, component::Component, ginfo::InfrastructureSystemsGeo)
    IS.add_info!(sys.data.infos, outage, ginfo)
    return
end

function has_geographic_info!(sys::System, component::Component)
    return IS.has_info(InfrastructureSystemsGeo, sys.data.infos, component)
end

function get_geographic_info!(sys::System, component::Component)
    _check_geographic_info(sys, component)
    return sys.data.infos[InfrastructureSystemsGeo][get_uuid(component)]
end
