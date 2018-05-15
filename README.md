# PowerSystems

[![Build Status](https://travis-ci.org/NREL/PowerSystems.jl.svg?branch=master)](https://travis-ci.org/NREL/PowerSystems.jl)

[![Build status](https://ci.appveyor.com/api/projects/status/51qboor9s6x8w9tl?svg=true)](https://ci.appveyor.com/project/jdlara-berkeley/powersystems-jl)

[![codecov](https://codecov.io/gh/NREL/PowerSystems.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/NREL/PowerSystems.jl)

The code in this repository is the base data management code for the global power system analysis tools repository.

## Installation

This package is not yet registered. **Until it is, things may change. It is perfectly
usable but should not be considered stable**.

You can install it by typing

```julia
julia> Pkg.clone("https://github.com/NREL/PowerSystems.jl.git")
```

## Usage

Once installed, the `PowerSystems` package can by used by typing

```julia
using PowerSystems
```

## To do list

- Include inner constructors in the types
- Generate testing code
- Define more clearly the data structure for generators and loads
- Define the structure for forecasting data
