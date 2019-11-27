abstract type Reserve <: Service end
abstract type ReserveDirection end
abstract type ReserveUp <: ReserveDirection end
abstract type ReserveDown <: ReserveDirection end

# Note that src/models/services_struct_types.jl and the testset
# "Test struct type collections" in test/test_services.jl must be modified if any types are
# added here.
