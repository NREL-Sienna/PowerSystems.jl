# [Parse Tabular Data from .csv Files](@id table_data)

!!! warning
    
    This parser will be deprecated sometime in the fall of 2024. `PowerSystems.jl` will be
    moving to a database solution for handling data. There are plans to eventually include
    utility functions to translate from .csv files to the database, but there will probably
    be a gap in support. **Users are recommended to write their own custom Julia code to
    import data from their unique data formats, rather than relying on this parsing
    code.**

This parser, called the tabular data parser, is a custom format that allows users to define
power system component data by category and column with custom names, types, and units.

## Categories

Components for each category must be defined in their own CSV file. The
following categories are currently supported:

  - branch.csv

  - bus.csv (required)
    
      + columns specifying `area` and `zone` will create a corresponding set of `Area` and `LoadZone` objects.
      + columns specifying `max_active_power` or `max_reactive_power` will create `PowerLoad` objects when nonzero values are encountered and will contribute to the `peak_active_power` and `peak_reactive_power` values for the
        corresponding `LoadZone` object.
  - dc_branch.csv
  - gen.csv
  - load.csv
  - reserves.csv
  - storage.csv

These must reside in the directory passed when constructing PowerSystemTableData.

## Customization

The tabular data parser in `PowerSystems.jl` can be customized to read a variety of
datasets by configuring:

  - [which type of generator (`<:Generator`) to create based on the fuel and prime mover specifications](@ref csv_genmap)
  - [property names](@ref csv_columns), [units](@ref csv_units), and [per units conversions](@ref csv_per_unit) in *.csv files

Here is an example of how to construct a System with all customizations listed in this section:

```julia
data_dir = "/data/my-data-dir"
base_power = 100.0
descriptors = "./user_descriptors.yaml"
timeseries_metadata_file = "./timeseries_pointers.json"
generator_mapping_file = "./generator_mapping.yaml"
data = PowerSystemTableData(
    data_dir,
    base_power,
    descriptors;
    timeseries_metadata_file = timeseries_metadata_file,
    generator_mapping_file = generator_mapping_file,
)
sys = System(data; time_series_in_memory = true)
```

Examples configuration files can be found in the [RTS-GMLC](https://github.com/GridMod/RTS-GMLC/) repo:

  - [user_descriptors.yaml](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/user_descriptors.yaml)
  - [generator_mapping.yaml](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/generator_mapping.yaml)

## [CSV Data Configurations](@id csv_data)

### [Custom construction of generators](@id csv_genmap)

`PowerSystems` supports custom construction of subtypes of the abstract type Generator based
on `fuel` and `type`. The parsing code detects these fields in the raw data and then
constructs the concrete type listed in the passed generator mapping file. The default file
is `src/parsers/generator_mapping.yaml`. You can override this behavior by specifying your
own file when constructing `PowerSystemTableData`.

### [Column names](@id csv_columns)

`PowerSystems` provides am input mapping capability that allows you to keep your own
column names.

For example, when parsing raw data for a generator the code expects a column
called `name`. If the raw data instead defines that column as `GEN UID` then
you can change the `custom_name` field under the `generator` category to
`GEN UID` in your YAML file.

To enable the parsing of a custom set of csv files, you can generate a configuration
file (such as `user_descriptors.yaml`) from the defaults, which are stored
in `src/descriptors/power_system_inputs.json`.

```python
python ./bin/generate_config_file.py ./user_descriptors.yaml
```

Next, edit this file with your customizations.

Note that the user-specific customizations are stored in YAML rather than JSON
to allow for easier editing. The next few sections describe changes you can
make to this YAML file.  Do not edit the default JSON file.

## [Per-unit conversion](@id csv_per_unit)

For more info on the per-unit conventions in `PowerSystems.jl`, refer to the [per-unit
section of the system documentation](@ref per_unit).

`PowerSystems` defines whether it expects a column value to be per-unit system base,
per-unit device base, or natural units in `power_system_inputs.json`. If it expects a
per-unit convention that differs from your values then you can set the `unit_system` in
`user_descriptors.yaml` and `PowerSystems` will automatically convert the values. For
example, if you have a `max_active_power` value stored in natural units (MW), but
`power_system_inputs.json` specifies `unit_system: device_base`, you can enter
`unit_system: natural_units` in `user_descriptors.yaml` and `PowerSystems` will divide
the value by the value of the corresponding entry in the column identified by the
`base_reference` field in `power_system_inputs.json`. You can also override the
`base_reference` setting by adding `base_reference: My Column` to make device base
per-unit conversion by dividing the value by the entry in `My Column`. System base
per-unit conversions always divide the value by the system `base_power` value
instantiated when constructing a `System`.

### [Unit conversion](@id csv_units)

`PowerSystems` provides a limited set of unit conversions. For example, if
`power_system_inputs.json` indicates that a value's unit is degrees but
your values are in radians then you can set `unit: radian` in
your YAML file. Other valid `unit` entries include `GW`, `GWh`, `MW`, `MWh`, `kW`,
and `kWh`.

## Extending the Tabular Data Parser

This section describes how developers should read columns from raw data files, and
assumes you are familiar with the sections above.

The main point is that you should not read individual hard-coded column names from
DataFrames. The parsing code includes mapping functionality that allows you to
use PowerSystems-standard names while letting the users define their own custom
names.

### Procedure

 1. Add an entry to the array of parameters for your category in
    `src/descriptors/power_system_inputs.json` according to the following:
    
     1. Use `snake_case` for the name field.
     2. The fields `name` and `description` are required.
     3. Try to use a name that is generic and not specific to one dataset.
     4. It is recommended that you define `unit`.
     5. If PowerSystems expects the value to be per-unit then you must specify
        `system_per_unit=true`.

 2. PowerSystems has two commonly-used datasets with customized user config
    files:
    [PowerSystemsTestData](https://github.com/NREL/PowerSystemsTestData/blob/main/RTS_GMLC/user_descriptors.yaml)
    and
    [RTS_GMLC](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/user_descriptors.yaml).
    Update both of these files and submit pull requests.
 3. Parse the raw data like in this example:

```julia
function demo_bus_csv_parser!(data::PowerSystemTableData)
    for bus in iterate_rows(data, BUS::InputCategory)
        @show bus.name, bus.max_active_power, bus.max_reactive_power
    end
end
```

`iterate_rows` returns a NamedTuple where each `name` defined in
`src/descriptors/power_system_inputs.json` is a field.

### See also:

  - Parsing [Matpower or PSS/e RAW Files](@ref pm_data)
  - Parsing [PSS/e DYR Files](@ref dyr_data)
  - Parsing [time series](@ref parsing_time_series)
