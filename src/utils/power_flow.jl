"""
Calculates the From - To complex power flow (Flow injected at the bus) of branch of type
TapTransformer
"""
function flow_val(b::TapTransformer)
    !get_available(b) && return 0.0
    Y_t = get_series_admittance(b)
    c = 1 / get_tap(b)
    arc = get_arc(b)
    V_from = arc.from.magnitude * (cos(arc.from.angle) + sin(arc.from.angle) * 1im)
    V_to = arc.to.magnitude * (cos(arc.to.angle) + sin(arc.to.angle) * 1im)
    I = (V_from * Y_t * c^2) - (V_to * Y_t * c)
    flow = V_from * conj(I)
    return flow
end

"""
Calculates the From - To complex power flow (Flow injected at the bus) of branch of type
Line
"""
function flow_val(b::ACBranch)
    !get_available(b) && return 0.0
    Y_t = get_series_admittance(b)
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.magnitude * (cos(arc.from.angle) + sin(arc.from.angle) * 1im)
    V_to = arc.to.magnitude * (cos(arc.to.angle) + sin(arc.to.angle) * 1im)
    I = V_from * (Y_t + (1im * PowerSystems.get_b(b).from)) - V_to * Y_t
    flow = V_from * conj(I)
    return flow
end

"""
Calculates the From - To complex power flow (Flow injected at the bus) of branch of type
Transformer2W
"""
function flow_val(b::Transformer2W)
    !get_available(b) && return 0.0
    Y_t = get_series_admittance(b)
    arc = get_arc(b)
    V_from = arc.from.magnitude * (cos(arc.from.angle) + sin(arc.from.angle) * 1im)
    V_to = arc.to.magnitude * (cos(arc.to.angle) + sin(arc.to.angle) * 1im)
    I = V_from * (Y_t + (1im * get_primary_shunt(b))) - V_to * Y_t
    flow = V_from * conj(I)
    return flow
end

function flow_val(b::PhaseShiftingTransformer)
    error("Systems with PhaseShiftingTransformer not supported yet")
    return
end

"""
Calculates the From - To complex power flow using external data of voltages of branch of type
TapTransformer
"""
function flow_func(b::TapTransformer, V_from::Complex{Float64}, V_to::Complex{Float64})
    !get_available(b) && return (0.0, 0.0)
    Y_t = get_series_admittance(b)
    c = 1 / get_tap(b)
    I = (V_from * Y_t * c^2) - (V_to * Y_t * c)
    flow = V_from * conj(I)
    return real(flow), imag(flow)
end

"""
Calculates the From - To complex power flow using external data of voltages of branch of type
Line
"""
function flow_func(b::ACBranch, V_from::Complex{Float64}, V_to::Complex{Float64})
    !get_available(b) && return (0.0, 0.0)
    Y_t = get_series_admittance(b)
    I = V_from * (Y_t + (1im * get_b(b).from)) - V_to * Y_t
    flow = V_from * conj(I)
    return real(flow), imag(flow)
end

"""
Calculates the From - To complex power flow using external data of voltages of branch of type
Transformer2W
"""
function flow_func(b::Transformer2W, V_from::Complex{Float64}, V_to::Complex{Float64})
    !get_available(b) && return (0.0, 0.0)
    Y_t = get_series_admittance(b)
    I = V_from * (Y_t + (1im * get_primary_shunt(b))) - V_to * Y_t
    flow = V_from * conj(I)
    return real(flow), imag(flow)
end

function flow_func(
    b::PhaseShiftingTransformer,
    V_from::Complex{Float64},
    V_to::Complex{Float64},
)
    error("Systems with PhaseShiftingTransformer not supported yet")
    return
end

"""
Updates the flow on the branches
"""
function _update_branch_flow!(sys::System)
    for b in get_components(ACBranch, sys)
        S_flow = get_available(b) ? flow_val(b) : 0.0 + 0.0im
        set_active_power_flow!(b, real(S_flow))
        set_reactive_power_flow!(b, imag(S_flow))
    end
end

"""
Obtain total load on bus b
"""
function _get_load_data(sys::System, b::Bus)
    active_power = 0.0
    reactive_power = 0.0
    for l in get_components(ElectricLoad, sys, x -> !isa(x, FixedAdmittance))
        !get_available(l) && continue
        if (l.bus == b)
            active_power += get_active_power(l)
            reactive_power += get_reactive_power(l)
        end
    end
    return active_power, reactive_power
end

function _get_fixed_admittance_power(sys::System, b::Bus, result::AbstractVector, ix::Int)
    active_power = 0.0
    reactive_power = 0.0
    for l in get_components(FixedAdmittance, sys)
        !get_available(l) && continue
        if (l.bus == b)
            Vm_squared =
                b.bustype == BusTypes.PQ ? result[2 * ix - 1]^2 : get_magnitude(b)^2
            active_power += Vm_squared * real(get_Y(l))
            reactive_power += Vm_squared * imag(get_Y(l))
        end
    end
    return active_power, reactive_power
end

"""
Updates system voltages and powers with power flow results
"""
function _write_pf_sol!(sys::System, nl_result)
    function _is_available_source(x, bus::Bus)
        return get_available(x) && x.bus == bus && !isa(x, ElectricLoad)
    end

    result = round.(nl_result.zero; digits = 7)
    buses = enumerate(sort!(collect(get_components(Bus, sys)), by = x -> get_number(x)))

    for (ix, bus) in buses
        if bus.bustype == BusTypes.REF
            P_gen = result[2 * ix - 1]
            Q_gen = result[2 * ix]
            devices =
                get_components(StaticInjection, sys, x -> _is_available_source(x, bus))
            sum_basepower = sum(get_base_power.(devices))
            for d in devices
                part_factor = get_base_power(d) / sum_basepower
                set_active_power!(d, P_gen * part_factor)
                set_reactive_power!(d, Q_gen * part_factor)
            end
        elseif bus.bustype == BusTypes.PV
            Q_gen = result[2 * ix - 1]
            θ = result[2 * ix]
            devices =
                get_components(StaticInjection, sys, x -> _is_available_source(x, bus))
            sum_basepower = sum(get_base_power.(devices))
            for d in devices
                set_reactive_power!(d, Q_gen * get_base_power(d) / sum_basepower)
            end
            bus.angle = θ
        elseif bus.bustype == BusTypes.PQ
            Vm = result[2 * ix - 1]
            θ = result[2 * ix]
            set_magnitude!(bus, Vm)
            set_angle!(bus, θ)
        end
    end

    _update_branch_flow!(sys)
    return
end

"""
Return power flow results in dictionary of dataframes.
"""
function _write_results(sys::System, nl_result)
    @info("Voltages are exported in pu. Powers are exported in MW/MVAr.")
    result = round.(nl_result.zero; digits = 7)
    buses = sort!(collect(get_components(Bus, sys)), by = x -> get_number(x))
    N_BUS = length(buses)
    bus_map = Dict(buses .=> 1:N_BUS)
    sys_basepower = get_base_power(sys)
    sources = get_components(StaticInjection, sys, d -> !isa(d, ElectricLoad))
    Vm_vect = fill(0.0, N_BUS)
    θ_vect = fill(0.0, N_BUS)
    P_gen_vect = fill(0.0, N_BUS)
    Q_gen_vect = fill(0.0, N_BUS)
    P_load_vect = fill(0.0, N_BUS)
    Q_load_vect = fill(0.0, N_BUS)

    for (ix, bus) in enumerate(buses)
        P_load_vect[ix], Q_load_vect[ix] = _get_load_data(sys, bus) .* sys_basepower
        P_admittance, Q_admittance = _get_fixed_admittance_power(sys, bus, result, ix)
        P_load_vect[ix] += P_admittance
        Q_load_vect[ix] += Q_admittance
        if bus.bustype == BusTypes.REF
            Vm_vect[ix] = get_magnitude(bus)
            θ_vect[ix] = get_angle(bus)
            P_gen_vect[ix] = result[2 * ix - 1] * sys_basepower
            Q_gen_vect[ix] = result[2 * ix] * sys_basepower
        elseif bus.bustype == BusTypes.PV
            Vm_vect[ix] = get_magnitude(bus)
            θ_vect[ix] = result[2 * ix]
            for gen in sources
                !get_available(gen) && continue
                if gen.bus == bus
                    P_gen_vect[ix] += get_active_power(gen) * sys_basepower
                end
            end
            Q_gen_vect[ix] = result[2 * ix - 1] * sys_basepower
        elseif bus.bustype == BusTypes.PQ
            Vm_vect[ix] = result[2 * ix - 1]
            θ_vect[ix] = result[2 * ix]
            for gen in sources
                !get_available(gen) && continue
                if gen.bus == bus
                    P_gen_vect[ix] += get_active_power(gen) * sys_basepower
                    Q_gen_vect[ix] += get_reactive_power(gen) * sys_basepower
                end
            end
        end
    end

    branches = get_components(ACBranch, sys)
    N_BRANCH = length(branches)
    P_from_to_vect = fill(0.0, N_BRANCH)
    Q_from_to_vect = fill(0.0, N_BRANCH)
    P_to_from_vect = fill(0.0, N_BRANCH)
    Q_to_from_vect = fill(0.0, N_BRANCH)
    for (ix, b) in enumerate(branches)
        !get_available(b) && continue
        bus_f_ix = bus_map[get_arc(b).from]
        bus_t_ix = bus_map[get_arc(b).to]
        V_from = Vm_vect[bus_f_ix] * (cos(θ_vect[bus_f_ix]) + sin(θ_vect[bus_f_ix]) * 1im)
        V_to = Vm_vect[bus_t_ix] * (cos(θ_vect[bus_t_ix]) + sin(θ_vect[bus_t_ix]) * 1im)
        P_from_to_vect[ix], Q_from_to_vect[ix] = flow_func(b, V_from, V_to) .* sys_basepower
        P_to_from_vect[ix], Q_to_from_vect[ix] = flow_func(b, V_to, V_from) .* sys_basepower
    end

    bus_df = DataFrames.DataFrame(
        bus_number = get_number.(buses),
        Vm = Vm_vect,
        θ = θ_vect,
        P_gen = P_gen_vect,
        P_load = P_load_vect,
        P_net = P_gen_vect - P_load_vect,
        Q_gen = Q_gen_vect,
        Q_load = Q_load_vect,
        Q_net = Q_gen_vect - Q_load_vect,
    )

    branch_df = DataFrames.DataFrame(
        line_name = get_name.(branches),
        bus_from = get_number.(get_from.(get_arc.(branches))),
        bus_to = get_number.(get_to.(get_arc.(branches))),
        P_from_to = P_from_to_vect,
        Q_from_to = Q_from_to_vect,
        P_to_from = P_to_from_vect,
        Q_to_from = Q_to_from_vect,
        P_losses = P_from_to_vect + P_to_from_vect,
        Q_losses = Q_from_to_vect + Q_to_from_vect,
    )
    DataFrames.sort!(branch_df, [:bus_from, :bus_to])

    return Dict("bus_results" => bus_df, "flow_results" => branch_df)
end

"""
Solves a the power flow into the system and writes the solution into the relevant structs.
Updates generators active and reactive power setpoints and branches active and reactive
power flows (calculated in the From - To direction) (see
[`flow_val`](@ref))

Supports solving using Finite Differences Method (instead of using analytic Jacobian)
by setting finite_diff = true.
Supports passing NLsolve kwargs in the args. By default shows the solver trace.

Arguments available for `nlsolve`:

* `method` : See NLSolve.jl documentation for available solvers
* `xtol`: norm difference in `x` between two successive iterates under which
  convergence is declared. Default: `0.0`.
* `ftol`: infinite norm of residuals under which convergence is declared.
  Default: `1e-8`.
* `iterations`: maximum number of iterations. Default: `1_000`.
* `store_trace`: should a trace of the optimization algorithm's state be
  stored? Default: `false`.
* `show_trace`: should a trace of the optimization algorithm's state be shown
  on `STDOUT`? Default: `false`.
* `extended_trace`: should additifonal algorithm internals be added to the state
  trace? Default: `false`.


## Examples
```julia
solve_powerflow!(sys)
# Passing NLsolve arguments
solve_powerflow!(sys, method = :newton)
# Using Finite Differences
solve_powerflow!(sys, finite_diff = true)

```

"""
function solve_powerflow!(system::System; finite_diff = false, kwargs...)
    #Save per-unit flag
    settings_unit_cache = deepcopy(system.units_settings.unit_system)
    #Work in System per unit
    set_units_base_system!(system, "SYSTEM_BASE")
    res = _solve_powerflow(system, finite_diff; kwargs...)
    if res.f_converged
        _write_pf_sol!(system, res)
        @info("PowerFlow solve converged, the results have been stored in the system")
        #Restore original per unit base
        set_units_base_system!(system, settings_unit_cache)
        return res.f_converged
    end
    @error("The powerflow solver returned convergence = $(res.f_converged)")
    set_units_base_system!(system, settings_unit_cache)
    return res.f_converged
end

"""
Similar to solve_powerflow!(sys) but does not update the system struct with results.
Returns the results in a dictionary of dataframes.

## Examples
```julia
res = solve_powerflow(sys)
# Passing NLsolve arguments
res = solve_powerflow(sys, method = :newton)
# Using Finite Differences
res = solve_powerflow(sys, finite_diff = true)

```

"""
function solve_powerflow(system::System; finite_diff = false, kwargs...)
    #Save per-unit flag
    settings_unit_cache = deepcopy(system.units_settings.unit_system)
    #Work in System per unit
    set_units_base_system!(system, "SYSTEM_BASE")
    res = _solve_powerflow(system, finite_diff; kwargs...)
    if res.f_converged
        @info("PowerFlow solve converged, the results are exported in DataFrames")
        df_results = _write_results(system, res)
        #Restore original per unit base
        set_units_base_system!(system, settings_unit_cache)
        return df_results
    end
    @error("The powerflow solver returned convergence = $(res.f_converged)")
    set_units_base_system!(system, settings_unit_cache)
    return res.f_converged
end

function _solve_powerflow(system::System, finite_diff::Bool; kwargs...)
    ybus_kw = [:check_connectivity, :connectivity_method]
    ybus_kwargs = (k for k in kwargs if first(k) ∈ ybus_kw)
    kwargs = (k for k in kwargs if first(k) ∉ ybus_kw)

    buses = sort!(collect(get_components(Bus, system)), by = x -> get_number(x))
    N_BUS = length(buses)

    # assumes the ordering in YBus is the same as in the buses.
    Yb = Ybus(system; ybus_kwargs...).data
    a = collect(1:N_BUS)
    I, J, V = SparseArrays.findnz(Yb)
    neighbors = [Set{Int}([i]) for i in 1:N_BUS]
    for nz in eachindex(V)
        push!(neighbors[I[nz]], J[nz])
        push!(neighbors[J[nz]], I[nz])
    end
    x0 = zeros(N_BUS * 2)

    #Create Jacobian structure
    J0_I = Int[]
    J0_J = Int[]
    J0_V = Float64[]

    for ix_f in a
        F_ix_f_r = 2 * ix_f - 1
        F_ix_f_i = 2 * ix_f

        for ix_t in neighbors[ix_f]
            X_ix_t_fst = 2 * ix_t - 1
            X_ix_t_snd = 2 * ix_t
            b = get_bustype(buses[ix_t])
            #Set to 0.0 only on connected buses
            if b == BusTypes.REF
                if ix_f == ix_t
                    #Active PF w/r Local Active Power
                    push!(J0_I, F_ix_f_r)
                    push!(J0_J, X_ix_t_fst)
                    push!(J0_V, 0.0)
                    #Rective PF w/r Local Reactive Power
                    push!(J0_I, F_ix_f_i)
                    push!(J0_J, X_ix_t_snd)
                    push!(J0_V, 0.0)
                end
            elseif b == BusTypes.PV
                #Active PF w/r Angle
                push!(J0_I, F_ix_f_r)
                push!(J0_J, X_ix_t_snd)
                push!(J0_V, 0.0)
                #Reactive PF w/r Angle
                push!(J0_I, F_ix_f_i)
                push!(J0_J, X_ix_t_snd)
                push!(J0_V, 0.0)
                if ix_f == ix_t
                    #Reactive PF w/r Local Reactive Power
                    push!(J0_I, F_ix_f_i)
                    push!(J0_J, X_ix_t_fst)
                    push!(J0_V, 0.0)
                end
            elseif b == BusTypes.PQ
                #Active PF w/r VoltageMag
                push!(J0_I, F_ix_f_r)
                push!(J0_J, X_ix_t_fst)
                push!(J0_V, 0.0)
                #Reactive PF w/r VoltageMag
                push!(J0_I, F_ix_f_i)
                push!(J0_J, X_ix_t_fst)
                push!(J0_V, 0.0)
                #Active PF w/r Angle
                push!(J0_I, F_ix_f_r)
                push!(J0_J, X_ix_t_snd)
                push!(J0_V, 0.0)
                #Reactive PF w/r Angle
                push!(J0_I, F_ix_f_i)
                push!(J0_J, X_ix_t_snd)
                push!(J0_V, 0.0)
            end
        end
    end
    J0 = SparseArrays.sparse(J0_I, J0_J, J0_V)

    # Use vectors to cache data for closure
    # These should be read only
    P_GEN_BUS = fill(0.0, N_BUS)
    Q_GEN_BUS = fill(0.0, N_BUS)
    P_LOAD_BUS = fill(0.0, N_BUS)
    Q_LOAD_BUS = fill(0.0, N_BUS)
    P_net = fill(0.0, N_BUS)
    Q_net = fill(0.0, N_BUS)
    Vm = fill(0.0, N_BUS)
    θ = fill(0.0, N_BUS)

    state_variable_count = 1
    sources = get_components(StaticInjection, system, d -> !isa(d, ElectricLoad))

    for (ix, b) in enumerate(buses)
        bus_angle = get_angle(b)::Float64
        Vm[ix] = bus_voltage_magnitude = get_magnitude(b)::Float64
        P_GEN_BUS[ix] = 0.0
        Q_GEN_BUS[ix] = 0.0
        get_ext(b)["neighbors"] = neighbors[ix]
        for gen in sources
            !get_available(gen) && continue
            if gen.bus == b
                P_GEN_BUS[ix] += get_active_power(gen)
                Q_GEN_BUS[ix] += get_reactive_power(gen)
            end
        end

        P_LOAD_BUS[ix], Q_LOAD_BUS[ix] = _get_load_data(system, b)
        if b.bustype == BusTypes.REF
            injection_components = get_components(
                StaticInjection,
                system,
                d -> get_available(d) && get_bus(d) == b,
            )
            isempty(injection_components) && throw(
                IS.ConflictingInputsError(
                    "The slack bus does not have any injection component. Power Flow can not proceed",
                ),
            )
            θ[ix] = get_angle(b)::Float64
            x0[state_variable_count] = P_GEN_BUS[ix]
            x0[state_variable_count + 1] = Q_GEN_BUS[ix]
            state_variable_count += 2
        elseif b.bustype == BusTypes.PV
            x0[state_variable_count] = Q_GEN_BUS[ix]
            x0[state_variable_count + 1] = bus_angle
            state_variable_count += 2
        elseif b.bustype == BusTypes.PQ
            x0[state_variable_count] = bus_voltage_magnitude
            x0[state_variable_count + 1] = bus_angle
            state_variable_count += 2
        else
            throw(ArgumentError("Bustype not recognized"))
        end
    end

    @assert state_variable_count - 1 == N_BUS * 2
    bus_types = get_bustype.(buses)
    function pf!(F::Vector{Float64}, X::Vector{Float64})
        for (ix, b) in enumerate(bus_types)
            if b == BusTypes.REF
                # When bustype == REFERENCE Bus, state variables are Active and Reactive Power Generated
                P_net[ix] = X[2 * ix - 1] - P_LOAD_BUS[ix]
                Q_net[ix] = X[2 * ix] - Q_LOAD_BUS[ix]
            elseif b == BusTypes.PV
                # When bustype == PV Bus, state variables are Reactive Power Generated and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = X[2 * ix - 1] - Q_LOAD_BUS[ix]
                θ[ix] = X[2 * ix]
            elseif b == BusTypes.PQ
                # When bustype == PQ Bus, state variables are Voltage Magnitude and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = Q_GEN_BUS[ix] - Q_LOAD_BUS[ix]
                Vm[ix] = X[2 * ix - 1]
                θ[ix] = X[2 * ix]
            end
        end

        # F is active and reactive power balance equations at all buses
        for ix_f in a
            S_re = -P_net[ix_f]
            S_im = -Q_net[ix_f]
            for ix_t in neighbors[ix_f]
                gb = real(Yb[ix_f, ix_t])
                bb = imag(Yb[ix_f, ix_t])
                if ix_f == ix_t
                    S_re += Vm[ix_f] * Vm[ix_t] * gb
                    S_im += -Vm[ix_f] * Vm[ix_t] * bb
                else
                    S_re +=
                        Vm[ix_f] *
                        Vm[ix_t] *
                        (gb * cos(θ[ix_f] - θ[ix_t]) + bb * sin(θ[ix_f] - θ[ix_t]))
                    S_im +=
                        Vm[ix_f] *
                        Vm[ix_t] *
                        (gb * sin(θ[ix_f] - θ[ix_t]) - bb * cos(θ[ix_f] - θ[ix_t]))
                end
            end
            F[2 * ix_f - 1] = S_re
            F[2 * ix_f] = S_im
        end
    end

    function jsp!(J::SparseArrays.SparseMatrixCSC{Float64, Int}, X::Vector{Float64})
        for ix_f in a
            F_ix_f_r = 2 * ix_f - 1
            F_ix_f_i = 2 * ix_f

            for ix_t in neighbors[ix_f]
                X_ix_t_fst = 2 * ix_t - 1
                X_ix_t_snd = 2 * ix_t
                b = bus_types[ix_t]

                if b == BusTypes.REF
                    # State variables are Active and Reactive Power Generated
                    # F[2*i-1] := p[i] = p_flow[i] + p_load[i] - x[2*i-1]
                    # F[2*i] := q[i] = q_flow[i] + q_load[i] - x[2*i]
                    # x does not appears in p_flow and q_flow
                    if ix_f == ix_t
                        J[F_ix_f_r, X_ix_t_fst] = -1.0
                        J[F_ix_f_i, X_ix_t_snd] = -1.0
                    end
                elseif b == BusTypes.PV
                    # State variables are Reactive Power Generated and Voltage Angle
                    # F[2*i-1] := p[i] = p_flow[i] + p_load[i] - p_gen[i]
                    # F[2*i] := q[i] = q_flow[i] + q_load[i] - x[2*i]
                    # x[2*i] (associated with q_gen) does not appear in q_flow
                    # x[2*i] (associated with q_gen) does not appear in the active power balance
                    if ix_f == ix_t
                        #Jac: Reactive PF against local active power
                        J[F_ix_f_i, X_ix_t_fst] = -1.0
                        #Jac: Active PF against same Angle: θ[ix_f] =  θ[ix_t]
                        J[F_ix_f_r, X_ix_t_snd] =
                            Vm[ix_f] * sum(
                                Vm[k] * (
                                    real(Yb[ix_f, k]) * -sin(θ[ix_f] - θ[k]) +
                                    imag(Yb[ix_f, k]) * cos(θ[ix_f] - θ[k])
                                ) for k in neighbors[ix_f] if k != ix_f
                            )
                        #Jac: Reactive PF against same Angle: θ[ix_f] = θ[ix_t]
                        J[F_ix_f_i, X_ix_t_snd] =
                            Vm[ix_f] * sum(
                                Vm[k] * (
                                    real(Yb[ix_f, k]) * cos(θ[ix_f] - θ[k]) -
                                    imag(Yb[ix_f, k]) * -sin(θ[ix_f] - θ[k])
                                ) for k in neighbors[ix_f] if k != ix_f
                            )
                    else
                        g_ij = real(Yb[ix_f, ix_t])
                        b_ij = imag(Yb[ix_f, ix_t])
                        #Jac: Active PF against other angles θ[ix_t]
                        J[F_ix_f_r, X_ix_t_snd] =
                            Vm[ix_f] *
                            Vm[ix_t] *
                            (g_ij * sin(θ[ix_f] - θ[ix_t]) + b_ij * -cos(θ[ix_f] - θ[ix_t]))
                        #Jac: Reactive PF against other angles θ[ix_t]
                        J[F_ix_f_i, X_ix_t_snd] =
                            Vm[ix_f] *
                            Vm[ix_t] *
                            (g_ij * -cos(θ[ix_f] - θ[ix_t]) - b_ij * sin(θ[ix_f] - θ[ix_t]))
                    end
                elseif b == BusTypes.PQ
                    # State variables are Voltage Magnitude and Voltage Angle
                    # Everything appears in everything
                    if ix_f == ix_t
                        #Jac: Active PF against same voltage magnitude Vm[ix_f]
                        J[F_ix_f_r, X_ix_t_fst] =
                            2 * real(Yb[ix_f, ix_t]) * Vm[ix_f] + sum(
                                Vm[k] * (
                                    real(Yb[ix_f, k]) * cos(θ[ix_f] - θ[k]) +
                                    imag(Yb[ix_f, k]) * sin(θ[ix_f] - θ[k])
                                ) for k in neighbors[ix_f] if k != ix_f
                            )
                        #Jac: Active PF against same angle θ[ix_f]
                        J[F_ix_f_r, X_ix_t_snd] =
                            Vm[ix_f] * sum(
                                Vm[k] * (
                                    real(Yb[ix_f, k]) * -sin(θ[ix_f] - θ[k]) +
                                    imag(Yb[ix_f, k]) * cos(θ[ix_f] - θ[k])
                                ) for k in neighbors[ix_f] if k != ix_f
                            )

                        #Jac: Reactive PF against same voltage magnitude Vm[ix_f]
                        J[F_ix_f_i, X_ix_t_fst] =
                            -2 * imag(Yb[ix_f, ix_t]) * Vm[ix_f] + sum(
                                Vm[k] * (
                                    real(Yb[ix_f, k]) * sin(θ[ix_f] - θ[k]) -
                                    imag(Yb[ix_f, k]) * cos(θ[ix_f] - θ[k])
                                ) for k in neighbors[ix_f] if k != ix_f
                            )
                        #Jac: Reactive PF against same angle θ[ix_f]
                        J[F_ix_f_i, X_ix_t_snd] =
                            Vm[ix_f] * sum(
                                Vm[k] * (
                                    real(Yb[ix_f, k]) * cos(θ[ix_f] - θ[k]) -
                                    imag(Yb[ix_f, k]) * -sin(θ[ix_f] - θ[k])
                                ) for k in neighbors[ix_f] if k != ix_f
                            )
                    else
                        g_ij = real(Yb[ix_f, ix_t])
                        b_ij = imag(Yb[ix_f, ix_t])
                        #Jac: Active PF w/r to different voltage magnitude Vm[ix_t]
                        J[F_ix_f_r, X_ix_t_fst] =
                            Vm[ix_f] *
                            (g_ij * cos(θ[ix_f] - θ[ix_t]) + b_ij * sin(θ[ix_f] - θ[ix_t]))
                        #Jac: Active PF w/r to different angle θ[ix_t]
                        J[F_ix_f_r, X_ix_t_snd] =
                            Vm[ix_f] *
                            Vm[ix_t] *
                            (g_ij * sin(θ[ix_f] - θ[ix_t]) + b_ij * -cos(θ[ix_f] - θ[ix_t]))

                        #Jac: Reactive PF w/r to different voltage magnitude Vm[ix_t]
                        J[F_ix_f_i, X_ix_t_fst] =
                            Vm[ix_f] *
                            (g_ij * sin(θ[ix_f] - θ[ix_t]) - b_ij * cos(θ[ix_f] - θ[ix_t]))
                        #Jac: Reactive PF w/r to different angle θ[ix_t]
                        J[F_ix_f_i, X_ix_t_snd] =
                            Vm[ix_f] *
                            Vm[ix_t] *
                            (g_ij * -cos(θ[ix_f] - θ[ix_t]) - b_ij * sin(θ[ix_f] - θ[ix_t]))
                    end
                else
                    error("Undefined Conditional")
                end
            end
        end
    end

    res = similar(x0)
    pf!(res, x0)
    if sum(res) > 10 * (N_BUS * 2)
        _, ix = findmax(res)
        bus_no = get_number(buses[Int(ceil(ix/2))])
        @warn "Initial guess provided results in a large initial residual. Largest residual at bus $bus_no"
    end

    if finite_diff
        res = NLsolve.nlsolve(pf!, x0; kwargs...)
    else
        F0 = similar(x0)
        df = NLsolve.OnceDifferentiable(pf!, jsp!, x0, F0, J0)
        res = NLsolve.nlsolve(df, x0; kwargs...)
    end

    return res
end
