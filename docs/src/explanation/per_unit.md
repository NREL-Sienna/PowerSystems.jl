# [Per-unit Conventions](@id per_unit)

It is often useful to express power systems data in relative terms using per-unit conventions.
`PowerSystems.jl` supports the automatic conversion of data between three different unit systems:

 1. Natural Units: The naturally defined units of each parameter (typically MW).
 2. System Base: Parameter values are divided by the system `base_power`.
 3. Device Base: Parameter values are divided by the device `base_mva`.

To see the unit system setting of a `System`:

```@repl per-unit
using PowerSystems; #hide
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data") #hide
system = System(joinpath(file_dir, "RTS_GMLC.m")); #hide
get_units_base(system)
```

To change the unit system setting of a `System`:

```@repl per-unit
set_units_base_system!(system, "DEVICE_BASE")
```

The units of the parameter values stored in each struct are defined in
`src/descriptors/power_system_structs.json`. Conversion between unit systems does not change
the stored parameter values. Instead, unit system conversions are made when accessing
parameters using the [accessor functions](@ref dot_access), thus making it
imperative to utilize the accessor functions instead of the "dot" accessor methods to
ensure the return of the correct values.