"""
Attribute that contains information regarding the Transformer Impedance Correction Rows defined in the Table.

# Arguments
- `table_number::Int64`: Row number of the impedance correction table to be linked with a specific Transformer component.
- `function_data::PiecewiseLinearData`: Function to define intervals to apply tap ratio or angle shift to the Transformer component.
- `subcategory::String`: Indicates the winding for Transformer3W or an empty string for the Transformer2W.
- `type::String`: Indicates whether the function is for tap ratio or angle shift.
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct ImpedanceCorrectionData <: SupplementalAttribute
    table_number::Int64
    impedance_correction_function_data::PiecewiseLinearData
    transformer_winding::WindingCategory
    transformer_control_mode::TransformerControlMode
    internal::InfrastructureSystemsInternal
end

function ImpedanceCorrectionData(;
    table_number,
    impedance_correction_function_data,
    transformer_winding,
    transformer_control_mode,
    internal = InfrastructureSystemsInternal(),
)
    return ImpedanceCorrectionData(
        table_number,
        impedance_correction_function_data,
        transformer_winding,
        transformer_control_mode,
        internal,
    )
end

"""Get [`ImpedanceCorrectionData`](@ref) `table_number`."""
get_table_number(value::ImpedanceCorrectionData) = value.table_number
"""Get [`ImpedanceCorrectionData`](@ref) `function_data`."""
get_impedance_correction_function_data(value::ImpedanceCorrectionData) =
    value.impedance_correction_function_data
"""Get [`ImpedanceCorrectionData`](@ref) `transformer_winding`."""
get_transformer_winding(value::ImpedanceCorrectionData) = value.transformer_winding
"""Get [`ImpedanceCorrectionData`](@ref) `transformer_control_mode`."""
get_transformer_control_mode(value::ImpedanceCorrectionData) =
    value.transformer_control_mode
"""Get [`ImpedanceCorrectionData`](@ref) `internal`."""
get_internal(value::ImpedanceCorrectionData) = value.internal
