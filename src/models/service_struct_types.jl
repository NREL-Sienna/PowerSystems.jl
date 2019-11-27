const STATIC_RESERVE_STRUCT_TYPES = (
    StaticReserve{ReserveUp},
    StaticReserve{ReserveDown},
)

const VARIABLE_RESERVE_STRUCT_TYPES = (
    VariableReserve{ReserveUp},
    VariableReserve{ReserveDown},
)

const RESERVE_STRUCT_TYPES = Tuple(vcat(
    IS.get_all_concrete_subtypes(Reserve),
    collect(STATIC_RESERVE_STRUCT_TYPES),
    collect(VARIABLE_RESERVE_STRUCT_TYPES),
))

const SERVICE_STRUCT_TYPES = Tuple(vcat(
    IS.get_all_concrete_subtypes(Service),
    IS.get_all_concrete_subtypes(Reserve),
    collect(RESERVE_STRUCT_TYPES),
))
