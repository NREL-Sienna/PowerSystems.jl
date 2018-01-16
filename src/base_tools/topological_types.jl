export system_param
export bus
export branch
export network
#export load_zone

"""
This file contains the types used in the componentes for power systems analysis 
toolbox developed in Julia.
"""

struct system_param
    #BusQuantity::Int
    #GeneratorQuantity::Int
    #LoadQuantity::Int
    BaseVoltage::Float64 # [kV]
    BasePower::Float64 # [MVA]
    GlobalReserves::Float64 # [pu]
    TimeSteps::Int
end

struct bus
    Number::Int
    Name::String
    BusType::String # [PV, PQ, SF]
    Voltage::Nullable{Float64} # [pu]
    MaxVoltage::Nullable{Float64} # [pu]
    MinVoltage::Nullable{Float64} # [pu]
    Angle::Nullable{Float64} # [degrees]
    BaseVoltage::Float64 # [kV]
end

struct branch
    number::Int
    status::Bool
    branch_type::String #[Line, Transf, 3W-Transf]
    ConnectionPoints::Tuple{bus,bus}    
    R::Nullable{Float64} #[pu]
    X::Float64 #[pu]Co
    B::Nullable{Float64} #[pu]
    MaxCapacity_forward::Float64  #[MVA]
    MaxCapacity_backward::Float64 #[MVA]
    BaseVoltage::Float64 #[kV]
end

struct network 
    LineQuantity::Int
    Ybus::SparseMatrixCSC{Complex{Float64},Int64}
    PTDLF::Array{Float64} 
    IncidenceMatrix::Array{Int}
    MaxFlows::Array{Float64,2} 
end
