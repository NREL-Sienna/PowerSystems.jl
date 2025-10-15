#####################################################################
#                                                                   #
# This file provides functions for interfacing with pti .raw files  #
#                                                                   #
#####################################################################

"""
A list of data file sections in the order that they appear in a PTI v33/v35 file
"""
const _pti_sections = [
    "CASE IDENTIFICATION",
    "BUS",
    "LOAD",
    "FIXED SHUNT",
    "GENERATOR",
    "BRANCH",
    "TRANSFORMER",
    "AREA INTERCHANGE",
    "TWO-TERMINAL DC",
    "VOLTAGE SOURCE CONVERTER",
    "IMPEDANCE CORRECTION",
    "MULTI-TERMINAL DC",
    "MULTI-SECTION LINE",
    "ZONE",
    "INTER-AREA TRANSFER",
    "OWNER",
    "FACTS CONTROL DEVICE",
    "SWITCHED SHUNT",
    "GNE DEVICE",
    "INDUCTION MACHINE",
]

const _pti_sections_v35 = vcat(
    _pti_sections[1:6],
    ["SWITCHING DEVICE"],
    _pti_sections[7:end],
    "SUBSTATION DATA",
)

const _transaction_dtypes = [
    ("IC", Int64),
    ("SBASE", Float64),
    ("REV", Int64),
    ("XFRRAT", Float64),
    ("NXFRAT", Float64),
    ("BASFRQ", Float64),
]

const _transaction_dtypes_v35 = _transaction_dtypes

const _system_wide_dtypes_v35 = [
    ("THRSHZ", Float64),
    ("PQBRAK", Float64),
    ("BLOWUP", Float64),
    ("MAXISOLLVLS", Int64),
    ("CAMAXREPTSLN", Int64),
    ("CHKDUPCNTLBL", Int64),
    ("ITMX", Int64),
    ("ACCP", Float64),
    ("ACCQ", Float64),
    ("ACCM", Float64),
    ("TOL", Float64),
    ("ITMXN", Int64),
    ("ACCN", Float64),
    ("TOLN", Float64),
    ("VCTOLQ", Float64),
    ("VCTOLV", Float64),
    ("DVLIM", Float64),
    ("NDVFCT", Float64),
    ("ADJTHR", Float64),
    ("ACCTAP", Float64),
    ("TAPLIM", Float64),
    ("SWVBND", Float64),
    ("MXTPSS", Int64),
    ("MXSWIM", Int64),
    ("ITMXTY", Int64),
    ("ACCTY", Float64),
    ("TOLTY", Float64),
    ("METHOD", String),
    ("ACTAPS", Int64),
    ("AREAIN", Int64),
    ("PHSHFT", Int64),
    ("DCTAPS", Int64),
    ("SWSHNT", Int64),
    ("FLATST", Int64),
    ("VARLIM", Int64),
    ("NONDIV", Int64),
    ("IRATE", Int64),
    ("NAME", String),
    ("DESC", String),
]

const _system_wide_data_sections_v35 = Dict{String, Vector{String}}(
    "GENERAL" =>
        ["THRSHZ", "PQBRAK", "BLOWUP", "MAXISOLLVLS", "CAMAXREPTSLN", "CHKDUPCNTLBL"],
    "GAUSS" => ["ITMX", "ACCP", "ACCQ", "ACCM", "TOL"],
    "NEWTON" => ["ITMXN", "ACCN", "TOLN", "VCTOLQ", "VCTOLV", "DVLIM", "NDVFCT"],
    "ADJUST" => ["ADJTHR", "ACCTAP", "TAPLIM", "SWVBND", "MXTPSS", "MXSWIM"],
    "TYSL" => ["ITMXTY", "ACCTY", "TOLTY"],
    "SOLVER" => [
        "METHOD",
        "ACTAPS",
        "AREAIN",
        "PHSHFT",
        "DCTAPS",
        "SWSHNT",
        "FLATST",
        "VARLIM",
        "NONDIV",
    ],
    "RATING" => ["IRATE", "NAME", "DESC"],
)

const _bus_dtypes = [
    ("I", Int64),
    ("NAME", String),
    ("BASKV", Float64),
    ("IDE", Int64),
    ("AREA", Int64),
    ("ZONE", Int64),
    ("OWNER", Int64),
    ("VM", Float64),
    ("VA", Float64),
    ("NVHI", Float64),
    ("NVLO", Float64),
    ("EVHI", Float64),
    ("EVLO", Float64),
]

const _bus_dtypes_v35 = _bus_dtypes

const _load_dtypes = [
    ("I", Int64),
    ("ID", String),
    ("STATUS", Int64),
    ("AREA", Int64),
    ("ZONE", Int64),
    ("PL", Float64),
    ("QL", Float64),
    ("IP", Float64),
    ("IQ", Float64),
    ("YP", Float64),
    ("YQ", Float64),
    ("OWNER", Int64),
    ("SCALE", Int64),
    ("INTRPT", Int64),
]

const _load_dtypes_v35 = vcat(
    _load_dtypes[1:14],
    [
        ("DGENP", Float64),
        ("DGENQ", Float64),
        ("DGENM", Float64),
        ("LOADTYPE", String),
    ],
)

const _fixed_shunt_dtypes = [
    ("I", Int64),
    ("ID", String),
    ("STATUS", Int64),
    ("GL", Float64),
    ("BL", Float64),
]

const _fixed_shunt_dtypes_v35 = _fixed_shunt_dtypes

const _generator_dtypes = [
    ("I", Int64),
    ("ID", String),
    ("PG", Float64),
    ("QG", Float64),
    ("QT", Float64),
    ("QB", Float64),
    ("VS", Float64),
    ("IREG", Int64),
    ("MBASE", Float64),
    ("ZR", Float64),
    ("ZX", Float64),
    ("RT", Float64),
    ("XT", Float64),
    ("GTAP", Float64),
    ("STAT", Int64),
    ("RMPCT", Float64),
    ("PT", Float64),
    ("PB", Float64),
    ("O1", Int64),
    ("F1", Float64),
    ("O2", Int64),
    ("F2", Float64),
    ("O3", Int64),
    ("F3", Float64),
    ("O4", Int64),
    ("F4", Float64),
    ("WMOD", Int64),
    ("WPF", Float64),
]

const _generator_dtypes_v35 = vcat(
    _generator_dtypes[1:8],
    [("NREG", Int64)],
    _generator_dtypes[9:18],
    [("BASLOD", Int64)],
    _generator_dtypes[19:end],
)

const _branch_dtypes = [
    ("I", Int64),
    ("J", Int64),
    ("CKT", String),
    ("R", Float64),
    ("X", Float64),
    ("B", Float64),
    ("RATEA", Float64),
    ("RATEB", Float64),
    ("RATEC", Float64),
    ("GI", Float64),
    ("BI", Float64),
    ("GJ", Float64),
    ("BJ", Float64),
    ("ST", Int64),
    ("MET", Int64),
    ("LEN", Float64),
    ("O1", Int64),
    ("F1", Float64),
    ("O2", Int64),
    ("F2", Float64),
    ("O3", Int64),
    ("F3", Float64),
    ("O4", Int64),
    ("F4", Float64),
]

const _branch_dtypes_v35 = vcat(
    _branch_dtypes[1:6],
    [
        ("NAME", String),
        ("RATE1", Float64),
        ("RATE2", Float64),
        ("RATE3", Float64),
        ("RATE4", Float64),
        ("RATE5", Float64),
        ("RATE6", Float64),
        ("RATE7", Float64),
        ("RATE8", Float64),
        ("RATE9", Float64),
        ("RATE10", Float64),
        ("RATE11", Float64),
        ("RATE12", Float64),
    ],
    _branch_dtypes[10:end],
)

const _switching_dtypes_v35 = [
    ("I", Int64),
    ("J", Int64),
    ("CKT", String),
    ("X", Float64),
    ("RATE1", Float64),
    ("RATE2", Float64),
    ("RATE3", Float64),
    ("RATE4", Float64),
    ("RATE5", Float64),
    ("RATE6", Float64),
    ("RATE7", Float64),
    ("RATE8", Float64),
    ("RATE9", Float64),
    ("RATE10", Float64),
    ("RATE11", Float64),
    ("RATE12", Float64),
    ("STAT", Int64),
    ("NSTAT", Int64),
    ("MET", Int64),
    ("STYPE", Int64),
    ("NAME", String),
]

const _transformer_dtypes = [
    ("I", Int64),
    ("J", Int64),
    ("K", Int64),
    ("CKT", String),
    ("CW", Int64),
    ("CZ", Int64),
    ("CM", Int64),
    ("MAG1", Float64),
    ("MAG2", Float64),
    ("NMETR", Int64),
    ("NAME", String),
    ("STAT", Int64),
    ("O1", Int64),
    ("F1", Float64),
    ("O2", Int64),
    ("F2", Float64),
    ("O3", Int64),
    ("F3", Float64),
    ("O4", Int64),
    ("F4", Float64),
    ("VECGRP", String),
]

const _transformer_dtypes_v35 = _transformer_dtypes

const _transformer_3_1_dtypes = [
    ("R1-2", Float64),
    ("X1-2", Float64),
    ("SBASE1-2", Float64),
    ("R2-3", Float64),
    ("X2-3", Float64),
    ("SBASE2-3", Float64),
    ("R3-1", Float64),
    ("X3-1", Float64),
    ("SBASE3-1", Float64),
    ("VMSTAR", Float64),
    ("ANSTAR", Float64),
]

const _transformer_3_1_dtypes_v35 = _transformer_3_1_dtypes

const _transformer_3_2_dtypes = [
    ("WINDV1", Float64),
    ("NOMV1", Float64),
    ("ANG1", Float64),
    ("RATA1", Float64),
    ("RATB1", Float64),
    ("RATC1", Float64),
    ("COD1", Int64),
    ("CONT1", Int64),
    ("RMA1", Float64),
    ("RMI1", Float64),
    ("VMA1", Float64),
    ("VMI1", Float64),
    ("NTP1", Float64),
    ("TAB1", Int64),
    ("CR1", Float64),
    ("CX1", Float64),
    ("CNXA1", Float64),
]

const _transformer_3_2_dtypes_v35 = vcat(
    _transformer_3_2_dtypes[1:3],
    [
        ("RATE11", Float64),
        ("RATE12", Float64),
        ("RATE13", Float64),
        ("RATE14", Float64),
        ("RATE15", Float64),
        ("RATE16", Float64),
        ("RATE17", Float64),
        ("RATE18", Float64),
        ("RATE19", Float64),
        ("RATE110", Float64),
        ("RATE111", Float64),
        ("RATE112", Float64),
    ],
    _transformer_3_2_dtypes[7:8],
    [("NOD1", Int64)],
    _transformer_3_2_dtypes[9:end],
)

const _transformer_3_3_dtypes = [
    ("WINDV2", Float64),
    ("NOMV2", Float64),
    ("ANG2", Float64),
    ("RATA2", Float64),
    ("RATB2", Float64),
    ("RATC2", Float64),
    ("COD2", Int64),
    ("CONT2", Int64),
    ("RMA2", Float64),
    ("RMI2", Float64),
    ("VMA2", Float64),
    ("VMI2", Float64),
    ("NTP2", Float64),
    ("TAB2", Int64),
    ("CR2", Float64),
    ("CX2", Float64),
    ("CNXA2", Float64),
]

const _transformer_3_3_dtypes_v35 = vcat(
    _transformer_3_3_dtypes[1:3],
    [
        ("RATE21", Float64),
        ("RATE22", Float64),
        ("RATE23", Float64),
        ("RATE24", Float64),
        ("RATE25", Float64),
        ("RATE26", Float64),
        ("RATE27", Float64),
        ("RATE28", Float64),
        ("RATE29", Float64),
        ("RATE210", Float64),
        ("RATE211", Float64),
        ("RATE212", Float64),
    ],
    _transformer_3_3_dtypes[7:8],
    [("NOD2", Int64)],
    _transformer_3_3_dtypes[9:end],
)

const _transformer_3_4_dtypes = [
    ("WINDV3", Float64),
    ("NOMV3", Float64),
    ("ANG3", Float64),
    ("RATA3", Float64),
    ("RATB3", Float64),
    ("RATC3", Float64),
    ("COD3", Int64),
    ("CONT3", Int64),
    ("RMA3", Float64),
    ("RMI3", Float64),
    ("VMA3", Float64),
    ("VMI3", Float64),
    ("NTP3", Float64),
    ("TAB3", Int64),
    ("CR3", Float64),
    ("CX3", Float64),
    ("CNXA3", Float64),
]

const _transformer_3_4_dtypes_v35 = vcat(
    _transformer_3_4_dtypes[1:3],
    [
        ("RATE31", Float64),
        ("RATE32", Float64),
        ("RATE33", Float64),
        ("RATE34", Float64),
        ("RATE35", Float64),
        ("RATE36", Float64),
        ("RATE37", Float64),
        ("RATE38", Float64),
        ("RATE39", Float64),
        ("RATE310", Float64),
        ("RATE311", Float64),
        ("RATE312", Float64),
    ],
    _transformer_3_4_dtypes[7:8],
    [("NOD3", Int64)],
    _transformer_3_4_dtypes[9:end],
)

const _transformer_2_1_dtypes =
    [("R1-2", Float64), ("X1-2", Float64), ("SBASE1-2", Float64)]

const _transformer_2_1_dtypes_v35 = _transformer_2_1_dtypes

const _transformer_2_2_dtypes = [
    ("WINDV1", Float64),
    ("NOMV1", Float64),
    ("ANG1", Float64),
    ("RATA1", Float64),
    ("RATB1", Float64),
    ("RATC1", Float64),
    ("COD1", Int64),
    ("CONT1", Int64),
    ("RMA1", Float64),
    ("RMI1", Float64),
    ("VMA1", Float64),
    ("VMI1", Float64),
    ("NTP1", Float64),
    ("TAB1", Int64),
    ("CR1", Float64),
    ("CX1", Float64),
    ("CNXA1", Float64),
]

const _transformer_2_2_dtypes_v35 = vcat(
    _transformer_2_2_dtypes[1:3],
    [
        ("RATE11", Float64),
        ("RATE12", Float64),
        ("RATE13", Float64),
        ("RATE14", Float64),
        ("RATE15", Float64),
        ("RATE16", Float64),
        ("RATE17", Float64),
        ("RATE18", Float64),
        ("RATE19", Float64),
        ("RATE110", Float64),
        ("RATE111", Float64),
        ("RATE112", Float64),
    ],
    _transformer_2_2_dtypes[7:8],
    [("NOD1", Int64)],
    _transformer_2_2_dtypes[9:end],
)

const _transformer_2_3_dtypes = [("WINDV2", Float64), ("NOMV2", Float64)]

const _transformer_2_3_dtypes_v35 = _transformer_2_3_dtypes

const _area_interchange_dtypes =
    [("I", Int64), ("ISW", Int64), ("PDES", Float64), ("PTOL", Float64), ("ARNAME", String)]

const _area_interchange_dtypes_v35 = _area_interchange_dtypes

const _two_terminal_line_dtypes = [
    ("NAME", String),
    ("MDC", Int64),
    ("RDC", Float64),
    ("SETVL", Float64),
    ("VSCHD", Float64),
    ("VCMOD", Float64),
    ("RCOMP", Float64),
    ("DELTI", Float64),
    ("METER", String),
    ("DCVMIN", Float64),
    ("CCCITMX", Int64),
    ("CCCACC", Float64),
    ("IPR", Int64),
    ("NBR", Int64),
    ("ANMXR", Float64),
    ("ANMNR", Float64),
    ("RCR", Float64),
    ("XCR", Float64),
    ("EBASR", Float64),
    ("TRR", Float64),
    ("TAPR", Float64),
    ("TMXR", Float64),
    ("TMNR", Float64),
    ("STPR", Float64),
    ("ICR", Int64),
    ("IFR", Int64),
    ("ITR", Int64),
    ("IDR", String),
    ("XCAPR", Float64),
    ("IPI", Int64),
    ("NBI", Int64),
    ("ANMXI", Float64),
    ("ANMNI", Float64),
    ("RCI", Float64),
    ("XCI", Float64),
    ("EBASI", Float64),
    ("TRI", Float64),
    ("TAPI", Float64),
    ("TMXI", Float64),
    ("TMNI", Float64),
    ("STPI", Float64),
    ("ICI", Int64),
    ("IFI", Int64),
    ("ITI", Int64),
    ("IDI", String),
    ("XCAPI", Float64),
]

const _two_terminal_line_dtypes_v35 = vcat(
    _two_terminal_line_dtypes[1:25],
    [("NDR", Int64)],
    _two_terminal_line_dtypes[26:42],
    [("NDI", Int64)],
    _two_terminal_line_dtypes[43:end],
)

const _vsc_line_dtypes = [
    ("NAME", String),
    ("MDC", Int64),
    ("RDC", Float64),
    ("O1", Int64),
    ("F1", Float64),
    ("O2", Int64),
    ("F2", Float64),
    ("O3", Int64),
    ("F3", Float64),
    ("O4", Int64),
    ("F4", Float64),
]

const _vsc_line_dtypes_35 = _vsc_line_dtypes

const _vsc_subline_dtypes = [
    ("IBUS", Int64),
    ("TYPE", Int64),
    ("MODE", Int64),
    ("DCSET", Float64),
    ("ACSET", Float64),
    ("ALOSS", Float64),
    ("BLOSS", Float64),
    ("MINLOSS", Float64),
    ("SMAX", Float64),
    ("IMAX", Float64),
    ("PWF", Float64),
    ("MAXQ", Float64),
    ("MINQ", Float64),
    ("REMOT", Int64),
    ("RMPCT", Float64),
]

const _vsc_subline_dtypes_v35 = _vsc_subline_dtypes

const _impedance_correction_dtypes = [
    ("I", Int64),
    ("T1", Float64),
    ("F1", Float64),
    ("T2", Float64),
    ("F2", Float64),
    ("T3", Float64),
    ("F3", Float64),
    ("T4", Float64),
    ("F4", Float64),
    ("T5", Float64),
    ("F5", Float64),
    ("T6", Float64),
    ("F6", Float64),
    ("T7", Float64),
    ("F7", Float64),
    ("T8", Float64),
    ("F8", Float64),
    ("T9", Float64),
    ("F9", Float64),
    ("T10", Float64),
    ("F10", Float64),
    ("T11", Float64),
    ("F11", Float64),
]

const _impedance_correction_dtypes_v35 = [
    ("I", Int64),
    ("T1", Float64), ("Re(F1)", Float64), ("Im(F1)", Float64),
    ("T2", Float64), ("Re(F2)", Float64), ("Im(F2)", Float64),
    ("T3", Float64), ("Re(F3)", Float64), ("Im(F3)", Float64),
    ("T4", Float64), ("Re(F4)", Float64), ("Im(F4)", Float64),
    ("T5", Float64), ("Re(F5)", Float64), ("Im(F5)", Float64),
    ("T6", Float64), ("Re(F6)", Float64), ("Im(F6)", Float64),
    ("T7", Float64), ("Re(F7)", Float64), ("Im(F7)", Float64),
    ("T8", Float64), ("Re(F8)", Float64), ("Im(F8)", Float64),
    ("T9", Float64), ("Re(F9)", Float64), ("Im(F9)", Float64),
    ("T10", Float64), ("Re(F10)", Float64), ("Im(F10)", Float64),
    ("T11", Float64), ("Re(F11)", Float64), ("Im(F11)", Float64),
    ("T12", Float64), ("Re(F12)", Float64), ("Im(F12)", Float64),
]

const _multi_term_main_dtypes = [
    ("NAME", String),
    ("NCONV", Int64),
    ("NDCBS", Int64),
    ("NDCLN", Int64),
    ("MDC", Int64),
    ("VCONV", Int64),
    ("VCMOD", Float64),
    ("VCONVN", Float64),
]

const _multi_term_main_dtypes_v35 = _multi_term_main_dtypes

const _multi_term_nconv_dtypes = [
    ("IB", Int64),
    ("N", Int64),
    ("ANGMX", Float64),
    ("ANGMN", Float64),
    ("RC", Float64),
    ("XC", Float64),
    ("EBAS", Float64),
    ("TR", Float64),
    ("TAP", Float64),
    ("TPMX", Float64),
    ("TPMN", Float64),
    ("TSTP", Float64),
    ("SETVL", Float64),
    ("DCPF", Float64),
    ("MARG", Float64),
    ("CNVCOD", Int64),
]

const _multi_term_nconv_dtypes_v35 = _multi_term_nconv_dtypes

const _multi_term_ndcbs_dtypes = [
    ("IDC", Int64),
    ("IB", Int64),
    ("AREA", Int64),
    ("ZONE", Int64),
    ("DCNAME", String),
    ("IDC2", Int64),
    ("RGRND", Float64),
    ("OWNER", Int64),
]

const _multi_term_ndcbs_dtypes_v35 = _multi_term_ndcbs_dtypes

const _multi_term_ndcln_dtypes = [
    ("IDC", Int64),
    ("JDC", Int64),
    ("DCCKT", String),
    ("MET", Int64),
    ("RDC", Float64),
    ("LDC", Float64),
]

const _multi_term_ndcln_dtypes_v35 = _multi_term_ndcln_dtypes

const _multi_section_dtypes = [
    ("I", Int64),
    ("J", Int64),
    ("ID", String),
    ("MET", Int64),
    ("DUM1", Int64),
    ("DUM2", Int64),
    ("DUM3", Int64),
    ("DUM4", Int64),
    ("DUM5", Int64),
    ("DUM6", Int64),
    ("DUM7", Int64),
    ("DUM8", Int64),
    ("DUM9", Int64),
]

const _multi_section_dtypes_v35 = _multi_section_dtypes

const _zone_dtypes = [("I", Int64), ("ZONAME", String)]

const _zone_dtypes_v35 = _zone_dtypes

const _interarea_dtypes =
    [("ARFROM", Int64), ("ARTO", Int64), ("TRID", String), ("PTRAN", Float64)]

const _interarea_dtypes_v35 = _interarea_dtypes

const _owner_dtypes = [("I", Int64), ("OWNAME", String)]

const _owner_dtypes_v35 = _owner_dtypes

const _FACTS_dtypes = [
    ("NAME", String),
    ("I", Int64),
    ("J", Int64),
    ("MODE", Int64),
    ("PDES", Float64),
    ("QDES", Float64),
    ("VSET", Float64),
    ("SHMX", Float64),
    ("TRMX", Float64),
    ("VTMN", Float64),
    ("VTMX", Float64),
    ("VSMX", Float64),
    ("IMX", Float64),
    ("LINX", Float64),
    ("RMPCT", Float64),
    ("OWNER", Int64),
    ("SET1", Float64),
    ("SET2", Float64),
    ("VSREF", Int64),
    ("REMOT", Int64),
    ("MNAME", String),
]

const _FACTS_dtypes_v35 = vcat(
    _FACTS_dtypes[1:19],
    [
        ("FCREG", Int64),
        ("NREG", Int64),
        ("MNAME", String),
    ],
)

const _switched_shunt_dtypes = [
    ("I", Int64),
    ("MODSW", Int64),
    ("ADJM", Int64),
    ("STAT", Int64),
    ("VSWHI", Float64),
    ("VSWLO", Float64),
    ("SWREM", Int64),
    ("RMPCT", Float64),
    ("RMIDNT", String),
    ("BINIT", Float64),
    ("N1", Int64),
    ("B1", Float64),
    ("N2", Int64),
    ("B2", Float64),
    ("N3", Int64),
    ("B3", Float64),
    ("N4", Int64),
    ("B4", Float64),
    ("N5", Int64),
    ("B5", Float64),
    ("N6", Int64),
    ("B6", Float64),
    ("N7", Int64),
    ("B7", Float64),
    ("N8", Int64),
    ("B8", Float64),
]

const _switched_shunt_dtypes_v35 = vcat(
    _switched_shunt_dtypes[1],
    [("ID", String)],
    _switched_shunt_dtypes[2:7],
    [
        ("NREG", Int64),
        ("RMPCT", Float64),
        ("RMIDNT", String),
        ("BINIT", Float64),
        ("S1", Int64), ("N1", Int64), ("B1", Float64),
        ("S2", Int64), ("N2", Int64), ("B2", Float64),
        ("S3", Int64), ("N3", Int64), ("B3", Float64),
        ("S4", Int64), ("N4", Int64), ("B4", Float64),
        ("S5", Int64), ("N5", Int64), ("B5", Float64),
        ("S6", Int64), ("N6", Int64), ("B6", Float64),
        ("S7", Int64), ("N7", Int64), ("B7", Float64),
        ("S8", Int64), ("N8", Int64), ("B8", Float64),
    ],
)

# TODO: Account for multiple lines in GNE Device entries
const _gne_device_dtypes = [
    ("NAME", String),
    ("MODEL", String),
    ("NTERM", Int64),
    ("BUSi", Int64),
    ("NREAL", Int64),
    ("NINTG", Int64),
    ("NCHAR", Int64),
    ("STATUS", Int64),
    ("OWNER", Int64),
    ("NMETR", Int64),
    ("REALi", Float64),
    ("INTGi", Int64),
    ("CHARi", String),
]

const _gne_device_dtypes_v35 = _gne_device_dtypes

const _induction_machine_dtypes = [
    ("I", Int64),
    ("ID", String),
    ("STAT", Int64),
    ("SCODE", Int64),
    ("DCODE", Int64),
    ("AREA", Int64),
    ("ZONE", Int64),
    ("OWNER", Int64),
    ("TCODE", Int64),
    ("BCODE", Int64),
    ("MBASE", Float64),
    ("RATEKV", Float64),
    ("PCODE", Int64),
    ("PSET", Float64),
    ("H", Float64),
    ("A", Float64),
    ("B", Float64),
    ("D", Float64),
    ("E", Float64),
    ("RA", Float64),
    ("XA", Float64),
    ("XM", Float64),
    ("R1", Float64),
    ("X1", Float64),
    ("R2", Float64),
    ("X2", Float64),
    ("X3", Float64),
    ("E1", Float64),
    ("SE1", Float64),
    ("E2", Float64),
    ("SE2", Float64),
    ("IA1", Float64),
    ("IA2", Float64),
    ("XAMULT", Float64),
]

const _induction_machine_dtypes_v35 = _induction_machine_dtypes

const _substation_dtypes_v35 = [
    ("IS", Int64),
    ("NAME", String),
    ("LATITUDE", Float64),
    ("LONGITUDE", Float64),
    ("SGR", Float64),
]

"""
lookup array of data types for PTI file sections given by
`field_name`, as enumerated by PSS/E Program Operation Manual.
"""
const _pti_dtypes = Dict{String, Array}(
    "BUS" => _bus_dtypes,
    "LOAD" => _load_dtypes,
    "FIXED SHUNT" => _fixed_shunt_dtypes,
    "GENERATOR" => _generator_dtypes,
    "BRANCH" => _branch_dtypes,
    "TRANSFORMER" => _transformer_dtypes,
    "TRANSFORMER TWO-WINDING LINE 1" => _transformer_2_1_dtypes,
    "TRANSFORMER TWO-WINDING LINE 2" => _transformer_2_2_dtypes,
    "TRANSFORMER TWO-WINDING LINE 3" => _transformer_2_3_dtypes,
    "TRANSFORMER THREE-WINDING LINE 1" => _transformer_3_1_dtypes,
    "TRANSFORMER THREE-WINDING LINE 2" => _transformer_3_2_dtypes,
    "TRANSFORMER THREE-WINDING LINE 3" => _transformer_3_3_dtypes,
    "TRANSFORMER THREE-WINDING LINE 4" => _transformer_3_4_dtypes,
    "AREA INTERCHANGE" => _area_interchange_dtypes,
    "TWO-TERMINAL DC" => _two_terminal_line_dtypes,
    "VOLTAGE SOURCE CONVERTER" => _vsc_line_dtypes,
    "VOLTAGE SOURCE CONVERTER SUBLINES" => _vsc_subline_dtypes,
    "IMPEDANCE CORRECTION" => _impedance_correction_dtypes,
    "MULTI-TERMINAL DC" => _multi_term_main_dtypes,
    "MULTI-TERMINAL DC NCONV" => _multi_term_nconv_dtypes,
    "MULTI-TERMINAL DC NDCBS" => _multi_term_ndcbs_dtypes,
    "MULTI-TERMINAL DC NDCLN" => _multi_term_ndcln_dtypes,
    "MULTI-SECTION LINE" => _multi_section_dtypes,
    "ZONE" => _zone_dtypes,
    "INTER-AREA TRANSFER" => _interarea_dtypes,
    "OWNER" => _owner_dtypes,
    "FACTS CONTROL DEVICE" => _FACTS_dtypes,
    "SWITCHED SHUNT" => _switched_shunt_dtypes,
    "CASE IDENTIFICATION" => _transaction_dtypes,
    "GNE DEVICE" => _gne_device_dtypes,
    "INDUCTION MACHINE" => _induction_machine_dtypes,
)

const _pti_dtypes_v35 = Dict{String, Array}(
    "BUS" => _bus_dtypes_v35,
    "LOAD" => _load_dtypes_v35,
    "FIXED SHUNT" => _fixed_shunt_dtypes_v35,
    "GENERATOR" => _generator_dtypes_v35,
    "BRANCH" => _branch_dtypes_v35,
    "SWITCHING DEVICE" => _switching_dtypes_v35,
    "TRANSFORMER" => _transformer_dtypes_v35,
    "TRANSFORMER TWO-WINDING LINE 1" => _transformer_2_1_dtypes_v35,
    "TRANSFORMER TWO-WINDING LINE 2" => _transformer_2_2_dtypes_v35,
    "TRANSFORMER TWO-WINDING LINE 3" => _transformer_2_3_dtypes_v35,
    "TRANSFORMER THREE-WINDING LINE 1" => _transformer_3_1_dtypes_v35,
    "TRANSFORMER THREE-WINDING LINE 2" => _transformer_3_2_dtypes_v35,
    "TRANSFORMER THREE-WINDING LINE 3" => _transformer_3_3_dtypes_v35,
    "TRANSFORMER THREE-WINDING LINE 4" => _transformer_3_4_dtypes_v35,
    "AREA INTERCHANGE" => _area_interchange_dtypes_v35,
    "TWO-TERMINAL DC" => _two_terminal_line_dtypes_v35,
    "VOLTAGE SOURCE CONVERTER" => _vsc_line_dtypes_35,
    "VOLTAGE SOURCE CONVERTER SUBLINES" => _vsc_subline_dtypes_v35,
    "IMPEDANCE CORRECTION" => _impedance_correction_dtypes_v35,
    "MULTI-TERMINAL DC" => _multi_term_main_dtypes_v35,
    "MULTI-TERMINAL DC NCONV" => _multi_term_nconv_dtypes_v35,
    "MULTI-TERMINAL DC NDCBS" => _multi_term_ndcbs_dtypes_v35,
    "MULTI-TERMINAL DC NDCLN" => _multi_term_ndcln_dtypes_v35,
    "MULTI-SECTION LINE" => _multi_section_dtypes_v35,
    "ZONE" => _zone_dtypes_v35,
    "INTER-AREA TRANSFER" => _interarea_dtypes_v35,
    "OWNER" => _owner_dtypes_v35,
    "FACTS CONTROL DEVICE" => _FACTS_dtypes_v35,
    "SWITCHED SHUNT" => _switched_shunt_dtypes_v35,
    "CASE IDENTIFICATION" => _transaction_dtypes_v35,
    "GNE DEVICE" => _gne_device_dtypes_v35,
    "INDUCTION MACHINE" => _induction_machine_dtypes_v35,
    "SUBSTATION DATA" => _substation_dtypes_v35,
)

const _default_case_identification = Dict(
    "IC" => 0,
    "SBASE" => 100.0,
    "REV" => 33,
    "XFRRAT" => 0,
    "NXFRAT" => 0,
    "BASFRQ" => 60,
)

const _default_case_identification_v35 = Dict(
    "IC" => 0,
    "SBASE" => 100.0,
    "REV" => 35,
    "XFRRAT" => 0,
    "NXFRAT" => 0,
    "BASFRQ" => 60,
)

const _default_bus = Dict(
    "BASKV" => 0.0,
    "IDE" => 1,
    "AREA" => 1,
    "ZONE" => 1,
    "OWNER" => 1,
    "VM" => 1.0,
    "VA" => 0.0,
    "NVHI" => 1.1,
    "NVLO" => 0.9,
    "EVHI" => 1.1,
    "EVLO" => 0.9,
    "NAME" => "            ",
)

const _default_bus_v35 = _default_bus

const _default_load = Dict(
    "ID" => "1",
    "STATUS" => 1,
    "PL" => 0.0,
    "QL" => 0.0,
    "IP" => 0.0,
    "IQ" => 0.0,
    "YP" => 0.0,
    "YQ" => 0.0,
    "SCALE" => 1,
    "INTRPT" => 0,
    "AREA" => nothing,
    "ZONE" => nothing,
    "OWNER" => nothing,
)

const _default_load_v35 = merge(
    _default_load,
    Dict(
        "DGENP" => 0.0,
        "DGENQ" => 0.0,
        "DGENM" => 0.0,
        "LOADTYPE" => nothing,
    ),
)

const _default_fixed_shunt = Dict("ID" => "1", "STATUS" => 1, "GL" => 0.0, "BL" => 0.0)

const _default_fixed_shunt_v35 = _default_fixed_shunt

const _default_generator = Dict(
    "ID" => "1",
    "PG" => 0.0,
    "QG" => 0.0,
    "QT" => 9999.0,
    "QB" => -9999.0,
    "VS" => 1.0,
    "IREG" => 0,
    "MBASE" => nothing,
    "ZR" => 0.0,
    "ZX" => 1.0,
    "RT" => 0.0,
    "XT" => 0.0,
    "GTAP" => 1.0,
    "STAT" => 1,
    "RMPCT" => 100.0,
    "PT" => 9999.0,
    "PB" => -9999.0,
    "O1" => nothing,
    "O2" => 0,
    "O3" => 0,
    "O4" => 0,
    "F1" => 1.0,
    "F2" => 1.0,
    "F3" => 1.0,
    "F4" => 1.0,
    "WMOD" => 0,
    "WPF" => 1.0,
)

const _default_generator_v35 = merge(_default_generator, Dict(
    "NREG" => 0,
    "BASLOD" => 0,
))

const _default_branch = Dict(
    "CKT" => "1",
    "B" => 0.0,
    "RATEA" => 0.0,
    "RATEB" => 0.0,
    "RATEC" => 0.0,
    "GI" => 0.0,
    "BI" => 0.0,
    "GJ" => 0.0,
    "BJ" => 0.0,
    "ST" => 1,
    "MET" => 1,
    "LEN" => 0.0,
    "O1" => nothing,
    "O2" => 0,
    "O3" => 0,
    "O4" => 0,
    "F1" => 1.0,
    "F2" => 1.0,
    "F3" => 1.0,
    "F4" => 1.0,
)

const _default_branch_v35 = merge(
    _default_branch,
    Dict(
        "RATE1" => 0.0,
        "RATE2" => 0.0,
        "RATE3" => 0.0,
        "RATE4" => 0.0,
        "RATE5" => 0.0,
        "RATE6" => 0.0,
        "RATE7" => 0.0,
        "RATE8" => 0.0,
        "RATE9" => 0.0,
        "RATE10" => 0.0,
        "RATE11" => 0.0,
        "RATE12" => 0.0,
    ),
)

const _default_switching_device_v35 = Dict(
    "CKT" => "1",
    "RATE1" => 0.0,
    "RATE2" => 0.0,
    "RATE3" => 0.0,
    "RATE4" => 0.0,
    "RATE5" => 0.0,
    "RATE6" => 0.0,
    "RATE7" => 0.0,
    "RATE8" => 0.0,
    "RATE9" => 0.0,
    "RATE10" => 0.0,
    "RATE11" => 0.0,
    "RATE12" => 0.0,
    "STAT" => 1,
    "NSTAT" => 1,
    "MET" => 0.0,
    "STYPE" => 0.0,
    "NAME" => "",
)

const _default_transformer = Dict(
    "K" => 0,
    "CKT" => "1",
    "CW" => 1,
    "CZ" => 1,
    "CM" => 1,
    "MAG1" => 0.0,
    "MAG2" => 0.0,
    "NMETR" => 2,
    "NAME" => "            ",
    "STAT" => 1,
    "O1" => nothing,
    "O2" => 0,
    "O3" => 0,
    "O4" => 0,
    "F1" => 1.0,
    "F2" => 1.0,
    "F3" => 1.0,
    "F4" => 1.0,
    "VECGRP" => "            ",
    "R1-2" => 0.0,
    "SBASE1-2" => nothing,
    "R2-3" => 0.0,
    "SBASE2-3" => nothing,
    "R3-1" => 0.0,
    "SBASE3-1" => nothing,
    "VMSTAR" => 1.0,
    "ANSTAR" => 0.0,
    "WINDV1" => nothing,
    "NOMV1" => 0.0,
    "ANG1" => 0.0,
    "RATA1" => 0.0,
    "RATB1" => 0.0,
    "RATC1" => 0.0,
    "COD1" => 0,
    "CONT1" => 0,
    "RMA1" => 1.1,
    "RMI1" => 0.9,
    "VMA1" => 1.1,
    "VMI1" => 0.9,
    "NTP1" => 33,
    "TAB1" => 0,
    "CR1" => 0.0,
    "CX1" => 0.0,
    "CNXA1" => 0.0,
    "WINDV2" => nothing,
    "NOMV2" => 0.0,
    "ANG2" => 0.0,
    "RATA2" => 0.0,
    "RATB2" => 0.0,
    "RATC2" => 0.0,
    "COD2" => 0,
    "CONT2" => 0,
    "RMA2" => 1.1,
    "RMI2" => 0.9,
    "VMA2" => 1.1,
    "VMI2" => 0.9,
    "NTP2" => 33,
    "TAB2" => 0,
    "CR2" => 0.0,
    "CX2" => 0.0,
    "CNXA2" => 0.0,
    "WINDV3" => nothing,
    "NOMV3" => 0.0,
    "ANG3" => 0.0,
    "RATA3" => 0.0,
    "RATB3" => 0.0,
    "RATC3" => 0.0,
    "COD3" => 0,
    "CONT3" => 0,
    "RMA3" => 1.1,
    "RMI3" => 0.9,
    "VMA3" => 1.1,
    "VMI3" => 0.9,
    "NTP3" => 33,
    "TAB3" => 0,
    "CR3" => 0.0,
    "CX3" => 0.0,
    "CNXA3" => 0.0,
)

const _default_transformer_v35 = merge(
    _default_transformer,
    Dict(
        "NOD1" => 0,
        "NOD2" => 0,
        "NOD3" => 0,
    ),
)

const _default_area_interchange =
    Dict("ISW" => 0, "PDES" => 0.0, "PTOL" => 10.0, "ARNAME" => "            ")

const _default_area_interchange_v35 = _default_area_interchange

const _default_two_terminal_dc = Dict(
    "MDC" => 0,
    "VCMOD" => 0.0,
    "RCOMP" => 0.0,
    "DELTI" => 0.0,
    "METER" => "I",
    "DCVMIN" => 0.0,
    "CCCITMX" => 20,
    "CCCACC" => 1.0,
    "TRR" => 1.0,
    "TAPR" => 1.0,
    "TMXR" => 1.5,
    "TMNR" => 0.51,
    "STPR" => 0.00625,
    "ICR" => 0,
    "IFR" => 0,
    "ITR" => 0,
    "IDR" => "1",
    "XCAPR" => 0.0,
    "TRI" => 1.0,
    "TAPI" => 1.0,
    "TMXI" => 1.5,
    "TMNI" => 0.51,
    "STPI" => 0.00625,
    "ICI" => 0,
    "IFI" => 0,
    "ITI" => 0,
    "IDI" => "1",
    "XCAPI" => 0.0,
)

const _default_two_terminal_dc_v35 = merge(_default_two_terminal_dc, Dict(
    "NDR" => 0,
    "NDI" => 0,
))

const _default_vsc_dc = Dict(
    "MDC" => 1,
    "O1" => nothing,
    "O2" => 0,
    "O3" => 0,
    "O4" => 0,
    "F1" => 1.0,
    "F2" => 1.0,
    "F3" => 1.0,
    "F4" => 1.0,
    "CONVERTER BUSES" => Dict(
        "MODE" => 1,
        "ACSET" => 1.0,
        "ALOSS" => 1.0,
        "BLOSS" => 0.0,
        "MINLOSS" => 0.0,
        "SMAX" => 0.0,
        "IMAX" => 0.0,
        "PWF" => 1.0,
        "MAXQ" => 9999.0,
        "MINQ" => -9999.0,
        "REMOT" => 0,
        "RMPCT" => 100.0,
    ),
)

const _default_vsc_dc_v35 = _default_vsc_dc

const _default_impedance_correction = Dict(
    "T1" => 0.0,
    "T2" => 0.0,
    "T3" => 0.0,
    "T4" => 0.0,
    "T5" => 0.0,
    "T6" => 0.0,
    "T7" => 0.0,
    "T8" => 0.0,
    "T9" => 0.0,
    "T10" => 0.0,
    "T11" => 0.0,
    "F1" => 0.0,
    "F2" => 0.0,
    "F3" => 0.0,
    "F4" => 0.0,
    "F5" => 0.0,
    "F6" => 0.0,
    "F7" => 0.0,
    "F8" => 0.0,
    "F9" => 0.0,
    "F10" => 0.0,
    "F11" => 0.0,
)

const _default_impedance_correction_v35 = Dict(
    "T1" => 0.0, "Re(F1)" => 0.0, "Im(F1)" => 0.0,
    "T2" => 0.0, "Re(F2)" => 0.0, "Im(F2)" => 0.0,
    "T3" => 0.0, "Re(F3)" => 0.0, "Im(F3)" => 0.0,
    "T4" => 0.0, "Re(F4)" => 0.0, "Im(F4)" => 0.0,
    "T5" => 0.0, "Re(F5)" => 0.0, "Im(F5)" => 0.0,
    "T6" => 0.0, "Re(F6)" => 0.0, "Im(F6)" => 0.0,
    "T7" => 0.0, "Re(F7)" => 0.0, "Im(F7)" => 0.0,
    "T8" => 0.0, "Re(F8)" => 0.0, "Im(F8)" => 0.0,
    "T9" => 0.0, "Re(F9)" => 0.0, "Im(F9)" => 0.0,
    "T10" => 0.0, "Re(F10)" => 0.0, "Im(F10)" => 0.0,
    "T11" => 0.0, "Re(F11)" => 0.0, "Im(F11)" => 0.0,
    "T12" => 0.0, "Re(F12)" => 0.0, "Im(F12)" => 0.0,
)

const _default_multi_term_dc = Dict(
    "MDC" => 0,
    "VCMOD" => 0.0,
    "VCONVN" => 0,
    "CONV" => Dict(
        "TR" => 1.0,
        "TAP" => 1.0,
        "TPMX" => 1.5,
        "TPMN" => 0.51,
        "TSTP" => 0.00625,
        "DCPF" => 1,
        "MARG" => 0.0,
        "CNVCOD" => 1,
    ),
    "DCBS" => Dict(
        "IB" => 0.0,
        "AREA" => 1,
        "ZONE" => 1,
        "DCNAME" => "            ",
        "IDC2" => 0,
        "RGRND" => 0.0,
        "OWNER" => 1,
    ),
    "DCLN" => Dict("DCCKT" => 1, "MET" => 1, "LDC" => 0.0),
)

const _default_multi_term_dc_v35 = _default_multi_term_dc

const _default_multi_section = Dict("ID" => "&1", "MET" => 1)

const _default_multi_section_v35 = _default_multi_section

const _default_zone = Dict("ZONAME" => "            ")

const _default_zone_v35 = _default_zone

const _default_interarea = Dict("TRID" => 1, "PTRAN" => 0.0)

const _default_interarea_v35 = _default_interarea

const _default_owner = Dict("OWNAME" => "            ")

const _default_owner_v35 = _default_owner

const _default_facts = Dict(
    "J" => 0,
    "MODE" => 1,
    "PDES" => 0.0,
    "QDES" => 0.0,
    "VSET" => 1.0,
    "SHMX" => 9999.0,
    "TRMX" => 9999.0,
    "VTMN" => 0.9,
    "VTMX" => 1.1,
    "VSMX" => 1.0,
    "IMX" => 0.0,
    "LINX" => 0.05,
    "RMPCT" => 100.0,
    "OWNER" => 1,
    "SET1" => 0.0,
    "SET2" => 0.0,
    "VSREF" => 0,
    "REMOT" => 0,
    "MNAME" => "",
)

const _default_facts_v35 = merge(
    Dict(k => v for (k, v) in pairs(_default_facts) if k != "REMOT"),
    Dict(
        "FCREG" => 0,  # Replaces REMOT in v35
        "NREG" => 0,
    ),
)

const _default_switched_shunt = Dict(
    "MODSW" => 1,
    "ADJM" => 0,
    "STAT" => 1,
    "VSWHI" => 1.0,
    "VSWLO" => 1.0,
    "SWREM" => 0,
    "RMPCT" => 100.0,
    "RMIDNT" => "",
    "BINIT" => 0.0,
    "S1" => 1, "N1" => 0, "B1" => 0.0,
    "S2" => 1, "N2" => 0, "B2" => 0.0,
    "S3" => 1, "N3" => 0, "B3" => 0.0,
    "S4" => 1, "N4" => 0, "B4" => 0.0,
    "S5" => 1, "N5" => 0, "B5" => 0.0,
    "S6" => 1, "N6" => 0, "B6" => 0.0,
    "S7" => 1, "N7" => 0, "B7" => 0.0,
    "S8" => 1, "N8" => 0, "B8" => 0.0,
)

const _default_switched_shunt_v35 = merge(
    Dict(k => v for (k, v) in pairs(_default_switched_shunt) if k != "SWREM"),
    Dict(
        "SWREG" => 0,
        "ID" => "1",
        "NAME" => "",
    ),
)

const _default_gne_device = Dict(
    "NTERM" => 1,
    "NREAL" => 0,
    "NINTG" => 0,
    "NCHAR" => 0,
    "STATUS" => 1,
    "OWNER" => nothing,
    "NMETR" => nothing,
    "REAL" => 0,
    "INTG" => nothing,
    "CHAR" => "1",
)

const _default_gne_device_v35 = _default_gne_device

const _default_induction_machine = Dict(
    "ID" => 1,
    "STAT" => 1,
    "SCODE" => 1,
    "DCODE" => 2,
    "AREA" => nothing,
    "ZONE" => nothing,
    "OWNER" => nothing,
    "TCODE" => 1,
    "BCODE" => 1,
    "MBASE" => nothing,
    "RATEKV" => 0.0,
    "PCODE" => 1,
    "H" => 1.0,
    "A" => 1.0,
    "B" => 1.0,
    "D" => 1.0,
    "E" => 1.0,
    "RA" => 0.0,
    "XA" => 0.0,
    "XM" => 2.5,
    "R1" => 999.0,
    "X1" => 999.0,
    "R2" => 999.0,
    "X2" => 999.0,
    "X3" => 0.0,
    "E1" => 1.0,
    "SE1" => 0.0,
    "E2" => 1.2,
    "SE2" => 0.0,
    "IA1" => 0.0,
    "IA2" => 0.0,
    "XAMULT" => 1,
)

const _default_induction_machine_v35 = _default_induction_machine

const _default_substation_data_v35 = Dict(
    "NAME" => "",
    "LATI" => 0.0,
    "LONG" => 0.0,
    "SGR" => 0.1,
)

const _pti_defaults = Dict(
    "BUS" => _default_bus,
    "LOAD" => _default_load,
    "FIXED SHUNT" => _default_fixed_shunt,
    "GENERATOR" => _default_generator,
    "BRANCH" => _default_branch,
    "TRANSFORMER" => _default_transformer,
    "AREA INTERCHANGE" => _default_area_interchange,
    "TWO-TERMINAL DC" => _default_two_terminal_dc,
    "VOLTAGE SOURCE CONVERTER" => _default_vsc_dc,
    "IMPEDANCE CORRECTION" => _default_impedance_correction,
    "MULTI-TERMINAL DC" => _default_multi_term_dc,
    "MULTI-SECTION LINE" => _default_multi_section,
    "ZONE" => _default_zone,
    "INTER-AREA TRANSFER" => _default_interarea,
    "OWNER" => _default_owner,
    "FACTS CONTROL DEVICE" => _default_facts,
    "SWITCHED SHUNT" => _default_switched_shunt,
    "CASE IDENTIFICATION" => _default_case_identification,
    "GNE DEVICE" => _default_gne_device,
    "INDUCTION MACHINE" => _default_induction_machine,
)

const _pti_defaults_v35 = Dict(
    "BUS" => _default_bus,
    "LOAD" => _default_load,
    "FIXED SHUNT" => _default_fixed_shunt,
    "GENERATOR" => _default_generator,
    "BRANCH" => _default_branch,
    "SWITCHING DEVICE" => _default_switching_device_v35,
    "TRANSFORMER" => _default_transformer,
    "AREA INTERCHANGE" => _default_area_interchange,
    "TWO-TERMINAL DC" => _default_two_terminal_dc,
    "VOLTAGE SOURCE CONVERTER" => _default_vsc_dc,
    "IMPEDANCE CORRECTION" => _default_impedance_correction,
    "MULTI-TERMINAL DC" => _default_multi_term_dc,
    "MULTI-SECTION LINE" => _default_multi_section,
    "ZONE" => _default_zone,
    "INTER-AREA TRANSFER" => _default_interarea,
    "OWNER" => _default_owner,
    "FACTS CONTROL DEVICE" => _default_facts,
    "SWITCHED SHUNT" => _default_switched_shunt,
    "CASE IDENTIFICATION" => _default_case_identification,
    "GNE DEVICE" => _default_gne_device,
    "INDUCTION MACHINE" => _default_induction_machine,
    "SUBSTATION DATA" => _default_substation_data_v35,
)

function _correct_nothing_values!(data::Dict)
    if !haskey(data, "BUS")
        return
    end

    sbase = data["CASE IDENTIFICATION"][1]["SBASE"]
    bus_lookup = Dict(bus["I"] => bus for bus in data["BUS"])

    if haskey(data, "LOAD")
        for load in data["LOAD"]
            load_bus = bus_lookup[load["I"]]
            if load["AREA"] === nothing
                load["AREA"] = load_bus["AREA"]
            end
            if load["ZONE"] === nothing
                load["ZONE"] = load_bus["ZONE"]
            end
            if load["OWNER"] === nothing
                load["OWNER"] = load_bus["OWNER"]
            end
        end
    end

    if haskey(data, "GENERATOR")
        for gen in data["GENERATOR"]
            gen_bus = bus_lookup[gen["I"]]
            if haskey(gen, "OWNER") && gen["OWNER"] === nothing
                gen["OWNER"] = gen_bus["OWNER"]
            end
            if gen["MBASE"] === nothing
                gen["MBASE"] = sbase
            end
        end
    end

    if haskey(data, "BRANCH")
        for branch in data["BRANCH"]
            branch_bus = bus_lookup[branch["I"]]
            if haskey(branch, "OWNER") && branch["OWNER"] === nothing
                branch["OWNER"] = branch_bus["OWNER"]
            end
        end
    end

    if haskey(data, "TRANSFORMER")
        for transformer in data["TRANSFORMER"]
            transformer_bus = bus_lookup[transformer["I"]]
            for base_id in ["SBASE1-2", "SBASE2-3", "SBASE3-1"]
                if haskey(transformer, base_id) && transformer[base_id] === nothing
                    transformer[base_id] = sbase
                end
            end
            for winding_id in ["WINDV1", "WINDV2", "WINDV3"]
                if haskey(transformer, winding_id) && transformer[winding_id] === nothing
                    if transformer["CW"] == 2
                        transformer[winding_id] = transformer_bus["BASKV"]
                    else
                        transformer[winding_id] = 1.0
                    end
                end
            end
        end
    end

    #=
    # TODO update this default value
    if haskey(data, "VOLTAGE SOURCE CONVERTER")
        for mdc in data["VOLTAGE SOURCE CONVERTER"]
            mdc["O1"] = Expr(:call, :_get_component_property, data["BUS"], "OWNER", "I", get(get(component, "CONVERTER BUSES", [Dict()])[1], "IBUS", 0))
        end
    end
    =#

    if haskey(data, "GNE DEVICE")
        for gne in data["GNE DEVICE"]
            gne_bus = bus_lookup[gne["I"]]
            if haskey(gne, "OWNER") && gne["OWNER"] === nothing
                gne["OWNER"] = gne_bus["OWNER"]
            end
            if haskey(gne, "NMETR") && gne["NMETR"] === nothing
                gne["NMETR"] = gne_bus["NTERM"]
            end
        end
    end

    if haskey(data, "INDUCTION MACHINE")
        for indm in data["INDUCTION MACHINE"]
            indm_bus = bus_lookup[indm["I"]]
            if indm["AREA"] === nothing
                indm["AREA"] = indm_bus["AREA"]
            end
            if indm["ZONE"] === nothing
                indm["ZONE"] = indm_bus["ZONE"]
            end
            if indm["OWNER"] === nothing
                indm["OWNER"] = indm_bus["OWNER"]
            end
            if indm["MBASE"] === nothing
                indm["MBASE"] = sbase
            end
        end
    end
end

"""
This is an experimental method for parsing elements and setting defaults at the same time.
It is not currently working but would reduce memory allocations if implemented correctly.
"""
function _parse_elements(
    elements::Array,
    dtypes::Array,
    defaults::Dict,
    section::AbstractString,
)
    data = Dict{String, Any}()

    if length(elements) > length(dtypes)
        @warn(
            "ignoring $(length(elements) - length(dtypes)) extra values in section $section, only $(length(dtypes)) items are defined"
        )
        elements = elements[1:length(dtypes)]
    end

    for (i, element) in enumerate(elements)
        field, dtype = dtypes[i]

        element = strip(element)

        if dtype == String
            if startswith(element, "'") && endswith(element, "'")
                data[field] = element[2:(end - 1)]
            else
                data[field] = element
            end
        else
            if length(element) <= 0
                # this will be set to a default in the cleanup phase
                data[field] = nothing
            else
                try
                    data[field] = parse(dtype, element)
                catch message
                    if isa(message, Meta.ParseError)
                        data[field] = element
                    else
                        @error(
                            "value '$element' for $field in section $section is not of type $dtype."
                        )
                    end
                end
            end
        end
    end

    if length(elements) < length(dtypes)
        for (field, dtype) in dtypes[length(elements):end]
            data[field] = defaults[field]
            #=
            if length(missing_fields) > 0
                for field in missing_fields
                    data[field] = ""
                end
                missing_str = join(missing_fields, ", ")
                if !(section == "SWITCHED SHUNT" && startswith(missing_str, "N")) &&
                    !(section == "MULTI-SECTION LINE" && startswith(missing_str, "DUM")) &&
                    !(section == "IMPEDANCE CORRECTION" && startswith(missing_str, "T"))
                    @warn("The following fields in $section are missing: $missing_str")
                end
            end
            =#
        end
    end

    return data
end

"""
    _parse_line_element!(data, elements, section)

Internal function. Parses a single "line" of data elements from a PTI file, as
given by `elements` which is an array of the line, typically split at `,`.
Elements are parsed into data types given by `section` and saved into `data::Dict`.
"""
function _parse_line_element!(
    data::Dict,
    elements::Array,
    section::AbstractString,
    dtypes::Dict{String, Array},
)
    missing_fields = []
    for (i, (field, dtype)) in enumerate(dtypes[section])
        if i > length(elements)
            @debug "Have run out of elements in $section at $field" _group =
                IS.LOG_GROUP_PARSING
            push!(missing_fields, field)
            continue
        else
            element = strip(elements[i])
        end

        try
            if dtype != String && element != ""
                data[field] = parse(dtype, element)
            else
                if dtype == String && startswith(element, "'") && endswith(element, "'")
                    data[field] = chop(element[nextind(element, 1):end])
                else
                    data[field] = element
                end
            end
        catch message
            if isa(message, Meta.ParseError)
                data[field] = element
            else
                error(
                    "value '$element' for $field in section $section is not of type $dtype.",
                )
            end
        end
    end

    if length(missing_fields) > 0
        for field in missing_fields
            data[field] = ""
        end
        missing_str = join(missing_fields, ", ")
        if !(section == "SWITCHED SHUNT" && startswith(missing_str, "N")) &&
           !(section == "MULTI-SECTION LINE" && startswith(missing_str, "DUM")) &&
           !(section == "IMPEDANCE CORRECTION" && startswith(missing_str, "T"))
            @debug "The following fields in $section are missing: $missing_str"
        end
    end
end

const _comment_split = r"(?!\B[\'][^\']*)[\/](?![^\']*[\']\B)"
const _split_string = r",(?=(?:[^']*'[^']*')*[^']*$)"

"""
    _get_line_elements(line)

Internal function. Uses regular expressions to extract all separate data
elements from a line of a PTI file and populate them into an `Array{String}`.
Comments, typically indicated at the end of a line with a `'/'` character,
are also extracted separately, and `Array{Array{String}, String}` is returned.
"""
function _get_line_elements(line::AbstractString)
    if count(i -> (i == "'"), line) % 2 == 1
        throw(
            DataFormatError(
                "There are an uneven number of single-quotes in \"{line}\", the line cannot be parsed.",
            ),
        )
    end

    line_comment = split(line, _comment_split; limit = 2)
    line = strip(line_comment[1])
    comment = length(line_comment) > 1 ? strip(line_comment[2]) : ""

    elements = split(line, _split_string)

    return (elements, comment)
end

"""
Process substation data with elements and parse associated nodes
"""
function parse_substation_nodes!(
    section_data::Dict{String, Any},
    data_lines::Vector{String},
    start_line_index::Int,
)::Int
    """Parse nodes for a substation and return the updated line index"""
    section_data["NODES"] = []
    temp_line_index = start_line_index + 1

    # Look for "BEGIN SUBSTATION NODE DATA" comment
    while temp_line_index <= length(data_lines)
        temp_line = data_lines[temp_line_index]
        if contains(temp_line, "BEGIN SUBSTATION NODE DATA")
            temp_line_index += 1
            break
        end
        temp_line_index += 1
    end

    # Parse node data until we hit the end marker
    while temp_line_index <= length(data_lines)
        temp_line = data_lines[temp_line_index]

        if startswith(temp_line, "0 /") && (
            contains(temp_line, "END OF SUBSTATION NODE DATA") ||
            contains(temp_line, "SUBSTATION TERMINAL DATA")
        )
            return temp_line_index
        end

        if contains(temp_line, "BEGIN SUBSTATION DATA BLOCK")
            return temp_line_index - 1
        end

        if !startswith(temp_line, "@!") && !isempty(strip(temp_line))
            (check_elements, check_comment) = _get_line_elements(temp_line)
            if length(check_elements) == 5 &&
               tryparse(Int, strip(check_elements[1])) !== nothing &&
               occursin('\'', check_elements[2]) &&
               tryparse(Float64, strip(check_elements[3])) !== nothing &&
               tryparse(Float64, strip(check_elements[4])) !== nothing &&
               tryparse(Float64, strip(check_elements[5])) !== nothing
                return temp_line_index - 1
            end
        end

        if startswith(temp_line, "@!")
            temp_line_index += 1
            continue
        end

        if !isempty(strip(temp_line))
            (node_elements, node_comment) = _get_line_elements(temp_line)

            if length(node_elements) >= 4
                if length(node_elements) >= 3 &&
                   length(strip(node_elements[3])) == 3 &&
                   startswith(strip(node_elements[3]), "'") &&
                   endswith(strip(node_elements[3]), "'")
                    return temp_line_index - 1
                end
            end

            if length(node_elements) >= 4 && length(node_elements) <= 6
                node_data = Dict{String, Any}()
                node_data["NI"] = parse(Int, strip(node_elements[1]))

                name_string = strip(node_elements[2])
                if startswith(name_string, "'") && endswith(name_string, "'")
                    name_string = name_string[2:(end - 1)]  # Remove quotes
                end
                node_data["NAME"] = strip(name_string)

                i_value = strip(node_elements[3])
                if startswith(i_value, "'") && endswith(i_value, "'")
                    i_value = i_value[2:(end - 1)]  # Remove quotes
                end
                node_data["I"] = parse(Int, strip(i_value))

                node_data["STATUS"] = parse(Int, strip(node_elements[4]))
                if length(node_elements) >= 5 && !isempty(strip(node_elements[5]))
                    node_data["VM"] = parse(Float64, strip(node_elements[5]))
                end
                if length(node_elements) >= 6 && !isempty(strip(node_elements[6]))
                    node_data["VA"] = parse(Float64, strip(node_elements[6]))
                end
                push!(section_data["NODES"], node_data)
            elseif length(node_elements) > 6
                return temp_line_index - 1
            end
        end
        temp_line_index += 1
    end

    return temp_line_index
end

"""
Process substation data with elements and parse associated nodes
"""
function process_substation_data!(
    section_data,
    elements,
    section,
    current_dtypes,
    data_lines,
    line_index,
    pti_data,
)
    try
        _parse_line_element!(section_data, elements, section, current_dtypes)

        if haskey(section_data, "NAME")
            section_data["NAME"] = strip(section_data["NAME"])
        end

        # Parse nodes for this substation
        updated_line_index = parse_substation_nodes!(section_data, data_lines, line_index)

        if haskey(pti_data, section)
            push!(pti_data[section], section_data)
        else
            pti_data[section] = [section_data]
        end

        return updated_line_index
    catch message
        error("Parsing failed at line $line_index: $(sprint(showerror, message))")
    end
end

"""
    _parse_pti_data(data_string, sections)

Internal function. Parse a PTI raw file into a `Dict`, given the
`data_string` of the file and a list of the `sections` in the PTI
file (typically given by default by `get_pti_sections()`.
"""
function _parse_pti_data(data_io::IO)
    sections = deepcopy(_pti_sections)
    sections_v35 = deepcopy(_pti_sections_v35)
    data_lines = readlines(data_io)
    skip_lines = 0
    skip_sublines = 0
    subsection = ""
    is_v35 = false

    pti_data = Dict{String, Array{Dict}}()

    section = popfirst!(sections)
    section_v35 = popfirst!(sections_v35)
    section_data = Dict{String, Any}()

    if any(startswith.(data_lines, "@!"))
        is_v35 = true
    end

    header_line_start = is_v35 ? 2 : 1 # Start in second line due to @!
    # Dynamically handle the start of BUS DATA section
    # In v35 files, BUS DATA starts in different lines due to the fields GENERAL,GAUSS,NEWTON,ADJUST,TYSL,SOLVER,RATING
    # This fields are optional in the file and when not found, the start of the reading vary a lot
    bus_data_start = if is_v35
        found_start = 25  # Default of most files
        for i in 3:min(35, length(data_lines))
            line = strip(data_lines[i])

            # Skip comments and system-wide data
            if startswith(
                line,
                r"@!|GENERAL,|GAUSS,|NEWTON,|ADJUST,|TYSL,|SOLVER,|RATING,",
            ) || isempty(line)
                continue
            end

            # Look for section marker of BUS DATA
            if contains(line, "END OF SYSTEM-WIDE DATA") ||
               (
                tryparse(Int, split(line, ',')[1] |> strip) !== nothing &&
                contains(line, "'")
            )
                found_start = if contains(line, "END OF SYSTEM-WIDE DATA")
                    (i + (startswith(strip(data_lines[i + 1]), "@!") ? 2 : 1))
                else
                    i
                end
                break
            end
        end
        # New updated start section
        found_start
    else
        4 # Start for all v33 files
    end

    current_dtypes = is_v35 ? _pti_dtypes_v35 : _pti_dtypes

    line_index = 1
    while line_index <= length(data_lines)
        line = data_lines[line_index]

        if startswith(line, "@!")
            line_index += 1
            continue
        end

        (elements, comment) = _get_line_elements(line)

        first_element = strip(elements[1])

        if is_v35 && (line_index == 3 || line_index == 4) &&
           section_v35 == "CASE IDENTIFICATION"
            comment_line = strip(line)
            comment_key = line_index == 3 ? "Comment_Line_1" : "Comment_Line_2"

            if haskey(pti_data, "CASE IDENTIFICATION") &&
               !isempty(pti_data["CASE IDENTIFICATION"])
                pti_data["CASE IDENTIFICATION"][1][comment_key] = comment_line
                @debug "Added $comment_key: $comment_line" _group = IS.LOG_GROUP_PARSING
            end
            line_index += 1
            continue
        end

        if is_v35 && line_index >= 3 && line_index < bus_data_start
            line_index += 1
            continue
        end

        if line_index > (is_v35 ? bus_data_start - 1 : 3) && length(elements) != 0 &&
           first_element == "Q"
            break
        elseif line_index > (is_v35 ? bus_data_start - 1 : 3) && length(elements) != 0 &&
               first_element == "0"
            if line_index == bus_data_start
                section = is_v35 ? popfirst!(sections_v35) : popfirst!(sections)
            end

            if length(elements) > 1
                @info(
                    "At line $line_index, new section started with '0', but additional non-comment data is present. Pattern '^\\s*0\\s*[/]*.*' is reserved for section start/end.",
                )
            elseif length(comment) > 0
                @debug "At line $line_index, switched to $section" _group =
                    IS.LOG_GROUP_PARSING
            end

            current_sections = is_v35 ? sections_v35 : sections
            if !isempty(current_sections)
                section = popfirst!(current_sections)
            end

            line_index += 1
            continue
        else
            if line_index == bus_data_start
                section = is_v35 ? popfirst!(sections_v35) : popfirst!(sections)
                section_data = Dict{String, Any}()
            end

            if skip_lines > 0
                skip_lines -= 1
                line_index += 1
                continue
            end

            if section == "IMPEDANCE CORRECTION" && is_v35
                temporal_ic_elements = Vector{Vector{String}}()

                while line_index <= length(data_lines)
                    line = data_lines[line_index]

                    if startswith(line, "0 /") || startswith(line, "Q")
                        if !isempty(temporal_ic_elements)
                            last_entry_elements = temporal_ic_elements[end]

                            section_data_final = Dict{String, Any}()
                            section_data_final["I"] =
                                parse(Int64, strip(last_entry_elements[1]))

                            processing_elements = last_entry_elements[2:end]

                            point_index = 1
                            element_index = 1
                            while element_index <= length(processing_elements) &&
                                element_index + 2 <= length(processing_elements)
                                t_str = strip(processing_elements[element_index])
                                re_str = strip(processing_elements[element_index + 1])
                                im_str = strip(processing_elements[element_index + 2])

                                if !isempty(t_str) && !isempty(re_str) && !isempty(im_str)
                                    section_data_final["T$point_index"] =
                                        parse(Float64, t_str)
                                    section_data_final["Re(F$point_index)"] =
                                        parse(Float64, re_str)
                                    section_data_final["Im(F$point_index)"] =
                                        parse(Float64, im_str)
                                    point_index += 1
                                end
                                element_index += 3
                            end

                            if haskey(pti_data, section)
                                push!(pti_data[section], section_data_final)
                            else
                                pti_data[section] = [section_data_final]
                            end
                        end
                        break
                    end

                    if startswith(line, "@!")
                        line_index += 1
                        continue
                    end

                    if isempty(strip(line))
                        line_index += 1
                        continue
                    end

                    (elements, comment) = _get_line_elements(line)
                    first_element = strip(elements[1])

                    if tryparse(Int64, first_element) === nothing
                        line_index += 1
                        if !isempty(temporal_ic_elements)
                            append!(temporal_ic_elements[end], elements)
                        end
                        continue
                    end

                    if !isempty(temporal_ic_elements)
                        last_entry_elements = temporal_ic_elements[end]

                        section_data_prev = Dict{String, Any}()
                        section_data_prev["I"] = parse(Int64, strip(last_entry_elements[1]))

                        processing_elements = last_entry_elements[2:end]

                        point_index = 1
                        element_index = 1
                        while element_index <= length(processing_elements) &&
                            element_index + 2 <= length(processing_elements)
                            t_str = strip(processing_elements[element_index])
                            re_str = strip(processing_elements[element_index + 1])
                            im_str = strip(processing_elements[element_index + 2])

                            if !isempty(t_str) && !isempty(re_str) && !isempty(im_str)
                                section_data_prev["T$point_index"] = parse(Float64, t_str)
                                section_data_prev["Re(F$point_index)"] =
                                    parse(Float64, re_str)
                                section_data_prev["Im(F$point_index)"] =
                                    parse(Float64, im_str)
                                point_index += 1
                            end
                            element_index += 3
                        end

                        if haskey(pti_data, section)
                            push!(pti_data[section], section_data_prev)
                        else
                            pti_data[section] = [section_data_prev]
                        end
                    end

                    push!(temporal_ic_elements, elements)
                    line_index += 1
                end

            elseif !(
                section in [
                    "CASE IDENTIFICATION",
                    "SWITCHING DEVICE DATA",
                    "TRANSFORMER",
                    "VOLTAGE SOURCE CONVERTER",
                    "IMPEDANCE CORRECTION",
                    "MULTI-TERMINAL DC",
                    "TWO-TERMINAL DC",
                    "GNE DEVICE",
                    "SUBSTATION DATA",
                ]
            )
                section_data = Dict{String, Any}()

                try
                    _parse_line_element!(section_data, elements, section, current_dtypes)
                catch message
                    throw(
                        @error(
                            "Parsing failed at line $line_index: $(sprint(showerror, message))"
                        )
                    )
                end
                line_index += 1

            elseif section == "CASE IDENTIFICATION"
                if line_index == header_line_start
                    try
                        _parse_line_element!(
                            section_data,
                            elements,
                            section,
                            current_dtypes,
                        )
                    catch message
                        throw(
                            @error(
                                "Parsing failed at line $line_index: $(sprint(showerror, message))",
                            ),
                        )
                    end

                    if section_data["REV"] != "" && section_data["REV"] < 33
                        @info(
                            "Version $(section_data["REV"]) of PTI format is unsupported, parser may not function correctly.",
                        )
                    end

                    if is_v35
                        if haskey(pti_data, section)
                            push!(pti_data[section], section_data)
                        else
                            pti_data[section] = [section_data]
                        end
                    end
                else
                    if is_v35
                        if line_index == 3
                            comment_line = strip(line)
                            if haskey(pti_data, section) && !isempty(pti_data[section])
                                pti_data[section][1]["Comment_Line_1"] = comment_line
                            end
                        elseif line_index == 4
                            comment_line = strip(line)
                            if haskey(pti_data, section) && !isempty(pti_data[section])
                                pti_data[section][1]["Comment_Line_2"] = comment_line
                            end
                        end
                    elseif !is_v35 && line_index > header_line_start
                        section_data["Comment_Line_$(line_index - 1)"] = strip(line)
                    end
                end

                if line_index < (bus_data_start - 1)
                    line_index += 1
                    continue
                end

                line_index += 1

            elseif section == "SWITCHING DEVICE"
                if is_v35
                    section_data = Dict{String, Any}()
                    try
                        _parse_line_element!(
                            section_data,
                            elements,
                            section,
                            current_dtypes,
                        )
                    catch message
                        throw(
                            @error(
                                "Parsing failed at line $line_index: $(sprint(showerror, message))",
                            ),
                        )
                    end
                else
                    @info("SWITCHING DEVICE DATA section found in non-v35 file, skipping.")
                end
                line_index += 1

            elseif section == "TRANSFORMER"
                section_data = Dict{String, Any}()
                if parse(Int64, _get_line_elements(line)[1][3]) == 0 # two winding transformer
                    winding = "TWO-WINDING"
                    skip_lines = 3
                elseif parse(Int64, _get_line_elements(line)[1][3]) != 0 # three winding transformer
                    winding = "THREE-WINDING"
                    skip_lines = 4
                else
                    @error("Cannot detect type of Transformer")
                end

                try
                    for transformer_line in 0:4
                        if transformer_line == 0
                            temp_section = section
                        else
                            temp_section =
                                join([section, winding, "LINE", transformer_line], " ")
                        end

                        if winding == "TWO-WINDING" && transformer_line == 4
                            break
                        else
                            elements = _get_line_elements(
                                data_lines[line_index + transformer_line],
                            )[1]
                            _parse_line_element!(
                                section_data,
                                elements,
                                temp_section,
                                current_dtypes,
                            )
                        end
                    end
                catch message
                    throw(
                        @error(
                            "Parsing failed at line $line_index: $(sprint(showerror, message))",
                        ),
                    )
                end
                line_index += 1

            elseif section == "VOLTAGE SOURCE CONVERTER"
                vsc_line_length = length(_get_line_elements(line)[1])
                # VSC DC LINE DATA can have 5 or 11 elements in all cases possible
                # "CSC-VSC     ",1, 1.5800,  28,1.0000
                # "CSC-VSC     ",1, 1.5800,  28,1.0000,,,,,,
                # "CSC-VSC     ",1, 1.5800,  28,1.0000,1.0,0.0,1.0,0.0,1.0,0.0
                # This is how originally the parser was written
                if vsc_line_length == 5 || vsc_line_length == 11
                    section_data = Dict{String, Any}()
                    try
                        _parse_line_element!(
                            section_data,
                            elements,
                            section,
                            current_dtypes,
                        )
                    catch message
                        throw(
                            @error(
                                "Parsing failed at line $line_index: $(sprint(showerror, message))",
                            ),
                        )
                    end
                    skip_sublines = 2
                    line_index += 1
                    continue

                elseif skip_sublines > 0
                    skip_sublines -= 1
                    subsection_data = Dict{String, Any}()

                    for (field, dtype) in _pti_dtypes["$section SUBLINES"]
                        element = popfirst!(elements)
                        if element != ""
                            subsection_data[field] = parse(dtype, element)
                        else
                            line_index += 1
                            subsection_data[field] = ""
                        end
                    end

                    if haskey(section_data, "CONVERTER BUSES")
                        push!(section_data["CONVERTER BUSES"], subsection_data)
                    else
                        section_data["CONVERTER BUSES"] = [subsection_data]
                        line_index += 1
                        continue
                    end
                end
                line_index += 1

            elseif section == "TWO-TERMINAL DC"
                section_data = Dict{String, Any}()
                if length(_get_line_elements(line)[1]) == 12
                    (elements, comment) = _get_line_elements(
                        join(data_lines[line_index:(line_index + 2)], ','),
                    )
                    skip_lines = 2
                end

                try
                    _parse_line_element!(section_data, elements, section, current_dtypes)
                catch message
                    throw(
                        @error(
                            "Parsing failed at line $line_index: $(sprint(showerror, message))",
                        ),
                    )
                end
                line_index += 1

            elseif section == "IMPEDANCE CORRECTION" && !is_v35
                section_data = Dict{String, Any}()
                try
                    _parse_line_element!(section_data, elements, section, current_dtypes)
                catch message
                    throw(
                        @error(
                            "Parsing failed at line $line_index: $(sprint(showerror, message))",
                        ),
                    )
                end
                line_index += 1

            elseif section == "MULTI-TERMINAL DC"
                if skip_sublines == 0
                    section_data = Dict{String, Any}()
                    try
                        _parse_line_element!(
                            section_data,
                            elements,
                            section,
                            current_dtypes,
                        )
                    catch message
                        throw(
                            @error(
                                "Parsing failed at line $line_index: $(sprint(showerror, message))",
                            ),
                        )
                    end

                    if section_data["NCONV"] > 0
                        skip_sublines = section_data["NCONV"]
                        subsection = "NCONV"
                        line_index += 1
                        continue
                    elseif section_data["NDCBS"] > 0
                        skip_sublines = section_data["NDCBS"]
                        subsection = "NDCBS"
                        line_index += 1
                        continue
                    elseif section_data["NDCLN"] > 0
                        skip_sublines = section_data["NDCLN"]
                        subsection = "NDCLN"
                        line_index += 1
                        continue
                    end
                end

                if skip_sublines > 0
                    skip_sublines -= 1

                    subsection_data = Dict{String, Any}()
                    try
                        _parse_line_element!(
                            subsection_data,
                            elements,
                            "$section $subsection",
                            current_dtypes,
                        )
                    catch message
                        throw(
                            error(
                                "Parsing failed at line $line_index: $(sprint(showerror, message))",
                            ),
                        )
                    end

                    if haskey(section_data, "$(subsection[2:end])")
                        section_data["$(subsection[2:end])"] =
                            push!(section_data["$(subsection[2:end])"], subsection_data)
                        if skip_sublines > 0 && subsection != "NDCLN"
                            line_index += 1
                            continue
                        end
                    else
                        section_data["$(subsection[2:end])"] = [subsection_data]
                        if skip_sublines > 0 && subsection != "NDCLN"
                            line_index += 1
                            continue
                        end
                    end

                    if skip_sublines == 0 && subsection != "NDCLN"
                        if subsection == "NDCBS"
                            skip_sublines = section_data["NDCLN"]
                            subsection = "NDCLN"
                            line_index += 1
                            continue
                        elseif subsection == "NCONV"
                            skip_sublines = section_data["NDCBS"]
                            subsection = "NDCBS"
                            line_index += 1
                            continue
                        end
                    elseif skip_sublines == 0 && subsection == "NDCLN"
                        subsection = ""
                    else
                        line_index += 1
                        continue
                    end
                end
                line_index += 1

            elseif section == "SUBSTATION DATA" && is_v35
                if startswith(line, "@!")
                    line_index += 1
                    continue
                else
                    if length(elements) == 4 && occursin('\'', elements[1])
                        first_part = elements[1]
                        if occursin(",'", first_part)
                            comma_quote_pos = findfirst(",'", first_part)
                            if comma_quote_pos !== nothing
                                is_part = first_part[1:(comma_quote_pos[1] - 1)]
                                name_part = first_part[(comma_quote_pos[1] + 1):end]

                                corrected_elements = [
                                    is_part,
                                    name_part,
                                    elements[2],
                                    elements[3],
                                    elements[4],
                                ]

                                if length(corrected_elements) == 5 &&
                                   occursin('\'', corrected_elements[2]) &&
                                   tryparse(Float64, strip(corrected_elements[3])) !==
                                   nothing &&
                                   tryparse(Float64, strip(corrected_elements[4])) !==
                                   nothing &&
                                   tryparse(Float64, strip(corrected_elements[5])) !==
                                   nothing
                                    @debug "Parsing substation data line: $line" _group =
                                        IS.LOG_GROUP_PARSING
                                    section_data = Dict{String, Any}()
                                    line_index = process_substation_data!(
                                        section_data,
                                        corrected_elements,
                                        section,
                                        current_dtypes,
                                        data_lines,
                                        line_index,
                                        pti_data,
                                    )
                                end
                            end
                        end

                    elseif length(elements) == 5 &&
                           occursin('\'', elements[2]) &&
                           tryparse(Float64, strip(elements[3])) !== nothing &&
                           tryparse(Float64, strip(elements[4])) !== nothing &&
                           tryparse(Float64, strip(elements[5])) !== nothing
                        section_data = Dict{String, Any}()
                        line_index = process_substation_data!(
                            section_data,
                            elements,
                            section,
                            current_dtypes,
                            data_lines,
                            line_index,
                            pti_data,
                        )
                    end

                    line_index += 1
                    continue
                end
                line_index += 1

            elseif section == "GNE DEVICE"
                # TODO: handle multiple lines of GNE Device
                @info("GNE DEVICE parsing is not supported.")
                line_index += 1
            else
                line_index += 1
            end
        end
        if subsection != ""
            @debug "appending data" _group = IS.LOG_GROUP_PARSING
        end

        if haskey(pti_data, section)
            if section == "IMPEDANCE CORRECTION" &&
               pti_data["CASE IDENTIFICATION"][1]["REV"] == 35
                continue
            else
                push!(pti_data[section], section_data)
            end
        else
            pti_data[section] = [section_data]
        end
    end

    _split_breakers_and_branches!(pti_data)
    _populate_defaults!(pti_data)
    _correct_nothing_values!(pti_data)

    return pti_data
end

"""
    parse_pti(filename::String)

Open PTI raw file given by `filename`, returning a `Dict` of the data parsed
into the proper types.
"""
function parse_pti(filename::String)::Dict
    pti_data = open(filename) do f
        parse_pti(f)
    end

    return pti_data
end

"""
    parse_pti(io::IO)

Reads PTI data in `io::IO`, returning a `Dict` of the data parsed into the
proper types.
"""
function parse_pti(io::IO)::Dict
    pti_data = _parse_pti_data(io)
    try
        pti_data["CASE IDENTIFICATION"][1]["NAME"] = match(
            r"^\<file\s[\/\\]*(?:.*[\/\\])*(.*)\.raw\>$",
            lowercase(io.name),
        ).captures[1]
    catch
        throw(error("This file is unrecognized and cannot be parsed"))
    end

    return pti_data
end

function _split_breakers_and_branches!(data::Dict)
    breakers = sizehint!(eltype(data["BRANCH"])[], length(data["BRANCH"]))
    delete_ixs = Int[]
    for (ix, item) in enumerate(data["BRANCH"])
        if first(item["CKT"]) == '@' || first(item["CKT"]) == '*'
            push!(breakers, item)
            push!(delete_ixs, ix)
        end
    end
    if isempty(delete_ixs)
        @info "No breakers modeled as branches using @ or * found in the system."
        return data
    else
        @info "Found $(length(breakers)) breakers in the system modeled as branches."
    end
    deleteat!(data["BRANCH"], delete_ixs)
    data["SWITCHES_AS_BRANCHES"] = breakers
    return data
end

"""
    _populate_defaults!(pti_data)

Internal function. Populates empty fields with PSS(R)E PTI v33 default values
"""
function _populate_defaults!(data::Dict)
    for section in _pti_sections
        if haskey(data, section)
            component_defaults = _pti_defaults[section]
            for component in data[section]
                for (field, field_value) in component
                    if isa(field_value, Array)
                        sub_component_defaults = component_defaults[field]
                        for sub_component in field_value
                            for (sub_field, sub_field_value) in sub_component
                                if sub_field_value == ""
                                    try
                                        sub_component[sub_field] =
                                            sub_component_defaults[sub_field]
                                    catch msg
                                        if isa(msg, KeyError)
                                            @warn(
                                                "'$sub_field' in '$field' in '$section' has no default value",
                                            )
                                        else
                                            rethrow(msg)
                                        end
                                    end
                                end
                            end
                        end
                    elseif field_value == "" &&
                           !(field in ["Comment_Line_1", "Comment_Line_2"]) &&
                           !startswith(field, "DUM")
                        try
                            component[field] = component_defaults[field]
                        catch msg
                            if isa(msg, KeyError)
                                @warn("'$field' in '$section' has no default value",)
                            else
                                rethrow(msg)
                            end
                        end
                    end
                end
            end
        end
    end
end
