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
    for (ix, b) in enumerate(branches)
        if get_name(b) == "init"
            throw(DataFormatError("The data in Branch is invalid"))
        end

        _ybus!(ybus, b, num_bus)
    end
    for fa in fixed_admittances
        _ybus!(ybus, fa, num_bus)
    end
    return SparseArrays.dropzeros!(ybus)
end

function _goderya(ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int})
    node_count = size(ybus)[1]
    max_I = node_count^2
    I, J, val = SparseArrays.findnz(ybus)
    T = SparseArrays.sparse(I, J, ones(length(val)))
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
                throw(DataFormatError("The system contains islands"))
            end
            T_ = temp
        else
            @assert false
        end
        @assert n < node_count - 1
    end
    return
end

"""
Builds a Ybus from a collection of buses and branches. The return is a Ybus Array indexed with the bus numbers and the branch names.

# Keyword arguments
- `check_connectivity::Bool`: Checks connectivity of the network using Goderya's algorithm
"""
function Ybus(branches, nodes; check_connectivity::Bool = true)
    #Get axis names
    bus_ax = [get_number(bus) for bus in nodes]
    sort!(bus_ax)
    axes = (bus_ax, bus_ax)
    look_up = (_make_ax_ref(bus_ax), _make_ax_ref(bus_ax))
    ybus = _buildybus(branches, nodes, Vector{FixedAdmittance}())
    if check_connectivity
        _goderya(ybus)
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
    nodes = sort(collect(get_components(Bus, sys)), by = x -> x.number)
    fixed_admittances = get_components(FixedAdmittance, sys)
    # Get axis names
    bus_ax = sort([get_number(bus) for bus in nodes])
    axes = (bus_ax, bus_ax)
    look_up = (_make_ax_ref(bus_ax), _make_ax_ref(bus_ax))
    ybus = _buildybus(branches, nodes, fixed_admittances)
    if check_connectivity
        _goderya(ybus)
    end
    return Ybus(ybus, axes, look_up)
end
