
"From http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf Table B-4"
@enum GeneratorCostModel begin
    piecewise_linear = 1
    polynomial = 2
end


"Thrown upon detection of user data that is not supported."
struct DataFormatError <: Exception
    msg::String
end
