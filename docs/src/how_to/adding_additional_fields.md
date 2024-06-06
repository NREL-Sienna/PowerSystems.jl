# Adding additional data to a component 

All `PowerSystems.jl` components have an `ext` field that contains an empty `Dictionary`.
This Dictionary is useful to contain additional required data where there is no need to
create new behaviors with that data. A simple example is the addition of geographic
information, if needed.

#### Example

__Step 1:__ Use `get_ext` to get the `ext` field of the desired components and assign your data:
```@repl generated_adding_additional_fields
using PowerSystems #hide
const PSY = PowerSystems #hide
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data"); #hide
system = System(joinpath(file_dir, "case5_re.m")); #hide
for g in get_components(ThermalStandard, system)
    external_field = get_ext(g)
    external_field["my_data"] = 1.0
end
```
Here, we added additional data called `my_data` to the [`ThermalStandard`](@ref)
generators in a previously defined [`system`](@ref).

__Step 2:__ Retrieve your data using `get_ext` again:
```@repl generated_adding_additional_fields
gen_alta = get_component(ThermalStandard, system, "Alta")

my_data = get_ext(gen_alta)["my_data"]
```
Verify above that `my_data` has been added for the generator named Alta.

