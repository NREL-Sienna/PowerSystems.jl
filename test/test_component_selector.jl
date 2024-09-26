test_sys = PSB.build_system(PSB.PSITestSystems, "c_sys5_all_components")
gen_solitude = PSY.get_component(ThermalStandard, test_sys, "Solitude")::Component  # Error if `nothing`
gen_sundance = get_component(ThermalStandard, test_sys, "Sundance")::Component
set_available!(gen_sundance, false)
gen_wind = get_component(RenewableDispatch, test_sys, "WindBusA")::Component

test_sys2 = PSB.build_system(PSB.PSISystems, "5_bus_hydro_uc_sys")
gen_sundance2 = get_component(ThermalStandard, test_sys2, "Sundance")::Component
set_available!(gen_sundance2, false)

sort_name!(x) = sort!(collect(x); by = get_name)

@testset "Test helper functions" begin
    @test subtype_to_string(ThermalStandard) == "ThermalStandard"
    @test component_to_qualified_string(ThermalStandard, "Solitude") ==
          "ThermalStandard__Solitude"
    @test component_to_qualified_string(gen_solitude) == "ThermalStandard__Solitude"
end

@testset "Test NameComponentSelector" begin
    test_gen_ent = PSY.NameComponentSelector(ThermalStandard, "Solitude", nothing)
    named_test_gen_ent = PSY.NameComponentSelector(ThermalStandard, "Solitude", "SolGen")

    # Equality
    @test PSY.NameComponentSelector(ThermalStandard, "Solitude", nothing) == test_gen_ent
    @test PSY.NameComponentSelector(ThermalStandard, "Solitude", "SolGen") ==
          named_test_gen_ent

    # Construction
    @test make_selector(ThermalStandard, "Solitude") == test_gen_ent
    @test make_selector(ThermalStandard, "Solitude"; name = "SolGen") == named_test_gen_ent
    @test make_selector(gen_solitude) == test_gen_ent

    # Naming
    @test get_name(test_gen_ent) == "ThermalStandard__Solitude"
    @test get_name(named_test_gen_ent) == "SolGen"
    @test PSY.default_name(test_gen_ent) == "ThermalStandard__Solitude"

    # Contents
    @test collect(get_components(make_selector(NonexistentComponent, ""), test_sys)) ==
          Vector{Component}()
    the_components = collect(get_components(test_gen_ent, test_sys))
    @test length(the_components) == 1
    @test typeof(first(the_components)) == ThermalStandard
    @test get_name(first(the_components)) == "Solitude"
    @test collect(
        get_components(make_selector(gen_sundance), test_sys; filterby = get_available),
    ) ==
          Vector{Component}()

    @test only(get_groups(test_gen_ent, test_sys)) == test_gen_ent
end

@testset "Test ListComponentSelector" begin
    comp_ent_1 = make_selector(ThermalStandard, "Sundance")
    comp_ent_2 = make_selector(RenewableDispatch, "WindBusA")
    test_list_ent = PSY.ListComponentSelector((comp_ent_1, comp_ent_2), nothing)
    named_test_list_ent = PSY.ListComponentSelector((comp_ent_1, comp_ent_2), "TwoComps")

    # Equality
    @test PSY.ListComponentSelector((comp_ent_1, comp_ent_2), nothing) == test_list_ent
    @test PSY.ListComponentSelector((comp_ent_1, comp_ent_2), "TwoComps") ==
          named_test_list_ent

    # Construction
    @test make_selector(comp_ent_1, comp_ent_2;) == test_list_ent
    @test make_selector(comp_ent_1, comp_ent_2; name = "TwoComps") ==
          named_test_list_ent

    # Naming
    @test get_name(test_list_ent) ==
          "[ThermalStandard__Sundance, RenewableDispatch__WindBusA]"
    @test get_name(named_test_list_ent) == "TwoComps"

    # Contents
    @test collect(get_components(make_selector(), test_sys)) == Vector{Component}()
    the_components = collect(get_components(test_list_ent, test_sys))
    @test length(the_components) == 2

    @test collect(get_groups(make_selector(), test_sys)) ==
          Vector{ComponentSelector}()
    the_groups = collect(get_groups(test_list_ent, test_sys))
    @test length(the_groups) == 2
end

@testset "Test SubtypeComponentSelector" begin
    test_sub_ent = PSY.SubtypeComponentSelector(ThermalStandard, nothing, :all)
    named_test_sub_ent = PSY.SubtypeComponentSelector(ThermalStandard, "Thermals", :all)

    # Equality
    @test PSY.SubtypeComponentSelector(ThermalStandard, nothing, :all) == test_sub_ent
    @test PSY.SubtypeComponentSelector(ThermalStandard, "Thermals", :all) ==
          named_test_sub_ent

    # Construction
    @test make_selector(ThermalStandard) == test_sub_ent
    @test make_selector(ThermalStandard; name = "Thermals") == named_test_sub_ent
    @test make_selector(ThermalStandard; groupby = string) isa PSY.SubtypeComponentSelector

    # Naming
    @test get_name(test_sub_ent) == "ThermalStandard"
    @test get_name(named_test_sub_ent) == "Thermals"
    @test PSY.default_name(test_sub_ent) == "ThermalStandard"

    # Contents
    answer = sort_name!(get_components(ThermalStandard, test_sys))

    @test collect(get_components(make_selector(NonexistentComponent), test_sys)) ==
          Vector{Component}()
    the_components = sort_name!(get_components(test_sub_ent, test_sys))
    @test all(the_components .== answer)
    @test !(
        gen_sundance in
        collect(get_components(test_sub_ent, test_sys; filterby = get_available)))

    # Grouping inherits from `DynamicallyGroupedComponentSelector` and is tested elsewhere
end

@testset "Test TopologyComponentSelector" begin
    topo1 = get_component(Area, test_sys2, "1")
    topo2 = get_component(LoadZone, test_sys2, "2")
    @assert !isnothing(topo1) && !isnothing(topo2) "Relies on an out-of-date `5_bus_hydro_uc_sys` definition"
    test_topo_ent1 =
        PSY.TopologyComponentSelector(ThermalStandard, Area, "1", nothing, :all)
    test_topo_ent2 =
        PSY.TopologyComponentSelector(StaticInjection, LoadZone, "2", "Zone_2", :all)

    # Equality
    @test PSY.TopologyComponentSelector(ThermalStandard, Area, "1", nothing, :all) ==
          test_topo_ent1
    @test PSY.TopologyComponentSelector(StaticInjection, LoadZone, "2", "Zone_2", :all) ==
          test_topo_ent2

    # Construction
    @test make_selector(ThermalStandard, Area, "1") == test_topo_ent1
    @test make_selector(StaticInjection, LoadZone, "2"; name = "Zone_2") == test_topo_ent2
    @test make_selector(StaticInjection, LoadZone, "2"; groupby = string) isa
          PSY.TopologyComponentSelector

    # Naming
    @test get_name(test_topo_ent1) == "Area__1__ThermalStandard"
    @test get_name(test_topo_ent2) == "Zone_2"

    # Contents
    empty_topo_ent = make_selector(NonexistentComponent, Area, "1")
    @test collect(get_components(empty_topo_ent, test_sys2)) == Vector{Component}()

    nonexistent_topo_ent = make_selector(ThermalStandard, Area, "NonexistentArea")
    @test collect(get_components(nonexistent_topo_ent, test_sys2)) == Vector{Component}()

    answers =
        sort_name!.((
            get_components_in_aggregation_topology(
                ThermalStandard,
                test_sys2,
                get_component(Area, test_sys2, "1"),
            ),
            get_components_in_aggregation_topology(
                StaticInjection,
                test_sys2,
                get_component(LoadZone, test_sys2, "2"),
            )))
    for (ent, ans) in zip((test_topo_ent1, test_topo_ent2), answers)
        @assert length(ans) > 0 "Relies on an out-of-date `5_bus_hydro_uc_sys` definition"

        the_components = get_components(ent, test_sys2)
        @test all(sort_name!(the_components) .== ans)
        @test Set(collect(get_components(ent, test_sys2; filterby = x -> true))) ==
              Set(the_components)
        @test length(collect(get_components(ent, test_sys2; filterby = x -> false))) == 0
    end
end

@testset "Test FilterComponentSelector" begin
    starts_with_s(x) = lowercase(first(get_name(x))) == 's'
    test_filter_ent =
        PSY.FilterComponentSelector(ThermalStandard, starts_with_s, nothing, :all)
    named_test_filter_ent = PSY.FilterComponentSelector(
        ThermalStandard, starts_with_s, "ThermStartsWithS", :all)

    # Equality
    @test PSY.FilterComponentSelector(ThermalStandard, starts_with_s, nothing, :all) ==
          test_filter_ent
    @test PSY.FilterComponentSelector(
        ThermalStandard, starts_with_s, "ThermStartsWithS", :all) == named_test_filter_ent

    # Construction
    @test make_selector(ThermalStandard, starts_with_s) == test_filter_ent
    @test make_selector(ThermalStandard, starts_with_s; name = "ThermStartsWithS") ==
          named_test_filter_ent
    @test make_selector(ThermalStandard, starts_with_s; groupby = string) isa
          PSY.FilterComponentSelector

    # Naming
    @test get_name(test_filter_ent) == "starts_with_s__ThermalStandard"
    @test get_name(named_test_filter_ent) == "ThermStartsWithS"

    # Contents
    answer = filter(starts_with_s, collect(get_components(ThermalStandard, test_sys)))

    @test collect(
        get_components(make_selector(NonexistentComponent, x -> true), test_sys),
    ) ==
          Vector{Component}()
    @test collect(get_components(make_selector(Component, x -> false), test_sys)) ==
          Vector{Component}()
    @test all(collect(get_components(test_filter_ent, test_sys)) .== answer)
    @test !(
        gen_sundance in
        collect(get_components(test_filter_ent, test_sys; filterby = get_available)))

    @test !(
        gen_sundance in
        collect(get_components(test_filter_ent, test_sys; filterby = get_available)))
end

@testset "Test DynamicallyGroupedComponentSelector grouping" begin
    # We'll use TopologyComponentSelector as the token example
    @assert PSY.TopologyComponentSelector <: DynamicallyGroupedComponentSelector

    all_selector = make_selector(ThermalStandard, Area, "1"; groupby = :all)
    each_selector = make_selector(ThermalStandard, Area, "1"; groupby = :each)
    @test make_selector(ThermalStandard, Area, "1") == all_selector
    @test_throws ArgumentError make_selector(ThermalStandard, Area, "1"; groupby = :other)
    # @show get_name.(get_components(all_selector, test_sys2))
    partition_selector = make_selector(ThermalStandard, Area, "1";
        groupby = x -> occursin(" ", get_name(x)))

    @test only(get_groups(all_selector, test_sys2)) == all_selector
    @test Set(get_name.(get_groups(each_selector, test_sys2))) ==
          Set((
        component_to_qualified_string.(Ref(ThermalStandard),
            get_name.(get_components(each_selector, test_sys2)))
    ))
    @test length(
        collect(
            get_groups(each_selector, test_sys2;
                filterby = x -> length(get_name(x)) == 8),
        ),
    ) == 2
    @test Set(get_name.(get_groups(partition_selector, test_sys2))) ==
          Set(["true", "false"])
    @test length(
        collect(
            get_groups(partition_selector, test_sys2;
                filterby = x -> length(get_name(x)) == 8),
        ),
    ) == 1

    # Also test briefly with something from IS
    @assert PSY.SubtypeComponentSelector <: DynamicallyGroupedComponentSelector
    @test length(
        collect(
            get_groups(make_selector(ThermalStandard;
                    groupby = x -> length(get_name(x))), test_sys),
        ),
    ) == 3
end
