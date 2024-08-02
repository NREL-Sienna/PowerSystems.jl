### [Install PowerSystems.jl](@id install)

PowerSystems.jl is a command line tool written in the Julia programming language. To install:

**Step 1:** [Install Julia](https://julialang.org/downloads/)

**Step 2:** Start the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) from a command line:
```
$ julia
```

You should see the Julia REPL start up, which looks something like this:
```
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.4 (2024-06-04)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```
If not, go back to check the Julia installation steps.


**Step 3:** Install the latest stable release of PowerSystems.jl using the
[Julia package manager](https://docs.julialang.org/en/v1/stdlib/Pkg/#Pkg) with:

```julia
] add PowerSystems
```
Once you type `]`, you will see the prompt change color as it activates the Julia package
manager. This command may take a few minutes to download the packages and compile them.

Press the delete or backspace key to return to the REPL. 

Install is complete!

!!! note "Alternate"
    To use the current development version instead, "checkout" the main branch of this package with:

    ```julia
    ] add PowerSystems#main
    ```

!!! note
    `PowerSystems.jl` uses [`InfrastructureSystems.jl`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/)
    as a utility library. Many methods are re-exported from `InfrastructureSystems.jl`.
    For most users there is no need to import `InfrastructureSystems.jl`.