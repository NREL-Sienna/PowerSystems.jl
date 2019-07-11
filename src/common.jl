
const Min_Max = NamedTuple{(:min, :max),Tuple{Float64,Float64}}
const From_To_Float = NamedTuple{(:from, :to),Tuple{Float64,Float64}}
const FromTo_ToFrom_Float = NamedTuple{(:from_to, :to_from),Tuple{Float64,Float64}}

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
    ISOLATED
    PQ
    PV
    REF
    SLACK
end

"From https://www.eia.gov/survey/form/eia_923/instructions.pdf"
@enum PrimeMovers begin
    ST	#Steam Turbine, including nuclear, geothermal and solar steam (does not include combined cycle)
    BT  #Turbines Used in a Binary Cycle (geothermal)
    GT	#Combustion (Gas) Turbine (includes jet engine design)
    IC	#Internal Combustion (diesel, piston) Engine
    CT	#Combined Cycle Combustion – Turbine Part
    CA	#Combined Cycle – Steam Part
    CS	#Combined Cycle Single Shaft (combustion turbine and steam turbine share a single generator)
    HY	#Hydraulic Turbine (includes turbines associated with delivery of water by pipeline)
    PS	#Hydraulic Turbine – Reversible (pumped storage)
    PV	#Photovoltaic
    WT	#Wind Turbine
    CE	#Compressed Air Energy Storage
    FC	#Fuel Cell
    OT	#Other
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
