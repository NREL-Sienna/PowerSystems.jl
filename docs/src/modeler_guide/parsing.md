# Constructing a System from RAW data

## Supported Formats

- PowerSystems table data (CSV Files)
- MATPOWER (code copied with permision from [`PowerModels.jl`](https://github.com/lanl-ansi/PowerModels.jl))
- PSS/e RAW Files (code copied with permision from [`PowerModels.jl`](https://github.com/lanl-ansi/PowerModels.jl))
- PSS/e DYR Files

## PowerSystems Table Data

This is a custom format that allows users to define power system component data
by category and column with custom names, types, and units.

### Categories

Components for each category must be defined in their own CSV file. The
following categories are currently supported:

- branch.csv
- bus.csv (required)
- dc_branch.csv
- gen.csv
- load.csv
- reserves.csv
- storage.csv

These must reside in the directory passed when constructing PowerSystemTableData.

### Customization

Generate a configuration file (such as `user_descriptors.yaml`) from the
defaults, which are stored in `src/descriptors/power_system_inputs.json`.

```python
python ./bin/generate_config_file.py ./user_descriptors.yaml
```

Next, edit this file with your customizations.

Note that the user-specific customizations are stored in YAML rather than JSON
to allow for easier editing. The next few sections describe changes you can
make to this YAML file.  Do not edit the default JSON file.

### Column names

PowerSystems provides a mapping capability that allows you to keep your own
column names.

For example, when parsing raw data for a generator the code expects a column
called `name`. If the raw data instead defines that column as `GEN UID` then
you can change the `custom_name` field under the `generator` category to
`GEN UID` in your YAML file.

#### Per-unit conversion

PowerSystems defines whether it expects a column value to be per-unit system base,
per-unit device base, or natural units in `power_system_inputs.json`. If it expects a
per-unit convention that differs from your values then you can set the `unit_system` in
`user_descriptors.yaml` and PowerSystems will automatically convert the values. For
example, if you have a `max_active_power` value stored in natural units (MW), but
`power_system_inputs.json` specifies `unit_system: device_base`, you can enter
`unit_system: natural_units` in `user_descriptors.yaml` and PowerSystems will divide
the value by the value of the corresponding entry in the column identified by the
`base_reference` field in `power_system_inputs.json`. You can also override the
`base_reference` setting by adding `base_reference: My Column` to make device base
per-unit conversion by dividing the value by the entry in `My Column`. System base
per-unit conversions always divide the value by the system `base_power` value
instantiated when constructing a `System`.

#### Unit conversion

PowerSystems provides a limited set of unit conversions. For example, if
`power_system_inputs.json` indicates that a value's unit is degrees but
your values are in radians then you can set `unit: radian` in
your YAML file. Other valid `unit` entries include `GW`, `GWh`, `MW`, `MWh`, `kW`,
and `kWh`.

#### Example file

Refer to
[RTS_GMLC](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/user_descriptors.yaml)
for an example.

### [Adding Time Series Data](@id parsing_time_series)

PowerSystems requires a metadata file that maps components to their time series
data in order to be able to automatically construct time_series from raw data
files. The following fields are required for each time array:

- simulation:  User description of simulation
- category:  Type of component. Must map to PowerSystems abstract types (Bus,
  ElectricLoad, Generator, LoadZone, Reserve)
- component_name:  Name of component
- name:  User-defined name for the time series data.
- normalization_factor:  Controls normalization of the data. Use 1.0 for
  pre-normalized data. Use 'Max' to divide the time series by the max value in the
  column. Use any float for a custom scaling factor.
- data_file:  Path to the time series data file

PowerSystems supports this metadata in either CSV or JSON formats. Refer to
[RTS_GMLC](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/FormattedData/SIIP/timeseries_pointers.json)
for an example.

#### Performance considerations

By default PowerSystems stores time series data in HDF5 files. It does not keep
all of the data in memory. This means that every time you access a time_series
PowerSystems will have to read the data from storage, which will add latency. If
you know ahead of time that all of your data will fit in memory then you can
change this behavior by passing `time_series_in_memory = true` when you create
the System.

If the time series data is stored in HDF5 then PowerSystems will use the tmp filesystem by
default. You can change this by passing `time_series_directory = X` when you create the
System. This is required if the time series data is larger than the amount of tmp space
available.

### Custom construction of generators

PowerSystems supports custom construction of subtypes of the abstract type Generator based
on `fuel` and `type`. The parsing code detects these fields in the raw data and then
constructs the concrete type listed in the passed generator mapping file. The default file
is `src/parsers/generator_mapping.yaml`. You can override this behavior by specifying your
own file when constructing PowerSystemTableData.

### System creation with custom config files

Here is an example of how to construct a System with all customizations listed on this page.

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
sys = System(data, time_series_in_memory = true)
```

## MATPOWER / PSS/e

The following code will create a System from a MATPOWER or PSS/e file by first
parsing it with [PowerModels](https://github.com/lanl-ansi/PowerModels.jl).

```julia
sys = System(PowerSystems.PowerModelsData("./case5.m"))
```

## PSS/e dyr parsing

PSS/e's dynamic model library is extensive, we currently support parsing a limited amount
of models out of the box.

### Machine models

- "GENSAE"
- "GENSAL"
- "GENROE"
- "GENCLS"
- "GENROU"

### AVR Models

- "IEEET1"
- "ESDC1A"
- "ESAC1A"
- "ESST4B"
- "EXAC2"
- "EXPIC1"
- "ESAC6A"
- "EXAC1"
- "SCRX"
- "ESDC2A"

### Prime Movers

- "HYGOV"
- "IEEEG1"
- "GGOV1"

### PSS models

- "IEEEST"
