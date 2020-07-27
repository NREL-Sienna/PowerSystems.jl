abstract type ReserveDirection end
abstract type ReserveUp <: ReserveDirection end
abstract type ReserveDown <: ReserveDirection end
abstract type ReserveSupplementaryUp  <: ReserveDirection end
abstract type ReserveSupplementaryDown  <: ReserveDirection end
abstract type Reserve{T <: ReserveDirection} <: Service end
