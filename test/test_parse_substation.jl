const V35_SUBSTATION_FIXTURE = joinpath(dirname(@__FILE__), "test_data", "v35_substation.raw")

@testset "PTI v35 substation section parsing" begin
    pti_data = PowerSystems._parse_pti_data(
        IOBuffer(read(V35_SUBSTATION_FIXTURE, String)),
    )

    @test haskey(pti_data, "SUBSTATION DATA")
    substations = pti_data["SUBSTATION DATA"]
    @test length(substations) == 2

    alpha = substations[1]
    @test alpha["IS"] == 1
    @test alpha["NAME"] == "ALPHA"
    @test alpha["LATITUDE"] == 34.61
    @test alpha["LONGITUDE"] == -86.67
    @test alpha["SGR"] == 0.25

    @testset "nodes" begin
        nodes = alpha["NODES"]
        @test length(nodes) == 3
        @test nodes[1]["NI"] == 1
        @test nodes[1]["NAME"] == "ALPHA\$138\$0001"
        @test nodes[1]["I"] == 1
        @test nodes[1]["STATUS"] == 1
        @test nodes[1]["VM"] == 1.01
        @test nodes[1]["VA"] == -11.0
        @test nodes[3]["STATUS"] == 0
        # node 3 omits VM/VA in the RAW; the parser leaves them unset (empty string) rather
        # than fabricating a flat 1.0/0.0 that would masquerade as a solved node voltage. When
        # absent, a node inherits its bus voltage downstream.
        @test nodes[3]["VM"] == ""
        @test nodes[3]["VA"] == ""
    end

    @testset "switching devices" begin
        devices = alpha["SWITCHING DEVICES"]
        @test length(devices) == 3
        breaker = devices[1]
        @test breaker["NI"] == 1
        @test breaker["NJ"] == 2
        @test breaker["CKT"] == "1"
        @test breaker["NAME"] == "ALPHA\$138\$CB\$0001"
        @test breaker["TYPE"] == 2
        @test breaker["STATUS"] == 1
        @test breaker["NSTAT"] == 1
        @test breaker["X"] == 0.0001
        @test breaker["RATE1"] == 100.0
        @test breaker["RATE2"] == 110.0
        @test breaker["RATE3"] == 120.0
        disconnect = devices[2]
        @test disconnect["TYPE"] == 3
        @test disconnect["STATUS"] == 0
        @test disconnect["NSTAT"] == 1
        generic = devices[3]
        @test generic["TYPE"] == 1
        @test generic["CKT"] == "2"
    end

    @testset "terminals" begin
        terminals = alpha["TERMINALS"]
        @test length(terminals) == 6
        load_terminal = terminals[1]
        @test load_terminal["I"] == 1
        @test load_terminal["NI"] == 1
        @test load_terminal["TYP"] == "L"
        @test load_terminal["ID"] == "1"
        @test iszero(load_terminal["J"])
        @test iszero(load_terminal["K"])
        branch_terminal = terminals[4]
        @test branch_terminal["TYP"] == "B"
        @test branch_terminal["J"] == 2
        @test iszero(branch_terminal["K"])
        @test branch_terminal["ID"] == "1"
        xf2_terminal = terminals[5]
        @test xf2_terminal["TYP"] == "2"
        @test xf2_terminal["J"] == 3
        @test xf2_terminal["ID"] == "T1"
        xf3_terminal = terminals[6]
        @test xf3_terminal["TYP"] == "3"
        @test xf3_terminal["J"] == 2
        @test xf3_terminal["K"] == 3
    end

    @testset "comment-free empty-sub-block substation" begin
        bravo = substations[2]
        @test bravo["IS"] == 2
        @test bravo["NAME"] == "BRAVO"
        @test length(bravo["NODES"]) == 1
        @test bravo["NODES"][1]["I"] == 2
        @test isempty(bravo["SWITCHING DEVICES"])
        @test isempty(bravo["TERMINALS"])
    end
end

@testset "PowerModels substation conversion" begin
    pm = PowerSystems.PowerModelsData(V35_SUBSTATION_FIXTURE)
    pm_data = pm.data

    @test haskey(pm_data, "substation")
    @test !haskey(pm_data, "substation_data")
    substations = pm_data["substation"]
    @test length(substations) == 2

    alpha = substations["1"]
    @test alpha["index"] == 1
    @test alpha["number"] == 1
    @test alpha["name"] == "ALPHA"
    @test alpha["latitude"] == 34.61
    @test alpha["longitude"] == -86.67
    @test alpha["grounding_resistance"] == 0.25
    @test alpha["source_id"] == ["substation", 1]

    @test length(alpha["nodes"]) == 3
    node1 = alpha["nodes"][1]
    @test node1["number"] == 1
    @test node1["name"] == "ALPHA\$138\$0001"
    @test node1["bus"] == 1
    @test node1["status"] == 1
    @test node1["vm"] == 1.01
    @test node1["va"] == -11.0
    # node 3 stored no voltage in the RAW -> the clean dict omits vm/va entirely, so it
    # inherits its bus voltage downstream instead of a fabricated flat value.
    @test !haskey(alpha["nodes"][3], "vm")
    @test !haskey(alpha["nodes"][3], "va")

    @test length(alpha["switching_devices"]) == 3
    breaker = alpha["switching_devices"][1]
    @test breaker["from_node"] == 1
    @test breaker["to_node"] == 2
    @test breaker["ckt"] == "1"
    @test breaker["name"] == "ALPHA\$138\$CB\$0001"
    @test breaker["device_type"] == 2
    @test breaker["status"] == 1
    @test breaker["normal_status"] == 1
    @test breaker["x"] == 0.0001
    @test breaker["rates"] == [100.0, 110.0, 120.0]

    @test length(alpha["terminals"]) == 6
    xf3_terminal = alpha["terminals"][6]
    @test xf3_terminal["bus"] == 1
    @test xf3_terminal["node"] == 3
    @test xf3_terminal["type"] == "3"
    @test xf3_terminal["secondary_bus"] == 2
    @test xf3_terminal["tertiary_bus"] == 3
    @test xf3_terminal["id"] == "3"
    load_terminal = alpha["terminals"][1]
    @test iszero(load_terminal["secondary_bus"])
    @test iszero(load_terminal["tertiary_bus"])

    bravo = substations["2"]
    @test bravo["number"] == 2
    @test isempty(bravo["switching_devices"])
    @test isempty(bravo["terminals"])

    @testset "no leakage into system-level switch/breaker tables" begin
        for table in ("switch", "breaker")
            if haskey(pm_data, table)
                @test isempty(pm_data[table])
            end
        end
    end

    @testset "import_all" begin
        pm_all = PowerSystems.PowerModelsData(V35_SUBSTATION_FIXTURE; import_all = true)
        subs_all = pm_all.data["substation"]
        @test length(subs_all) == 2
        @test subs_all["1"]["name"] == "ALPHA"
        @test length(subs_all["1"]["switching_devices"]) == 3
    end
end
