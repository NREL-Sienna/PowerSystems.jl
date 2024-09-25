# [Parsing MATPOWER or PSS/e Files](@id pm_data)

The following code will create a System from a MATPOWER .m or PSS/e .raw file:

```@repl m_system
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data")
sys = System(joinpath(file_dir, "case5.m"))
```

This parsing code was copied with permission from
[`PowerModels.jl`](https://github.com/lanl-ansi/PowerModels.jl).

### See also:

  - Parsing [PSS/e .dyr Files](@ref dyr_data), which also includes an example of parsing a
    .raw file
  - Parsing [table data (CSV Files)](@ref table_data)
  - Parsing [time series](@ref parsing_time_series)
