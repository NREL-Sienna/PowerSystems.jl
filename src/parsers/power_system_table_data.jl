
const POWER_SYSTEM_DESCRIPTOR_FILE =
    joinpath(dirname(pathof(PowerSystems)), "descriptors", "power_system_inputs.json")

struct PowerSystemTableData
    basepower::Float64
    category_to_df::Dict{InputCategory,DataFrames.DataFrame}
    timeseries_metadata_file::Union{String,Nothing}
    directory::String
    user_descriptors::Dict
    descriptors::Dict
    generator_mapping::Dict{NamedTuple,DataType}
end

function PowerSystemTableData(
    data::Dict{String,Any},
    directory::String,
    user_descriptors::Union{String,Dict},
    descriptors::Union{String,Dict},
    generator_mapping::Union{String,Dict};
    timeseries_metadata_file = joinpath(directory, "timeseries_pointers"),
)
    category_to_df = Dict{InputCategory,DataFrames.DataFrame}()
    categories = [
        ("branch", BRANCH::InputCategory),
        ("bus", BUS::InputCategory),
        ("dc_branch", DC_BRANCH::InputCategory),
        ("gen", GENERATOR::InputCategory),
        ("load", LOAD::InputCategory),
        ("reserves", RESERVE::InputCategory),
        ("storage", STORAGE::InputCategory),
    ]

    if !haskey(data, "bus")
        throw(DataFormatError("key 'bus' not found in input data"))
    end

    if !haskey(data, "basepower")
        @warn "key 'basepower' not found in input data; using default=$(DEFAULT_BASE_MVA)"
    end
    basepower = get(data, "basepower", DEFAULT_BASE_MVA)

    for (label, category) in categories
        val = get(data, label, nothing)
        if isnothing(val)
            @warn "key '$label' not found in input data, set to nothing"
        else
            category_to_df[category] = val
        end
    end

    if !isfile(timeseries_metadata_file)
        if isfile(string(timeseries_metadata_file, ".json"))
            timeseries_metadata_file = string(timeseries_metadata_file, ".json")
        elseif isfile(string(timeseries_metadata_file, ".csv"))
            timeseries_metadata_file = string(timeseries_metadata_file, ".csv")
        else
            timeseries_metadata_file = nothing
        end
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

    return PowerSystemTableData(
        basepower,
        category_to_df,
        timeseries_metadata_file,
        directory,
        user_descriptors,
        descriptors,
        generator_mapping,
    )
end

"""
     PowerSystemTableData(directory::AbstractString,
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
function PowerSystemTableData(
    directory::AbstractString,
    basepower::Float64,
    user_descriptor_file::AbstractString;
    descriptor_file = POWER_SYSTEM_DESCRIPTOR_FILE,
    generator_mapping_file = GENERATOR_MAPPING_FILE,
    timeseries_metadata_file = joinpath(directory, "timeseries_pointers"),
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
                for file in readdir(joinpath(directory, d_file))
                    if match(REGEX_DEVICE_TYPE, file) != nothing
                        @info "Parsing csv data in $file ..."
                        encountered_files += 1
                        fpath = joinpath(directory, d_file, file)
                        raw_data = DataFrames.DataFrame(CSV.File(fpath))
                        d_file_data[split(file, r"[.]")[1]] = raw_data
                    end
                end

                if length(d_file_data) > 0
                    data[d_file] = d_file_data
                    @info "Successfully parsed $d_file"
                end

            elseif match(REGEX_DEVICE_TYPE, d_file) != nothing
                @info "Parsing csv data in $d_file ..."
                encountered_files += 1
                fpath = joinpath(directory, d_file)
                raw_data = DataFrames.DataFrame(CSV.File(fpath))
                data[split(d_file, r"[.]")[1]] = raw_data
                @info "Successfully parsed $d_file"
            end
        catch ex
            @error "Error occurred while parsing $d_file" exception = ex
            throw(ex)
        end
    end
    if encountered_files == 0
        error("No csv files or folders in $directory")
    end

    return PowerSystemTableData(
        data,
        directory,
        user_descriptor_file,
        descriptor_file,
        generator_mapping_file,
        timeseries_metadata_file = timeseries_metadata_file,
    )
end

"""
Return the custom name stored in the user descriptor file.

Throws DataFormatError if a required value is not found in the file.
"""
function get_user_field(
    data::PowerSystemTableData,
    category::InputCategory,
    field::AbstractString,
)
    if !haskey(data.user_descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    try
        for item in data.user_descriptors[category]
            if item["name"] == field
                return Symbol(item["custom_name"])
            end
        end
    catch
        (err)
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
function get_user_fields(data::PowerSystemTableData, category::InputCategory)
    if !haskey(data.user_descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    return [x["name"] for x in data.user_descriptors[category]]
end

"""Return the dataframe for the category."""
function get_dataframe(data::PowerSystemTableData, category::InputCategory)
    @assert haskey(data.category_to_df, category)
    return data.category_to_df[category]
end

"""
    iterate_rows(data::PowerSystemTableData, category; na_to_nothing=true)

Return a NamedTuple of parameters from the descriptor file for each row of a dataframe,
making type conversions as necessary.

Refer to the PowerSystems descriptor file for field names that will be created.
"""
function iterate_rows(data::PowerSystemTableData, category; na_to_nothing = true)
    df = get_dataframe(data, category)
    field_infos = _get_field_infos(data, category, names(df))

    Channel() do channel
        for row in eachrow(df)
            obj = _read_data_row(data, row, field_infos; na_to_nothing = na_to_nothing)
            put!(channel, obj)
        end
    end
end

"""
    System(data::PowerSystemTableData)

Construct a System from PowerSystemTableData data.

# Arguments
- `forecast_resolution::Union{DateTime, Nothing}=nothing`: only store forecasts that match
  this resolution.
- `time_series_in_memory::Bool=false`: Store time series data in memory instead of HDF5 file
- `runchecks::Bool=true`: Validate struct fields.

Throws DataFormatError if forecasts with multiple resolutions are detected.
- A forecast has a different resolution than others.
- A forecast has a different horizon than others.

"""
function System(
    data::PowerSystemTableData;
    forecast_resolution = nothing,
    time_series_in_memory = false,
    runchecks = true,
)
    sys = System(
        data.basepower;
        time_series_in_memory = time_series_in_memory,
        runchecks = runchecks,
    )

    bus_csv_parser!(sys, data)
    loadzone_csv_parser!(sys, data)
    load_csv_parser!(sys, data)

    # Services and forecasts must be last.
    parsers = (
        (get_dataframe(data, BRANCH::InputCategory), branch_csv_parser!),
        (get_dataframe(data, DC_BRANCH::InputCategory), dc_branch_csv_parser!),
        (get_dataframe(data, GENERATOR::InputCategory), gen_csv_parser!),
        (get_dataframe(data, RESERVE::InputCategory), services_csv_parser!),
    )

    for (val, parser) in parsers
        if !isnothing(val)
            parser(sys, data)
        end
    end

    if !isnothing(data.timeseries_metadata_file)
        add_forecasts!(sys, data.timeseries_metadata_file; resolution = forecast_resolution)
    end

    check!(sys)
    return sys
end

"""
    bus_csv_parser!(sys::System, bus_raw::DataFrames.DataFrame)

Add buses to the System from the raw data.

"""
function bus_csv_parser!(sys::System, data::PowerSystemTableData)
    for bus in iterate_rows(data, BUS::InputCategory)
        bus_type = get_enum_value(BusType, bus.bus_type)
        number = bus.bus_id
        voltage_limits = (min = 0.95, max = 1.05)
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
    branch_csv_parser!(sys::System, data::PowerSystemTableData)

Add branches to the System from the raw data.

"""
function branch_csv_parser!(sys::System, data::PowerSystemTableData)
    available = true

    for branch in iterate_rows(data, BRANCH::InputCategory)
        bus_from = get_bus(sys, branch.connection_points_from)
        bus_to = get_bus(sys, branch.connection_points_to)
        connection_points = Arc(bus_from, bus_to)
        pf = get(branch, :pf, 0.0)
        qf = get(branch, :qf, 0.0)

        #TODO: noop math...Phase-Shifting Transformer angle
        alpha = (branch.primary_shunt / 2) - (branch.primary_shunt / 2)

        branch_type = get_branch_type(branch.tap, alpha)

        if branch_type == Line
            b = branch.primary_shunt / 2
            anglelimits = (min = -π / 2, max = π / 2) #TODO: add field in CSV
            value = Line(
                name = branch.name,
                available = available,
                activepower_flow = pf,
                reactivepower_flow = qf,
                arc = connection_points,
                r = branch.r,
                x = branch.x,
                b = (from = b, to = b),
                rate = branch.rate,
                anglelimits = anglelimits,
            )
        elseif branch_type == Transformer2W
            value = Transformer2W(
                name = branch.name,
                available = available,
                activepower_flow = pf,
                reactivepower_flow = qf,
                arc = connection_points,
                r = branch.r,
                x = branch.x,
                primaryshunt = branch.primary_shunt,
                rate = branch.rate,
            )
        elseif branch_type == TapTransformer
            value = TapTransformer(
                name = branch.name,
                available = available,
                activepower_flow = pf,
                reactivepower_flow = qf,
                arc = connection_points,
                r = branch.r,
                x = branch.x,
                primaryshunt = branch.primary_shunt,
                tap = branch.tap,
                rate = branch.rate,
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
    dc_branch_csv_parser!(sys::System, data::PowerSystemTableData)

Add DC branches to the System from raw data.

"""
function dc_branch_csv_parser!(sys::System, data::PowerSystemTableData)
    for dc_branch in iterate_rows(data, DC_BRANCH::InputCategory)
        available = true
        bus_from = get_bus(sys, dc_branch.connection_points_from)
        bus_to = get_bus(sys, dc_branch.connection_points_to)
        connection_points = Arc(bus_from, bus_to)
        pf = get(dc_branch, :pf, 0.0)

        if dc_branch.control_mode == "Power"
            mw_load = dc_branch.mw_load / data.basepower

            #TODO: is there a better way to calculate these?,
            activepowerlimits_from = (min = -1 * mw_load, max = mw_load)
            activepowerlimits_to = (min = -1 * mw_load, max = mw_load)
            reactivepowerlimits_from = (min = 0.0, max = 0.0)
            reactivepowerlimits_to = (min = 0.0, max = 0.0)
            loss = (l0 = 0.0, l1 = dc_branch.loss) #TODO: Can we infer this from the other data?,

            value = HVDCLine(
                name = dc_branch.name,
                available = available,
                activepower_flow = pf,
                arc = connection_points,
                activepowerlimits_from = activepowerlimits_from,
                activepowerlimits_to = activepowerlimits_to,
                reactivepowerlimits_from = reactivepowerlimits_from,
                reactivepowerlimits_to = reactivepowerlimits_to,
                loss = loss,
            )
        else
            rectifier_taplimits = (
                min = dc_branch.rectifier_tap_limits_min,
                max = dc_branch.rectifier_tap_limits_max,
            )
            rectifier_xrc = dc_branch.rectifier_xrc #TODO: What is this?,
            rectifier_firingangle = dc_branch.rectifier_firingangle
            inverter_taplimits = (
                min = dc_branch.inverter_tap_limits_min,
                max = dc_branch.inverter_tap_limits_max,
            )
            inverter_xrc = dc_branch.inverter_xrc #TODO: What is this?
            inverter_firingangle = (
                min = dc_branch.inverter_firing_angle_min,
                max = dc_branch.inverter_firing_angle_max,
            )
            value = VSCDCLine(
                name = dc_branch.name,
                available = true,
                activepower_flow = pf,
                arc = connection_points,
                rectifier_taplimits = rectifier_taplimits,
                rectifier_xrc = rectifier_xrc,
                rectifier_firingangle = rectifier_firingangle,
                inverter_taplimits = inverter_taplimits,
                inverter_xrc = inverter_xrc,
                inverter_firingangle = inverter_firingangle,
            )
        end

        add_component!(sys, value)
    end
end

"""
    gen_csv_parser!(sys::System, data::PowerSystemTableData)

Add generators to the System from the raw data.

"""
function gen_csv_parser!(sys::System, data::PowerSystemTableData)
    output_percent_fields = Vector{Symbol}()
    heat_rate_fields = Vector{Symbol}()
    fields = get_user_fields(data, GENERATOR::InputCategory)
    for field in fields
        if occursin("output_percent", field)
            push!(output_percent_fields, Symbol(field))
        elseif occursin("heat_rate_", field)
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
    load_csv_parser!(sys::System, data::PowerSystemTableData)

Add loads to the System from the raw data.

"""
function load_csv_parser!(sys::System, data::PowerSystemTableData)
    for ps_bus in get_components(Bus, sys)
        max_active_power = 0.0
        max_reactive_power = 0.0
        active_power = 0.0
        reactive_power = 0.0
        found = false
        for bus in iterate_rows(data, BUS::InputCategory)
            if bus.bus_id == ps_bus.number
                max_active_power = bus.max_active_power
                max_reactive_power = bus.max_reactive_power
                active_power = get(bus, :active_power, max_active_power)
                reactive_power = get(bus, :reactive_power, max_reactive_power)
                found = true
                break
            end
        end

        if !found
            throw(DataFormatError("Did not find bus index in Load data $(ps_bus.name)"))
        end

        if (max_active_power != 0.0) || (max_reactive_power != 0.0)
            load = PowerLoad(
                name = ps_bus.name,
                available = true,
                bus = ps_bus,
                model = ConstantPower::LoadModel,
                activepower = active_power,
                reactivepower = reactive_power,
                maxactivepower = max_active_power,
                maxreactivepower = max_reactive_power,
            )
            add_component!(sys, load)
        end
    end
end

"""
    loadzone_csv_parser!(sys::System, data::PowerSystemTableData)

Add branches to the System from the raw data.

"""
function loadzone_csv_parser!(sys::System, data::PowerSystemTableData)
    buses = get_dataframe(data, BUS::InputCategory)
    area_column = get_user_field(data, BUS::InputCategory, "area")
    if !in(area_column, names(buses))
        @warn "Missing Data : no 'area' information for buses, cannot create loads based "
        "on areas"
        return
    end

    zones = unique(buses[!, area_column])
    for (i, zone) in enumerate(zones)
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
        zoneid = zone isa Number ? zone : i # if the zone is text use iteration count for zoneid
        load_zones =
            LoadZones(zoneid, name, buses, sum(active_powers), sum(reactive_powers))
        add_component!(sys, load_zones)
    end
end

"""
    services_csv_parser!(sys::System, data::PowerSystemTableData)

Add services to the System from the raw data.

"""
function services_csv_parser!(sys::System, data::PowerSystemTableData)
    bus_id_column = get_user_field(data, BUS::InputCategory, "bus_id")
    bus_area_column = get_user_field(data, BUS::InputCategory, "area")

    # Shortcut for data that looks like "(val1,val2,val3)"
    make_array(x) = isnothing(x) ? x : split(strip(x, ['(', ')']), ",")

    function _add_device!(contributing_devices, device_categories, name)
        component = []
        for dev_category in device_categories
            component_type = _get_component_type_from_category(dev_category)
            components = get_components_by_name(component_type, sys, name)
            if length(components) == 0
                # There multiple categories, so we might not find a match in some.
                continue
            elseif length(components) == 1
                push!(component, components[1])
            else
                msg = "Found duplicate names type=$component_type name=$name"
                throw(DataFormatError(msg))
            end
        end
        if length(component) > 1
            msg = "Found duplicate components with name=$name"
            throw(DataFormatError(msg))
        elseif length(component) == 1
            push!(contributing_devices, component[1])
        end
    end

    for reserve in iterate_rows(data, RESERVE::InputCategory)
        device_categories = make_array(reserve.eligible_device_categories)
        device_subcategories =
            make_array(get(reserve, :eligible_device_subcategories, nothing))
        devices = make_array(get(reserve, :contributing_devices, nothing))
        regions = make_array(reserve.eligible_regions)
        requirement = get(reserve, :requirement, nothing)
        contributing_devices = Vector{Device}()

        if isnothing(device_subcategories)
            @info("Adding contributing components for $(reserve.name) by component name")
            for device in devices
                _add_device!(contributing_devices, device_categories, device)
            end
        else
            @info("Adding contributing generators for $(reserve.name) by category")
            @warn "Adding contributing components by category only supports generators" maxlog =
                1
            for gen in iterate_rows(data, GENERATOR::InputCategory)
                buses = get_dataframe(data, BUS::InputCategory)
                bus_ids = buses[!, bus_id_column]
                sys_gen = get_components_by_name(Generator, sys, gen.name)
                if length(sys_gen) == 1
                    sys_gen = sys_gen[1]
                    area = string(buses[
                        bus_ids .== get_number(get_bus(sys_gen)),
                        bus_area_column,
                    ][1])
                    if gen.category in device_subcategories && area in regions
                        _add_device!(contributing_devices, device_categories, gen.name)
                    end
                else
                    @warn "Found $(length(sys_gen)) Generators with name=$(gen.name)"
                end
            end
        end

        if length(contributing_devices) == 0
            throw(DataFormatError("did not find contributing devices for service $(reserve.name)"))
        end

        direction = get_reserve_direction(reserve.direction)
        if isnothing(requirement)
            service = StaticReserve{direction}(reserve.name, reserve.timeframe, 0.0)
        else
            service =
                VariableReserve{direction}(reserve.name, reserve.timeframe, requirement)
        end

        add_service!(sys, service, contributing_devices)
    end
end

function get_reserve_direction(direction::AbstractString)
    if direction == "Up"
        return ReserveUp
    elseif direction == "Down"
        return ReserveDown
    else
        throw(DataFormatError("invalid reserve direction $direction"))
    end
end

"""Creates a generator of any type."""
function make_generator(data::PowerSystemTableData, gen, cost_colnames, bus)
    generator = nothing
    gen_type =
        get_generator_type(gen.fuel, get(gen, :unit_type, nothing), data.generator_mapping)

    if gen_type == ThermalStandard
        generator = make_thermal_generator(data, gen, cost_colnames, bus)
    elseif gen_type <: HydroGen
        generator = make_hydro_generator(gen_type, data, gen, bus)
    elseif gen_type <: RenewableGen
        generator = make_renewable_generator(gen_type, data, gen, bus)
    elseif gen_type == GenericBattery
        generator = make_storage(data, gen, bus)
    else
        @error "Skipping unsupported generator" gen_type
    end

    return generator
end

function make_thermal_generator(data::PowerSystemTableData, gen, cost_colnames, bus)
    fuel_cost = gen.fuel_price / 1000

    var_cost = [(getfield(gen, hr), getfield(gen, mw)) for (hr, mw) in cost_colnames]
    var_cost = [
        (tryparse(Float64, string(c[1])), tryparse(Float64, string(c[2])))
        for c in var_cost if !in(nothing, c)
    ]
    if length(unique(var_cost)) > 1
        var_cost[2:end] = [
            (
                var_cost[i][1] *
                (var_cost[i][2] - var_cost[i - 1][2]) *
                fuel_cost *
                data.basepower,
                var_cost[i][2],
            ) .* gen.active_power_limits_max
            for i in 2:length(var_cost)
        ]
        var_cost[1] =
            (
                var_cost[1][1] * var_cost[1][2] * fuel_cost * data.basepower,
                var_cost[1][2],
            ) .* gen.active_power_limits_max

        fixed = max(
            0.0,
            var_cost[1][1] -
                (var_cost[2][1] / (var_cost[2][2] - var_cost[1][2]) * var_cost[1][2]),
        )
        var_cost[1] = (var_cost[1][1] - fixed, var_cost[1][2])
        for i in 2:length(var_cost)
            var_cost[i] = (var_cost[i - 1][1] + var_cost[i][1], var_cost[i][2])
        end
    else
        var_cost = [(0.0, var_cost[1][2]), (1.0, var_cost[1][2])]
        fixed = 0.0
    end

    available = true
    rating = sqrt(gen.active_power_limits_max^2 + gen.reactive_power_limits_max^2)
    active_power_limits =
        (min = gen.active_power_limits_min, max = gen.active_power_limits_max)
    reactive_power_limits =
        (min = gen.reactive_power_limits_min, max = gen.reactive_power_limits_max)
    tech = TechThermal(
        rating = rating,
        primemover = convert(PrimeMovers, gen.unit_type),
        fuel = convert(ThermalFuels, gen.fuel),
        activepowerlimits = active_power_limits,
        reactivepowerlimits = reactive_power_limits,
        ramplimits = (up = gen.ramp_limits, down = gen.ramp_limits),
        timelimits = (up = gen.min_up_time, down = gen.min_down_time),
    )

    capacity = gen.active_power_limits_max
    startup_cost = get(gen, :startup_cost, nothing)
    if isnothing(startup_cost) && hasfield(typeof(gen), :startup_heat_cold_cost)
        startup_cost = gen.startup_heat_cold_cost * fuel_cost * 1000
    else
        @warn("No startup_cost defined for $(gen.name), setting to 0.0")
        startup_cost = 0.0
    end

    shutdown_cost = get(gen, :shutdown_cost, nothing)
    if isnothing(shutdown_cost)
        @warn("No shutdown_cost defined for $(gen.name), setting to 0.0")
        shutdown_cost = 0.0
    end
    op_cost = ThreePartCost(var_cost, fixed, startup_cost, shutdown_cost)

    return ThermalStandard(
        gen.name,
        available,
        bus,
        gen.active_power,
        gen.reactive_power,
        tech,
        op_cost,
    )
end

function make_hydro_generator(gen_type, data::PowerSystemTableData, gen, bus)
    available = true

    rating = calculate_rating(gen.active_power_limits_max, gen.reactive_power_limits_max)
    active_power_limits =
        (min = gen.active_power_limits_min, max = gen.active_power_limits_max)
    reactive_power_limits =
        (min = gen.reactive_power_limits_min, max = gen.reactive_power_limits_max)
    tech = TechHydro(
        rating,
        convert(PrimeMovers, gen.unit_type),
        active_power_limits,
        reactive_power_limits,
        (up = gen.ramp_limits, down = gen.ramp_limits),
        (up = gen.min_down_time, down = gen.min_down_time),
    )

    if gen_type == HydroDispatch
        if !haskey(data.category_to_df, STORAGE)
            throw(DataFormatError("Storage information must defined in storage.csv"))
        end
        @debug("Creating $(gen.name) as HydroDispatch")
        storage = get_storage_by_generator(data, gen.name)
        curtailcost = 0.0
        hydro_gen = HydroDispatch(
            name = gen.name,
            available = available,
            bus = bus,
            activepower = gen.active_power,
            reactivepower = gen.reactive_power,
            tech = tech,
            op_cost = TwoPartCost(curtailcost, 0.0),
            storage_capacity = storage.storage_capacity,
            inflow = storage.inflow_limit,
            initial_storage = storage.initial_storage,
        )
    elseif gen_type == HydroFix
        @debug("Creating $(gen.name) as HydroFix")
        hydro_gen = HydroFix(
            name = gen.name,
            available = available,
            bus = bus,
            activepower = gen.active_power,
            reactivepower = gen.reactive_power,
            tech = tech,
        )
    else
        error("Tabular data parser does not currently support $gen_type creation")
    end
    return hydro_gen
end

function get_storage_by_generator(data::PowerSystemTableData, gen_name::AbstractString)
    for storage in iterate_rows(data, STORAGE::InputCategory)
        if storage.generator_name == gen_name
            return storage
        end
    end

    throw(DataFormatError("no storage exists with generator $gen_name"))
end

function make_renewable_generator(gen_type, data::PowerSystemTableData, gen, bus)
    generator = nothing
    available = true
    rating = gen.active_power_limits_max

    tech = TechRenewable(
        rating,
        convert(PrimeMovers, gen.unit_type),
        (min = gen.reactive_power_limits_min, max = gen.reactive_power_limits_max),
        1.0,
    )
    if gen_type == RenewableDispatch
        generator = RenewableDispatch(
            gen.name,
            available,
            bus,
            gen.active_power,
            gen.reactive_power,
            tech,
            TwoPartCost(0.0, 0.0),
        )
    elseif gen_type == RenewableFix
        generator = RenewableFix(
            gen.name,
            available,
            bus,
            gen.active_power,
            gen.reactive_power,
            tech,
        )
    else
        error("Unsupported type $gen_type")
    end

    return generator
end

function make_storage(data::PowerSystemTableData, gen, bus)
    available = true
    energy = 0.0
    capacity = (min = gen.active_power_limits_min, max = gen.active_power_limits_max)
    rating = gen.active_power_limits_max
    input_active_power_limits = (min = 0.0, max = gen.active_power_limits_max)
    output_active_power_limits = (min = 0.0, max = gen.active_power_limits_max)
    efficiency = (in = 0.9, out = 0.9)
    reactive_power_limits = (min = 0.0, max = 0.0)

    battery = GenericBattery(
        name = gen.name,
        available = available,
        bus = bus,
        primemover = convert(PrimeMovers, gen.unit_type),
        energy = energy,
        capacity = capacity,
        rating = rating,
        activepower = gen.active_power,
        inputactivepowerlimits = input_active_power_limits,
        outputactivepowerlimits = output_active_power_limits,
        efficiency = efficiency,
        reactivepower = gen.reactive_power,
        reactivepowerlimits = reactive_power_limits,
    )

    return battery
end

const CATEGORY_STR_TO_COMPONENT = Dict{String,DataType}(
    "Bus" => Bus,
    "Generator" => Generator,
    "Reserve" => Service,
    "LoadZone" => LoadZones,
    "ElectricLoad" => ElectricLoad,
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
        config_data = Dict{InputCategory,Vector}()
        for (key, val) in data
            # TODO: need to change user_descriptors.yaml to use reserve instead.
            if key == "reserves"
                key = "reserve"
            end
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
    unit_conversion::Union{NamedTuple{(:From, :To),Tuple{String,String}},Nothing}
    # TODO unit, value ranges and options
end

function _get_field_infos(data::PowerSystemTableData, category::InputCategory, df_names)
    if !haskey(data.user_descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    if !haskey(data.descriptors, category)
        throw(DataFormatError("Invalid category=$category"))
    end

    # Cache whether PowerSystems uses a column's values as system-per-unit.
    # The user's descriptors indicate that the raw data is already system-per-unit or not.
    per_unit = Dict{String,Bool}()
    unit = Dict{String,Union{String,Nothing}}()
    descriptor_names = Vector{String}()
    for descriptor in data.descriptors[category]
        per_unit[descriptor["name"]] = get(descriptor, "system_per_unit", false)
        unit[descriptor["name"]] = get(descriptor, "unit", nothing)
        push!(descriptor_names, descriptor["name"])
    end

    fields = Vector{_FieldInfo}()
    try
        for item in data.user_descriptors[category]
            custom_name = Symbol(item["custom_name"])
            name = item["name"]
            if custom_name in df_names
                if !(name in descriptor_names)
                    if occursin("heat_rate_", name) || occursin("output_percent_", name)
                        base = name[(findlast("_", name)[end] + 1):end]
                        d_name = descriptor_names[occursin.(base, descriptor_names)][end]
                        per_unit[name] = per_unit[d_name]
                        unit[name] = unit[d_name]
                    else
                        throw(DataFormatError("$name is not defined in $POWER_SYSTEM_DESCRIPTOR_FILE"))
                    end
                end

                if !per_unit[name] && get(item, "system_per_unit", false)
                    throw(DataFormatError("$name cannot be defined as system_per_unit"))
                end

                needs_pu_conversion =
                    per_unit[name] &&
                    haskey(item, "system_per_unit") && !item["system_per_unit"]

                custom_unit = get(item, "unit", nothing)
                if !isnothing(unit[name]) &&
                   !isnothing(custom_unit) && custom_unit != unit[name]
                    unit_conversion = (From = custom_unit, To = unit[name])
                else
                    unit_conversion = nothing
                end

                push!(
                    fields,
                    _FieldInfo(name, custom_name, needs_pu_conversion, unit_conversion),
                )
            else
                # TODO: This should probably be a fatal error. However, the parsing code
                # doesn't use all the descriptor fields, so skip for now.
                @warn "User-defined column name $custom_name is not in dataframe."
            end
        end
        return fields
    catch err
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
function _read_data_row(data::PowerSystemTableData, row, field_infos; na_to_nothing = true)
    fields = Vector{String}()
    vals = Vector()
    for field_info in field_infos
        value = row[field_info.custom_name]
        if ismissing(value)
            throw(DataFormatError("$(field_info.custom_name) value missing"))
        end
        if na_to_nothing && value == "NA"
            value = nothing
        end

        if field_info.needs_per_unit_conversion
            @debug "convert to system_per_unit" field_info.custom_name
            value /= data.basepower
        end

        # TODO: need special handling for units
        if !isnothing(field_info.unit_conversion)
            @debug "convert units" field_info.custom_name
            value = convert_units!(value, field_info.unit_conversion)
        end
        # TODO: validate ranges and option lists

        push!(fields, field_info.name)
        push!(vals, value)
    end

    return NamedTuple{Tuple(Symbol.(fields))}(vals)
end
