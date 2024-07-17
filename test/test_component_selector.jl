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

@testset "Test SingleComponentSelector" begin
    test_gen_ent = SingleComponentSelector(ThermalStandard, "Solitude", nothing)
    named_test_gen_ent = SingleComponentSelector(ThermalStandard, "Solitude", "SolGen")

    # Equality
    @test SingleComponentSelector(ThermalStandard, "Solitude", nothing) == test_gen_ent
    @test SingleComponentSelector(ThermalStandard, "Solitude", "SolGen") ==
          named_test_gen_ent

    # Construction
    @test select_components(ThermalStandard, "Solitude") == test_gen_ent
    @test select_components(ThermalStandard, "Solitude", "SolGen") == named_test_gen_ent
    @test select_components(gen_solitude) == test_gen_ent

    # Naming
    @test get_name(test_gen_ent) == "ThermalStandard__Solitude"
    @test get_name(named_test_gen_ent) == "SolGen"
    @test IS.default_name(test_gen_ent) == "ThermalStandard__Solitude"

    # Contents
    @test collect(get_components(select_components(NonexistentComponent, ""), test_sys)) ==
          Vector{Component}()
    the_components = collect(get_components(test_gen_ent, test_sys))
    @test length(the_components) == 1
    @test typeof(first(the_components)) == ThermalStandard
    @test get_name(first(the_components)) == "Solitude"
    @test collect(
        get_components(select_components(gen_sundance), test_sys; filterby = get_available),
    ) ==
          Vector{Component}()

    @test gen_solitude in test_gen_ent
    @test !(gen_sundance in test_gen_ent)
    @test !in(gen_sundance, select_components(gen_sundance); filterby = get_available)
end

@testset "Test ListComponentSelector" begin
    comp_ent_1 = select_components(ThermalStandard, "Sundance")
    comp_ent_2 = select_components(RenewableDispatch, "WindBusA")
    test_list_ent = ListComponentSelector((comp_ent_1, comp_ent_2), nothing)
    named_test_list_ent = ListComponentSelector((comp_ent_1, comp_ent_2), "TwoComps")

    # Equality
    @test ListComponentSelector((comp_ent_1, comp_ent_2), nothing) == test_list_ent
    @test ListComponentSelector((comp_ent_1, comp_ent_2), "TwoComps") ==
          named_test_list_ent

    # Construction
    @test select_components(comp_ent_1, comp_ent_2;) == test_list_ent
    @test select_components(comp_ent_1, comp_ent_2; name = "TwoComps") ==
          named_test_list_ent

    # Naming
    @test get_name(test_list_ent) ==
          "[ThermalStandard__Sundance, RenewableDispatch__WindBusA]"
    @test get_name(named_test_list_ent) == "TwoComps"

    # Contents
    @test collect(get_components(select_components(), test_sys)) == Vector{Component}()
    the_components = collect(get_components(test_list_ent, test_sys))
    @test length(the_components) == 2
    @test gen_sundance in the_components
    @test get_component(RenewableDispatch, test_sys, "WindBusA") in the_components
    @test !(
        gen_sundance in
        collect(get_components(test_list_ent, test_sys; filterby = get_available)))

    @test collect(get_subselectors(select_components(), test_sys)) ==
          Vector{ComponentSelector}()
    the_subselectors = collect(get_subselectors(test_list_ent, test_sys))
    @test length(the_subselectors) == 2
    @test comp_ent_1 in the_subselectors
    @test comp_ent_2 in the_subselectors

    @test gen_sundance in test_list_ent
    @test !(gen_solitude in test_list_ent)
    @test !in(gen_sundance, test_list_ent; filterby = get_available)
end

@testset "Test SubtypeComponentSelector" begin
    test_sub_ent = SubtypeComponentSelector(ThermalStandard, nothing)
    named_test_sub_ent = SubtypeComponentSelector(ThermalStandard, "Thermals")

    # Equality
    @test SubtypeComponentSelector(ThermalStandard, nothing) == test_sub_ent
    @test SubtypeComponentSelector(ThermalStandard, "Thermals") == named_test_sub_ent

    # Construction
    @test select_components(ThermalStandard) == test_sub_ent
    @test select_components(ThermalStandard; name = "Thermals") == named_test_sub_ent

    # Naming
    @test get_name(test_sub_ent) == "ThermalStandard"
    @test get_name(named_test_sub_ent) == "Thermals"
    @test IS.default_name(test_sub_ent) == "ThermalStandard"

    # Contents
    answer = sort_name!(get_components(ThermalStandard, test_sys))

    @test collect(get_components(select_components(NonexistentComponent), test_sys)) ==
          Vector{Component}()
    the_components = sort_name!(get_components(test_sub_ent, test_sys))
    @test all(the_components .== answer)
    @test !(
        gen_sundance in
        collect(get_components(test_sub_ent, test_sys; filterby = get_available)))

    @test collect(get_subselectors(select_components(NonexistentComponent), test_sys)) ==
          Vector{ComponentSelectorElement}()
    the_subselectors = sort_name!(get_subselectors(test_sub_ent, test_sys))
    @test all(the_subselectors .== select_components.(answer))
    @test !(
        gen_sundance in
        collect(get_subselectors(test_sub_ent, test_sys; filterby = get_available)))

    @test gen_sundance in test_sub_ent
    @test !(gen_wind in test_sub_ent)
    @test !in(gen_sundance, test_sub_ent; filterby = get_available)
end

@testset "Test TopologyComponentSelector" begin
    topo1 = get_component(Area, test_sys2, "1")
    topo2 = get_component(LoadZone, test_sys2, "2")
    test_topo_ent1 = TopologyComponentSelector(Area, "1", ThermalStandard, nothing)
    test_topo_ent2 = TopologyComponentSelector(LoadZone, "2", StaticInjection, "Zone_2")
    @assert (test_topo_ent1 !== nothing) && (test_topo_ent2 !== nothing) "Relies on an out-of-date `5_bus_hydro_uc_sys` definition"

    # Equality
    @test TopologyComponentSelector(Area, "1", ThermalStandard, nothing) ==
          test_topo_ent1
    @test TopologyComponentSelector(LoadZone, "2", StaticInjection, "Zone_2") ==
          test_topo_ent2

    # Construction
    @test select_components(Area, "1", ThermalStandard) == test_topo_ent1
    @test select_components(LoadZone, "2", StaticInjection, "Zone_2") == test_topo_ent2

    # Naming
    @test get_name(test_topo_ent1) == "Area__1__ThermalStandard"
    @test get_name(test_topo_ent2) == "Zone_2"

    # Contents
    empty_topo_ent = select_components(Area, "1", NonexistentComponent)
    @test collect(get_components(empty_topo_ent, test_sys2)) == Vector{Component}()
    @test collect(get_subselectors(empty_topo_ent, test_sys2)) ==
          Vector{ComponentSelectorElement}()

    nonexistent_topo_ent = select_components(Area, "NonexistentArea", ThermalStandard)
    @test collect(get_components(nonexistent_topo_ent, test_sys2)) == Vector{Component}()
    @test collect(get_subselectors(nonexistent_topo_ent, test_sys2)) ==
          Vector{ComponentSelectorElement}()

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

        the_subselectors = get_subselectors(ent, test_sys2)
        @test all(sort_name!(the_subselectors) .== sort_name!(select_components.(ans)))
        @test Set(collect(get_subselectors(ent, test_sys2; filterby = x -> true))) ==
              Set(the_subselectors)
        @test length(collect(get_subselectors(ent, test_sys2; filterby = x -> false))) == 0

        @test all(in(comp, ent, test_sys2) for comp in ans)
    end

    @test !(
        gen_sundance2 in
        collect(get_components(test_topo_ent1, test_sys2; filterby = get_available)))
    @test !(
        select_components(gen_sundance2) in
        collect(get_subselectors(test_topo_ent1, test_sys2; filterby = get_available)))

    @test in(gen_sundance2, test_topo_ent1, test_sys2)
    @test !in(gen_sundance2, test_topo_ent1, test_sys2; filterby = get_available)
    @test !in(gen_sundance2, test_topo_ent2, test_sys2)
end

@testset "Test FilterComponentSelector" begin
    starts_with_s(x) = lowercase(first(get_name(x))) == 's'
    test_filter_ent = FilterComponentSelector(starts_with_s, ThermalStandard, nothing)
    named_test_filter_ent =
        FilterComponentSelector(starts_with_s, ThermalStandard, "ThermStartsWithS")

    # Equality
    @test FilterComponentSelector(starts_with_s, ThermalStandard, nothing) ==
          test_filter_ent
    @test FilterComponentSelector(starts_with_s, ThermalStandard, "ThermStartsWithS") ==
          named_test_filter_ent

    # Construction
    @test select_components(starts_with_s, ThermalStandard) == test_filter_ent
    @test select_components(starts_with_s, ThermalStandard, "ThermStartsWithS") ==
          named_test_filter_ent
    bad_input_fn(x::Integer) = true  # Should always fail to construct
    specific_input_fn(x::RenewableDispatch) = true  # Should require compatible subtype
    @test_throws ArgumentError select_components(bad_input_fn, ThermalStandard)
    @test_throws ArgumentError select_components(specific_input_fn, Component)
    @test_throws ArgumentError select_components(specific_input_fn, ThermalStandard)
    @test select_components(specific_input_fn, RenewableDispatch) isa Any  # test absence of error

    # Naming
    @test get_name(test_filter_ent) == "starts_with_s__ThermalStandard"
    @test get_name(named_test_filter_ent) == "ThermStartsWithS"

    # Contents
    answer = filter(starts_with_s, collect(get_components(ThermalStandard, test_sys)))

    @test collect(
        get_components(select_components(x -> true, NonexistentComponent), test_sys),
    ) ==
          Vector{Component}()
    @test collect(get_components(select_components(x -> false, Component), test_sys)) ==
          Vector{Component}()
    @test all(collect(get_components(test_filter_ent, test_sys)) .== answer)
    @test !(
        gen_sundance in
        collect(get_components(test_filter_ent, test_sys; filterby = get_available)))

    @test collect(
        get_subselectors(select_components(x -> true, NonexistentComponent), test_sys),
    ) == Vector{ComponentSelectorElement}()
    @test collect(get_subselectors(select_components(x -> false, Component), test_sys)) ==
          Vector{ComponentSelectorElement}()
    @test all(
        collect(get_subselectors(test_filter_ent, test_sys)) .== select_components.(answer),
    )
    @test !(
        gen_sundance in
        collect(get_components(test_filter_ent, test_sys; filterby = get_available)))
    @test !(
        select_components(gen_sundance) in
        collect(get_subselectors(test_filter_ent, test_sys; filterby = get_available)))
end
