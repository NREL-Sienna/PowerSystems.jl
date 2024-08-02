# [Load a `system` from `PowerSystemCaseBuilder`](@id psb)

**Originally Contributed by**: Clayton Barrows

## Introduction

[PowerSystemCaseBuilder.jl](https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl) provides a utility to manage a library of `System`s. The package has utilities to list the available system data and to create instances of each system. By keeping track of which systems have been constructed locally, it makes the re-instantiation of systems efficient by utilizing the serialization features and avoiding the parsing process for systems that have been previously constructed.

## Dependencies

```@repl psb
using PowerSystemCaseBuilder
```

## List all systems in library

```@repl psb
show_systems()
```

## Systems can be listed by category

The available categories can be displayed with:

```@repl psb
show_categories()
```

## Create a `System`

The first time this is run, it will parse csv data. Subsequent executions will rely on serialized data and will execute much faster since the employ deserialization

```@repl psb
sys = build_system(PSITestSystems, "c_sys5_uc")
```
