abstract type ReserveDirection end
abstract type ReserveUp <: ReserveDirection end
abstract type ReserveDown <: ReserveDirection end
abstract type Reserve{T <: ReserveDirection} <: Service end

abstract type ReserveNonSpinning <: Service end
