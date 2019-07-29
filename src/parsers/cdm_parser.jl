
const POWER_SYSTEM_DESCRIPTOR_FILE = joinpath(dirname(pathof(PowerSystems)),
                                              "descriptors", "power_system_inputs.json")

struct PowerSystemRaw
    basepower::Float64
    branch::Union{DataFrames.DataFrame, Nothing}
    bus::DataFrames.DataFrame
    dcline::Union{DataFrames.DataFrame, Nothing}
    forecasts::Union{DataFrames.DataFrame, Nothing}
    gen::Union{DataFrames.DataFrame, Nothing}
    load::Union{DataFrames.DataFrame, Nothing}
    services::Union{DataFrames.DataFrame, Nothing}
    category_to_df::Dict{InputCategory, DataFrames.DataFrame}
    directory::String
    user_descriptors::Dict
    descriptors::Dict
    generator_mapping::Dict{NamedTuple, DataType}
end

function PowerSystemRaw(
                        data::Dict{String, Any},
                        directory::String,
                        user_descriptors::Union{String, Dict},
                        descriptors::Union{String, Dict},
                        generator_mapping::Union{String, Dict},
                       )
    category_to_df = Dict{InputCategory, DataFrames.DataFrame}()
    categories = [
        ("branch", BRANCH::InputCategory),
        ("bus", BUS::InputCategory),
        ("dc_branch", DC_BRANCH::InputCategory),
        ("gen", GENERATOR::InputCategory),
        ("load", LOAD::InputCategory),
        ("reserves", RESERVES::InputCategory),
        ("timeseries_pointers", TIMESERIES_POINTERS::InputCategory),
    ]

    if !haskey(data, "bus")
        throw(DataFormatError("key 'bus' not found in input data"))
    end

    if !haskey(data, "basepower")
        @warn "key 'basepower' not found in input data; using default=$(DEFAULT_BASE_MVA)"
    end
    basepower = get(data, "basepower", DEFAULT_BASE_MVA)

    dfs = Vector()
    for (label, category) in categories
        val = get(data, label, nothing)
        if isnothing(val)
            @warn "key '$label' not found in input data, set to nothing"
        else
            category_to_df[category] = val
        end

        push!(dfs, val)
    end

    if user_descriptors isa AbstractString
        user_descriptors = _read_config_file(user_descriptors)
    end

    if descriptors isa AbstractString
        descriptors = _read_config_file(descriptors)
    end

    if generator_mapping isa AbstractString
        generator_mapping = get_generator_mapping(generator_mapping)
    end

    return PowerSystemRaw(basepower, dfs..., category_to_df, directory, user_descriptors,
                          descriptors, generator_mapping)
end

"""
     PowerSystemRaw(directory::AbstractString,
                    basepower::Float64,
                    user_descriptor_file::AbstractString;
                    descriptor_file=POWER_SYSTEM_DESCRIPTOR_FILE)

Reads in all the data stored in csv files
The general format for data is
    folder:
        gen.csv
        branch.csv
        bus.csv
        ..
        load.csv

# Arguments
- `directory::AbstractString`: directory containing CSV files
- `basepower::Float64`: base power for System
- `user_descriptor_file::AbstractString`: customized input descriptor file
- `descriptor_file=POWER_SYSTEM_DESCRIPTOR_FILE`: PowerSystems descriptor file
- `generator_mapping_file=GENERATOR_MAPPING_FILE`: generator mapping configuration file
"""
function PowerSystemRaw(
                        directory::AbstractString,
                        basepower::Float64,
                        user_descriptor_file::AbstractString;
                        descriptor_file=POWER_SYSTEM_DESCRIPTOR_FILE,
                        generator_mapping_file=GENERATOR_MAPPING_FILE,
                       )
    files = readdir(directory)
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data = Dict{String,Any}()

    if length(files) == 0
        error("No files in the folder")
    else
        data["basepower"] = basepower
    end

    encountered_files = 0
    for d_file in files
        try
            if match(REGEX_IS_FOLDER, d_file) != nothing
                @info "Parsing csv files in $d_file ..."
                d_file_data = Dict{String,Any}()
                for file in readdir(joinpath(directory,d_file))
                    if match(REGEX_DEVICE_TYPE, file) != nothing
                        @info "Parsing csv data in $file ..."
                        encountered_files += 1
                        fpath = joinpath(directory,d_file,file)
                        raw_data = CSV.File(fpath) |> DataFrames.DataFrame
                        d_file_data[split(file,r"[.]")[1]] = raw_data
                    end
                end

                if length(d_file_data) > 0
                    data[d_file] = d_file_data
                    @info "Successfully parsed $d_file"
                end

            elseif match(REGEX_DEVICE_TYPE, d_file) != nothing
                @info "Parsing csv data in $d_file ..."
                encountered_files += 1
                fpath = joinpath(directory,d_file)
                raw_data = CSV.File(fpath)|> DataFrames.DataFrame
                data[split(d_file,r"[.]")[1]] = raw_data
                @info "Successfully parsed $d_file"
            end
        catch ex
            @error "Error occurred while parsing $d_file" exception=ex
            throw(ex)
        end
    end
    if encountered_files == 0
        error("No csv files or folders in $directory")
    end

    return PowerSystemRaw(data, directory, user_descriptor_file, descriptor_file,
                          generator_mapping_file)
end

"""
Return the custom name stored in the user descriptor file.

Throws DataFormatError if a required value is not found in the file.
"""
function get_user_field(data::PowerSystemRaw, category::InputCategory,
                        field::AbstractString)
    if !haskey(data.user_descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    try
        for item in data.user_descriptors[category]
            if item["name"] == field
                return Symbol(item["custom_name"])
            end
        end
    catch(err)
        if err == KeyError
            msg = "Failed to find category=$category field=$field in input descriptors $err"
            throw(DataFormatError(msg))
        else
            throw(err)
        end
    end

    msg = "Failed to find category=$category field=$field in input descriptors"
    throw(DataFormatError(msg))
end

"""Return a vector of user-defined fields for the category."""
function get_user_fields(data::PowerSystemRaw, category::InputCategory)
    if !haskey(data.user_descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    return [x["name"] for x in data.user_descriptors[category]]
end

"""Return the dataframe for the category."""
function get_dataframe(data::PowerSystemRaw, category::InputCategory)
    @assert haskey(data.category_to_df, category)
    return data.category_to_df[category]
end

"""
    iterate_rows(data::PowerSystemRaw, category; na_to_nothing=true)

Return a NamedTuple of parameters from the descriptor file for each row of a dataframe,
making type conversions as necessary.

Refer to the PowerSystems descriptor file for field names that will be created.
"""
function iterate_rows(data::PowerSystemRaw, category; na_to_nothing=true)
    df = data.category_to_df[category]
    field_infos = _get_field_infos(data, category, names(df))

    Channel() do channel
        for row in eachrow(df)
            obj = _read_data_row(data, row, field_infos; na_to_nothing=na_to_nothing)
            put!(channel, obj)
        end
    end
end

"""
    System(data::PowerSystemRaw)

Construct a System from PowerSystemRaw data.

# Arguments
- `forecast_resolution::Union{DateTime, Nothing}=nothing`: only store forecasts that match
  this resolution.

Throws DataFormatError if forecasts with multiple resolutions are detected.
- A component-label pair is not unique within a forecast array.
- A forecast has a different resolution than others.
- A forecast has a different horizon than others.

"""
function System(data::PowerSystemRaw; forecast_resolution=nothing)
    sys = System(data.basepower)

    bus_csv_parser!(sys, data)
    loadzone_csv_parser!(sys, data)

    # Services and forecasts must be last.
    parsers = (
       (data.branch, branch_csv_parser!),
       (data.dcline, dc_branch_csv_parser!),
       (data.gen, gen_csv_parser!),
       (data.load, load_csv_parser!),
       (data.services, services_csv_parser!),
    )

    for (val, parser) in parsers
        if !isnothing(val)
            parser(sys, data)
        end
    end

    if !isnothing(data.forecasts)
        forecast_csv_parser!(sys, data; resolution=forecast_resolution)
    end

    check!(sys)
    return sys
end

"""
    bus_csv_parser!(sys::System, bus_raw::DataFrames.DataFrame)

Add buses to the System from the raw data.

"""
function bus_csv_parser!(sys::System, data::PowerSystemRaw)
    for bus in iterate_rows(data, BUS::InputCategory)
        bus_type = get_enum_value(BusType, bus.bus_type)
        number = bus.bus_id
        voltage_limits = (min=0.95, max=1.05)
        ps_bus = Bus(
            number,
            bus.name,
            bus_type,
            bus.angle,
            bus.voltage,
            voltage_limits,
            bus.base_voltage,
        )

        add_component!(sys, ps_bus)
    end
end

"""
    branch_csv_parser!(sys::System, data::PowerSystemRaw)

Add branches to the System from the raw data.

"""
function branch_csv_parser!(sys::System, data::PowerSystemRaw)
    available = true

    for branch in iterate_rows(data, BRANCH::InputCategory)
        bus_from = get_bus(sys, branch.connection_points_from)
        bus_to = get_bus(sys, branch.connection_points_to)
        connection_points = Arch(bus_from, bus_to)

        #TODO: noop math...Phase-Shifting Transformer angle
        alpha = (branch.primary_shunt / 2) - (branch.primary_shunt / 2)

        branch_type = get_branch_type(branch.tap, alpha)

        if branch_type == Line
            b = branch.primary_shunt / 2
            anglelimits = (min=-60.0, max=60.0) #TODO: add field in CSV
            value = Line(
                branch.name,
                available,
                connection_points,
                branch.r,
                branch.x,
                (from=b, to=b),
                branch.rate,
                anglelimits,
            )
        elseif branch_type == Transformer2W
            value = Transformer2W(
                branch.name,
                available,
                connection_points,
                branch.r,
                branch.x,
                branch.primary_shunt,
                branch.rate,
            )
        elseif branch_type == TapTransformer
            value = TapTransformer(
                branch.name,
                available,
                connection_points,
                branch.r,
                branch.x,
                branch.primary_shunt,
                branch.tap,
                branch.rate,
            )
        elseif branch_type == PhaseShiftingTransformer
            # TODO create PhaseShiftingTransformer
            error("Unsupported branch type $branch_type")
        else
            error("Unsupported branch type $branch_type")
        end

        add_component!(sys, value)
    end
end

"""
    dc_branch_csv_parser!(sys::System, data::PowerSystemRaw)

Add DC branches to the System from raw data.

"""
function dc_branch_csv_parser!(sys::System, data::PowerSystemRaw)
    for dc_branch in iterate_rows(data, DC_BRANCH::InputCategory)
        available = true
        bus_from = get_bus(sys, dc_branch.connection_points_from)
        bus_to = get_bus(sys, dc_branch.connection_points_to)
        connection_points = Arch(bus_from, bus_to)

        if dc_branch.control_mode == "Power"
            mw_load = dc_branch.mw_load

            #TODO: is there a better way to calculate these?,
            activepowerlimits_from = (min=-1 * mw_load, max=mw_load)
            activepowerlimits_to = (min=-1 * mw_load, max=mw_load)
            reactivepowerlimits_from = (min=0.0, max=0.0)
            reactivepowerlimits_to = (min=0.0, max=0.0)
            loss = (l0=0.0, l1=dc_branch.loss) #TODO: Can we infer this from the other data?,

            value = HVDCLine(
                dc_branch.name,
                available,
                connection_points,
                activepowerlimits_from,
                activepowerlimits_to,
                reactivepowerlimits_from,
                reactivepowerlimits_to,
                loss
            )
        else
            rectifier_taplimits = (min=dc_branch.rectifier_tap_limits_min,
                                   max=dc_branch.rectifier_tap_limits_max)
            rectifier_xrc = dc_branch.rectifier_xrc #TODO: What is this?,
            rectifier_firingangle = dc_branch.rectifier_firingangle
            inverter_taplimits = (min=dc_branch.inverter_tap_limits_min,
                                  max=dc_branch.inverter_tap_limits_max)
            inverter_xrc = dc_branch.inverter_xrc #TODO: What is this?
            inverter_firingangle = (min=dc_branch.inverter_firing_angle_min,
                                    max=dc_branch.inverter_firing_angle_max)
            value = VSCDCLine(
                dc_branch.name,
                available=true,
                connection_points,
                rectifier_taplimits,
                rectifier_xrc,
                rectifier_firingangle,
                inverter_taplimits,
                inverter_xrc,
                inverter_firingangle,
            )
        end

        add_component!(sys, value)
    end
end

"""
    forecast_csv_parser!(sys::System, data::PowerSystemRaw)

Add forecasts to the System from raw data.

"""
function forecast_csv_parser!(sys::System, data::PowerSystemRaw; resolution=nothing)
    forecast_data = parse_forecast_data_files(sys, data)

    return _forecast_csv_parser!(sys, forecast_data, resolution)
end

"""
    gen_csv_parser!(sys::System, data::PowerSystemRaw)

Add generators to the System from the raw data.

"""
function gen_csv_parser!(sys::System, data::PowerSystemRaw)
    output_percent_fields = Vector{Symbol}()
    heat_rate_fields = Vector{Symbol}()
    fields = get_user_fields(data, GENERATOR::InputCategory)
    for field in fields
        if occursin("output_percent", field)
            push!(output_percent_fields, Symbol(field))
        elseif occursin("heat_rate_avg", field)
            push!(heat_rate_fields, Symbol(field))
        end
    end

    @assert length(output_percent_fields) > 0
    cost_colnames = zip(heat_rate_fields, output_percent_fields)

    for gen in iterate_rows(data, GENERATOR::InputCategory)
        bus = get_bus(sys, gen.bus_id)
        if isnothing(bus)
            throw(DataFormatError("could not find $(gen.bus_id)"))
        end

        generator = make_generator(data, gen, cost_colnames, bus)
        if !isnothing(generator)
            add_component!(sys, generator)
        end
    end
end

"""
    load_csv_parser!(sys::System, data::PowerSystemRaw)

Add loads to the System from the raw data.

"""
function load_csv_parser!(sys::System, data::PowerSystemRaw)
    for ps_bus in get_components(Bus, sys)
        max_active_power = 0.0
        max_reactive_power = 0.0
        found = false
        for bus in iterate_rows(data, BUS::InputCategory)
            if bus.bus_id == ps_bus.number
                max_active_power = bus.max_active_power
                max_reactive_power = bus.max_reactive_power
                found = true
                break
            end
        end

        if !found
            throw(DataFormatError("Did not find bus index in Load data $(ps_bus.name)"))
        end

        load = PowerLoad(ps_bus.name, true, ps_bus, max_active_power, max_reactive_power)
        add_component!(sys, load)
    end
end

"""
    loadzone_csv_parser!(sys::System, cdm::PowerSystemRaw)

Add branches to the System from the raw data.

"""
function loadzone_csv_parser!(sys::System, data::PowerSystemRaw)
    area_column = get_user_field(data, BUS::InputCategory, "area")
    if !in(area_column, names(data.bus))
        @warn "Missing Data : no 'area' information for buses, cannot create loads based "
              "on areas"
        return
    end

    values = unique(data.bus[area_column])
    lbs = zip(values, [sum(data.bus[area_column] .== a) for a in values])
    for (zone, count) in lbs
        bus_numbers = Set{Int}()
        active_powers = Vector{Float64}()
        reactive_powers = Vector{Float64}()
        for bus in iterate_rows(data, BUS::InputCategory)
            if bus.area == zone
                bus_number = bus.bus_id
                push!(bus_numbers, bus_number)

                active_power = bus.max_active_power
                push!(active_powers, active_power)

                reactive_power = bus.max_reactive_power
                push!(reactive_powers, reactive_power)
            end
        end

        buses = get_buses(sys, bus_numbers)
        name = string(zone)
        load_zones = LoadZones(zone, name, buses, sum(active_powers), sum(reactive_powers))
        add_component!(sys, load_zones)
    end
end

"""
    services_csv_parser!(sys::System, data::PowerSystemRaw)

Add services to the System from the raw data.

"""
function services_csv_parser!(sys::System, data::PowerSystemRaw)
    bus_id_column = get_user_field(data, BUS::InputCategory, "bus_id")
    bus_area_column = get_user_field(data, BUS::InputCategory, "area")

    # Shortcut for data that looks like "(val1,val2,val3)"
    make_array(x) = split(strip(x, ['(', ')']), ",")

    for reserve in iterate_rows(data, RESERVES::InputCategory)
        device_categories = make_array(reserve.eligible_device_categories)
        device_subcategories = make_array(reserve.eligible_device_subcategories)
        regions = make_array(reserve.eligible_regions)
        contributing_devices = Vector{Device}()

        for gen in iterate_rows(data, GENERATOR::InputCategory)
            bus_ids = data.bus[bus_id_column]
            area = string(data.bus[bus_ids .== gen.bus_id, bus_area_column][1])
            if gen.category in device_subcategories && area in regions
                for dev_category in device_categories
                    component_type = _get_component_type_from_category(dev_category)
                    components = get_components_by_name(component_type, sys, gen.name)
                    if length(components) == 0
                        # There multiple categories, so we might not find a match in some.
                        continue
                    elseif length(components) == 1
                        component = components[1]
                    else
                        msg = "Found duplicate names type=$component_type name=$name"
                        throw(DataFormatError(msg))
                    end

                    push!(contributing_devices, component)
                end
            end
        end

        if length(contributing_devices) == 0
            throw(DataFormatError(
                "did not find contributing devices for service $(reserve.name)"
            ))
        end

        service = ProportionalReserve(reserve.name,
                                      contributing_devices,
                                      reserve.timeframe)
        add_component!(sys, service)
    end
end

"""Creates a generator of any type."""
function make_generator(data::PowerSystemRaw, gen, cost_colnames, bus)
    generator = nothing
    gen_type = get_generator_type(gen.fuel, gen.unit_type, data.generator_mapping)

    if gen_type == ThermalStandard
        generator = make_thermal_generator(data, gen, cost_colnames, bus)
    elseif gen_type == HydroDispatch
        generator = make_hydro_generator(data, gen, bus)
    elseif gen_type <: RenewableGen
        generator = make_renewable_generator(gen_type, data, gen, bus)
    elseif gen_type == GenericBattery
        generator = make_storage(data, gen, bus)
    else
        @error "Skipping unsupported generator" gen_type
    end

    return generator
end

function make_thermal_generator(data::PowerSystemRaw, gen, cost_colnames, bus)
    fuel_cost = gen.fuel_price / 1000

    var_cost = [(getfield(gen, hr), getfield(gen, mw)) for (hr, mw) in cost_colnames]
    var_cost = [(c[1], c[2]) for c in var_cost if !in(nothing, c)]
    var_cost[2:end] = [(var_cost[i][1] * (var_cost[i][2] - var_cost[i-1][2]) * fuel_cost * data.basepower,
                        var_cost[i][2]) .* gen.active_power_limits_max
                       for i in 2:length(var_cost)]
    var_cost[1] = (var_cost[1][1] * var_cost[1][2] * fuel_cost * data.basepower, var_cost[1][2]) .*
                  gen.active_power_limits_max
    for i in 2:length(var_cost)
        var_cost[i] = (var_cost[i - 1][1] + var_cost[i][1], var_cost[i][2])
    end

    available = true
    rating = sqrt(gen.active_power_limits_max^2 + gen.reactive_power_limits_max^2)
    active_power_limits = (min=gen.active_power_limits_min,
                         max=gen.active_power_limits_max)
    reactive_power_limits = (min=gen.reactive_power_limits_min,
                             max=gen.reactive_power_limits_max)
    tech = TechThermal(
        rating,
        gen.active_power,
        active_power_limits,
        gen.reactive_power,
        reactive_power_limits,
        (up=gen.ramp_limits, down=gen.ramp_limits),
        (up=gen.min_up_time, down=gen.min_down_time),
    )

    capacity = gen.active_power_limits_max
    fixed = 0.0
    startup_cost = gen.startup_heat_cold_cost * fuel_cost * 1000
    shutdown_cost = 0.0
    op_cost = ThreePartCost(
        var_cost,
        fixed,
        startup_cost,
        shutdown_cost
    )

    return ThermalStandard(gen.name, available, bus, tech, op_cost)
end

function make_hydro_generator(data::PowerSystemRaw, gen, bus)
    available = true

    rating = calculate_rating(gen.active_power_limits_max, gen.reactive_power_limits_max)
    active_power_limits = (min=gen.active_power_limits_min,
                           max=gen.active_power_limits_max)
    reactive_power_limits = (min=gen.reactive_power_limits_min,
                             max=gen.reactive_power_limits_max)
    tech = TechHydro(
        rating,
        gen.active_power,
        active_power_limits,
        gen.reactive_power,
        reactive_power_limits,
        (up=gen.ramp_limits, down=gen.ramp_limits),
        (up=gen.min_down_time, down=gen.min_down_time),
    )

    curtailcost = 0.0
    return HydroDispatch(gen.name, available, bus, tech, curtailcost)
end

function make_renewable_generator(gen_type, data::PowerSystemRaw, gen, bus)
    generator = nothing
    available = true
    rating = gen.active_power_limits_max

    tech = TechRenewable(rating,
                         gen.reactive_power,
                         (min=gen.reactive_power_limits_min,
                          max=gen.reactive_power_limits_max),
                         1.0)
    if gen_type == RenewableDispatch
        generator = RenewableDispatch(
            gen.name,
            available,
            bus,
            tech,
            TwoPartCost(0.0, 0.0),
        )
    elseif gen_type == RenewableFix
        generator = RenewableFix(gen.name, available, bus, tech)
    else
        error("Unsupported type $gen_type")
    end

    return generator
end

function make_storage(data::PowerSystemRaw, gen, bus)
    available = true
    energy = 0.0
    capacity = (min=gen.active_power_limits_min,
                max=gen.active_power_limits_max)
    rating = gen.active_power_limits_max
    input_active_power_limits = (min=0.0, max=gen.active_power_limits_max)
    output_active_power_limits = (min=0.0, max=gen.active_power_limits_max)
    efficiency = (in=0.9, out=0.9)
    reactive_power_limits = (min=0.0, max=0.0)

    battery=GenericBattery(
        gen.name,
        available,
        bus,
        energy,
        capacity,
        rating,
        gen.active_power,
        input_active_power_limits,
        output_active_power_limits,
        efficiency,
        gen.reactive_power,
        reactive_power_limits,
    )

    return battery
end

function parse_forecast_data_files(sys::System, data::PowerSystemRaw)
    forecast_data = ForecastInfos()
    label_cache = Dict()

    for forecast in iterate_rows(data, TIMESERIES_POINTERS::InputCategory)
        simulation = forecast.simulation
        category = _get_component_type_from_category(forecast.category)
        component = get_forecast_component(sys, category, forecast.component_name)
        label, per_unit = _get_label_info!(label_cache, data, typeof(component), forecast)
        data_file = forecast.data_file
        add_forecast_data!(forecast_data, simulation, component, label, per_unit,
                           joinpath(data.directory, data_file))
    end

    return forecast_data
end

"""Return the forecast label and whether to convert to per_unit from the descriptor."""
function _get_label_info!(label_cache::Dict, data::PowerSystemRaw, component_type, forecast)
    if forecast.label_source == "Category"
        if component_type <: Generator
            category = GENERATOR::InputCategory
        elseif component_type <: Service
            category = RESERVES::InputCategory
        elseif component_type <: Bus
            category = BUS::InputCategory
        elseif component_type <: ElectricLoad
            category = LOAD::InputCategory
        else
            error("unsupported $component_type")
        end
    else
        category = COMPONENT_TO_CATEGORY[CATEGORY_STR_TO_COMPONENT[forecast.label_source]]
    end

    key = (category, forecast.label)
    if haskey(label_cache, key)
        return label_cache[key]
    end

    for descriptor in data.user_descriptors[category]
        if descriptor["custom_name"] == forecast.label
            sys_descr = _get_system_descriptor(data, category, descriptor["name"])
            is_label_per_unit = get(sys_descr, "system_per_unit", false)
            needs_pu_conversion = is_label_per_unit &&
                                  haskey(descriptor, "system_per_unit") &&
                                  !descriptor["system_per_unit"]
            val = (forecast.label, needs_pu_conversion)
            label_cache[key] = val
            return val
        end
    end

    error("Failed to find category=$category label=$(forecast.label)")
end

function _get_system_descriptor(data::PowerSystemRaw, category, name)
    for descriptor in data.descriptors[category]
        if descriptor["name"] == name
            return descriptor
        end
    end

    error("Failed to find system descriptor category=$category name=$name")
end

const CATEGORY_STR_TO_COMPONENT = Dict{String, DataType}(
    "Bus" => Bus,
    "Generator" => Generator,
    "Reserve" => Service,
    "LoadZone" => LoadZones,
    "Load" => ElectricLoad,
)

const COMPONENT_TO_CATEGORY = Dict(
    Generator => GENERATOR::InputCategory,
    Bus => BUS::InputCategory,
    ElectricLoad => LOAD::InputCategory,
    LoadZones => LOAD::InputCategory,
    Service => RESERVES::InputCategory,
)

function _get_component_type_from_category(category::AbstractString)
    component_type = get(CATEGORY_STR_TO_COMPONENT, category, nothing)
    if isnothing(component_type)
        throw(DataFormatError("unsupported category=$category"))
    end

    return component_type
end

function _read_config_file(file_path::String)
    return open(file_path) do io
        data = YAML.load(io)
        # Replace keys with enums.
        config_data = Dict{InputCategory, Vector}()
        for (key, val) in data
            config_data[get_enum_value(InputCategory, key)] = val
        end
        return config_data
    end
end

"""Stores user-customized information for required dataframe columns."""
struct _FieldInfo
    name::String
    custom_name::Symbol
    needs_per_unit_conversion::Bool
    # TODO unit, value ranges and options
end

function _get_field_infos(data::PowerSystemRaw, category::InputCategory, df_names)
    if !haskey(data.user_descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    if !haskey(data.descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    # Cache whether PowerSystems uses a column's values as system-per-unit.
    # The user's descriptors indicate that the raw data is already system-per-unit or not.
    per_unit = Dict{String, Bool}()
    for descriptor in data.descriptors[category]
        per_unit[descriptor["name"]] = get(descriptor, "system_per_unit", false)
    end

    fields = Vector{_FieldInfo}()
    try
        for item in data.user_descriptors[category]
            custom_name = Symbol(item["custom_name"])
            name = item["name"]
            if custom_name in df_names
                if !per_unit[name] && get(item, "system_per_unit", false)
                    throw(DataFormatError("$name cannot be defined as system_per_unit"))
                end

                needs_pu_conversion = per_unit[name] &&
                                      haskey(item, "system_per_unit") &&
                                      !item["system_per_unit"]
                push!(fields, _FieldInfo(name, custom_name, needs_pu_conversion))
            else
                # TODO: This should probably be a fatal error. However, the parsing code
                # doesn't use all the descriptor fields, so skip for now.
                @warn "User-defined column name $custom_name is not in dataframe."
            end
        end
        return fields
    catch(err)
        if err == KeyError
            msg = "Failed to find category=$category field=$field in input descriptors $err"
            throw(DataFormatError(msg))
        else
            throw(err)
        end
    end

    msg = "Failed to find category=$category field=$field in input descriptors"
    throw(DataFormatError(msg))
end

"""Reads values from dataframe row and performs necessary conversions."""
function _read_data_row(data::PowerSystemRaw, row, field_infos; na_to_nothing=true)
    fields = Vector{String}()
    vals = Vector()
    for field_info in field_infos
        value = row[field_info.custom_name]
        if na_to_nothing && value == "NA"
            value = nothing
        end

        if field_info.needs_per_unit_conversion
            @debug "convert to system_per_unit" field_info.custom_name
            value /= data.basepower
        end

        # TODO: need special handling for units
        # TODO: validate ranges and option lists

        push!(fields, field_info.name)
        push!(vals, value)
    end

    return NamedTuple{Tuple(Symbol.(fields))}(vals)
end
