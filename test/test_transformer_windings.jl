@testset "TransformerControl construction and validation" begin
    ctrl = TransformerControl(;
        objective = TransformerControlObjective.VOLTAGE,
        regulated_bus_number = 101,
        limits = (min = 0.9, max = 1.1),
        controlled_quantity_limits = (min = 0.95, max = 1.05),
        number_of_tap_positions = 33,
    )
    @test get_objective(ctrl) == TransformerControlObjective.VOLTAGE
    @test get_regulated_bus_number(ctrl) == 101
    @test get_limits(ctrl) == (min = 0.9, max = 1.1)
    @test get_controlled_quantity_limits(ctrl) == (min = 0.95, max = 1.05)
    @test get_number_of_tap_positions(ctrl) == 33

    # invariants
    @test_throws ArgumentError TransformerControl(;
        objective = TransformerControlObjective.VOLTAGE,
        regulated_bus_number = 101,
        limits = (min = 1.1, max = 0.9),   # inverted
        controlled_quantity_limits = (min = 0.95, max = 1.05),
        number_of_tap_positions = 33,
    )
    @test_throws ArgumentError TransformerControl(;
        objective = TransformerControlObjective.UNDEFINED,   # uncontrolled must be `nothing`, not UNDEFINED
        regulated_bus_number = 101,
        limits = (min = 0.9, max = 1.1),
        controlled_quantity_limits = (min = 0.95, max = 1.05),
        number_of_tap_positions = 33,
    )
    @test_throws ArgumentError TransformerControl(;
        objective = TransformerControlObjective.VOLTAGE,
        regulated_bus_number = 101,
        limits = (min = 0.9, max = 1.1),
        controlled_quantity_limits = (min = 0.95, max = 1.05),
        number_of_tap_positions = -1,
    )
end

function _test_winding(; base_power = 20.0, system_base = 100.0)
    arc = Arc(ACBus(nothing), ACBus(nothing))
    w = TransformerWinding(;
        arc = arc,
        tap = 1.05,
        α = 0.0,
        winding_group_number = WindingGroupNumber.UNDEFINED,
        control = nothing,
        available = true,
        rating = 0.5,          # DU: 0.5 * 20 MVA = 10 MVA
        rating_b = nothing,
        rating_c = nothing,
        active_power_flow = 0.1,
        reactive_power_flow = 0.05,
        base_power = base_power,
        base_voltage = 138.0,
    )
    w.units_info = PSY.SystemUnitsSettings(system_base, IS.UnitSystem.SYSTEM_BASE)
    return w
end

@testset "TransformerWinding plain accessors" begin
    w = _test_winding()
    @test get_tap(w) == 1.05
    @test get_α(w) == 0.0
    @test get_available(w)
    @test isnothing(get_control(w))
    @test get_base_power(w) == 20.0
    @test get_base_voltage(w) == 138.0
    set_tap!(w, 1.0)
    @test get_tap(w) == 1.0
end

@testset "TransformerWinding explicit-units getters use the winding base" begin
    w = _test_winding()
    @test get_rating(w, DU) ≈ 0.5
    @test get_rating(w, SU) ≈ 0.5 * 20.0 / 100.0
    @test get_rating(w, NU) ≈ 10.0
    @test get_active_power_flow(w, NU) ≈ 0.1 * 20.0
    @test isnothing(get_rating_b(w, SU))
end

@testset "TransformerWinding tagged setters round-trip" begin
    w = _test_winding()
    set_rating!(w, 0.2 * SU)              # 0.2 SU = 20 MVA = 1.0 DU
    @test get_rating(w, DU) ≈ 1.0
    set_active_power_flow!(w, 5.0 * DU)
    @test get_active_power_flow(w, DU) ≈ 5.0
    @test_throws ArgumentError set_rating!(w, 0.9)   # bare floats rejected
end

@testset "TransformerWinding detached errors cleanly on SU" begin
    w = _test_winding()
    w.units_info = nothing
    @test get_rating(w, DU) ≈ 0.5          # DU needs no system base
    @test_throws ErrorException get_rating(w, SU)
end

@testset "predicates" begin
    w = _test_winding()
    @test !is_phase_shifting(w)
    set_α!(w, 0.3)
    @test is_phase_shifting(w)
    set_α!(w, 0.0)
    set_control!(
        w,
        TransformerControl(;
            objective = TransformerControlObjective.ACTIVE_POWER_FLOW,
            regulated_bus_number = 0,
            limits = (min = -0.5, max = 0.5),
            controlled_quantity_limits = (min = -100.0, max = 100.0),
            number_of_tap_positions = 33,
        ),
    )
    @test is_phase_shifting(w)
    @test has_control(w)
end

@testset "parent constructors" begin
    t2w = TwoWindingTransformer(nothing)
    @test t2w isa Component
    @test get_winding(t2w) isa TransformerWinding
    t3w = ThreeWindingTransformer(nothing)
    @test t3w isa Component
    @test get_primary_winding(t3w) isa TransformerWinding
end

function _test_t3w(; system_base = 100.0)
    t = ThreeWindingTransformer(nothing)
    IS.get_internal(t).units_info =
        PSY.SystemUnitsSettings(system_base, UnitSystem.SYSTEM_BASE)
    PowerSystems.set_units_setting!(t, IS.get_internal(t).units_info)
    set_base_power_12!(t, 15.0)
    set_base_power_23!(t, 20.0)
    set_base_power_13!(t, 25.0)
    set_base_power!(get_primary_winding(t), 15.0)
    set_base_power!(get_secondary_winding(t), 20.0)
    set_base_power!(get_tertiary_winding(t), 25.0)
    set_base_voltage!(get_primary_winding(t), 230.0)
    set_base_voltage!(get_secondary_winding(t), 138.0)
    set_base_voltage!(get_tertiary_winding(t), 69.0)
    return t
end

@testset "get_windings and derived availability" begin
    t = _test_t3w()
    @test length(get_windings(t)) == 3
    foreach(w -> set_available!(w, true), get_windings(t))
    @test get_available(t)
    set_available!(get_secondary_winding(t), false)
    @test get_available(t)                      # any-semantics
    foreach(w -> set_available!(w, false), get_windings(t))
    @test !get_available(t)
    set_available!(t, true)                     # fan-out restore (documented asymmetry)
    @test all(get_available, get_windings(t))

    t2 = TwoWindingTransformer(nothing)
    @test length(get_windings(t2)) == 1
    set_available!(t2, true)
    @test get_available(t2) == get_available(get_winding(t2))
end

@testset "pairwise impedance converts against pair base" begin
    t = _test_t3w()
    set_r_12!(t, 0.02 * DU)
    @test get_r_12(t, DU) ≈ 0.02
    # Independent derivation (not the engine under test): Zpu_su = Zpu_du * (Zbase_du / Zbase_su).
    # Zbase_du = V^2 / base_power_12 = V^2 / 15; Zbase_su = V^2 / system_base = V^2 / 100.
    # The base voltage V cancels in the ratio, leaving Zpu_su = Zpu_du * (system_base / base_power_12)
    # = 0.02 * (100.0 / 15.0).
    @test get_r_12(t, SU) ≈ 0.02 * (100.0 / 15.0)   # Zpu_su = Zpu_du * sb/db for impedance

    # Same derivation on the other two pairs, each against ITS OWN pair base —
    # catches a wrong-pair-base selection (e.g. r_23 accidentally using base_power_12).
    set_r_23!(t, 0.03 * DU)
    @test get_r_23(t, DU) ≈ 0.03
    @test get_r_23(t, SU) ≈ 0.03 * (100.0 / 20.0)   # base_power_23 = 20

    set_r_13!(t, 0.04 * DU)
    @test get_r_13(t, DU) ≈ 0.04
    @test get_r_13(t, SU) ≈ 0.04 * (100.0 / 25.0)   # base_power_13 = 25
end

@testset "units settings propagate to windings" begin
    t = _test_t3w()
    @test !isnothing(get_primary_winding(t).units_info)
    PowerSystems.set_units_setting!(t, nothing)
    @test isnothing(get_primary_winding(t).units_info)
end

function _test_t2w(; system_base = 100.0)
    t = TwoWindingTransformer(nothing)
    IS.get_internal(t).units_info =
        PSY.SystemUnitsSettings(system_base, UnitSystem.SYSTEM_BASE)
    PowerSystems.set_units_setting!(t, IS.get_internal(t).units_info)
    set_base_voltage!(get_winding(t), 138.0)
    return t
end

@testset "hand-written winding setters propagate units_info" begin
    # set_winding!/set_primary_winding!/set_secondary_winding!/set_tertiary_winding!
    # are `exclude_setter: true` in the descriptor precisely because the
    # generated `value.winding = val` form would install a winding whose
    # `units_info` is stale (or nothing, if freshly constructed) relative to
    # the owning transformer's System. These setters must copy the parent's
    # current units_info onto the incoming winding.
    t2 = _test_t2w()
    fresh_2w = TransformerWinding(;
        available = true,
        arc = Arc(ACBus(nothing), ACBus(nothing)),
        rating = 0.5,
        base_power = 100.0,
    )
    @test isnothing(fresh_2w.units_info)
    set_winding!(t2, fresh_2w)
    @test get_winding(t2) === fresh_2w
    @test get_winding(t2).units_info === IS.get_units_info(IS.get_internal(t2))
    @test get_rating(get_winding(t2), SU) ≈ 0.5   # base_power == system_base here

    t3 = _test_t3w()
    fresh_3w = TransformerWinding(;
        available = true,
        arc = Arc(ACBus(nothing), ACBus(nothing)),
        rating = 0.5,
        base_power = 15.0,
    )
    @test isnothing(fresh_3w.units_info)
    set_primary_winding!(t3, fresh_3w)
    @test get_primary_winding(t3) === fresh_3w
    @test get_primary_winding(t3).units_info === IS.get_units_info(IS.get_internal(t3))
    @test get_rating(get_primary_winding(t3), SU) ≈ 0.5 * 15.0 / 100.0
end

@testset "2W add_component!/remove_component! with runchecks on" begin
    sys = System(100.0)
    b1 = ACBus(nothing)
    b1.number = 1
    b1.name = "b1"
    b1.base_voltage = 230.0
    b2 = ACBus(nothing)
    b2.number = 2
    b2.name = "b2"
    b2.base_voltage = 138.0
    add_component!(sys, b1)
    add_component!(sys, b2)
    t = TwoWindingTransformer(nothing)
    t.name = "t2w1"
    w = get_winding(t)
    set_arc!(w, Arc(b1, b2))
    set_rating!(w, 1.0 * DU)
    set_x!(t, 0.1 * DU)
    add_component!(sys, t)   # runchecks defaults to true; validation must pass
    @test get_component(TwoWindingTransformer, sys, "t2w1") !== nothing
    @test PSY.get_from_bus(t) === b1
    @test PSY.get_to_bus(t) === b2
    remove_component!(sys, t)
    @test get_component(TwoWindingTransformer, sys, "t2w1") === nothing
end

@testset "transformer serialization round-trip" begin
    sys = System(100.0)
    b1 = ACBus(nothing);
    set_name!(b1, "b1");
    set_number!(b1, 1)
    b2 = ACBus(nothing);
    set_name!(b2, "b2");
    set_number!(b2, 2)
    b3 = ACBus(nothing);
    set_name!(b3, "b3");
    set_number!(b3, 3)
    star = ACBus(nothing);
    set_name!(star, "star");
    set_number!(star, 901)
    for b in (b1, b2, b3, star)
        set_base_voltage!(b, 100.0)
        set_bustype!(b, ACBusTypes.PQ)
        add_component!(sys, b)
    end
    set_bustype!(b1, ACBusTypes.REF)
    arc12 = Arc(b1, b2)
    add_component!(sys, arc12)
    ctrl = TransformerControl(;
        objective = TransformerControlObjective.VOLTAGE,
        regulated_bus_number = 2,
        limits = (min = 0.9, max = 1.1),
        controlled_quantity_limits = (min = 0.95, max = 1.05),
        number_of_tap_positions = 33,
    )
    t2w = TwoWindingTransformer(nothing)
    set_name!(t2w, "t2w")
    w = get_winding(t2w)
    set_arc!(w, arc12);
    set_tap!(w, 1.05);
    set_control!(w, ctrl)
    set_available!(w, true)
    set_rating!(w, 1.0 * DU)   # check_rating_values requires a non-nothing `rating`
    add_component!(sys, t2w)

    a1 = Arc(b1, star);
    a2 = Arc(b2, star);
    a3 = Arc(b3, star)
    foreach(a -> add_component!(sys, a), (a1, a2, a3))
    t3w = ThreeWindingTransformer(nothing)
    set_name!(t3w, "t3w")
    set_arc!(get_primary_winding(t3w), a1)
    set_arc!(get_secondary_winding(t3w), a2)
    set_arc!(get_tertiary_winding(t3w), a3)
    foreach(w -> set_available!(w, true), get_windings(t3w))
    set_star_bus!(t3w, star)
    set_r_12!(t3w, 0.01 * DU)
    add_component!(sys, t3w)

    path = joinpath(mktempdir(), "sys.json")
    to_json(sys, path)
    sys2 = System(path)
    t2w2 = get_component(TwoWindingTransformer, sys2, "t2w")
    @test get_tap(get_winding(t2w2)) == 1.05
    # the full TransformerControl round-trips: scoped enum, both MinMax fields, and Ints
    ctrl2 = get_control(get_winding(t2w2))
    @test get_objective(ctrl2) == TransformerControlObjective.VOLTAGE
    @test get_limits(ctrl2) == (min = 0.9, max = 1.1)
    @test get_controlled_quantity_limits(ctrl2) == (min = 0.95, max = 1.05)
    @test get_regulated_bus_number(ctrl2) == 2
    @test get_number_of_tap_positions(ctrl2) == 33
    # arc resolved to the live Arc component in sys2 (UUID ref, not an inline copy)
    @test IS.get_uuid(get_arc(get_winding(t2w2))) == IS.get_uuid(
        first(
            a for a in get_components(Arc, sys2) if
            get_number(get_from(a)) == 1 && get_number(get_to(a)) == 2
        ),
    )
    @test !isnothing(PSY._get_units_info(get_winding(t2w2)))   # repopulated on add during load
    t3w2 = get_component(ThreeWindingTransformer, sys2, "t3w")
    @test get_r_12(t3w2, DU) ≈ 0.01
    # 3W refs also resolve to live components in sys2 (UUID refs, not inline copies)
    @test IS.get_uuid(get_star_bus(t3w2)) ==
          IS.get_uuid(get_component(ACBus, sys2, "star"))
    @test IS.get_uuid(get_arc(get_primary_winding(t3w2))) == IS.get_uuid(
        first(
            a for a in get_components(Arc, sys2) if
            get_number(get_from(a)) == 1 && get_number(get_to(a)) == 901
        ),
    )
    @test IS.get_uuid(get_arc(get_secondary_winding(t3w2))) == IS.get_uuid(
        first(
            a for a in get_components(Arc, sys2) if
            get_number(get_from(a)) == 2 && get_number(get_to(a)) == 901
        ),
    )
    @test IS.get_uuid(get_arc(get_tertiary_winding(t3w2))) == IS.get_uuid(
        first(
            a for a in get_components(Arc, sys2) if
            get_number(get_from(a)) == 3 && get_number(get_to(a)) == 901
        ),
    )
    @test !isnothing(PSY._get_units_info(get_primary_winding(t3w2)))   # repopulated on add during load
end
