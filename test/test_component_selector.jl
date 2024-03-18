# TODO copied directly from https://github.com/GabrielKS/PowerAnalytics.jl/tree/gks/entity-metric-redesign, will require major refactor

test_sys = PSB.build_system(PSB.PSITestSystems, "c_sys5_all_components")
test_sys2 = PSB.build_system(PSB.PSISystems, "5_bus_hydro_uc_sys")

struct NonexistentComponent <: StaticInjection end  # <: Component

sort_name(x) = sort(collect(x); by = get_name)

@testset "Test helper functions" begin
    @test subtype_to_string(ThermalStandard) == "ThermalStandard"
    @test component_to_qualified_string(ThermalStandard, "Solitude") ==
          "ThermalStandard__Solitude"
    @test component_to_qualified_string(
        PSY.get_component(ThermalStandard, test_sys, "Solitude"),
    ) == "ThermalStandard__Solitude"
end

@testset "Test SingleComponentSelector" begin
    test_gen_ent = PA.SingleComponentSelector(ThermalStandard, "Solitude", nothing)
    named_test_gen_ent = PA.SingleComponentSelector(ThermalStandard, "Solitude", "SolGen")

    # Equality
    @test PA.SingleComponentSelector(ThermalStandard, "Solitude", nothing) == test_gen_ent
    @test PA.SingleComponentSelector(ThermalStandard, "Solitude", "SolGen") ==
          named_test_gen_ent

    # Construction
    @test select_components(ThermalStandard, "Solitude") == test_gen_ent
    @test select_components(ThermalStandard, "Solitude", "SolGen") == named_test_gen_ent
    @test select_components(get_component(ThermalStandard, test_sys, "Solitude")) ==
          test_gen_ent

    # Naming
    @test get_name(test_gen_ent) == "ThermalStandard__Solitude"
    @test get_name(named_test_gen_ent) == "SolGen"
    @test default_name(test_gen_ent) == "ThermalStandard__Solitude"

    # Contents
    @test collect(get_components(select_components(NonexistentComponent, ""), test_sys)) ==
          Vector{Component}()
    the_components = collect(get_components(test_gen_ent, test_sys))
    @test length(the_components) == 1
    @test typeof(first(the_components)) == ThermalStandard
    @test get_name(first(the_components)) == "Solitude"
end

@testset "Test ListComponentSelector" begin
    comp_ent_1 = select_components(ThermalStandard, "Solitude")
    comp_ent_2 = select_components(RenewableDispatch, "WindBusA")
    test_list_ent = PA.ListComponentSelector((comp_ent_1, comp_ent_2), nothing)
    named_test_list_ent = PA.ListComponentSelector((comp_ent_1, comp_ent_2), "TwoComps")

    # Equality
    @test PA.ListComponentSelector((comp_ent_1, comp_ent_2), nothing) == test_list_ent
    @test PA.ListComponentSelector((comp_ent_1, comp_ent_2), "TwoComps") ==
          named_test_list_ent

    # Construction
    @test select_components(comp_ent_1, comp_ent_2) == test_list_ent
    @test select_components(comp_ent_1, comp_ent_2; name = "TwoComps") ==
          named_test_list_ent

    # Naming
    @test get_name(test_list_ent) ==
          "[ThermalStandard__Solitude, RenewableDispatch__WindBusA]"
    @test get_name(named_test_list_ent) == "TwoComps"

    # Contents
    @test collect(get_components(select_components(), test_sys)) == Vector{Component}()
    the_components = collect(get_components(test_list_ent, test_sys))
    @test length(the_components) == 2
    @test get_component(ThermalStandard, test_sys, "Solitude") in the_components
    @test get_component(RenewableDispatch, test_sys, "WindBusA") in the_components

    @test collect(get_subselectors(select_components(), test_sys)) ==
          Vector{ComponentSelector}()
    the_subselectors = collect(get_subselectors(test_list_ent, test_sys))
    @test length(the_subselectors) == 2
    @test comp_ent_1 in the_subselectors
    @test comp_ent_2 in the_subselectors
end

@testset "Test SubtypeComponentSelector" begin
    test_sub_ent = PA.SubtypeComponentSelector(ThermalStandard, nothing)
    named_test_sub_ent = PA.SubtypeComponentSelector(ThermalStandard, "Thermals")

    # Equality
    @test PA.SubtypeComponentSelector(ThermalStandard, nothing) == test_sub_ent
    @test PA.SubtypeComponentSelector(ThermalStandard, "Thermals") == named_test_sub_ent

    # Construction
    @test select_components(ThermalStandard) == test_sub_ent
    @test select_components(ThermalStandard; name = "Thermals") == named_test_sub_ent

    # Naming
    @test get_name(test_sub_ent) == "ThermalStandard"
    @test get_name(named_test_sub_ent) == "Thermals"
    @test default_name(test_sub_ent) == "ThermalStandard"

    # Contents
    answer = sort_name(get_components(ThermalStandard, test_sys))

    @test collect(get_components(select_components(NonexistentComponent), test_sys)) ==
          Vector{Component}()
    the_components = sort_name(get_components(test_sub_ent, test_sys))
    @test all(the_components .== answer)

    @test collect(get_subselectors(select_components(NonexistentComponent), test_sys)) ==
          Vector{ComponentSelectorElement}()
    the_subselectors = sort_name(get_subselectors(test_sub_ent, test_sys))
    @test all(the_subselectors .== select_components.(answer))
end

@testset "Test TopologyComponentSelector" begin
    topo1 = get_component(Area, test_sys2, "1")
    topo2 = get_component(LoadZone, test_sys2, "2")
    test_topo_ent1 = PA.TopologyComponentSelector(Area, "1", ThermalStandard, nothing)
    test_topo_ent2 = PA.TopologyComponentSelector(LoadZone, "2", StaticInjection, "Zone_2")
    @assert (test_topo_ent1 !== nothing) && (test_topo_ent2 !== nothing) "Relies on an out-of-date `5_bus_hydro_uc_sys` definition"

    # Equality
    @test PA.TopologyComponentSelector(Area, "1", ThermalStandard, nothing) ==
          test_topo_ent1
    @test PA.TopologyComponentSelector(LoadZone, "2", StaticInjection, "Zone_2") ==
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

    answers =
        sort_name.((
            PSY.get_components_in_aggregation_topology(
                ThermalStandard,
                test_sys2,
                get_component(Area, test_sys2, "1"),
            ),
            PSY.get_components_in_aggregation_topology(
                StaticInjection,
                test_sys2,
                get_component(LoadZone, test_sys2, "2"),
            )))
    for (ent, ans) in zip((test_topo_ent1, test_topo_ent2), answers)
        @assert length(ans) > 0 "Relies on an out-of-date `5_bus_hydro_uc_sys` definition"

        the_components = sort_name(get_components(ent, test_sys2))
        @test all(the_components .== ans)

        the_subselectors = sort_name(get_subselectors(ent, test_sys2))
        @test all(the_subselectors .== sort_name(select_components.(ans)))
    end
end

@testset "Test FilterComponentSelector" begin
    starts_with_s(x) = lowercase(first(get_name(x))) == 's'
    test_filter_ent = PA.FilterComponentSelector(starts_with_s, ThermalStandard, nothing)
    named_test_filter_ent =
        PA.FilterComponentSelector(starts_with_s, ThermalStandard, "ThermStartsWithS")

    # Equality
    @test PA.FilterComponentSelector(starts_with_s, ThermalStandard, nothing) ==
          test_filter_ent
    @test PA.FilterComponentSelector(starts_with_s, ThermalStandard, "ThermStartsWithS") ==
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

    @test collect(
        get_subselectors(select_components(x -> true, NonexistentComponent), test_sys),
    ) == Vector{ComponentSelectorElement}()
    @test collect(get_subselectors(select_components(x -> false, Component), test_sys)) ==
          Vector{ComponentSelectorElement}()
    @test all(
        collect(get_subselectors(test_filter_ent, test_sys)) .== select_components.(answer),
    )
end
