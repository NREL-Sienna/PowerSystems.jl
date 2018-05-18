
function ybus!(Ybus, b::PowerSystems.Line)

    Y11 = (1 / (b.r + b.x * 1im) + (1im * b.b) / 2);
    Ybus[b.connectionpoints.from.number,
        b.connectionpoints.from.number] += Y11;
    Y12 = (-1 ./ (b.r + b.x * 1im));
    Ybus[b.connectionpoints.from.number,
        b.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.connectionpoints.to.number,
        b.connectionpoints.from.number] += Y12;
    #Y22 = Y11;
    Ybus[b.connectionpoints.to.number,
        b.connectionpoints.to.number] += Y11;

end

function ybus!(Ybus, b::PowerSystems.PhaseShiftingTransformer)

    y = 1 / (b.r + b.x * 1im)
    y_a = y / (b.tap * exp(b.α * 1im * (π / 180)))
    c = 1 / b.tap

    Y11 = (y_a + y * c * (c - 1) + (b.zb));
    Ybus[b.connectionpoints.from.number,
        b.connectionpoints.from.number] += Y11;
    Y12 = (-y_a) ;
    Ybus[b.connectionpoints.from.number,
        b.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.connectionpoints.to.number,
        b.connectionpoints.from.number] += Y12;
    Y22 = (y_a + y * (1 - c));
    Ybus[b.connectionpoints.to.number,
        b.connectionpoints.to.number] += Y22;

end

function ybus!(Ybus, b::PowerSystems.Transformer2W)

    y = 1 / (b.r + b.x * 1im)
    y_a = y / (b.tap)
    c = 1 / b.tap

    Y11 = (y_a + y * c * (c - 1) + (b.zb));
    Ybus[b.connectionpoints.from.number,
        b.connectionpoints.from.number] += Y11;
    Y12 = (-y_a) ;
    Ybus[b.connectionpoints.from.number,
        b.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.connectionpoints.to.number,
        b.connectionpoints.from.number] += Y12;
    Y22 = (y_a + y * (1 - c)) ;;
    Ybus[b.connectionpoints.to.number,
        b.connectionpoints.to.number] += Y22;

end

function ybus!(Ybus, b::PowerSystems.Transformer3W)

    @warn("Data contains a 3W transformer")

    Y11 = (1 / (b.line.r + b.line.x * 1im) + (1im * b.line.b) / 2);
    Ybus[b.line.connectionpoints.from.number,
        b.line.connectionpoints.from.number] += Y11;
    Y12 = (-1 ./ (b.line.r + b.line.x * 1im));
    Ybus[b.line.connectionpoints.from.number,
        b.line.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.line.connectionpoints.to.number,
        b.line.onnectionpoints[1].number] += Y12;
    #Y22 = Y11;
    Ybus[b.line.connectionpoints.to.number,
        b.line.connectionpoints.to.number] += Y11;

    y = 1 / (b.transformer.r + b.transformer.x * 1im)
    y_a = y / (b.transformer.tap * exp(b.transformer.α * 1im * (π / 180)))
    c = 1 / b.transformer.tap

    Y11 = (y_a + y * c * (c - 1) + (b.transformer.zb));
    Ybus[b.transformer.connectionpoints.from.number,
        b.transformer.connectionpoints.from.number] += Y11;
    Y12 = (-y_a) ;
    Ybus[b.transformer.connectionpoints.from.number,
        b.transformer.connectionpoints.to.number] += Y12;
    #Y21 = Y12
    Ybus[b.transformer.connectionpoints.to.number,
        b.transformer.connectionpoints.from.number] += Y12;
    Y22 = (y_a + y * (1 - c)) ;
    Ybus[b.transformer.connectionpoints.to.number,
        b.transformer.connectionpoints.to.number] += Y22;

end

function build_ybus(buscount, branches::Array{T}) where {T <: Branch}

    Ybus = spzeros(Complex{Float64}, buscount, buscount)

    for b in branches

        if b.name == "init"
            error("The data in Branch is incomplete")
        end

        ybus!(Ybus, b)
        # Update to use parametric dispatch and increase performance here.

    end

    return Ybus

end
