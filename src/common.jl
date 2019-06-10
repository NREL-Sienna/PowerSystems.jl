
"From http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf Table B-4"
@enum GeneratorCostModel begin
    PIECEWISE_LINEAR = 1
    POLYNOMIAL = 2
end

@enum AngleUnit begin
    DEGREES
    RADIANS
end

@enum BusType begin
    REF
    ISOLATED  # TODO DT: this was in a matpower file, verify
    PQ
    PV
    SF
    SLACK
    UNKNOWN
end

"Thrown upon detection of user data that is not supported."
struct DataFormatError <: Exception
    msg::String
end

struct InvalidParameter <: Exception
    msg::String
end

PS_MAX_LOG = parse(Int, get(ENV, "PS_MAX_LOG", "50"))
DEFAULT_BASE_MVA = 100.0
