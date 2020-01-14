# Extending PowerSystemTableData parsing

This page describes how developers should add code in order to read additional
columns from raw data files.

The main point is that you should not read individual hard-coded column names from
DataFrames manually. The parsing code includes mapping functionality that
allows you use PowerSystems-standard names while letting the users define their
own custom names.

*Note*:  This assumes that you are familiar with this [user workflow](../man/parsing.md).

**Procedure**

1. Add an entry to the array of parameters for your category. Use `snake_case`
   for the name field.  The fields `name` and `description` are required. Try
   to use a name that is generic and not specific to the `RTS_GMLC` dataset. It
   is recommended that you define `unit`. If PowerSystems expects the value to
   be per-unit then you must specify `system_per_unit` to be true.

2. PowerSystems has two commonly-used datasets with customized user config
   files:  `PowerSystemsTestData/RTS_GMLC/user_descriptors.yaml` and
   `RTS_GMLC/FormattedData/SIIP/user_descriptors.yaml`. Update both of these
   files and submit pull requests.

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
