abstract type ReserveDirection end
abstract type ReserveUp <: ReserveDirection end
abstract type ReserveDown <: ReserveDirection end
abstract type ReserveSymmetric <: ReserveDirection end
abstract type AbstractReserve <: Service end
abstract type Reserve{T <: ReserveDirection} <: AbstractReserve end
abstract type ReserveNonSpinning <: AbstractReserve end
