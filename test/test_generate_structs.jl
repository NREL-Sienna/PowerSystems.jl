# DISABLED pending a rewrite of `StructGeneration.test_generated_structs`.
#
# The helper it calls cannot do the job it claims. It pairs both the two directory listings
# and each file's lines with `zip`, which pairs by position and truncates to the shorter
# sequence. Three consequences: one extra file shifts every later comparison onto the wrong
# file; a file-count mismatch leaves the last file uncompared; and appended lines are never
# compared at all, so a generated file that gains content still passes.
#
# The replacement should assert that generated output matches BOTH sources of truth it is
# supposed to track — the struct definitions in the descriptor, and the field data in
# SiennaSchemas — pairing by filename and comparing whole contents, reporting missing and
# extra files rather than silently skipping them.
#
# @testset "Test generated structs" begin
#     descriptor_file =
#         joinpath(@__DIR__, "..", "src", "descriptors", "power_system_structs.json")
#     existing_dir = joinpath(@__DIR__, "..", "src", "models", "generated")
#     @test PowerSystems.StructGeneration.test_generated_structs(
#         descriptor_file, existing_dir,
#     )
# end

@testset "Test generated structs from StructDefinition" begin
    orig_descriptor_file =
        joinpath(@__DIR__, "..", "src", "descriptors", "power_system_structs.json")
    output_directory = mktempdir()
    descriptor_file = joinpath(output_directory, "power_system_structs.json")
    cp(orig_descriptor_file, descriptor_file)
    # This is necessary in cases where the package has been added through a GitHub branch
    # where all source files are read-only.
    chmod(descriptor_file, 0o644)
    new_struct = StructDefinition(;
        struct_name = "MyThermalStandard",
        docstring = "Custom ThermalStandard",
        supertype = "ThermalGen",
        is_component = true,
        fields = [
            StructField(; name = "name", data_type = String, comment = "name"),
            StructField(;
                name = "active_power",
                data_type = Float64,
                valid_range = "active_power_limits",
                validation_action = "warn",
                null_value = 0.0,
                comment = "active power",
                needs_conversion = true,
            ),
            StructField(;
                name = "active_power_limits",
                needs_conversion = true,
                data_type = "NamedTuple{(:min, :max), Tuple{Float64, Float64}}",
                null_value = "(min=0.0, max=0.0)",
            ),
            StructField(;
                name = "rating",
                data_type = Float64,
                valid_range = Dict("min" => 0.0, "max" => nothing),
                validation_action = "error",
                comment = "Thermal limited MVA Power Output of the unit. <= Capacity",
            ),
        ],
    )
    redirect_stdout(devnull) do
        generate_struct_file(
            new_struct;
            filename = descriptor_file,
            output_directory = output_directory,
        )
    end
    data = open(descriptor_file, "r") do io
        JSON.parse(io; dicttype = Dict{String, Any})
    end

    @test data["auto_generated_structs"][end]["struct_name"] == "MyThermalStandard"
    @test isfile(joinpath(output_directory, "MyThermalStandard.jl"))
end

@testset "OpenAPI converter codegen: absent openapi_type is untouched" begin
    # Hard invariant: a descriptor entry without `openapi_type` must never gain a converter,
    # even when another entry in the same generation call is annotated (proven below by
    # generating both together, not this struct alone).
    outdir = mktempdir()
    data = [
        Dict{String, Any}(
            "struct_name" => "OATestPlainBus",
            "supertype" => "InfrastructureSystemsComponent",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
            ],
        ),
        Dict{String, Any}(
            "struct_name" => "OATestPlainDevice",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestPlainDevice",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
                Dict{String, Any}("name" => "bus", "data_type" => "OATestPlainBus"),
            ],
        ),
    ]
    PowerSystems.StructGeneration.generate_structs(outdir, data; print_results = false)

    plain_bus = read(joinpath(outdir, "OATestPlainBus.jl"), String)
    @test !occursin("from_openapi", plain_bus)
    @test !occursin("_FROM_STRING", plain_bus)

    annotated = read(joinpath(outdir, "OATestPlainDevice.jl"), String)
    @test occursin("from_openapi", annotated)
end

@testset "OpenAPI converter codegen: annotated struct emits both Val methods" begin
    outdir = mktempdir()
    data = [
        Dict{String, Any}(
            "struct_name" => "OATestBus",
            "supertype" => "InfrastructureSystemsComponent",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
            ],
        ),
        Dict{String, Any}(
            "struct_name" => "OATestDevice",
            "docstring" => "Toy device exercising every OpenAPI converter field kind.",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestDevice",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
                Dict{String, Any}("name" => "bus", "data_type" => "OATestBus"),
                Dict{String, Any}(
                    "name" => "active_power",
                    "data_type" => "Float64",
                    "needs_conversion" => true,
                    "conversion_unit" => ":mva",
                ),
                Dict{String, Any}(
                    "name" => "rating_b",
                    "data_type" => "Union{Nothing, Float64}",
                    "needs_conversion" => true,
                    "conversion_unit" => ":mva",
                    "default" => "nothing",
                ),
                Dict{String, Any}("name" => "base_power", "data_type" => "Float64"),
                Dict{String, Any}("name" => "base_voltage", "data_type" => "Float64"),
                Dict{String, Any}(
                    "name" => "impedance_limits",
                    "data_type" => "MinMax",
                    "needs_conversion" => true,
                    "conversion_unit" => ":ohm",
                ),
                Dict{String, Any}(
                    "name" => "optional_limits",
                    "data_type" => "Union{Nothing, MinMax}",
                    "needs_conversion" => true,
                    "conversion_unit" => ":mva",
                    "default" => "nothing",
                ),
                Dict{String, Any}("name" => "status", "data_type" => "OATestStatus"),
                Dict{String, Any}(
                    "name" => "operation_cost",
                    "data_type" => "OperationalCost",
                ),
                Dict{String, Any}(
                    "name" => "ext",
                    "data_type" => "Dict{String, Any}",
                    "null_value" => "Dict{String, Any}()",
                    "default" => "Dict{String, Any}()",
                ),
                Dict{String, Any}(
                    "name" => "internal",
                    "data_type" => "InfrastructureSystemsInternal",
                    "internal_default" => "InfrastructureSystemsInternal()",
                ),
            ],
        ),
    ]
    PowerSystems.StructGeneration.generate_structs(outdir, data; print_results = false)
    gen = read(joinpath(outdir, "OATestDevice.jl"), String)

    # The generated code must parse as valid Julia syntax.
    @test Meta.parse("begin\n" * gen * "\nend") isa Expr

    device_start = findfirst("DeviceBaseUnit", gen)
    natural_start = findfirst("NaturalUnit", gen)
    @test !isnothing(device_start)
    @test !isnothing(natural_start)
    device_body = gen[first(device_start):(first(natural_start) - 1)]
    natural_body = gen[first(natural_start):end]

    # Enum table: emitted once, ahead of both methods, looked up (not `getproperty`).
    @test occursin(
        "const OA_TEST_STATUS_FROM_STRING = Dict{String, OATestStatus}(string(m) => m for m in instances(OATestStatus))",
        gen,
    )
    @test occursin("status = OA_TEST_STATUS_FROM_STRING[po.status],", device_body)
    @test occursin("status = OA_TEST_STATUS_FROM_STRING[po.status],", natural_body)

    # Reference: `resolve_ref(refs, po.<name>)`, identical in both methods. Not `refs[po.<name>]`
    # — a schema-optional reference the document omits arrives as `nothing`, and `refs[nothing]`
    # is a MethodError.
    @test occursin("bus = resolve_ref(refs, po.bus),", device_body)
    @test occursin("bus = resolve_ref(refs, po.bus),", natural_body)

    # Cost hook: identical in both methods.
    @test occursin("operation_cost = convert_cost(po.operation_cost),", device_body)
    @test occursin("operation_cost = convert_cost(po.operation_cost),", natural_body)

    # skip fields never appear as constructor kwargs inside either method.
    @test !occursin("ext =", device_body)
    @test !occursin("internal =", device_body)
    @test !occursin("ext =", natural_body)
    @test !occursin("internal =", natural_body)

    # Scalar POWER conversion: device-base is pass-through; natural-units divides by
    # the component's own base_power (S_base).
    @test occursin("active_power = po.active_power,", device_body)
    @test occursin("active_power = po.active_power / po.base_power,", natural_body)

    # Nullable scalar POWER conversion: device-base is still bare pass-through (no guard
    # needed — scalar field access on `nothing` is never attempted); natural-units guards
    # the division.
    @test occursin("rating_b = po.rating_b,", device_body)
    @test occursin(
        "rating_b = (if isnothing(po.rating_b); nothing; else; po.rating_b / po.base_power; end),",
        natural_body,
    )

    # Compound IMPEDANCE conversion: both methods member-rebuild (the PO type is never
    # PSY's NamedTuple alias); natural-units divides each member by Z_base = V_base^2/S_base.
    @test occursin(
        "impedance_limits = (min = po.impedance_limits.min, max = po.impedance_limits.max),",
        device_body,
    )
    @test occursin(
        "impedance_limits = (min = po.impedance_limits.min / (po.base_voltage^2 / po.base_power), max = po.impedance_limits.max / (po.base_voltage^2 / po.base_power)),",
        natural_body,
    )

    # Nullable compound POWER conversion: both methods need the nothing-guard (member
    # access on `nothing` fails regardless of unit system).
    @test occursin(
        "optional_limits = (if isnothing(po.optional_limits); nothing; else; (min = po.optional_limits.min, max = po.optional_limits.max); end),",
        device_body,
    )
    @test occursin(
        "optional_limits = (if isnothing(po.optional_limits); nothing; else; (min = po.optional_limits.min / po.base_power, max = po.optional_limits.max / po.base_power); end),",
        natural_body,
    )
end

@testset "OpenAPI converter codegen: openapi_unit pu override" begin
    # No base_power/base_voltage field on this struct at all — proving the override
    # skips S_base/Z_base resolution entirely rather than merely skipping the arithmetic
    # (a plain :none conversion would still be free of base fields, but a real :ohm/:mva
    # conversion_unit would normally demand them; see openapi_base_exprs).
    outdir = mktempdir()
    data = [
        Dict{String, Any}(
            "struct_name" => "OATestPuDevice",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestPuDevice",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
                Dict{String, Any}(
                    "name" => "r",
                    "data_type" => "Float64",
                    "needs_conversion" => true,
                    "conversion_unit" => ":ohm",
                    "openapi_unit" => "pu",
                ),
                Dict{String, Any}(
                    "name" => "impedance_limits",
                    "data_type" => "MinMax",
                    "needs_conversion" => true,
                    "conversion_unit" => ":siemens",
                    "openapi_unit" => "pu",
                ),
            ],
        ),
    ]
    PowerSystems.StructGeneration.generate_structs(outdir, data; print_results = false)
    gen = read(joinpath(outdir, "OATestPuDevice.jl"), String)
    @test Meta.parse("begin\n" * gen * "\nend") isa Expr

    device_start = findfirst("DeviceBaseUnit", gen)
    natural_start = findfirst("NaturalUnit", gen)
    device_body = gen[first(device_start):(first(natural_start) - 1)]
    natural_body = gen[first(natural_start):end]

    # Scalar pu-override: identity in both methods, no division by Z_base.
    @test occursin("r = po.r,", device_body)
    @test occursin("r = po.r,", natural_body)

    # Compound pu-override: still member-rebuilt (PO type isn't PSY's NamedTuple alias)
    # but never scaled.
    @test occursin(
        "impedance_limits = (min = po.impedance_limits.min, max = po.impedance_limits.max),",
        device_body,
    )
    @test occursin(
        "impedance_limits = (min = po.impedance_limits.min, max = po.impedance_limits.max),",
        natural_body,
    )

    # An unmapped openapi_unit value must error rather than be silently ignored.
    bad_value = [
        Dict{String, Any}(
            "struct_name" => "OATestBadUnitValue",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestBadUnitValue",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
                Dict{String, Any}(
                    "name" => "z",
                    "data_type" => "Float64",
                    "needs_conversion" => true,
                    "conversion_unit" => ":mva",
                    "openapi_unit" => "mva",
                ),
            ],
        ),
    ]
    @test_throws IS.DataFormatError PowerSystems.StructGeneration.generate_structs(
        mktempdir(),
        bad_value;
        print_results = false,
    )

    # openapi_unit on a struct without openapi_type is descriptor noise, not a no-op.
    orphan = [
        Dict{String, Any}(
            "struct_name" => "OATestOrphanUnit",
            "supertype" => "InfrastructureSystemsComponent",
            "fields" => [
                Dict{String, Any}("name" => "name", "data_type" => "String"),
                Dict{String, Any}(
                    "name" => "z",
                    "data_type" => "Float64",
                    "openapi_unit" => "pu",
                ),
            ],
        ),
    ]
    @test_throws IS.DataFormatError PowerSystems.StructGeneration.generate_structs(
        mktempdir(),
        orphan;
        print_results = false,
    )
end

@testset "OpenAPI converter codegen: generation-time errors, never partial output" begin
    base_fields = () -> [Dict{String, Any}("name" => "name", "data_type" => "String")]

    # An indeterminate field kind (not scalar/compound/reference/plausible-enum) must
    # error rather than silently guess.
    indeterminate = [
        Dict{String, Any}(
            "struct_name" => "OATestBadKind",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestBadKind",
            "fields" => vcat(
                base_fields(),
                [Dict{String, Any}("name" => "z", "data_type" => "Complex{Float64}")],
            ),
        ),
    ]
    @test_throws IS.DataFormatError PowerSystems.StructGeneration.generate_structs(
        mktempdir(),
        indeterminate;
        print_results = false,
    )

    # An unmapped conversion_unit on a needs_conversion field must error.
    bad_conversion_unit = [
        Dict{String, Any}(
            "struct_name" => "OATestBadConversionUnit",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestBadConversionUnit",
            "fields" => vcat(
                base_fields(),
                [
                    Dict{String, Any}(
                        "name" => "z",
                        "data_type" => "Float64",
                        "needs_conversion" => true,
                        "conversion_unit" => ":unknown_unit",
                    ),
                ],
            ),
        ),
    ]
    @test_throws IS.DataFormatError PowerSystems.StructGeneration.generate_structs(
        mktempdir(),
        bad_conversion_unit;
        print_results = false,
    )

    # An IMPEDANCE/ADMITTANCE conversion needs the struct's own base_voltage field to
    # resolve V_base; without it (and no reference-chain resolution implemented), error.
    missing_base_voltage = [
        Dict{String, Any}(
            "struct_name" => "OATestMissingVBase",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestMissingVBase",
            "fields" => vcat(
                base_fields(),
                [
                    Dict{String, Any}("name" => "base_power", "data_type" => "Float64"),
                    Dict{String, Any}(
                        "name" => "z",
                        "data_type" => "MinMax",
                        "needs_conversion" => true,
                        "conversion_unit" => ":ohm",
                    ),
                ],
            ),
        ),
    ]
    @test_throws IS.DataFormatError PowerSystems.StructGeneration.generate_structs(
        mktempdir(),
        missing_base_voltage;
        print_results = false,
    )

    # A parametric + openapi_type combination is out of scope for this generator pass
    # — refuse rather than emit a converter for the wrong (UnionAll) type.
    parametric_openapi = [
        Dict{String, Any}(
            "struct_name" => "OATestParametric",
            "supertype" => "InfrastructureSystemsComponent",
            "openapi_type" => "OATestParametric",
            "parametric" => "ReserveDirection",
            "fields" => base_fields(),
        ),
    ]
    @test_throws IS.DataFormatError PowerSystems.StructGeneration.generate_structs(
        mktempdir(),
        parametric_openapi;
        print_results = false,
    )
end
