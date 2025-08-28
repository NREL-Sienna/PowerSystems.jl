"""
Attribute that contains information regarding the Impedance Correction Table (ICT) rows defined in the Table.

# Arguments
- `table_number::Int64`: Row number of the ICT to be linked with a specific Transformer component.
- `impedance_correction_curve::PiecewiseLinearData`: Function to define intervals (tap ratio/angle shift) in the Transformer component.
- `transformer_winding::WindingCategory`: Indicates the winding to which the ICT is linked to for a Transformer component.
- `transformer_control_mode::String`: Defines the control modes of the Transformer, whether is for off-nominal turns ratio or phase angle shifts.
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct ImpedanceCorrectionData <: SupplementalAttribute
    table_number::Int64
    impedance_correction_curve::PiecewiseLinearData
    transformer_winding::WindingCategory
    transformer_control_mode::ImpedanceCorrectionTransformerControlMode
    internal::InfrastructureSystemsInternal
end

function ImpedanceCorrectionData(;
    table_number,
    impedance_correction_curve,
    transformer_winding,
    transformer_control_mode,
    internal = InfrastructureSystemsInternal(),
)
    return ImpedanceCorrectionData(
        table_number,
        impedance_correction_curve,
        transformer_winding,
        transformer_control_mode,
        internal,
    )
end

"""Get [`ImpedanceCorrectionData`](@ref) `table_number`."""
get_table_number(value::ImpedanceCorrectionData) = value.table_number
"""Get [`ImpedanceCorrectionData`](@ref) `function_data`."""
get_impedance_correction_curve(value::ImpedanceCorrectionData) =
    value.impedance_correction_curve
"""Get [`ImpedanceCorrectionData`](@ref) `transformer_winding`."""
get_transformer_winding(value::ImpedanceCorrectionData) = value.transformer_winding
"""Get [`ImpedanceCorrectionData`](@ref) `transformer_control_mode`."""
get_transformer_control_mode(value::ImpedanceCorrectionData) =
    value.transformer_control_mode
"""Get [`ImpedanceCorrectionData`](@ref) `internal`."""
get_internal(value::ImpedanceCorrectionData) = value.internal
