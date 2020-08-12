```@meta
EditURL = "<unknown>/docs/src/modeler/data.md"
```

```@example data
```@meta
EditURL = "<unknown>/docs/src/modeler/data.md"
```

Saving and Viewing a System

```@example data
PowerSystems data can be serialized and deserialized in JSON.

```julia
PowerSystems.to_json(system, "system.json")
system = System("system.json")
```

It can be useful to view and filter the PowerSystems data in this format. There
are many tools available to browse JSON data.

Here is an example [GUI tool](http://jsonviewer.stack.hu) that is available
online in a browser.

The command line utility [jq](https://stedolan.github.io/jq/) offers even more
features. The rest of this document provides example commands.
```

View the entire file pretty-printed.

```@example data
```
jq . system.json
```
```

View the PowerSystems component hierarchy.

```@example data
```
jq '.components | keys' system.json
jq '.components.Devices | keys' system.json
jq '.components.Devices.StaticInjection | keys' system.json
jq '.components.Devices.StaticInjection.Generator | keys' system.json
```
```

View specific components.

```@example data
```
jq '.components.Device.StaticInjection.Generator.ThermalGen.ThermalStandard' system.json
jq '.components.Device.StaticInjection.Generator.ThermalGen.ThermalStandard[0]' system.json
```
```

Filter on a parameter.

```@example data
```
jq '.components.Device.StaticInjection.Generator.ThermalGen.ThermalStandard | .[] | select(.name == "107_CC_1")' system.json
jq '.components.Device.StaticInjection.Generator.ThermalGen.ThermalStandard | .[] | select(.operation_cost.capacity > 3)' system.json
```
```

Output a table with select fields.

```@example data
```
jq -r '["name", "econ.capacity"], (.components.Device.StaticInjection.Generator.ThermalGen.ThermalStandard | .[] | [.name, .operation_cost.capacity]) | @tsv' system.json
```
```

View the forecast types and initial_time values.

```@example data
jq '.forecasts.data | keys' system.json
```

View the fields of a forecast.

```@example data
jq '.forecasts.data["PowerSystems.ForecastKey(2020-01-01T00:00:00, Deterministic{Bus})"][0] | keys'
```

View the value of every field in an array of forecasts.

```@example data
jq '.forecasts.data["PowerSystems.ForecastKey(2020-01-01T00:00:00, Deterministic{Bus})"] | .[].initial_time'
```

Contents

```@example data
```@contents
Pages = [
  "man/data_requirements_table.md",
]
```
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

