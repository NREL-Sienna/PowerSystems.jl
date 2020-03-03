abstract type ReserveDirection end
abstract type ReserveUp <: ReserveDirection end
abstract type ReserveDown <: ReserveDirection end
abstract type Reserve{T <: ReserveDirection} <: Service end

# Note that src/models/services_struct_types.jl and the testset
# "Test struct type collections" in test/test_services.jl must be modified if any types are
# added here.
