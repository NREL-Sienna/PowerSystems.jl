macro _fn(expr::Expr)
    @assert expr.head in (:function, :->)
    name = gensym()
    args = expr.args[1]
    args = typeof(args) == Symbol ? [args] : args.args
    body = expr.args[2]
    @eval $name($(args...)) = $body
    name
end

#TODO: Apply actions according to load type
function _get_load_data(sys::System, b::Bus)
    activepower = 0.0
    reactivepower = 0.0
    for l in get_components(ElectricLoad, sys)
        if !isa(l,FixedAdmittance) && (l.bus == b)
            activepower += get_activepower(l)
            reactivepower += get_reactivepower(l)
        end
    end
    return activepower, reactivepower
end

"""
    make_pf(sys)

Create the objects needed to solve an powerflow case using NLsolve.jl solvers. Returns
an anonymous function with the powerflow equations, initial conditions and a dict to link the
solutions to the original system. Only supports systems with a single generator per bus and
currently doesn't support distributes slack buses and doesn't enforce reactive power limits.

## Example
```julia
pf!, x0, res_ref = make_pf(sys)
res = NLsolve.nlsolve(pf!, x0)
```

# Arguments
    * `sys`::System : a PowerSystems.jl system

"""
function make_pf(system)
    buses = sort(collect(get_components(Bus, system)), by = x -> get_number(x))
    bus_count = length(buses)
    #assumes the ordering in YBus is the same as in the buses.
    Yb = Ybus(system)

    #internally allocate matrices
    internal = quote
        V = Vector{ComplexF64}(undef, $bus_count)
        Vc = Vector{ComplexF64}(undef, $bus_count)
        P_bal = Vector{Float64}(undef, $bus_count)
        Q_bal = Vector{Float64}(undef, $bus_count)
    end

    var_count = 1
    res_dict = Dict{String, Vector{Tuple{Symbol, Int}}}()
    x0 = Array{Float64}(undef, bus_count*2)

    for (ix, b) in enumerate(buses)
        #Gets relevant data about the generators
        bus_number = get_number(b)
        bus_angle = get_angle(b)
        bus_voltage = get_voltage(b)
        generator = nothing
        for gen in get_components(Generator, system)
            if gen.bus == b
                !isnothing(generator) && throw(DataFormatError("There is more than one generator connected to Bus $b.name"))
                generator = gen
            end
        end
        if isnothing(generator)
            total_gen = (0.0, 0.0)
        else
            total_gen = (get_activepower(generator),get_reactivepower(generator))
        end
        # get load data
        total_load = _get_load_data(system, b)
        #Make symbols for the variables names w.r.t bus names
        Vm_name = Symbol("Vm_", bus_number)
        ang_name = Symbol("θ_", bus_number)
        if b.bustype == REF::BusType
            P_name = Symbol("P_", bus_number)
            Q_name = Symbol("Q_", bus_number)
            net_p_load = :(-$(total_load[1]))
            net_q_load = :(-$(total_load[2]))
            push!(internal.args, :($Vm_name = $(bus_voltage)))
            push!(internal.args, :($ang_name = $(bus_angle)))
            var_ref1 = (:activepower, var_count)
            x0[var_count] = total_gen[1]
            push!(internal.args, :($P_name = x[$(var_count)])); var_count += 1
            var_ref2 = (:reactivepower, var_count)
            x0[var_count] = total_gen[2]
            push!(internal.args, :($Q_name = x[$(var_count)])); var_count += 1
            push!(internal.args, :(P_bal[$ix] = $P_name + $net_p_load))
            push!(internal.args, :(Q_bal[$ix] = $Q_name + $net_q_load))
            push!(internal.args, :(V[$ix] = $Vm_name*(cos($ang_name)+sin($ang_name)*1im)))
            push!(internal.args, :(Vc[$ix] = conj(V[$ix])))
            # Reference for the results Dict
            res_dict[b.name] = [var_ref1, var_ref2]
        elseif b.bustype == PV::BusType
            Q_name = Symbol("Q_", bus_number)
            net_p_load = :($(total_gen[1]) - $(total_load[1]))
            net_q_load = :(-$(total_load[2]))
            push!(internal.args, :($Vm_name = $(bus_voltage)))
            var_ref1 = (:reactivepower, var_count)
            x0[var_count] = total_gen[2]
            push!(internal.args, :($Q_name = x[$(var_count)])); var_count += 1
            var_ref2 = (:angle, var_count)
            x0[var_count] = bus_angle
            push!(internal.args, :($ang_name = x[$(var_count)])); var_count += 1
            push!(internal.args, :(P_bal[$ix] = $net_p_load))
            push!(internal.args, :(Q_bal[$ix] = $Q_name + $net_q_load))
            push!(internal.args, :(V[$ix] = $Vm_name*(cos($ang_name)+sin($ang_name)*1im)))
            push!(internal.args, :(Vc[$ix] = conj(V[$ix])))
            # Reference for the results Dict
            res_dict[b.name] = [var_ref1, var_ref2]
        elseif b.bustype == PQ::BusType
            net_p_load = :($(total_gen[1]) - $(total_load[1]))
            net_q_load = :($(total_gen[2]) - $(total_load[2]))
            var_ref1 = (:voltage, var_count)
            x0[var_count] = bus_voltage
            push!(internal.args, :($Vm_name = x[$(var_count)])); var_count += 1
            var_ref2 = (:angle, var_count)
            x0[var_count] = bus_angle
            push!(internal.args, :($ang_name = x[$(var_count)])); var_count += 1
            push!(internal.args, :(P_bal[$ix] = $net_p_load))
            push!(internal.args, :(Q_bal[$ix] = $net_q_load))
            push!(internal.args, :(V[$ix] = $Vm_name*(cos($ang_name)+sin($ang_name)*1im)))
            push!(internal.args, :(Vc[$ix] = conj(V[$ix])))
            # Reference for the results Dict
            res_dict[b.name] = [var_ref1, var_ref2]
        end
    end

    balance_eqs = quote  end

    res_count = 1
    for (ix_f, bf) in enumerate(buses)
        p_exp = :(-1*P_bal[$ix_f])
        q_exp = :(-1*Q_bal[$ix_f])
        for (ix_t, bt) in enumerate(buses)
            iszero(Yb[bf,bt]) && continue
            p_exp = :(real(V[$ix_f]*Vc[$ix_t]*$(conj(Yb[bf,bt]))) + $p_exp)
            q_exp = :(imag(V[$ix_f]*Vc[$ix_t]*$(conj(Yb[bf,bt]))) + $q_exp)
        end
        push!(balance_eqs.args, :(res[$res_count] = $p_exp)); res_count += 1
        push!(balance_eqs.args, :(res[$res_count] = $q_exp)); res_count += 1
    end
    @assert res_count == var_count

    ret = quote
        f! =  @_fn (res, x) -> begin
                         $internal
                         $balance_eqs
                         end
        (f!, $x0, $res_dict)
    end

    res = eval(ret)

    return res

end
