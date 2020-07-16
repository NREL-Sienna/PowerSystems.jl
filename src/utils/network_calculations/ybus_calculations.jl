struct Ybus{Ax, L <: NTuple{2, Dict}} <: PowerNetworkMatrix{ComplexF64}
    data::SparseArrays.SparseMatrixCSC{ComplexF64, Int64}
    axes::Ax
    lookup::L
end

function _ybus!(
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int64},
    b::ACBranch,
    num_bus::Dict{Int64, Int64},
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
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int64},
    b::Transformer2W,
    num_bus::Dict{Int64, Int64},
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
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int64},
    b::TapTransformer,
    num_bus::Dict{Int64, Int64},
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
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int64},
    b::PhaseShiftingTransformer,
    num_bus::Dict{Int64, Int64},
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
    ybus::SparseArrays.SparseMatrixCSC{ComplexF64, Int64},
    fa::FixedAdmittance,
    num_bus::Dict{Int64, Int64},
)
    bus = get_bus(fa)
    bus_no = num_bus[get_number(bus)]
    ybus[bus_no, bus_no] += fa.Y
    return
end

function _buildybus(branches, nodes, fixed_admittances)
    buscount = length(nodes)
    num_bus = Dict{Int64, Int64}()

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
    return ybus
end

function Ybus(branches, nodes)
    #Get axis names
    bus_ax = [get_number(bus) for bus in nodes]
    sort!(bus_ax, by = x -> x.number)
    axes = (bus_ax, bus_ax)
    look_up = (_make_ax_ref(bus_ax), _make_ax_ref(bus_ax))
    ybus = _buildybus(branches, nodes, Vector{FixedAdmittance}())
    return Ybus(ybus, axes, look_up)
end

function Ybus(sys::System)
    branches = get_components(ACBranch, sys)
    nodes = sort(collect(get_components(Bus, sys)), by = x -> x.number)
    fixed_admittances = get_components(FixedAdmittance, sys)

    # Get axis names
    bus_ax = [get_number(bus) for bus in nodes]
    axes = (bus_ax, bus_ax)
    look_up = (_make_ax_ref(bus_ax), _make_ax_ref(bus_ax))

    ybus = _buildybus(branches, nodes, fixed_admittances)

    return Ybus(ybus, axes, look_up)
end
