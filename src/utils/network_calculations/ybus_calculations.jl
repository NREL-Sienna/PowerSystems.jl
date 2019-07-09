
struct Ybus <: PowerNetworkMatrix
    data::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}
    axes::NTuple{2,Array}
    lookup::NTuple{2,Dict}
end

function ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
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

function ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
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

function ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
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
function ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64},
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

#=
function ybus!(ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}, b::Transformer3W)

    @warn "Data contains a 3W transformer"

    Y11 = (1 / (b.line.r + b.line.x * 1im) + (1im * b.line.b) / 2);
    ybus[b.line.connectionpoints.from.number,
        b.line.connectionpoints.from.number] += Y11;
    Y12 = (-1 ./ (b.line.r + b.line.x * 1im));
    ybus[b.line.connectionpoints.from.number,
        b.line.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    ybus[b.line.connectionpoints.to.number,
        b.line.onnectionpoints[1].number] += Y12;
    #Y22 = Y11;
    ybus[b.line.connectionpoints.to.number,
        b.line.connectionpoints.to.number] += Y11;

    y = 1 / (b.transformer.r + b.transformer.x * 1im)
    y_a = y / (b.transformer.tap * exp(b.transformer.α * 1im * (π / 180)))
    c = 1 / b.transformer.tap

    Y11 = (y_a + y * c * (c - 1) + (b.transformer.zb));
    ybus[b.transformer.connectionpoints.from.number,
        b.transformer.connectionpoints.from.number] += Y11;
    Y12 = (-y_a) ;
    ybus[b.transformer.connectionpoints.from.number,
        b.transformer.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    ybus[b.transformer.connectionpoints.to.number,
        b.transformer.connectionpoints.from.number] += Y12;
    Y22 = (y_a + y * (1 - c)) ;
    ybus[b.transformer.connectionpoints.to.number,
        b.transformer.connectionpoints.to.number] += Y22;

end
=#

# Old Ybus creation
#=
function build_ybus(buscount::Int64, branches::Array{T}) where {T <: Branch}

    ybus = SparseArrays.spzeros(Complex{Float64}, buscount, buscount)

    num_bus = Dict{Int32,Int32}(zip(1:buscount,1:buscount))

    for b in branches

        if b.name == "init"
            @error "The data in Branch is incomplete" # TODO: raise error here?
        end

        ybus!(ybus, b, num_bus)

    end

    return ybus

end
=#


function _buildybus(branches::Array{T}, nodes::Array{Bus}) where {T<:Branch}

    buscount = length(nodes)
    linecount = length(branches)
    num_bus = Dict{Int32,Int32}()

    for (ix,b) in enumerate(nodes)
        num_bus[get_number(b)] = ix
    end

    A = zeros(Float64,buscount,linecount);
    ybus = SparseArrays.spzeros(Complex{Float64}, buscount, buscount);

    for (ix,b) in enumerate(branches)

        if get_name(b) == "init"
            @error "The data in Branch is incomplete" # TODO: raise error here?
        end

        A[num_bus[get_connectionpoints(b).from |> get_number], ix] =  1;

        A[num_bus[get_connectionpoints(b).to |> get_number], ix] = -1;

        ybus!(ybus, b, num_bus)


    end

    return  ybus, A

end

function Ybus(branches::Array{T}, nodes::Array{Bus}) where {T<:ACBranch}

    #Get axis names
    bus_ax = [get_number(bus) for bus in nodes]
    axes = (bus_ax, bus_ax)
    look_up = (_make_ax_ref(bus_ax),_make_ax_ref(bus_ax))

    ybus, A = _buildybus(branches, nodes)

    return Ybus(ybus, axes, look_up)

end
