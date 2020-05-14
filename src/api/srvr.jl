import Dates
import Logging

import JSON
using JuliaWebAPI

using PowerSystems
const PSY=PowerSystems
import InfrastructureSystems
const IS=InfrastructureSystems

function components(component_type=""; kwargs...)
    if isempty(component_type)
        data = Dict("error" => "must specify component type")
    elseif component_type == "buses"
        data = list_buses(; kwargs...)
    else
        data = Dict("error" => "unsupported component type $component_type")
    end

    return data
end

function list_buses(; kwargs...)
    return JSON.parse(PSY.list_buses(sys))
end

const PSY_DESCRIPTORS = joinpath("./data/RTS_GMLC", "user_descriptors.yaml")

function create_rts_system(forecast_resolution=Dates.Hour(1); kwargs...)
    data = PSY.PowerSystemTableData("./data/RTS_GMLC", 100.0, PSY_DESCRIPTORS)
    return PSY.System(data; forecast_resolution=forecast_resolution, kwargs...)
end

logger = IS.configure_logging(console_level=Logging.Info)
#sys = System("api_example/sys.json")
sys = create_rts_system()

# Expose components via a ZMQ listener
process(
    JuliaWebAPI.create_responder([
        (components, true),
    ], "tcp://127.0.0.1:9999", true, "")
)
