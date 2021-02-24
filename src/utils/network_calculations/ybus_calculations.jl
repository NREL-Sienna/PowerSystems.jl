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
    b::ACBranch,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(b)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]
    Y_l = (1 / (get_r(b) + get_x(b) * 1im))
    Y11 = Y_l + (1im * get_b(b).from)
    ybus[bus_from_no, bus_from_no] += Y11
    Y12 = -Y_l
    ybus[bus_from_no, bus_to_no] += Y12
    #Y21 = Y12
    ybus[bus_to_no, bus_from_no] += Y12
    Y22 = Y_l + (1im * get_b(b).to)
    ybus[bus_to_no, bus_to_no] += Y22
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    b::Transformer2W,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(b)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]
    Y_t = 1 / (get_r(b) + get_x(b) * 1im)
    Y11 = Y_t
    b = get_primary_shunt(b)
    ybus[bus_from_no, bus_from_no] += Y11
    ybus[bus_from_no, bus_to_no] += -Y_t
    ybus[bus_to_no, bus_from_no] += -Y_t
    ybus[bus_to_no, bus_to_no] += Y_t + (1im * b)
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    b::TapTransformer,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(b)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]

    Y_t = 1 / (get_r(b) + get_x(b) * 1im)
    c = 1 / get_tap(b)
    b = get_primary_shunt(b)

    Y11 = (Y_t * c^2)
    ybus[bus_from_no, bus_from_no] += Y11
    Y12 = (-Y_t * c)
    ybus[bus_from_no, bus_to_no] += Y12
    #Y21 = Y12
    ybus[bus_to_no, bus_from_no] += Y12
    Y22 = Y_t
    ybus[bus_to_no, bus_to_no] += Y22 + (1im * b)
    return
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int},
    b::PhaseShiftingTransformer,
    num_bus::Dict{Int, Int},
)
    arc = get_arc(b)
    bus_from_no = num_bus[arc.from.number]
    bus_to_no = num_bus[arc.to.number]
    Y_t = 1 / (get_r(b) + get_x(b) * 1im)
    tap = (get_tap(b) * exp(get_α(b) * 1im))
    c_tap = (get_tap(b) * exp(-1 * get_α(b) * 1im))
    b = get_primary_shunt(b)
    Y11 = (Y_t / abs(tap)^2)
    ybus[bus_from_no, bus_from_no] += Y11
    Y12 = (-Y_t / c_tap)
    ybus[bus_from_no, bus_to_no] += Y12
    Y21 = (-Y_t / tap)
    ybus[bus_to_no, bus_from_no] += Y21
    Y22 = Y_t
    ybus[bus_to_no, bus_to_no] += Y22 + (1im * b)
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
"""
function Ybus(
    branches,
    nodes,
    fixed_admittances = Vector{FixedAdmittance}();
    check_connectivity::Bool = true,
)
    nodes = sort!(collect(nodes), by = x -> get_number(x))
    bus_ax = get_number.(nodes)
    axes = (bus_ax, bus_ax)
    bus_lookup = _make_ax_ref(bus_ax)
    look_up = (bus_lookup, bus_lookup)
    ybus = _buildybus(branches, nodes, fixed_admittances)
    if check_connectivity
        connected = is_connected(ybus, nodes, bus_lookup)
        !connected && throw(DataFormatError("Network not connected"))
    end
    return Ybus(ybus, axes, look_up)
end

"""
Builds a Ybus from the system. The return is a Ybus Array indexed with the bus numbers and the branch names.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
"""
function Ybus(sys::System; check_connectivity::Bool = true)
    branches = get_components(ACBranch, sys)
    nodes = get_components(Bus, sys)
    fixed_admittances = get_components(FixedAdmittance, sys)
    return Ybus(branches, nodes, fixed_admittances; check_connectivity = check_connectivity)
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
function Adjacency(branches, nodes; check_connectivity::Bool = true)
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
        connected = is_connected(a, nodes, bus_lookup)
        !connected && throw(DataFormatError("Network not connected"))
    end

    return Adjacency(a, axes, look_up)
end

"""
Builds a Adjacency from the system. The return is an N x N Adjacency Array indexed with the bus numbers.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
"""
function Adjacency(sys::System; check_connectivity::Bool = true)
    nodes = sort!(collect(get_components(Bus, sys)), by = x -> get_number(x))
    branches = get_components(Branch, sys, get_available)
    return Adjacency(branches, nodes; check_connectivity = check_connectivity)
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

function is_connected(sys::System)
    a = Adjacency(sys; check_connectivity = false)
    return is_connected(a.data, collect(get_components(Bus, sys)), a.lookup[1])
end

function is_connected(M, nodes, bus_lookup)
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
