# Viewing PowerSystems Data in the Terminal

PowerSystems data can be serialized and deserialized in JSON. This section shows how to
explore the data outside of Julia

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

* **View the entire file pretty-printed**

```zsh
jq . system.json
```

* **View the PowerSystems component types**

```zsh
jq '.data.components | keys' system.json
```

* **View specific components**

```zsh
jq '.data.components.ThermalStandard' system.json
```

* **Get the count of a component type**

```zsh
jq '.data.components.Bus  | length' system.json
```

* **View specific component by index**

```zsh
jq '.data.components.ThermalStandard | .[0]' system.json
```

* **View specific component by name**

```zsh
jq '.data.components.ThermalStandard | .[] | select(.name == "107_CC_1")' system.json
```

* **View the field names for a component**

```zsh
jq '.data.components.ThermalStandard | .[0] | keys' system.json
```

* **Filter on a field value**

```zsh
jq '.data.components.ThermalStandard | .[] | select(.active_power > 2.3)' system.json
```

* **Output a table with select fields**

```zsh
jq -r '["name", "econ.capacity"], (.data.components.ThermalStandard | .[] | [.name, .active_power]) | @tsv' system.json
```

* **View the time_series information for a component**

```zsh
jq '.data.components.ThermalStandard | .[0] | .time_series' system.json
```
