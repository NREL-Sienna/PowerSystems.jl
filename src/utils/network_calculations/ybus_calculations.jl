
struct Ybus <: PowerNetworkMatrix
    data::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}
    axes::NTuple{2,Array}
    lookup::NTuple{2,Dict}
end

function _ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
                b::Line,
                num_bus::Dict{Int32,Int32})

    Y_l = (1 / (b.r + b.x * 1im))

    Y11 = Y_l + (1im * b.b.from);
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y11;

    Y12 = -Y_l;
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y12;
    #Y21 = Y12
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y12;

    Y22 = Y_l + (1im * b.b.to);
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y22;

end

function _ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
                b::Transformer2W,
                num_bus::Dict{Int32,Int32})

    Y_t = 1 / (b.r + b.x * 1im)

    Y11 = Y_t
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y11;
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += -Y_t;
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += -Y_t;
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y_t + (1im * b.primaryshunt);

end

function _ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
                b::TapTransformer,
                num_bus::Dict{Int32,Int32})

    Y_t = 1 / (b.r + b.x * 1im)
    c = 1 / b.tap

    Y11 = (Y_t * c^2);
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y11;
    Y12 = (-Y_t*c) ;
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y12;
    #Y21 = Y12
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y12;
    Y22 = Y_t;
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y22 + (1im * b.primaryshunt);

end

# TODO: Add testing for Ybus of a system with a PS Transformer
function _ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
                b::PhaseShiftingTransformer,
                num_bus::Dict{Int32,Int32})

    Y_t = 1 / (b.r + b.x * 1im)
    tap =  (b.tap * exp(b.α * 1im))
    c_tap =  (b.tap * exp(-1*b.α * 1im))
    
    Y11 = (Y_t/abs(tap)^2);
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y11;
    Y12 = (-Y_t/c_tap);
    ybus[num_bus[get_connectionpoints(b).from |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y12;
    Y21 = (-Y_t/tap);
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).from |> get_number]] += Y21;
    Y22 = Y_t;
    ybus[num_bus[get_connectionpoints(b).to |> get_number],
        num_bus[get_connectionpoints(b).to |> get_number]] += Y22 + (1im * b.primaryshunt);

end

function _buildybus(branches::Array{T}, nodes::Array{Bus}) where {T<:ACBranch}

    buscount = length(nodes)
    num_bus = Dict{Int32,Int32}()

    for (ix,b) in enumerate(nodes)
        num_bus[get_number(b)] = ix
    end

    ybus = SparseArrays.spzeros(Complex{Float64}, buscount, buscount);

    for (ix,b) in enumerate(branches)

        if get_name(b) == "init"
            @error "The data in Branch is incomplete" # TODO: raise error here?
        end

        _ybus!(ybus, b, num_bus)

    end

    return  ybus

end

function Ybus(branches::Array{T}, nodes::Array{Bus}) where {T<:ACBranch}

    #Get axis names
    bus_ax = [get_number(bus) for bus in nodes]
    axes = (bus_ax, bus_ax)
    look_up = (_make_ax_ref(bus_ax),_make_ax_ref(bus_ax))

    ybus = _buildybus(branches, nodes)

    return Ybus(ybus, axes, look_up)

end

function Ybus(sys::System)
    branches = get_components(ACBranch, sys) |> collect
    nodes = get_components(Bus, sys) |> collect

    return Ybus(branches, nodes)
    
end