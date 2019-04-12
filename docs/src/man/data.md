# Saving and Viewing PowerSystems Data

PowerSystems data can be serialized and deserialized in JSON.

```julia
PowerSystems.to_json(system, "system.json")
system = ConcreteSystem("system.json")
```

It can be useful to view and filter the PowerSystems data in this format.  Here are some
example commands to do this with [jq](https://github.com/stedolan/jq).

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
jq '.components.Device.Injection.Generator.ThermalGen.ThermalDispatch' system.json
jq '.components.Device.Injection.Generator.ThermalGen.ThermalDispatch[0]' system.json
```

## Filter on a parameter.
```
jq '.components.Device.Injection.Generator.ThermalGen.ThermalDispatch | .[] | select(.name == "107_CC_1")' system.json
jq '.components.Device.Injection.Generator.ThermalGen.ThermalDispatch | .[] | select(.econ.capacity > 3)' system.json
```

## Output a table with select fields.
```
jq -r '["name", "econ.capacity"], (.components.Device.Injection.Generator.ThermalGen.ThermalDispatch | .[] | [.name, .econ.capacity]) | @tsv' system.json
```
