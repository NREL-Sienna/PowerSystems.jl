"""
Attribute that contains information regarding the Transformer Impedance Correction Table.

# Arguments
- `ict_row::Int64`: Row number of the impedance correction table to linked it with a specific Transformer component.
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct ImpedanceCorrectionTable <: SupplementalAttribute
    table_number::String
    function_data::PiecewiseLinearData
    subcategory::String
    type::String
    internal::InfrastructureSystemsInternal
end

function ImpedanceCorrectionTable(;
    ict_row,
    function_data::PiecewiseLinearData,
    subcategory::String = "",
    type::String,
    internal = InfrastructureSystemsInternal(),
)
    return ImpedanceCorrectionTable(
        ict_row,
        function_data,
        subcategory,
        type,
        internal,
    )
end

"""Get [`ImpedanceCorrectionTable`](@ref) `table_number`."""
get_table_number(value::ImpedanceCorrectionTable) = value.table_number
"""Get [`ImpedanceCorrectionTable`](@ref) `function_data`."""
get_function_data(value::ImpedanceCorrectionTable) = value.function_data
"""Get [`ImpedanceCorrectionTable`](@ref) `subcategory`."""
get_subcategory(value::ImpedanceCorrectionTable) = value.subcategory
"""Get [`ImpedanceCorrectionTable`](@ref) `type`."""
get_type(value::ImpedanceCorrectionTable) = value.type
"""Get [`ImpedanceCorrectionTable`](@ref) `internal`."""
get_internal(value::ImpedanceCorrectionTable) = value.internal
