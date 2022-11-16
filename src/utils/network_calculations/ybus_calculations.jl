"""
Nodal admittance matrix (Ybus) is an N x N matrix describing a power system with N buses. It represents the nodal admittance of the buses in a power system.

The Ybus Struct is indexed using the Bus Numbers, no need for them to be sequential
"""
struct Ybus{Ax, L <: NTuple{2, Dict}} <: PowerNetworkMatrix{ComplexF64}
    data::SparseArrays.SparseMatrixCSC{ComplexF64, Int}
    axes::Ax
    lookup::L
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    br::ACBranch,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(br)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]
    Y_l = (1 / (get_r(br) + get_x(br) * 1im))
    Y11 = Y_l + (1im * get_b(br).from)
    if !isfinite(Y11) || !isfinite(Y_l)
        error("Data in $(get_name(br)) is incorrect. r = $(get_r(br)), x = $(get_x(br))")
    end
    ybus[bus_from_no, bus_from_no] += Y11
    Y12 = -Y_l
    ybus[bus_from_no, bus_to_no] += Y12
    #Y21 = Y12
    ybus[bus_to_no, bus_from_no] += Y12
    Y22 = Y_l + (1im * get_b(br).to)
    ybus[bus_to_no, bus_to_no] += Y22
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    br::DynamicBranch,
    num_bus::Dict{Int, Int},
)
    _ybus!(ybus, br.branch, num_bus)
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    br::Transformer2W,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(br)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]
    Y_t = 1 / (get_r(br) + get_x(br) * 1im)
    Y11 = Y_t
    b = get_primary_shunt(br)
    if !isfinite(Y11) || !isfinite(Y_t) || !isfinite(b)
        error("Data in $(get_name(br)) is incorrect. r = $(get_r(br)), x = $(get_x(br))")
    end

    ybus[bus_from_no, bus_from_no] += Y11 - (1im * b)
    ybus[bus_from_no, bus_to_no] += -Y_t
    ybus[bus_to_no, bus_from_no] += -Y_t
    ybus[bus_to_no, bus_to_no] += Y_t
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    br::TapTransformer,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(br)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]

    Y_t = 1 / (get_r(br) + get_x(br) * 1im)
    c = 1 / get_tap(br)
    b = get_primary_shunt(br)

    Y11 = (Y_t * c^2)
    ybus[bus_from_no, bus_from_no] += Y11 - (1im * b)
    Y12 = (-Y_t * c)
    if !isfinite(Y11) || !isfinite(Y12) || !isfinite(b)
        error("Data in $(get_name(br)) is incorrect. r = $(get_r(br)), x = $(get_x(br))")
    end
    ybus[bus_from_no, bus_to_no] += Y12
    #Y21 = Y12
    ybus[bus_to_no, bus_from_no] += Y12
    Y22 = Y_t
    ybus[bus_to_no, bus_to_no] += Y22
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    br::PhaseShiftingTransformer,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(br)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]
    Y_t = 1 / (get_r(br) + get_x(br) * 1im)
    tap = (get_tap(br) * exp(get_α(br) * 1im))
    c_tap = (get_tap(br) * exp(-1 * get_α(br) * 1im))
    b = get_primary_shunt(br)
    Y11 = (Y_t / abs(tap)^2)
    if !isfinite(Y11) || !isfinite(Y_t) || !isfinite(b * c_tap)
        error("Data in $(get_name(br)) is incorrect. r = $(get_r(br)), x = $(get_x(br))")
    end
    ybus[bus_from_no, bus_from_no] += Y11 - (1im * b)
    Y12 = (-Y_t / c_tap)
    ybus[bus_from_no, bus_to_no] += Y12
    Y21 = (-Y_t / tap)
    ybus[bus_to_no, bus_from_no] += Y21
    Y22 = Y_t
    ybus[bus_to_no, bus_to_no] += Y22
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    fa::FixedAdmittance,
    num_bus::Dict{Int, Int},
)
    bus = get_bus(fa)
    bus_no = num_bus[get_number(bus)]
    ybus[bus_no, bus_no] += fa.Y
    return
end

function _buildybus(branches, nodes, fixed_admittances)
    buscount = length(nodes)
    num_bus = Dict{Int, Int}()

    for (ix, b) in enumerate(nodes)
        num_bus[get_number(b)] = ix
    end
    ybus = SparseArrays.spzeros(ComplexF64, buscount, buscount)
    for b in branches
        if get_name(b) == "init"
            throw(DataFormatError("The data in Branch is invalid"))
        end
        get_available(b) && _ybus!(ybus, b, num_bus)
    end
    for fa in fixed_admittances
        get_available(fa) && _ybus!(ybus, fa, num_bus)
    end
    return SparseArrays.dropzeros!(ybus)
end

"""
Builds a Ybus from a collection of buses and branches. The return is a Ybus Array indexed with the bus numbers and the branch names.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
- `connectivity_method::Function = goderya_connectivity`: method (`goderya_connectivity` or `dfs_connectivity`) for connectivity validation
"""
function Ybus(
    branches,
    nodes,
    fixed_admittances = Vector{FixedAdmittance}();
    check_connectivity::Bool = true,
    kwargs...,
)
    nodes = sort!(collect(nodes); by = x -> get_number(x))
    bus_ax = get_number.(nodes)
    axes = (bus_ax, bus_ax)
    bus_lookup = _make_ax_ref(bus_ax)
    look_up = (bus_lookup, bus_lookup)
    ybus = _buildybus(branches, nodes, fixed_admittances)
    if check_connectivity && length(nodes) > 1
        connected = validate_connectivity(ybus, nodes, bus_lookup; kwargs...)
        !connected && throw(DataFormatError("Network not connected"))
    end
    return Ybus(ybus, axes, look_up)
end

"""
Builds a Ybus from the system. The return is a Ybus Array indexed with the bus numbers and the branch names.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
- `connectivity_method::Function = goderya_connectivity`: method (`goderya_connectivity` or `dfs_connectivity`) for connectivity validation
"""
function Ybus(sys::System; check_connectivity::Bool = true, kwargs...)
    branches = get_components(ACBranch, sys)
    nodes = get_components(Bus, sys)
    fixed_admittances = get_components(FixedAdmittance, sys)
    return Ybus(
        branches,
        nodes,
        fixed_admittances;
        check_connectivity = check_connectivity,
        kwargs...,
    )
end

"""
Nodal incidence matrix (Adjacency) is an N x N matrix describing a power system with N buses. It represents the directed connectivity of the buses in a power system.

The Adjacency Struct is indexed using the Bus Numbers, no need for them to be sequential
"""
struct Adjacency{Ax, L <: NTuple{2, Dict}} <: PowerNetworkMatrix{Int}
    data::SparseArrays.SparseMatrixCSC{Int, Int}
    axes::Ax
    lookup::L
end

"""
Builds a Adjacency from a collection of buses and branches. The return is an N x N Adjacency Array indexed with the bus numbers.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
"""
function Adjacency(branches, nodes; check_connectivity::Bool = true, kwargs...)
    buscount = length(nodes)
    bus_ax = get_number.(nodes)
    axes = (bus_ax, bus_ax)
    bus_lookup = _make_ax_ref(bus_ax)
    look_up = (bus_lookup, bus_lookup)

    a = SparseArrays.spzeros(Int, buscount, buscount)

    for b in branches
        (fr_b, to_b) = get_bus_indices(b, bus_lookup)
        a[fr_b, to_b] = 1
        a[to_b, fr_b] = -1
        a[fr_b, fr_b] = 1
        a[to_b, to_b] = 1
    end

    if check_connectivity
        connected = validate_connectivity(a, nodes, bus_lookup; kwargs...)
        !connected && throw(DataFormatError("Network not connected"))
    end

    return Adjacency(a, axes, look_up)
end

"""
Builds a Adjacency from the system. The return is an N x N Adjacency Array indexed with the bus numbers.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
- `connectivity_method::Function = goderya_connectivity`: method (`goderya_connectivity` or `dfs_connectivity`) for connectivity validation
"""
function Adjacency(sys::System; check_connectivity::Bool = true, kwargs...)
    nodes = sort!(
        collect(get_components(Bus, sys, x -> get_bustype(x) != BusTypes.ISOLATED));
        by = x -> get_number(x),
    )
    branches = get_components(Branch, sys, get_available)
    return Adjacency(branches, nodes; check_connectivity = check_connectivity, kwargs...)
end

function _goderya(ybus::SparseArrays.SparseMatrixCSC)
    node_count = size(ybus)[1]
    max_I = node_count^2
    I, J, val = SparseArrays.findnz(ybus)
    T = SparseArrays.sparse(I, J, ones(Int, length(val)))
    T_ = T * T
    for n in 1:(node_count - 1)
        I, _, _ = SparseArrays.findnz(T_)
        if length(I) == max_I
            @info "The System has no islands"
            break
        elseif length(I) < max_I
            temp = T_ * T
            I_temp, _, _ = SparseArrays.findnz(temp)
            if all(I_temp == I)
                @warn "The system contains islands" maxlog = 1
            end
            T_ = temp
        else
            @assert false
        end
        #@assert n < node_count - 1
    end
    return I
end

"""
Checks the network connectivity of the system.

# Keyword arguments
- `connectivity_method::Function = goderya_connectivity`: Specifies the method used as Goderya's algorithm (`goderya_connectivity`) or depth first search/network traversal (`dfs_connectivity`)
* Note that the default Goderya method is more efficient, but is resource intensive and may not scale well on large networks.
"""
function validate_connectivity(
    sys::System;
    connectivity_method::Function = goderya_connectivity,
)
    nodes = sort!(
        collect(get_components(Bus, sys, x -> get_bustype(x) != BusTypes.ISOLATED));
        by = x -> get_number(x),
    )
    branches = get_components(Branch, sys, get_available)
    a = Adjacency(branches, nodes; check_connectivity = false)

    return validate_connectivity(
        a.data,
        nodes,
        a.lookup[1];
        connectivity_method = connectivity_method,
    )
end

function validate_connectivity(
    M,
    nodes::Vector{Bus},
    bus_lookup::Dict{Int64, Int64};
    connectivity_method::Function = goderya_connectivity,
)
    connected = connectivity_method(M, nodes, bus_lookup)
    return connected
end

function goderya_connectivity(M, nodes::Vector{Bus}, bus_lookup::Dict{Int64, Int64})
    @info "Validating connectivity with Goderya algorithm"
    length(nodes) > 15_000 &&
        @warn "The Goderya algorithm is memory intensive on large networks and may not scale well, try `connectivity_method = PowerSystems.dfs_connectivity"

    I = _goderya(M)

    node_count = length(nodes)
    connections = Dict([i => count(x -> x == i, I) for i in Set(I)])

    if length(Set(I)) == node_count
        connected = true
        if any(values(connections) .!= node_count)
            cc = Set(values(connections))
            @warn "Network has at least $(length(cc)) connected components with $cc nodes"
            connected = false
        end
    else
        disconnected_nodes = get_name.(nodes[setdiff(values(bus_lookup), I)])
        @warn "Principal connected component does not contain:" disconnected_nodes
        connected = false
    end
    return connected
end

"""
Finds the set of bus numbers that belong to each connnected component in the System
"""
# this function extends the PowerModels.jl implementation to accept a System
function find_connected_components(sys::System)
    a = Adjacency(sys; check_connectivity = false)
    return find_connected_components(a.data, a.lookup[1])
end

# this function extends the PowerModels.jl implementation to accept an adjacency matrix and bus lookup
function find_connected_components(M, bus_lookup::Dict{Int64, Int64})
    pm_buses = Dict([i => Dict("bus_type" => 1, "bus_i" => b) for (i, b) in bus_lookup])

    arcs = findall((LinearAlgebra.UpperTriangular(M) - LinearAlgebra.I) .!= 0)
    pm_branches = Dict([
        i => Dict("f_bus" => a[1], "t_bus" => a[2], "br_status" => 1) for
        (i, a) in enumerate(arcs)
    ],)

    data = Dict("bus" => pm_buses, "branch" => pm_branches)
    cc = calc_connected_components(data)
    bus_decode = Dict(value => key for (key, value) in bus_lookup)
    connected_components = Vector{Set{Int64}}()
    for c in cc
        push!(connected_components, Set([bus_decode[b] for b in c]))
    end
    return Set(connected_components)
end

function dfs_connectivity(M, _::Vector{Bus}, bus_lookup::Dict{Int64, Int64})
    @info "Validating connectivity with depth first search (network traversal)"
    cc = find_connected_components(M, bus_lookup)
    if length(cc) != 1
        @warn "Network has at least $(length(cc)) connected components with $(length.(cc)) nodes"
        connected = false
    else
        connected = true
    end
    return connected
end
