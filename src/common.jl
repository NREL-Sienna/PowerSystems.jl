
"From http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf Table B-4"
@enum GeneratorCostModel begin
    PIECEWISE_LINEAR = 1
    POLYNOMIAL = 2
end


"Thrown upon detection of user data that is not supported."
struct DataFormatError <: Exception
    msg::String
end

struct InvalidParameter <: Exception
    msg::String
end

PS_MAX_LOG = parse(Int, get(ENV, "PS_MAX_LOG", "50"))

