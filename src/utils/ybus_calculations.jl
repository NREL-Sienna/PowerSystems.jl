
function ybus!(Ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}, b::Line)

    Y_l = (1 / (b.r + b.x * 1im))

    Y11 = Y_l + (1im * b.b.from);
    Ybus[b.arch.from.number,
        b.arch.from.number] += Y11;

    Y12 = -Y_l;
    Ybus[b.arch.from.number,
        b.arch.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.arch.to.number,
        b.arch.from.number] += Y12;

    Y22 = Y_l + (1im * b.b.to);
    Ybus[b.arch.to.number,
        b.arch.to.number] += Y22;

end

function ybus!(Ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}, b::Transformer2W)

    Y_t = 1 / (b.r + b.x * 1im)

    Y11 = Y_t
    Ybus[b.arch.from.number,
        b.arch.from.number] += Y11;
    Ybus[b.arch.from.number,
        b.arch.to.number] += -Y_t;
    Ybus[b.arch.to.number,
        b.arch.from.number] += -Y_t;
    Ybus[b.arch.to.number,
        b.arch.to.number] += Y_t + (1im * b.primaryshunt);

end

function ybus!(Ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}, b::TapTransformer)

    Y_t = 1 / (b.r + b.x * 1im)
    c = 1 / b.tap

    Y11 = (Y_t * c^2);
    Ybus[b.arch.from.number,
        b.arch.from.number] += Y11;
    Y12 = (-Y_t*c) ;
    Ybus[b.arch.from.number,
        b.arch.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.arch.to.number,
        b.arch.from.number] += Y12;
    Y22 = Y_t;
    Ybus[b.arch.to.number,
        b.arch.to.number] += Y22 + (1im * b.primaryshunt);

end

# TODO: Add testing for Ybus of a system with a PS Transformer
function ybus!(Ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}, b::PhaseShiftingTransformer)

    Y_t = 1 / (b.r + b.x * 1im)
    tap =  (b.tap * exp(b.α * 1im))
    c_tap =  (b.tap * exp(-1*b.α * 1im))

    Y11 = (Y_t/abs(tap)^2);
    Ybus[b.arch.from.number,
        b.arch.from.number] += Y11;
    Y12 = (-Y_t/c_tap);
    Ybus[b.arch.from.number,
        b.arch.to.number] += Y12;
    Y21 = (-Y_t/tap);
    Ybus[b.arch.to.number,
        b.arch.from.number] += Y21;
    Y22 = Y_t;
    Ybus[b.arch.to.number,
        b.arch.to.number] += Y22 + (1im * b.primaryshunt);

end

#=
function ybus!(Ybus::SparseArrays.SparseMatrixCSC{Complex{Float64},Int64}, b::Transformer3W)

    @warn "Data contains a 3W transformer"

    Y11 = (1 / (b.line.r + b.line.x * 1im) + (1im * b.line.b) / 2);
    Ybus[b.line.arch.from.number,
        b.line.arch.from.number] += Y11;
    Y12 = (-1 ./ (b.line.r + b.line.x * 1im));
    Ybus[b.line.arch.from.number,
        b.line.arch.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.line.arch.to.number,
        b.line.onnectionpoints[1].number] += Y12;
    #Y22 = Y11;
    Ybus[b.line.arch.to.number,
        b.line.arch.to.number] += Y11;

    y = 1 / (b.transformer.r + b.transformer.x * 1im)
    y_a = y / (b.transformer.tap * exp(b.transformer.α * 1im * (π / 180)))
    c = 1 / b.transformer.tap

    Y11 = (y_a + y * c * (c - 1) + (b.transformer.zb));
    Ybus[b.transformer.arch.from.number,
        b.transformer.arch.from.number] += Y11;
    Y12 = (-y_a) ;
    Ybus[b.transformer.arch.from.number,
        b.transformer.arch.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.transformer.arch.to.number,
        b.transformer.arch.from.number] += Y12;
    Y22 = (y_a + y * (1 - c)) ;
    Ybus[b.transformer.arch.to.number,
        b.transformer.arch.to.number] += Y22;

end
=#

function build_ybus(buscount::Int64, branches::Array{T}) where {T <: Branch}

    Ybus = SparseArrays.spzeros(Complex{Float64}, buscount, buscount)

    for b in branches

        if b.name == "init"
            @error "The data in Branch is incomplete" # TODO: raise error here?
        end

        ybus!(Ybus, b)

    end

    return Ybus

end
