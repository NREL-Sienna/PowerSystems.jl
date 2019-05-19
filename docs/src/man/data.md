# Saving and Viewing PowerSystems Data

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

## View the entire file pretty-printed.
```
jq . system.json
```

## View the PowerSystems component hierarchy.
```
jq '.components | keys' system.json
jq '.components.Devices | keys' system.json
jq '.components.Devices.Injection | keys' system.json
jq '.components.Devices.Injection.Generator | keys' system.json
```

## View specific components.
```
jq '.components.Device.Injection.Generator.ThermalGen.StandardThermal' system.json
jq '.components.Device.Injection.Generator.ThermalGen.StandardThermal[0]' system.json
```

## Filter on a parameter.
```
jq '.components.Device.Injection.Generator.ThermalGen.StandardThermal | .[] | select(.name == "107_CC_1")' system.json
jq '.components.Device.Injection.Generator.ThermalGen.StandardThermal | .[] | select(.econ.capacity > 3)' system.json
```

## Output a table with select fields.
```
jq -r '["name", "econ.capacity"], (.components.Device.Injection.Generator.ThermalGen.StandardThermal | .[] | [.name, .econ.capacity]) | @tsv' system.json
```
