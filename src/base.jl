
const SKIP_PM_VALIDATION = false

const SYSTEM_KWARGS = Set((
    :branch_name_formatter,
    :bus_name_formatter,
    :config_path,
    :frequency,
    :gen_name_formatter,
    :generator_mapping,
    :internal,
    :load_name_formatter,
    :loadzone_name_formatter,
    :runchecks,
    :shunt_name_formatter,
    :time_series_directory,
    :time_series_in_memory,
    :time_series_read_only,
    :timeseries_metadata_file,
    :unit_system,
    :pm_data_corrections,
    :import_all,
    :enable_compression,
    :compression,
    :name,
    :description,
))

# This will be used in the future to handle serialization changes.
const DATA_FORMAT_VERSION = "4.0.0"

mutable struct SystemMetadata <: IS.InfrastructureSystemsType
    name::Union{Nothing, String}
    description::Union{Nothing, String}
end

"""
A power system

`System` is the main data container in PowerSystems.jl, including basic metadata (base
power, frequency), components (network topology, loads, generators, and services), and
time series data.

```julia
System(base_power)
System(base_power, buses, components...)
System(base_power, buses, generators, loads, branches, storage, services; kwargs...)
System(base_power, buses, generators, loads; kwargs...)
System(file; kwargs...)
System(; buses, generators, loads, branches, storage, base_power, services, kwargs...)
System(; kwargs...)
```

# Arguments
- `base_power::Float64`: the base power value for the system
- `buses::Vector{ACBus}`: an array of buses
- `components...`: Each element (e.g., `buses`, `generators`, ...) must be an iterable
    containing subtypes of `Component`.

# Keyword arguments
- `ext::Dict`: Contains user-defined parameters. Should only contain standard types.
- `frequency::Float64`: (default = 60.0) Operating frequency (Hz)
- `runchecks::Bool`: Run available checks on input fields and when add_component! is called.
  Throws InvalidValue if an error is found.
- `time_series_in_memory::Bool=false`: Store time series data in memory instead of HDF5.
- `time_series_directory::Union{Nothing, String}`: Directory for the time series HDF5 file.
    Defaults to the tmp file system
- `enable_compression::Bool=false`: Enable compression of time series data in HDF5.
- `compression::CompressionSettings`: Allows customization of HDF5 compression settings.
- `config_path::String`: specify path to validation config file
- `unit_system::String`: (Default = `"SYSTEM_BASE"`) Set the unit system for
    [per-unitization](@ref per_unit) while getting and setting data (`"SYSTEM_BASE"`,
        `"DEVICE_BASE"`, or `"NATURAL_UNITS"`)

By default, time series data is stored in an HDF5 file in the tmp file system to prevent
large datasets from overwhelming system memory (see [Data Storage](@ref)).
**If the system's time series
data will be larger than the amount of tmp space available**, use the
`time_series_directory` parameter to change its location.
You can also override the location by setting the environment
variable `SIENNA_TIME_SERIES_DIRECTORY` to another directory.

HDF5 compression is not enabled by default, but you can enable
it with `enable_compression` to get significant storage savings at the cost of CPU time.
[`CompressionSettings`](@ref) can be used to customize the HDF5 compression.

If you know that your dataset will fit in your computer's memory, then you can increase
performance by storing it in memory with `time_series_in_memory`.

# Examples
```julia
sys = System(100.0; enable_compression = true)
sys = System(100.0; compression = CompressionSettings(
    enabled = true,
    type = CompressionTypes.DEFLATE,  # BLOSC is also supported
    level = 3,
    shuffle = true)
)
sys = System(100.0; time_series_in_memory = true)
```
"""
struct System <: IS.InfrastructureSystemsType
    data::IS.SystemData
    frequency::Float64 # [Hz]
    bus_numbers::Set{Int}
    runchecks::Base.RefValue{Bool}
    units_settings::SystemUnitsSettings
    time_series_directory::Union{Nothing, String}
    metadata::SystemMetadata
    internal::IS.InfrastructureSystemsInternal

    function System(
        data,
        units_settings::SystemUnitsSettings,
        internal::IS.InfrastructureSystemsInternal;
        runchecks = true,
        frequency = DEFAULT_SYSTEM_FREQUENCY,
        time_series_directory = nothing,
        name = nothing,
        description = nothing,
        kwargs...,
    )
        # Note to devs: if you add parameters to kwargs then consider whether they need
        # special handling in the deserialization function in this file.
        # See deserialize for System.

        # Implement a strict check here to make sure that SYSTEM_KWARGS can be used
        # elsewhere.
        unsupported = setdiff(keys(kwargs), SYSTEM_KWARGS)
        !isempty(unsupported) && error("Unsupported kwargs = $unsupported")
        if !isnothing(get(kwargs, :unit_system, nothing))
            @warn(
                "unit_system kwarg ignored. The value in SystemUnitsSetting takes precedence"
            )
        end
        bus_numbers = Set{Int}()
        return new(
            data,
            frequency,
            bus_numbers,
            Base.RefValue{Bool}(runchecks),
            units_settings,
            time_series_directory,
            SystemMetadata(name, description),
            internal,
        )
    end
end

function System(data, base_power::Number, internal; kwargs...)
    unit_system_ = get(kwargs, :unit_system, "SYSTEM_BASE")
    unit_system = UNIT_SYSTEM_MAPPING[unit_system_]
    units_settings = SystemUnitsSettings(base_power, unit_system)
    return System(data, units_settings, internal; kwargs...)
end

"""Construct an empty `System`. Useful for building a System while parsing raw data."""
function System(base_power::Number; kwargs...)
    return System(_create_system_data_from_kwargs(; kwargs...), base_power; kwargs...)
end

"""Construct a `System` from `InfrastructureSystems.SystemData`"""
function System(
    data,
    base_power::Number;
    internal = IS.InfrastructureSystemsInternal(),
    kwargs...,
)
    return System(data, base_power, internal; kwargs...)
end

"""
System constructor when components are constructed externally.
"""
function System(base_power::Float64, buses::Vector{ACBus}, components...; kwargs...)
    data = _create_system_data_from_kwargs(; kwargs...)
    sys = System(data, base_power; kwargs...)

    for bus in buses
        add_component!(sys, bus)
    end

    for component in Iterators.flatten(components)
        add_component!(sys, component)
    end

    if get(kwargs, :runchecks, true)
        check(sys)
    end

    return sys
end

"""Constructs a non-functional System for demo purposes."""
function System(
    ::Nothing;
    buses = [
        ACBus(;
            number = 0,
            name = "init",
            bustype = ACBusTypes.REF,
            angle = 0.0,
            magnitude = 0.0,
            voltage_limits = (min = 0.0, max = 0.0),
            base_voltage = nothing,
            area = nothing,
            load_zone = nothing,
            ext = Dict{String, Any}(),
        ),
    ],
    generators = [ThermalStandard(nothing), RenewableNonDispatch(nothing)],
    loads = [PowerLoad(nothing)],
    branches = nothing,
    storage = nothing,
    base_power::Float64 = 100.0,
    services = nothing,
    kwargs...,
)
    for component in Iterators.flatten((generators, loads))
        if get_name(component) == "init"
            set_bus!(component, first(buses))
        end
    end
    _services = isnothing(services) ? [] : services
    _branches = isnothing(branches) ? [] : branches
    _storage = isnothing(storage) ? [] : storage
    return System(
        base_power,
        buses,
        generators,
        loads,
        _branches,
        _storage,
        _services;
        kwargs...,
    )
end

"""Constructs a System from a file path ending with .m, .RAW, or .json

If the file is JSON then assign_new_uuids = true will generate new UUIDs for the system
and all components.
"""
function System(file_path::AbstractString; assign_new_uuids = false, kwargs...)
    ext = splitext(file_path)[2]
    if lowercase(ext) in [".m", ".raw"]
        pm_kwargs = Dict(k => v for (k, v) in kwargs if !in(k, SYSTEM_KWARGS))
        sys_kwargs = Dict(k => v for (k, v) in kwargs if in(k, SYSTEM_KWARGS))
        return System(PowerModelsData(file_path; pm_kwargs...); sys_kwargs...)
    elseif lowercase(ext) == ".json"
        unsupported = setdiff(keys(kwargs), SYSTEM_KWARGS)
        !isempty(unsupported) && error("Unsupported kwargs = $unsupported")
        runchecks = get(kwargs, :runchecks, true)
        time_series_read_only = get(kwargs, :time_series_read_only, false)
        time_series_directory = get(kwargs, :time_series_directory, nothing)
        config_path = get(kwargs, :config_path, POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE)
        sys = deserialize(
            System,
            file_path;
            time_series_read_only = time_series_read_only,
            runchecks = runchecks,
            time_series_directory = time_series_directory,
            config_path = config_path,
        )
        _post_deserialize_handling(
            sys;
            runchecks = runchecks,
            assign_new_uuids = assign_new_uuids,
        )
        return sys
    else
        throw(DataFormatError("$file_path is not a supported file type"))
    end
end

"""
If assign_new_uuids = true, generate new UUIDs for the system and all components.

Warning: time series data is not restored by this method. If that is needed, use the normal
process to construct the system from a serialized JSON file instead, such as with
`System("sys.json")`.
"""
function IS.from_json(
    io::Union{IO, String},
    ::Type{System};
    runchecks = true,
    assign_new_uuids = false,
    kwargs...,
)
    data = JSON3.read(io, Dict)
    sys = from_dict(System, data; kwargs...)
    _post_deserialize_handling(
        sys;
        runchecks = runchecks,
        assign_new_uuids = assign_new_uuids,
    )
    return sys
end

function _post_deserialize_handling(sys::System; runchecks = true, assign_new_uuids = false)
    runchecks && check(sys)
    if assign_new_uuids
        IS.assign_new_uuid!(sys)
        for component in get_components(Component, sys)
            IS.assign_new_uuid!(sys, component)
        end
        for component in
            IS.get_masked_components(InfrastructureSystemsComponent, sys.data)
            IS.assign_new_uuid!(sys, component)
        end
        # Note: this does not change UUIDs for time series data because they are
        # shared with components.
    end
end

"""
Parse static and dynamic data directly from PSS/e text files. Automatically generates
all the relationships between the available dynamic injection models and the static counterpart

Each dictionary indexed by id contains a vector with 5 of its components:
* Machine
* Shaft
* AVR
* TurbineGov
* PSS

Files must be parsed from a .raw file (PTI data format) and a .dyr file.

## Examples:
```julia
raw_file = "Example.raw"
dyr_file = "Example.dyr"
sys = System(raw_file, dyr_file)
```

"""
function System(sys_file::AbstractString, dyr_file::AbstractString; kwargs...)
    ext = splitext(sys_file)[2]
    if lowercase(ext) in [".raw"]
        pm_kwargs = Dict(k => v for (k, v) in kwargs if !in(k, SYSTEM_KWARGS))
        sys = System(PowerModelsData(sys_file; pm_kwargs...); kwargs...)
    else
        throw(DataFormatError("$sys_file is not a .raw file type"))
    end
    bus_dict_gen = _parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
    return sys
end

"""
Construct a System from a subsystem of an existing system.
"""
function from_subsystem(sys::System, subsystem::AbstractString; runchecks = true)
    if !in(subsystem, get_subsystems(sys))
        error("subsystem = $subsystem is not stored")
    end

    # It would be faster to create an empty system and then populate it with
    # deep copies of each component in the subsystem. It would also result in a "clean" HDF5
    # file (the result here will have deleted entries that need to repacked through
    # serialization/de-serialization). That is not implemented because
    # 1. The performance loss should not be too large.
    # 2. We haven't yet implemented deepcopy(Component).
    # 3. There is extra code complexity in adding copied components in the correct order
    #    as well as copying time series data.
    new_sys = deepcopy(sys)
    filter_components_by_subsystem!(new_sys, subsystem; runchecks = runchecks)

    IS.assign_new_uuid!(new_sys)
    for component in get_components(Component, new_sys)
        IS.assign_new_uuid!(new_sys, component)
    end

    return new_sys
end

"""
Filter out all components that are not part of the subsystem.
"""
function filter_components_by_subsystem!(
    sys::System,
    subsystem::AbstractString;
    runchecks = true,
)
    component_uuids = get_component_uuids(sys, subsystem)
    for component in get_components(Component, sys)
        if !in(IS.get_uuid(component), component_uuids)
            remove_component!(sys, component)
        end
    end

    for component in IS.get_masked_components(Component, sys.data)
        if !in(IS.get_uuid(component), component_uuids)
            IS.remove_masked_component!(sys.data, component)
        end
    end

    if runchecks
        check(sys)
        check_components(sys)
    end
end

"""
Serializes a system to a JSON file and saves time series to an HDF5 file.

# Arguments
- `sys::System`: system
- `filename::AbstractString`: filename to write

# Keyword arguments
- `user_data::Union{Nothing, Dict} = nothing`: optional metadata to record
- `pretty::Bool = false`: whether to pretty-print the JSON
- `force::Bool = false`: whether to overwrite existing files
- `check::Bool = false`: whether to run system validation checks

Refer to [`check_component`](@ref) for exceptions thrown if `check = true`.
"""
function IS.to_json(
    sys::System,
    filename::AbstractString;
    user_data = nothing,
    pretty = false,
    force = false,
    runchecks = false,
)
    if runchecks
        check(sys)
        check_components(sys)
    end

    IS.prepare_for_serialization_to_file!(sys.data, filename; force = force)
    data = to_json(sys; pretty = pretty)
    open(filename, "w") do io
        write(io, data)
    end

    mfile = joinpath(dirname(filename), splitext(basename(filename))[1] * "_metadata.json")
    @info "Serialized System to $filename"
    _serialize_system_metadata_to_file(sys, mfile, user_data)
    return
end

function _serialize_system_metadata_to_file(sys::System, filename, user_data)
    name = get_name(sys)
    description = get_description(sys)
    resolutions = [x.value for x in get_time_series_resolutions(sys)]
    metadata = OrderedDict(
        "name" => isnothing(name) ? "" : name,
        "description" => isnothing(description) ? "" : description,
        "frequency" => sys.frequency,
        "time_series_resolutions_milliseconds" => resolutions,
        "component_counts" => IS.get_component_counts_by_type(sys.data),
        "time_series_counts" => IS.get_time_series_counts_by_type(sys.data),
    )
    if !isnothing(user_data)
        metadata["user_data"] = user_data
    end

    open(filename, "w") do io
        JSON3.pretty(io, metadata)
    end

    @info "Serialized System metadata to $filename"
end

IS.assign_new_uuid!(sys::System) = IS.assign_new_uuid_internal!(sys)

"""
Return the internal of the system
"""
IS.get_internal(sys::System) = sys.internal

"""
Return a user-modifiable dictionary to store extra information.
"""
get_ext(sys::System) = IS.get_ext(sys.internal)

"""
Return the system's base power.
"""
get_base_power(sys::System) = sys.units_settings.base_value

"""
Return the system's frequency.
"""
get_frequency(sys::System) = sys.frequency

"""
Clear any value stored in ext.
"""
clear_ext!(sys::System) = IS.clear_ext!(sys.internal)

"""
Return true if checks are enabled on the system.
"""
get_runchecks(sys::System) = sys.runchecks[]

"""
Enable or disable system checks.
Applies to component addition as well as overall system consistency.
"""
function set_runchecks!(sys::System, value::Bool)
    sys.runchecks[] = value
    @info "Set runchecks to $value"
end

function set_units_setting!(
    component::Component,
    settings::Union{SystemUnitsSettings, Nothing},
)
    set_units_info!(get_internal(component), settings)
    return
end

"""
Sets the units base for the getter functions on the devices. It modifies the behavior of all getter functions
"""
function set_units_base_system!(system::System, settings::String)
    set_units_base_system!(system::System, UNIT_SYSTEM_MAPPING[uppercase(settings)])
    return
end

function set_units_base_system!(system::System, settings::UnitSystem)
    if system.units_settings.unit_system != settings
        system.units_settings.unit_system = settings
        @info "Unit System changed to $settings"
    end
    return
end

"""
Get the system's [unit base](@ref per_unit))
"""
function get_units_base(system::System)
    return string(system.units_settings.unit_system)
end

function get_units_setting(component::T) where {T <: Component}
    return get_units_info(get_internal(component))
end

function has_units_setting(component::T) where {T <: Component}
    return !isnothing(get_units_setting(component))
end

"""
Set the name of the system.
"""
set_name!(sys::System, name::AbstractString) = sys.metadata.name = name

"""
Get the name of the system.
"""
get_name(sys::System) = sys.metadata.name

"""
Set the description of the system.
"""
set_description!(sys::System, description::AbstractString) =
    sys.metadata.description = description

"""
Get the description of the system.
"""
get_description(sys::System) = sys.metadata.description

"""
Add a component to the system.

A component cannot be added to more than one `System`.
Throws ArgumentError if the component's name is already stored for its concrete type.
Throws ArgumentError if any Component-specific rule is violated.
Throws InvalidValue if any of the component's field values are outside of defined valid
range.

# Examples
```julia
sys = System(100.0)

# Add a single component.
add_component!(sys, bus)

# Add many at once.
buses = [bus1, bus2, bus3]
generators = [gen1, gen2, gen3]
foreach(x -> add_component!(sys, x), Iterators.flatten((buses, generators)))
```

See also [`add_components!`](@ref).
"""
function add_component!(
    sys::System,
    component::T;
    skip_validation = false,
    kwargs...,
) where {T <: Component}
    set_units_setting!(component, sys.units_settings)
    @assert has_units_setting(component)

    check_topology(sys, component)
    check_component_addition(sys, component; kwargs...)

    deserialization_in_progress = _is_deserialization_in_progress(sys)
    if !deserialization_in_progress
        # Services are attached to devices at deserialization time.
        check_for_services_on_addition(sys, component)
    end

    skip_validation = _validate_or_skip!(sys, component, skip_validation)
    _kwargs = Dict(k => v for (k, v) in kwargs if k !== :static_injector)
    IS.add_component!(
        sys.data,
        component;
        allow_existing_time_series = deserialization_in_progress,
        skip_validation = skip_validation,
        _kwargs...,
    )

    if !deserialization_in_progress
        # Whatever this may change should have been validated above in
        # check_component_addition, so this should not fail.
        # Doesn't run at deserialization time because the changes made by this function
        # occurred when the original addition ran and do not apply to that scenario.
        handle_component_addition!(sys, component; kwargs...)
        # Special condition required to populate the bus numbers in the system after
    elseif component isa ACBus
        handle_component_addition!(sys, component; kwargs...)
    end

    return
end

"""
Add many components to the system at once.

A component cannot be added to more than one `System`.
Throws ArgumentError if the component's name is already stored for its concrete type.
Throws ArgumentError if any Component-specific rule is violated.
Throws InvalidValue if any of the component's field values are outside of defined valid
range.

# Examples
```julia
sys = System(100.0)

buses = [bus1, bus2, bus3]
generators = [gen1, gen2, gen3]
add_components!(sys, Iterators.flatten((buses, generators))
```
"""
function add_components!(sys::System, components)
    foreach(x -> add_component!(sys, x), components)
    return
end

"""
Add a dynamic injector to the system.

A component cannot be added to more than one `System`.
Throws ArgumentError if the name does not match the `static_injector` name.
Throws ArgumentError if the `static_injector` is not attached to the system.

All rules for the generic `add_component!` method also apply.
"""
function add_component!(
    sys::System,
    dyn_injector::DynamicInjection,
    static_injector::StaticInjection;
    kwargs...,
)
    add_component!(sys, dyn_injector; static_injector = static_injector, kwargs...)
    return
end

function _add_service!(
    sys::System,
    service::Service,
    contributing_devices;
    skip_validation = false,
    kwargs...,
)
    skip_validation = _validate_or_skip!(sys, service, skip_validation)
    for device in contributing_devices
        device_type = typeof(device)
        if !(device_type <: Device)
            throw(ArgumentError("contributing_devices must be of type Device"))
        end
        throw_if_not_attached(device, sys)
    end

    set_units_setting!(service, sys.units_settings)
    # Since this isn't atomic, order is important. Add to system before adding to devices.
    IS.add_component!(sys.data, service; skip_validation = skip_validation, kwargs...)

    for device in contributing_devices
        add_service_internal!(device, service)
    end
end

"""
Similar to [`add_component!`](@ref) but for services.

# Arguments
- `sys::System`: system
- `service::Service`: service to add
- `contributing_devices`: Must be an iterable of type Device
"""
function add_service!(sys::System, service::Service, contributing_devices; kwargs...)
    _add_service!(sys, service, contributing_devices; kwargs...)
    return
end

"""
Similar to [`add_component!`](@ref) but for services.

# Arguments
- `sys::System`: system
- `service::Service`: service to add
- `contributing_device::Device`: Valid Device
"""
function add_service!(sys::System, service::Service, contributing_device::Device; kwargs...)
    _add_service!(sys, service, [contributing_device]; kwargs...)
    return
end

"""
Similar to [`add_service!`](@ref) but for Service and Device already stored in the system.
Performs validation checks on the device and the system

# Arguments
- `device::Device`: Device
- `service::Service`: Service
- `sys::System`: system
"""
function add_service!(device::Device, service::Service, sys::System)
    throw_if_not_attached(service, sys)
    throw_if_not_attached(device, sys)
    add_service_internal!(device, service)
    return
end

"""
Similar to [`add_component!`](@ref) but for ConstantReserveGroup.

# Arguments
- `sys::System`: system
- `service::ConstantReserveGroup`: service to add
"""
function add_service!(
    sys::System,
    service::ConstantReserveGroup;
    skip_validation = false,
    kwargs...,
)
    skip_validation = _validate_or_skip!(sys, service, skip_validation)

    for _service in get_contributing_services(service)
        throw_if_not_attached(_service, sys)
    end

    set_units_setting!(service, sys.units_settings)
    IS.add_component!(sys.data, service; skip_validation = skip_validation, kwargs...)
    return
end

"""Set ConstantReserveGroup contributing_services with check"""
function set_contributing_services!(
    sys::System,
    service::ConstantReserveGroup,
    val::Vector{<:Service},
)
    for _service in val
        throw_if_not_attached(_service, sys)
    end
    service.contributing_services = val
    return
end

"""
Similar to [`add_component!`](@ref) but for ConstantReserveGroup.

# Arguments
- `sys::System`: system
- `service::ConstantReserveGroup`: service to add
- `contributing_services`: contributing services to the group
"""
function add_service!(
    sys::System,
    service::ConstantReserveGroup,
    contributing_services::Vector{<:Service};
    skip_validation = false,
    kwargs...,
)
    skip_validation = _validate_or_skip!(sys, service, skip_validation)
    set_contributing_services!(sys, service, contributing_services)

    set_units_setting!(service, sys.units_settings)
    IS.add_component!(sys.data, service; skip_validation = skip_validation, kwargs...)
    return
end

"""
Open the time series store for bulk additions or reads

This is recommended before calling `add_time_series!` many times because of the overhead
associated with opening and closing an HDF5 file.

This is not necessary for an in-memory time series store.

# Examples
```julia
# Assume there is a system with an array of Components and SingleTimeSeries
# stored in the variables components and single_time_series, respectively
open_time_series_store!(sys, "r+") do
    for (component, ts) in zip(components, single_time_series)
        add_time_series!(sys, component, ts)
    end
end
```
You can also use this function to make reads faster. Change the mode from `"r+"` to `"r"` to open
the file read-only.

See also: [`bulk_add_time_series!`](@ref)
"""
function open_time_series_store!(
    func::Function,
    sys::System,
    mode = "r",
    args...;
    kwargs...,
)
    IS.open_time_series_store!(func, sys.data, mode, args...; kwargs...)
end

"""
Add time series data from a metadata file or metadata descriptors.

# Arguments
- `sys::System`: system
- `metadata_file::AbstractString`: metadata file for timeseries
  that includes an array of IS.TimeSeriesFileMetadata instances or a vector.
- `resolution::DateTime.Period=nothing`: skip time series that don't match this resolution.
"""
function add_time_series!(sys::System, metadata_file::AbstractString; resolution = nothing)
    return IS.add_time_series_from_file_metadata!(
        sys.data,
        Component,
        metadata_file;
        resolution = resolution,
    )
end

"""
Add time series data from a metadata file or metadata descriptors.

# Arguments
- `sys::System`: system
- `timeseries_metadata::Vector{IS.TimeSeriesFileMetadata}`: metadata for timeseries
- `resolution::DateTime.Period=nothing`: skip time series that don't match this resolution.
"""
function add_time_series!(
    sys::System,
    file_metadata::Vector{IS.TimeSeriesFileMetadata};
    resolution = nothing,
)
    return IS.add_time_series_from_file_metadata!(
        sys.data,
        Component,
        file_metadata;
        resolution = resolution,
    )
end

function IS.add_time_series_from_file_metadata_internal!(
    data::IS.SystemData,
    ::Type{<:Component},
    cache::IS.TimeSeriesParsingCache,
    file_metadata::IS.TimeSeriesFileMetadata,
)
    associations = TimeSeriesAssociation[]
    IS.set_component!(file_metadata, data, PowerSystems)
    component = file_metadata.component
    if isnothing(component)
        return associations
    end

    ts = IS.make_time_series!(cache, file_metadata)
    if component isa AggregationTopology && file_metadata.scaling_factor_multiplier in
       ["get_max_active_power", "get_max_reactive_power"]
        uuids = Set{Base.UUID}()
        for bus in _get_buses(data, component)
            push!(uuids, IS.get_uuid(bus))
        end
        for _component in (
            load for load in IS.get_components(ElectricLoad, data) if
            IS.get_uuid(get_bus(load)) in uuids
        )
            file_metadata.component = _component
            if !IS.has_assignment(cache, file_metadata)
                IS.add_assignment!(cache, file_metadata)
                push!(associations, TimeSeriesAssociation(_component, ts))
            end
        end
        file_metadata.component = component
        orig_sf = file_metadata.scaling_factor_multiplier
        try
            file_metadata.scaling_factor_multiplier = replace(orig_sf, "max" => "peak")
            area_ts = IS.make_time_series!(cache, file_metadata)
            IS.add_assignment!(cache, file_metadata)
            push!(associations, TimeSeriesAssociation(component, area_ts))
        finally
            file_metadata.scaling_factor_multiplier = orig_sf
        end
    else
        push!(associations, TimeSeriesAssociation(component, ts))
        IS.add_assignment!(cache, file_metadata)
    end
    return associations
end

"""
Iterates over all components.

# Examples
```julia
for component in iterate_components(sys)
    @show component
end
```

See also: [`get_components`](@ref)
"""
function iterate_components(sys::System)
    return IS.iterate_components(sys.data)
end

"""
Remove all components from the system.
"""
function clear_components!(sys::System)
    return IS.clear_components!(sys.data)
end

"""
Remove all components of type T from the system.

Throws ArgumentError if the type is not stored.
"""
# the argument order in this function is un-julian and should be deprecated in 2.0
function remove_components!(::Type{T}, sys::System) where {T <: Component}
    return remove_components!(sys, T)
end

function remove_components!(sys::System, ::Type{T}) where {T <: Component}
    components = IS.remove_components!(T, sys.data)
    for component in components
        handle_component_removal!(sys, component)
    end
    return components
end

function remove_components!(
    filter_func::Function,
    sys::System,
    ::Type{T},
) where {T <: Component}
    components = collect(get_components(filter_func, T, sys))
    for component in components
        remove_component!(sys, component)
    end
    return components
end

"""
Set the name for a component that is attached to the system.
"""
set_name!(sys::System, component::Component, name::AbstractString) =
    set_name!(sys.data, component, name)

"""
Set the name of a component.

Throws an exception if the component is attached to a system.
"""
function set_name!(component::Component, name::AbstractString)
    # The units setting is nothing until the component is attached to the system.
    if get_units_setting(component) !== nothing
        # This is not allowed because components are stored in the system in a Dict
        # keyed by name.
        error(
            "The component is attached to a system. " *
            "Call set_name!(system, component, name) instead.",
        )
    end

    component.name = name
end

function clear_units!(component::Component)
    get_internal(component).units_info = nothing
    return
end

"""
Remove a component from the system by its value.

Throws ArgumentError if the component is not stored.
"""
function remove_component!(sys::System, component::T) where {T <: Component}
    check_component_removal(sys, component)
    IS.remove_component!(sys.data, component)
    handle_component_removal!(sys, component)
    return
end

"""
Throws ArgumentError if a PowerSystems rule blocks removal from the system.
"""
function check_component_removal(sys::System, service::T) where {T <: Service}
    if T == ConstantReserveGroup
        return
    end
    groupservices = get_components(ConstantReserveGroup, sys)
    for groupservice in groupservices
        if service ∈ get_contributing_services(groupservice)
            throw(
                ArgumentError(
                    "service $(get_name(service)) cannot be removed with an attached ConstantReserveGroup",
                ),
            )
            return
        end
    end
end

"""
Remove a component from the system by its name.

Throws ArgumentError if the component is not stored.
"""
function remove_component!(
    ::Type{T},
    sys::System,
    name::AbstractString,
) where {T <: Component}
    component = IS.remove_component!(T, sys.data, name)
    handle_component_removal!(sys, component)
    return
end

"""
Check to see if the component of type T exists.
"""
function has_component(sys::System, T::Type{<:Component})
    return IS.has_component(sys.data, T)
end

"""
Check to see if the component of type T with name exists.
"""
function has_component(sys::System, T::Type{<:Component}, name::AbstractString)
    return IS.has_component(sys.data, T, name)
end

has_component(T::Type{<:Component}, sys::System, name::AbstractString) =
    has_component(sys, T, name)

"""
Get the component of type T with name. Returns nothing if no component matches. If T is an abstract
type then the names of components across all subtypes of T must be unique.

See [`get_components_by_name`](@ref) for abstract types with non-unique names across subtypes.

Throws ArgumentError if T is not a concrete type and there is more than one component with
    requested name
"""
function get_component(::Type{T}, sys::System, name::AbstractString) where {T <: Component}
    return IS.get_component(T, sys.data, name)
end

"""
Return an iterator of components of a given `Type` from a [`System`](@ref).

`T` can be a concrete or abstract [`Component`](@ref) type from the [Type Tree](@ref).
Call collect on the result if an array is desired.

# Examples
```julia
iter = get_components(ThermalStandard, sys)
iter = get_components(Generator, sys)
generators = collect(get_components(Generator, sys))
```

See also: [`iterate_components`](@ref), [`get_components` with a filter](@ref get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component}),
[`get_available_components`](@ref), [`get_buses`](@ref)
"""
function get_components(
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component}
    return IS.get_components(T, sys.data; subsystem_name = subsystem_name)
end

"""
Return an iterator of components of a given `Type` from a [`System`](@ref), using an
additional filter

`T` can be a concrete or abstract [`Component`](@ref) type from the [Type Tree](@ref).
Call collect on the result if an array is desired.

# Examples
```julia
iter_coal = get_components(x -> get_fuel(x) == ThermalFuels.COAL, Generator, sys)
pv_gens =
    collect(get_components(x -> get_prime_mover_type(x) == PrimeMovers.PVe, Generator, sys))
```

See also: [`get_components`](@ref get_components(
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component}), [`get_available_components`](@ref),
[`get_buses`](@ref)
"""
function get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component}
    return IS.get_components(filter_func, T, sys.data; subsystem_name = subsystem_name)
end

"""
Return a vector of components that are attached to the supplemental attribute.
"""
function get_components(sys::System, attribute::SupplementalAttribute)
    return IS.get_components(sys.data, attribute)
end

"""
Get the component by UUID.
"""
get_component(sys::System, uuid::Base.UUID) = IS.get_component(sys.data, uuid)
get_component(sys::System, uuid::String) = IS.get_component(sys.data, Base.UUID(uuid))

"""
Change the UUID of a component.
"""
IS.assign_new_uuid!(sys::System, x::Component) = IS.assign_new_uuid!(sys.data, x)

function _get_components_by_name(abstract_types, data::IS.SystemData, name::AbstractString)
    _components = []
    for subtype in abstract_types
        component = IS.get_component(subtype, data, name)
        if !isnothing(component)
            push!(_components, component)
        end
    end

    return _components
end

"""
Get the components of abstract type T with name. Note that PowerSystems enforces unique
names on each concrete type but not across concrete types.

See [`get_component`](@ref) if the concrete type is known.

Throws ArgumentError if T is not an abstract type.
"""
function get_components_by_name(
    ::Type{T},
    sys::System,
    name::AbstractString,
) where {T <: Component}
    return IS.get_components_by_name(T, sys.data, name)
end

"""
Returns iterator of available components in a [`System`](@ref).

`T` can be a concrete or abstract [`Component`](@ref) type from the [Type Tree](@ref)
and must have the method `get_available` implemented.
Call collect on the result if an array is desired.
"""
function get_available_components(::Type{T}, sys::System) where {T <: Component}
    return get_components(get_available, T, sys)
end

"""
Return true if the component is attached to the system.
"""
function is_attached(component::T, sys::System) where {T <: Component}
    existing_component = get_component(T, sys, get_name(component))
    isnothing(existing_component) && return false
    return component === existing_component
end

"""
Throws ArgumentError if the component is not attached to the system.
"""
function throw_if_not_attached(component::Component, sys::System)
    if !is_attached(component, sys)
        throw(ArgumentError("$(summary(component)) is not attached to the system"))
    end
end

"""
Return a vector of devices contributing to the service.
"""
function get_contributing_devices(sys::System, service::T) where {T <: Service}
    throw_if_not_attached(service, sys)
    return [x for x in get_components(Device, sys) if has_service(x, service)]
end

struct ServiceContributingDevices
    service::Service
    contributing_devices::Vector{Device}
end

const ServiceContributingDevicesKey = NamedTuple{(:type, :name), Tuple{DataType, String}}
const ServiceContributingDevicesMapping =
    Dict{ServiceContributingDevicesKey, ServiceContributingDevices}

"""
Returns a ServiceContributingDevices object.
"""
function _get_contributing_devices(sys::System, service::T) where {T <: Service}
    uuid = IS.get_uuid(service)
    devices = ServiceContributingDevices(service, Vector{Device}())
    for device in get_components(Device, sys)
        for _service in get_services(device)
            if IS.get_uuid(_service) == uuid
                push!(devices.contributing_devices, device)
                break
            end
        end
    end
    return devices
end

"""
Return an instance of ServiceContributingDevicesMapping.
"""
function get_contributing_device_mapping(sys::System)
    services = ServiceContributingDevicesMapping()
    for service in get_components(Service, sys)
        key = ServiceContributingDevicesKey((typeof(service), get_name(service)))
        services[key] = _get_contributing_devices(sys, service)
    end

    return services
end

"""
Return a vector of components with buses in the AggregationTopology.
"""
function get_components_in_aggregation_topology(
    ::Type{T},
    sys::System,
    aggregator::AggregationTopology,
) where {T <: StaticInjection}
    buses = Set{String}((get_name(x) for x in get_buses(sys, aggregator)))
    components = Vector{T}()
    for component in get_components(T, sys)
        bus = get_bus(component)
        bus_name = get_name(bus)
        if bus_name in buses
            push!(components, component)
        end
    end

    return components
end

"Return whether the given component's bus is in the AggregationTopology."
function is_component_in_aggregation_topology(
    comp::Component,
    aggregator::T,
) where {T <: AggregationTopology}
    accessor = get_aggregation_topology_accessor(T)
    return IS.get_uuid(accessor(get_bus(comp))) == IS.get_uuid(aggregator)
end

"""
Return a mapping of AggregationTopology name to vector of buses within it.
"""
function get_aggregation_topology_mapping(
    ::Type{T},
    sys::System,
) where {T <: AggregationTopology}
    mapping = Dict{String, Vector{ACBus}}()
    accessor_func = get_aggregation_topology_accessor(T)
    for bus in get_components(ACBus, sys)
        aggregator = accessor_func(bus)
        name = get_name(aggregator)
        buses = get(mapping, name, nothing)
        if isnothing(buses)
            mapping[name] = Vector{ACBus}([bus])
        else
            push!(buses, bus)
        end
    end

    return mapping
end

"""
Return a vector of buses contained within the AggregationTopology.
"""
function get_buses(sys::System, aggregator::AggregationTopology)
    return _get_buses(sys.data, aggregator)
end

function _get_buses(data::IS.SystemData, aggregator::T) where {T <: AggregationTopology}
    accessor_func = get_aggregation_topology_accessor(T)
    buses = Vector{ACBus}()
    for bus in IS.get_components(ACBus, data)
        _aggregator = accessor_func(bus)
        if !isnothing(_aggregator) && IS.get_uuid(_aggregator) == IS.get_uuid(aggregator)
            push!(buses, bus)
        end
    end

    return buses
end

"""
Add time series data to a component.

Throws ArgumentError if the component is not stored in the system.

"""
function add_time_series!(
    sys::System,
    component::Component,
    time_series::TimeSeriesData;
    features...,
)
    return IS.add_time_series!(sys.data, component, time_series; features...)
end

"""
Add many time series in bulk

This method is advantageous when adding thousands of time
series arrays because of the overhead in writing the time series to the underlying storage.

# Arguments
- `sys::System`: system
- `associations`: Iterable of [`TimeSeriesAssociation`](@ref) instances. Using a Vector is not
  recommended. Pass a Generator or Iterator to avoid loading all time series data into
  system memory at once.
- `batch_size::Int`: (Default = 100) Number of time series to add per batch.

# Examples
```julia
# Assumes `read_time_series` will return data appropriate for Deterministic forecasts
# based on the generator name and the filenames match the component and time series names.
resolution = Dates.Hour(1)
associations = (
    IS.TimeSeriesAssociation(
        gen,
        Deterministic(
            data = read_time_series(get_name(gen) * ".csv"),
            name = "get_max_active_power",
            resolution=resolution),
    )
    for gen in get_components(ThermalStandard, sys)
)
bulk_add_time_series!(sys, associations)
```

See also: [`open_time_series_store!`](@ref) to minimize HDF5 file handle overhead if you
must add time series arrays one at a time
"""
function bulk_add_time_series!(
    sys::System,
    associations;
    batch_size::Int = IS.ADD_TIME_SERIES_BATCH_SIZE,
)
    return IS.bulk_add_time_series!(sys.data, associations; batch_size = batch_size)
end

"""
Add the same time series data to multiple components.

This function stores a single copy of the data. Each component will store a reference to
that data. This is significantly more efficent than calling `add_time_series!` for each
component individually with the same data because in this case, only one time series
array is stored.

Throws ArgumentError if a component is not stored in the system.
"""
function add_time_series!(sys::System, components, time_series::TimeSeriesData; features...)
    return IS.add_time_series!(sys.data, components, time_series; features...)
end

#=
# TODO 1.0: do we need this functionality? not currently present in IS
"""
Return a vector of time series data from a metadata file.

# Arguments
- `data::SystemData`: system
- `metadata_file::AbstractString`: path to metadata file
- `resolution::{Nothing, Dates.Period}`: skip data that doesn't match this resolution

See InfrastructureSystems.TimeSeriesFileMetadata for description of what the file
should contain.
"""
function make_time_series(sys::System, metadata_file::AbstractString; resolution = nothing)
    return IS.make_time_series(
        sys.data,
        metadata_file,
        PowerSystems;
        resolution = resolution,
    )
end

"""
Return a vector of time series data from a vector of TimeSeriesFileMetadata values.

# Arguments
- `data::SystemData`: system
- `timeseries_metadata::Vector{TimeSeriesFileMetadata}`: metadata values
- `resolution::{Nothing, Dates.Period}`: skip data that doesn't match this resolution
"""
function make_time_series(
    sys::System,
    metadata::Vector{IS.TimeSeriesFileMetadata};
    resolution = nothing,
)
    return IS.make_time_series!(sys.data, metadata; resolution = resolution)
end
=#

"""
Return the compression settings used for system data such as time series arrays.
"""
get_compression_settings(sys::System) = IS.get_compression_settings(sys.data)

"""
Return the initial times for all forecasts.
"""
get_forecast_initial_times(sys::System) = IS.get_forecast_initial_times(sys.data)

"""
Return the window count for all forecasts.
"""
get_forecast_window_count(sys::System) = IS.get_forecast_window_count(sys.data)

"""
Return the horizon for all forecasts.
"""
get_forecast_horizon(sys::System) = IS.get_forecast_horizon(sys.data)

"""
Return the initial_timestamp for all forecasts.
"""
get_forecast_initial_timestamp(sys::System) = IS.get_forecast_initial_timestamp(sys.data)

"""
Return the interval for all forecasts.
"""
get_forecast_interval(sys::System) = IS.get_forecast_interval(sys.data)

"""
Return a sorted Vector of distinct resolutions for all time series of the given type
(or all types).
"""
get_time_series_resolutions(
    sys::System;
    time_series_type::Union{Type{<:TimeSeriesData}, Nothing} = nothing,
) = IS.get_time_series_resolutions(sys.data; time_series_type = time_series_type)

"""
Return an iterator of time series in order of initial time.

Note that passing a filter function can be much slower than the other filtering parameters
because it reads time series data from media.

Call `collect` on the result to get an array.

# Arguments
- `data::SystemData`: system
- `filter_func = nothing`: Only return time series for which this returns true.
- `type = nothing`: Only return time series with this type.
- `name = nothing`: Only return time series matching this value.

# Examples
```julia
for time_series in get_time_series_multiple(sys)
    @show time_series
end

ts = collect(get_time_series_multiple(sys; type = SingleTimeSeries))
```
"""
function IS.get_time_series_multiple(
    sys::System,
    filter_func = nothing;
    type = nothing,
    name = nothing,
)
    return get_time_series_multiple(sys.data, filter_func; type = type, name = name)
end

"""
Clear all time series data from the system.

If you are storing time series data in an HDF5 file, this will
will delete the HDF5 file and create a new one.

See also: [`remove_time_series!`](@ref remove_time_series!(sys::System, ::Type{T}) where {T <: TimeSeriesData})
"""
function clear_time_series!(sys::System)
    return IS.clear_time_series!(sys.data)
end

"""
Remove the time series data for a component and time series type.
"""
function remove_time_series!(
    sys::System,
    ::Type{T},
    component::Component,
    name::String,
) where {T <: TimeSeriesData}
    return IS.remove_time_series!(sys.data, T, component, name)
end

"""
Remove all the time series data for a time series type.

See also: [`clear_time_series!`](@ref)

If you are storing time series data in an HDF5 file, `remove_time_series!` does
not actually free up file space (HDF5 behavior). If you want to remove all or
most time series instances then consider using `clear_time_series!`. It
will delete the HDF5 file and create a new one. PowerSystems has plans to
automate this type of workflow.
"""
function remove_time_series!(sys::System, ::Type{T}) where {T <: TimeSeriesData}
    return IS.remove_time_series!(sys.data, T)
end

"""
Transform all instances of [`SingleTimeSeries`](@ref) in a `System` to
[`DeterministicSingleTimeSeries`](@ref)

This can be used to generate a perfect forecast from historical measurements or realizations
when actual forecasts are unavailable, without unnecessarily duplicating data.

If all `SingleTimeSeries` instances cannot be transformed then none will be.

Any existing `DeterministicSingleTimeSeries` forecasts will be deleted even if the inputs are
invalid.

# Arguments
- `sys::System`: System containing the components.
- `horizon::Dates.Period`: desired [horizon](@ref H) of each forecast [window](@ref W)
- `interval::Dates.Period`: desired [interval](@ref I) between forecast [windows](@ref W)
"""
function transform_single_time_series!(
    sys::System,
    horizon::Dates.Period,
    interval::Dates.Period,
)
    IS.transform_single_time_series!(
        sys.data,
        IS.DeterministicSingleTimeSeries,
        horizon,
        interval,
    )
    return
end

"""
Add a supplemental attribute to the component. The attribute may already be attached to a
different component.
"""
function add_supplemental_attribute!(
    sys::System,
    component::Component,
    attribute::IS.SupplementalAttribute,
)
    return IS.add_supplemental_attribute!(sys.data, component, attribute)
end

"""
Remove the supplemental attribute from the component. The attribute will be removed from the
system if it is not attached to any other component.
"""
function remove_supplemental_attribute!(
    sys::System,
    component::Component,
    attribute::IS.SupplementalAttribute,
)
    return IS.remove_supplemental_attribute!(sys.data, component, attribute)
end

"""
Remove the supplemental attribute from the system and all attached components.
"""
function remove_supplemental_attribute!(sys::System, attribute::IS.SupplementalAttribute)
    return IS.remove_supplemental_attribute!(sys.data, attribute)
end

"""
Remove all supplemental attributes with the given type from the system.
"""
function remove_supplemental_attributes!(
    ::Type{T},
    sys::System,
) where {T <: IS.SupplementalAttribute}
    return IS.remove_supplemental_attributes!(T, sys.data)
end

"""
Returns an iterator of supplemental attributes. T can be concrete or abstract.
Call collect on the result if an array is desired.

# Examples
```julia
iter = get_supplemental_attributes(GeometricDistributionForcedOutage, sys)
iter = get_supplemental_attributes(Outage, sys)
iter = get_supplemental_attributes(x -> get_mean_time_to_recovery(x) ==  >= 0.5, GeometricDistributionForcedOutage, sys)
outages = get_supplemental_attributes(GeometricDistributionForcedOutage, sys) do outage
    get_mean_time_to_recovery(x) ==  >= 0.5
end
outages = collect(get_supplemental_attributes(GeometricDistributionForcedOutage, sys))
```

See also: [`iterate_supplemental_attributes`](@ref)
"""
function get_supplemental_attributes(
    filter_func::Function,
    ::Type{T},
    sys::System,
) where {T <: IS.SupplementalAttribute}
    return IS.get_supplemental_attributes(filter_func, T, sys.data)
end

function get_supplemental_attributes(
    ::Type{T},
    sys::System,
) where {T <: IS.SupplementalAttribute}
    return IS.get_supplemental_attributes(T, sys.data)
end

"""
Return the supplemental attribute with the given uuid.

Throws ArgumentError if the attribute is not stored.
"""
function get_supplemental_attribute(sys::System, uuid::Base.UUID)
    return IS.get_supplemental_attribute(sys.data, uuid)
end

"""
Iterates over all supplemental_attributes.

# Examples
```julia
for supplemental_attribute in iterate_supplemental_attributes(sys)
    @show supplemental_attribute
end
```

See also: [`get_supplemental_attributes`](@ref)
"""
function iterate_supplemental_attributes(sys::System)
    return IS.iterate_supplemental_attributes(sys.data)
end

"""
Sanitize component values.
"""
sanitize_component!(component::Component, sys::System) = true

"""
Validate the component fields using only those fields. Refer to
[`validate_component_with_system`](@ref) to use other System data for the
validation.

Return true if the instance is valid.
"""
validate_component(component::Component) = true

"""
Validate a component against System data. Return true if the instance is valid.

Refer to [`validate_component`](@ref) if the validation logic only requires data contained
within the instance.
"""
validate_component_with_system(component::Component, sys::System) = true

Base.@deprecate validate_struct(sys::System, component::Component) validate_component_with_system(
    component,
    sys,
) false

# Keeps the code working with IS.
IS.validate_struct(component::Component) = validate_component(component)

"""
Check system consistency and validity.
"""
function check(sys::System)
    buses = get_components(ACBus, sys)
    slack_bus_check(buses)
    buscheck(buses)
    critical_components_check(sys)
    adequacy_check(sys)
    check_subsystems(sys)
    return
end

"""
Check the the consistency of subsystems.
"""
function check_subsystems(sys::System)
    must_be_assigned_to_subsystem = false
    for (i, component) in enumerate(iterate_components(sys))
        is_assigned = is_assigned_to_subsystem(sys, component)
        if i == 1
            must_be_assigned_to_subsystem = is_assigned
        elseif is_assigned != must_be_assigned_to_subsystem
            throw(
                IS.InvalidValue(
                    "If any component is assigned to a subsystem then all " *
                    "components must be assigned to a subsystem.",
                ),
            )
        end
        check_subsystems(sys, component)
    end
end

"""
Check the values of all components. See [`check_component`](@ref) for exceptions thrown.
"""
function check_components(sys::System; check_masked_components = true)
    must_be_assigned_to_subsystem = false
    for (i, component) in enumerate(iterate_components(sys))
        is_assigned = is_assigned_to_subsystem(sys, component)
        if i == 1
            must_be_assigned_to_subsystem = is_assigned
        elseif is_assigned != must_be_assigned_to_subsystem
            throw(
                IS.InvalidValue(
                    "If any component is assigned to a subsystem then all " *
                    "components must be assigned to a subsystem.",
                ),
            )
        end
        check_component(sys, component)
    end

    if check_masked_components
        for component in IS.get_masked_components(Component, sys.data)
            check_component(sys, component)
        end
    end
end

"""
Check the values of components of a given abstract or concrete type.
See [`check_component`](@ref) for exceptions thrown.
"""
function check_components(
    sys::System,
    ::Type{T};
    check_masked_components = true,
) where {T <: Component}
    for component in get_components(T, sys)
        check_component(sys, component)
    end

    if check_masked_components
        for component in IS.get_masked_components(T, sys.data)
            check_component(sys, component)
        end
    end
end

"""
Check the values of each component in an iterable of components.
See [`check_component`](@ref) for exceptions thrown.
"""
function check_components(sys::System, components)
    for component in components
        check_component(sys, component)
    end
end

"""
Check the values of a component.

Throws InvalidValue if any of the component's field values are outside of defined valid
range or if the custom validate method for the type fails its check.
"""
function check_component(sys::System, component::Component)
    if !validate_component_with_system(component, sys)
        throw(IS.InvalidValue("Invalid value for $component"))
    end
    IS.check_component(sys.data, component)
    return
end

function check_sil_values(sys::System)
    is_valid = true
    base_power = get_base_power(sys)
    for line in
        Iterators.flatten((get_components(Line, sys), get_components(MonitoredLine, sys)))
        if !check_sil_values(line, base_power)
            is_valid = false
        end
    end
    return is_valid
end

function IS.serialize(sys::T) where {T <: System}
    data = Dict{String, Any}()
    data["data_format_version"] = DATA_FORMAT_VERSION
    for field in fieldnames(T)
        # Exclude bus_numbers because they will get rebuilt during deserialization.
        # Exclude time_series_directory because the system may get deserialized on a
        # different system.
        if field != :bus_numbers && field != :time_series_directory
            data[string(field)] = serialize(getfield(sys, field))
        end
    end

    return data
end

function IS.deserialize(
    ::Type{System},
    filename::AbstractString;
    kwargs...,
)
    raw = open(filename) do io
        JSON3.read(io, Dict)
    end

    if raw["data_format_version"] != DATA_FORMAT_VERSION
        pre_read_conversion!(raw)
    end

    # These file paths are relative to the system file.
    directory = dirname(filename)
    for file_key in ("time_series_storage_file",)
        if haskey(raw["data"], file_key) && !isabspath(raw["data"][file_key])
            raw["data"][file_key] = joinpath(directory, raw["data"][file_key])
        end
    end

    return from_dict(System, raw; kwargs...)
end

function from_dict(
    ::Type{System},
    raw::Dict{String, Any};
    time_series_read_only = false,
    time_series_directory = nothing,
    config_path = POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE,
    kwargs...,
)
    # Read any field that is defined in System but optional for the constructors and not
    # already handled here.
    handled = (
        "data",
        "units_settings",
        "bus_numbers",
        "internal",
        "data_format_version",
        "metadata",
        "name",
        "description",
    )
    parsed_kwargs = Dict{Symbol, Any}()
    for field in setdiff(keys(raw), handled)
        parsed_kwargs[Symbol(field)] = raw[field]
    end

    # The user can override the serialized runchecks value by passing a kwarg here.
    if haskey(kwargs, :runchecks)
        parsed_kwargs[:runchecks] = kwargs[:runchecks]
    end

    units = IS.deserialize(SystemUnitsSettings, raw["units_settings"])
    data = IS.deserialize(
        IS.SystemData,
        raw["data"];
        time_series_read_only = time_series_read_only,
        time_series_directory = time_series_directory,
        validation_descriptor_file = config_path,
    )
    metadata = get(raw, "metadata", Dict())
    name = get(metadata, "name", nothing)
    description = get(metadata, "description", nothing)
    internal = IS.deserialize(InfrastructureSystemsInternal, raw["internal"])
    sys = System(
        data,
        units,
        internal;
        name = name,
        description = description,
        parsed_kwargs...,
    )

    if raw["data_format_version"] != DATA_FORMAT_VERSION
        pre_deserialize_conversion!(raw, sys)
    end

    ext = get_ext(sys)
    ext["deserialization_in_progress"] = true
    try
        deserialize_components!(sys, raw["data"])
    finally
        pop!(ext, "deserialization_in_progress")
        isempty(ext) && clear_ext!(sys)
    end

    if !get_runchecks(sys)
        @warn "The System was deserialized with checks disabled, and so was not validated."
    end

    if raw["data_format_version"] != DATA_FORMAT_VERSION
        post_deserialize_conversion!(sys, raw)
    end

    return sys
end

function deserialize_components!(sys::System, raw)
    # Convert the array of components into type-specific arrays to allow addition by type.
    data = Dict{Any, Vector{Dict}}()
    # This field was not present in older versions.
    masked_components = get(raw, "masked_components", [])
    for component in Iterators.Flatten((raw["components"], masked_components))
        type = IS.get_type_from_serialization_data(component)
        components = get(data, type, nothing)
        if components === nothing
            components = Vector{Dict}()
            data[type] = components
        end
        push!(components, component)
    end

    # Maintain a lookup of UUID to component because some component types encode
    # composed types as UUIDs instead of actual types.
    component_cache = Dict{Base.UUID, Component}()

    # Add each type to this as we parse.
    parsed_types = Set()

    function is_matching_type(type, types)
        return any(x -> type <: x, types)
    end

    function deserialize_and_add!(;
        skip_types = nothing,
        include_types = nothing,
        post_add_func = nothing,
    )
        for (type, components) in data
            type in parsed_types && continue
            if !isnothing(skip_types) && is_matching_type(type, skip_types)
                continue
            end
            if !isnothing(include_types) && !is_matching_type(type, include_types)
                continue
            end
            for component in components
                handle_deserialization_special_cases!(component, type)
                comp = deserialize(type, component, component_cache)
                add_component!(sys, comp)
                component_cache[IS.get_uuid(comp)] = comp
                if !isnothing(post_add_func)
                    post_add_func(comp)
                end
            end
            push!(parsed_types, type)
        end
    end

    # Run in order based on type composition.
    # Bus and AGC instances can have areas and LoadZones.
    # Most components have buses.
    # Static injection devices can contain dynamic injection devices.
    # StaticInjectionSubsystem instances have StaticInjection subcomponents.
    deserialize_and_add!(; include_types = [Area, LoadZone])
    deserialize_and_add!(; include_types = [AGC])
    deserialize_and_add!(; include_types = [Bus])
    deserialize_and_add!(;
        include_types = [Arc, Service],
        skip_types = [ConstantReserveGroup],
    )
    deserialize_and_add!(; include_types = [Branch])
    deserialize_and_add!(; include_types = [DynamicBranch])
    deserialize_and_add!(; include_types = [ConstantReserveGroup, DynamicInjection])
    deserialize_and_add!(; skip_types = [StaticInjectionSubsystem])
    deserialize_and_add!()

    for subsystem in get_components(StaticInjectionSubsystem, sys)
        # This normally happens when the subsytem is added to the system.
        # Workaround for deserialization.
        for subcomponent in get_subcomponents(subsystem)
            IS.mask_component!(sys.data, subcomponent)
        end
    end
end

"""
Allow types to implement handling of special cases during deserialization.

# Arguments
- `component::Dict`: The component serialized as a dictionary.
- `::Type`: The type of the component.
"""
handle_deserialization_special_cases!(component::Dict, ::Type{<:Component}) = nothing

# TODO DT: Do I need to handle this in the new format upgrade?
#function handle_deserialization_special_cases!(component::Dict, ::Type{DynamicBranch})
#    # IS handles deserialization of supplemental attribues in each component.
#    # In this case the DynamicBranch's composed branch is not part of the system and so
#    # IS will not handle it. It can never attributes.
#    if !isempty(component["branch"]["supplemental_attributes_container"])
#        error(
#            "Bug: serialized DynamicBranch.branch has supplemental attributes: $component",
#        )
#    end
#    return
#end

"""
Return bus with name.
"""
function get_bus(sys::System, name::AbstractString)
    return get_component(ACBus, sys, name)
end

"""
Return bus with bus_number.
"""
function get_bus(sys::System, bus_number::Int)
    for bus in get_components(ACBus, sys)
        if bus.number == bus_number
            return bus
        end
    end

    return nothing
end

"""
Return all buses values with bus_numbers.
"""
function get_buses(sys::System, bus_numbers::Set{Int})
    buses = Vector{ACBus}()
    for bus in get_components(ACBus, sys)
        if bus.number in bus_numbers
            push!(buses, bus)
        end
    end

    return buses
end

"""
Return all the device types in the system. It does not return component types or masked components.
"""
function get_existing_device_types(sys::System)
    device_types = Vector{DataType}()
    for component_type in keys(sys.data.components.data)
        if component_type <: Device
            push!(device_types, component_type)
        end
    end
    return device_types
end

"""
Return all the component types in the system. It does not return masked components.
"""
function get_existing_component_types(sys::System)
    return collect(keys(sys.data.components.data))
end

function _is_deserialization_in_progress(sys::System)
    ext = get_ext(sys)
    return get(ext, "deserialization_in_progress", false)
end

check_for_services_on_addition(sys::System, component::Component) = nothing

function check_for_services_on_addition(sys::System, component::Device)
    if supports_services(component) && length(get_services(component)) > 0
        throw(ArgumentError("type Device cannot be added with services"))
    end
    return
end

function check_topology(sys::System, component::AreaInterchange)
    throw_if_not_attached(get_from_area(component), sys)
    throw_if_not_attached(get_to_area(component), sys)
    return
end

function check_topology(sys::System, component::Component)
    check_attached_buses(sys, component)
    return
end

"""
Throws ArgumentError if any bus attached to the component is invalid.
"""
check_attached_buses(sys::System, component::Component) = nothing

function check_attached_buses(sys::System, component::StaticInjection)
    throw_if_not_attached(get_bus(component), sys)
    return
end

function check_attached_buses(sys::System, component::Branch)
    throw_if_not_attached(get_from_bus(component), sys)
    throw_if_not_attached(get_to_bus(component), sys)
    return
end

function check_attached_buses(sys::System, component::DynamicBranch)
    check_attached_buses(sys, get_branch(component))
    return
end

function check_attached_buses(sys::System, component::Arc)
    throw_if_not_attached(get_from(component), sys)
    throw_if_not_attached(get_to(component), sys)
    return
end

"""
Throws ArgumentError if a PowerSystems rule blocks addition to the system.

This method is tied with handle_component_addition!. If the methods are re-implemented for
a subtype then whatever is added in handle_component_addition! must be checked here.
"""
check_component_addition(sys::System, component::Component; kwargs...) = nothing

"""
Throws ArgumentError if a PowerSystems rule blocks removal from the system.
"""
check_component_removal(sys::System, component::Component) = nothing

function check_component_removal(sys::System, static_injector::StaticInjection)
    if get_dynamic_injector(static_injector) !== nothing
        name = get_name(static_injector)
        throw(ArgumentError("$name cannot be removed with an attached dynamic injector"))
    end
end

"""
Refer to docstring for check_component_addition!
"""
handle_component_addition!(sys::System, component::Component; kwargs...) = nothing

handle_component_removal!(sys::System, component::Component) = nothing

function check_component_addition(sys::System, branch::AreaInterchange; kwargs...)
    throw_if_not_attached(get_from_area(branch), sys)
    throw_if_not_attached(get_to_area(branch), sys)
    return
end

function check_component_addition(sys::System, branch::Branch; kwargs...)
    arc = get_arc(branch)
    throw_if_not_attached(get_from(arc), sys)
    throw_if_not_attached(get_to(arc), sys)
    return
end

function check_component_addition(sys::System, dyn_branch::DynamicBranch; kwargs...)
    if !_is_deserialization_in_progress(sys)
        throw_if_not_attached(dyn_branch.branch, sys)
    end
    arc = get_arc(dyn_branch)
    throw_if_not_attached(get_from(arc), sys)
    throw_if_not_attached(get_to(arc), sys)
    return
end

function check_component_addition(sys::System, dyn_injector::DynamicInjection; kwargs...)
    if _is_deserialization_in_progress(sys)
        # Ordering of component addition makes these checks impossible.
        return
    end

    static_injector = get(kwargs, :static_injector, nothing)
    if static_injector === nothing
        throw(
            ArgumentError("static_injector must be passed when adding a DynamicInjection"),
        )
    end

    if get_name(dyn_injector) != get_name(static_injector)
        throw(
            ArgumentError(
                "static_injector must have the same name as the DynamicInjection",
            ),
        )
    end

    throw_if_not_attached(static_injector, sys)
    return
end

function check_component_addition(sys::System, bus::ACBus; kwargs...)
    number = get_number(bus)
    if number in sys.bus_numbers
        throw(ArgumentError("bus number $number is already stored in the system"))
    end

    area = get_area(bus)
    if !isnothing(area)
        throw_if_not_attached(area, sys)
    end

    load_zone = get_load_zone(bus)
    if !isnothing(load_zone)
        throw_if_not_attached(load_zone, sys)
    end
end

function handle_component_addition!(sys::System, bus::ACBus; kwargs...)
    number = get_number(bus)
    @assert !(number in sys.bus_numbers) "bus number $number is already stored"
    push!(sys.bus_numbers, number)
    return
end

function handle_component_addition!(sys::System, component::Branch; kwargs...)
    _handle_branch_addition_common!(sys, component)
    return
end

function handle_component_addition!(sys::System, component::DynamicBranch; kwargs...)
    _handle_branch_addition_common!(sys, component)
    remove_component!(sys, component.branch)
    return
end

function handle_component_addition!(sys::System, dyn_injector::DynamicInjection; kwargs...)
    static_injector = kwargs[:static_injector]
    static_base_power = get_base_power(static_injector)
    set_base_power!(dyn_injector, static_base_power)
    set_dynamic_injector!(static_injector, dyn_injector)
    return
end

function handle_component_addition!(
    sys::System,
    subsystem::StaticInjectionSubsystem;
    kwargs...,
)
    for subcomponent in get_subcomponents(subsystem)
        if is_attached(subcomponent, sys)
            IS.mask_component!(sys.data, subcomponent)
            copy_subcomponent_time_series!(subsystem, subcomponent)
        else
            IS.add_masked_component!(sys.data, subcomponent)
        end
    end
end

function _handle_branch_addition_common!(sys::System, component::Branch)
    # If this arc is already attached to the system, assign it to the branch.
    # Else, add it to the system.
    arc = get_arc(component)
    _arc = get_component(Arc, sys, get_name(arc))
    if isnothing(_arc)
        add_component!(sys, arc)
    else
        set_arc!(component, _arc)
    end
    return
end

_handle_branch_addition_common!(sys::System, component::AreaInterchange) = nothing

"""
Throws ArgumentError if the bus number is not stored in the system.
"""
function handle_component_removal!(sys::System, bus::ACBus)
    _handle_component_removal_common!(bus)
    number = get_number(bus)
    @assert number in sys.bus_numbers "bus number $number is not stored"
    pop!(sys.bus_numbers, number)
    return
end

function handle_component_removal!(sys::System, device::Device)
    _handle_component_removal_common!(device)
    # This may have to be refactored if handle_component_removal! needs to be implemented
    # for a subtype.
    clear_services!(device)
    return
end

function handle_component_removal!(sys::System, service::Service)
    _handle_component_removal_common!(service)
    for device in get_components(Device, sys)
        _remove_service!(device, service)
    end
end

function handle_component_removal!(sys::System, component::StaticInjectionSubsystem)
    _handle_component_removal_common!(component)
    subcomponents = collect(get_subcomponents(component))
    for subcomponent in subcomponents
        IS.remove_masked_component!(sys.data, subcomponent)
    end
end

function handle_component_removal!(sys::System, value::T) where {T <: AggregationTopology}
    _handle_component_removal_common!(value)
    for device in get_components(ACBus, sys)
        if get_aggregation_topology_accessor(T)(device) == value
            _remove_aggregration_topology!(device, value)
        end
    end
end

function handle_component_removal!(sys::System, dyn_injector::DynamicInjection)
    _handle_component_removal_common!(dyn_injector)
    injectors = get_components_by_name(StaticInjection, sys, get_name(dyn_injector))
    found = false
    for static_injector in injectors
        _dyn_injector = get_dynamic_injector(static_injector)
        _dyn_injector === nothing && continue
        if _dyn_injector === dyn_injector
            @assert !found
            set_dynamic_injector!(static_injector, nothing)
            found = true
        end
    end

    @assert found
end

function _handle_component_removal_common!(component)
    clear_units!(component)
end

"""
Return a sorted vector of bus numbers in the system.
"""
function get_bus_numbers(sys::System)
    return sort(collect(sys.bus_numbers))
end

_fetch_match_fn(match_fn::Function) = match_fn
_fetch_match_fn(::Nothing) = IS.isequivalent

function IS.compare_values(
    match_fn::Union{Function, Nothing},
    x::T,
    y::T;
    compare_uuids = false,
    exclude = Set{Symbol}(),
) where {T <: Union{StaticInjection, DynamicInjection}}
    # Must implement this method because a device of one of these subtypes might have a
    # reference to its counterpart, and vice versa, and so infinite recursion will occur
    # in the default function.
    match = true
    for name in fieldnames(T)
        name in exclude && continue
        val1 = getfield(x, name)
        val2 = getfield(y, name)
        if val1 isa StaticInjection || val2 isa DynamicInjection
            if !compare_uuids
                name1 = get_name(val1)
                name2 = get_name(val2)
                if !match_fn(name1, name2)
                    @error "values do not match" T name name1 name2
                    match = false
                end
            else
                uuid1 = IS.get_uuid(val1)
                uuid2 = IS.get_uuid(val2)
                if uuid1 != uuid2
                    @error "values do not match" T name uuid1 uuid2
                    match = false
                end
            end
        elseif !isempty(fieldnames(typeof(val1)))
            if !IS.compare_values(
                match_fn,
                val1,
                val2;
                compare_uuids = compare_uuids,
                exclude = exclude,
            )
                @error "values do not match" T name val1 val2
                match = false
            end
        elseif val1 isa AbstractArray
            if !IS.compare_values(
                match_fn,
                val1,
                val2;
                compare_uuids = compare_uuids,
                exclude = exclude,
            )
                match = false
            end
        else
            if !_fetch_match_fn(match_fn)(val1, val2)
                @error "values do not match" T name val1 val2
                match = false
            end
        end
    end

    return match
end

function _create_system_data_from_kwargs(;
    time_series_in_memory = false,
    time_series_directory = nothing,
    compression = nothing,
    enable_compression = false,
    config_path = POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE,
    kwargs...,
)
    if isnothing(compression)
        compression = IS.CompressionSettings(; enabled = enable_compression)
    end

    return IS.SystemData(;
        validation_descriptor_file = config_path,
        time_series_in_memory = time_series_in_memory,
        time_series_directory = time_series_directory,
        compression = compression,
    )
end

"""
Converts a Line component to a MonitoredLine component and replaces the original in the
system
"""
function convert_component!(
    sys::System,
    line::Line,
    linetype::Type{MonitoredLine};
    kwargs...,
)
    new_line = linetype(
        line.name,
        line.available,
        line.active_power_flow,
        line.reactive_power_flow,
        line.arc,
        line.r,
        line.x,
        line.b,
        (from_to = line.rating, to_from = line.rating),
        line.rating,
        line.angle_limits,
        line.g,
        line.services,
        line.ext,
        _copy_internal_for_conversion(line),
    )
    IS.assign_new_uuid!(sys, line)
    add_component!(sys, new_line)
    copy_time_series!(new_line, line)
    # TODO: PSY4
    # copy_supplemental_attibutes!(new_line, line)
    remove_component!(sys, line)
    return
end

"""
Converts a MonitoredLine component to a Line component and replaces the original in the
system.
"""
function convert_component!(
    sys::System,
    line::MonitoredLine,
    linetype::Type{Line};
    kwargs...,
)
    force = get(kwargs, :force, false)
    if force
        @warn("Possible data loss converting from $(typeof(line)) to $linetype")
    else
        error(
            "Possible data loss converting from $(typeof(line)) to $linetype, add `force = true` to convert anyway.",
        )
    end

    new_line = linetype(
        line.name,
        line.available,
        line.active_power_flow,
        line.reactive_power_flow,
        line.arc,
        line.r,
        line.x,
        line.b,
        line.rating,
        line.angle_limits,
        line.g,
        line.services,
        line.ext,
        _copy_internal_for_conversion(line),
    )
    IS.assign_new_uuid!(sys, line)
    add_component!(sys, new_line)
    copy_time_series!(new_line, line)
    # TODO: PSY4
    # copy_supplemental_attibutes!(new_line, line)
    remove_component!(sys, line)
    return
end

"""
Converts a PowerLoad component to a StandardLoad component and replaces the original in the
system. Does not set any fields in StandardLoad that lack a PowerLoad equivalent.
"""
function convert_component!(
    sys::System,
    old_load::PowerLoad,
    new_type::Type{StandardLoad};
    kwargs...,
)
    new_load = new_type(;
        name = get_name(old_load),
        available = get_available(old_load),
        bus = get_bus(old_load),
        base_power = get_base_power(old_load),
        constant_active_power = get_active_power(old_load),
        constant_reactive_power = get_reactive_power(old_load),
        max_constant_active_power = get_max_active_power(old_load),
        max_constant_reactive_power = get_max_active_power(old_load),
        dynamic_injector = get_dynamic_injector(old_load),
        internal = _copy_internal_for_conversion(old_load),
        services = Device[],
    )
    IS.assign_new_uuid!(sys, old_load)
    add_component!(sys, new_load)
    copy_time_series!(new_load, old_load)
    # TODO: PSY4
    # copy_supplemental_attibutes!(new_line, line)
    for service in get_services(old_load)
        add_service!(new_load, service, sys)
    end
    remove_component!(sys, old_load)
end

# Use this function to avoid deepcopy of shared_system_references.
function _copy_internal_for_conversion(component::Component)
    internal = get_internal(component)
    refs = internal.shared_system_references
    return InfrastructureSystemsInternal(;
        uuid = deepcopy(internal.uuid),
        units_info = deepcopy(internal.units_info),
        shared_system_references = IS.SharedSystemReferences(;
            supplemental_attribute_manager = refs.supplemental_attribute_manager,
            time_series_manager = refs.time_series_manager,
        ),
        ext = deepcopy(internal.ext),
    )
end

function _validate_or_skip!(sys, component, skip_validation)
    if skip_validation && get_runchecks(sys)
        @warn(
            "skip_validation is deprecated; construct System with runchecks = true or call set_runchecks!. Disabling System.runchecks"
        )
        set_runchecks!(sys, false)
    end

    # Always skip if system checks are disabled.
    if !skip_validation && !get_runchecks(sys)
        skip_validation = true
    end

    if !skip_validation
        sanitize_component!(component, sys)
        if !validate_component_with_system(component, sys)
            throw(IS.InvalidValue("Invalid value for $component"))
        end
    end

    return skip_validation
end

"""
Returns counts of time series including attachments to components and supplemental
attributes.
"""
get_time_series_counts(sys::System) = IS.get_time_series_counts(sys.data)

"""
Checks time series in the system for inconsistencies.

For SingleTimeSeries, returns a Tuple of initial_timestamp and length.

This is a no-op for subtypes of Forecast because those are already guaranteed to be
consistent.

Throws InfrastructureSystems.InvalidValue if any time series is inconsistent.
"""
function check_time_series_consistency(sys::System, ::Type{T}) where {T <: TimeSeriesData}
    return IS.check_time_series_consistency(sys.data, T)
end

stores_time_series_in_memory(sys::System) = IS.stores_time_series_in_memory(sys.data)
