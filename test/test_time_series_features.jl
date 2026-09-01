# Coverage for the `features` keyword on the `System`-level time series API. These wrappers
# take a single `features::Union{Nothing, Dict} = nothing` keyword rather than slurping
# arbitrary keyword arguments, so the tests here pin both the accepted shape and the
# filtering behavior it drives.

"""Build a system with `count` `ThermalStandard` units on one bus."""
function _features_test_system(count::Int = 2)
    sys = System(100.0)
    bus = ACBus(nothing)
    bus.bustype = ACBusTypes.REF
    add_component!(sys, bus)
    gens = ThermalStandard[]
    for i in 1:count
        gen = ThermalStandard(nothing)
        gen.name = string(i)
        gen.bus = bus
        add_component!(sys, gen)
        push!(gens, gen)
    end
    return sys, gens
end

"""
The features stored for `key`, read from `owner`'s catalog rows.

A `TimeSeriesKey` carries only its association id; `features` is a catalog column, so it
comes from the [`TimeSeriesMetadata`](@ref) row the key addresses.
"""
function _features_for(owner, key)
    md = only(
        filter(m -> IS.get_time_series_key(m) == key, list_time_series_metadata(owner)),
    )
    return IS.get_features(md)
end

const _FEATURES_INITIAL_TIME = Dates.DateTime("2020-01-01T00:00:00")
const _FEATURES_RESOLUTION = Dates.Hour(1)
const _FEATURES_LENGTH = 24

function _features_sts(name, values)
    timestamps = collect(
        range(
            _FEATURES_INITIAL_TIME;
            step = _FEATURES_RESOLUTION,
            length = _FEATURES_LENGTH,
        ),
    )
    return SingleTimeSeries(;
        name = name,
        data = TimeSeries.TimeArray(timestamps, values),
    )
end

function _features_forecast(name, values; interval = Dates.Hour(24))
    initial_times = [_FEATURES_INITIAL_TIME, _FEATURES_INITIAL_TIME + interval]
    data = SortedDict(it => values for it in initial_times)
    return Deterministic(name, data, _FEATURES_RESOLUTION)
end

@testset "Test add_time_series! features on a component" begin
    sys, gens = _features_test_system(1)
    gen = gens[1]
    name = "max_active_power"

    high = Dict("scenario" => "high")
    low = Dict("scenario" => "low")
    key_high = add_time_series!(sys, gen, _features_sts(name, collect(1.0:24.0));
        features = high)
    key_low = add_time_series!(sys, gen, _features_sts(name, collect(25.0:48.0));
        features = low)

    # Same type and name; only the features separate them.
    @test _features_for(gen, key_high) == Dict{String, Any}("scenario" => "high")
    @test _features_for(gen, key_low) == Dict{String, Any}("scenario" => "low")
    @test key_high != key_low
    @test length(list_time_series_metadata(gen)) == 2

    @test get_time_series_values(SingleTimeSeries, gen, name; features = high)[1] == 1.0
    @test get_time_series_values(SingleTimeSeries, gen, name; features = low)[1] == 25.0
    @test has_time_series(gen, SingleTimeSeries, name; features = high)
    @test IS.get_time_series_key(only(list_time_series_metadata(gen; features = high))) ==
          key_high

    # Without features the lookup is ambiguous.
    @test_throws ArgumentError get_time_series(SingleTimeSeries, gen, name)

    # `features` is one keyword taking a `Dict`, not slurped keyword arguments.
    @test_throws MethodError add_time_series!(
        sys,
        gen,
        _features_sts("other", collect(1.0:24.0));
        scenario = "high",
    )

    # Feature values are restricted to `Bool`, `Real`, and `String`.
    @test_throws ArgumentError add_time_series!(
        sys,
        gen,
        _features_sts("other", collect(1.0:24.0));
        features = Dict("scenario" => [1, 2]),
    )

    # The default is `nothing`, and passing it explicitly is the same as omitting it.
    key_plain = add_time_series!(sys, gen, _features_sts("plain", collect(1.0:24.0));
        features = nothing)
    @test isempty(_features_for(gen, key_plain))
    @test get_time_series_values(SingleTimeSeries, gen, "plain")[1] == 1.0
end

@testset "Test add_time_series! features on multiple components" begin
    sys, gens = _features_test_system(2)
    name = "max_active_power"
    high = Dict("scenario" => "high")

    keys = add_time_series!(sys, gens, _features_sts(name, collect(1.0:24.0));
        features = high)
    @test all(((g, k),) -> _features_for(g, k) == Dict{String, Any}("scenario" => "high"),
        zip(gens, keys))

    # Every component gets the features, and the array itself is still stored once.
    keys_by_gen =
        [
            IS.get_time_series_key(only(list_time_series_metadata(g; name = name))) for
            g in gens
        ]
    @test all(((g, k),) -> _features_for(g, k) == Dict{String, Any}("scenario" => "high"),
        zip(gens, keys_by_gen))
    hashes = [get_time_series_hash(g, k) for (g, k) in zip(gens, keys_by_gen)]
    @test hashes[1] == hashes[2]

    for gen in gens
        @test get_time_series_values(SingleTimeSeries, gen, name; features = high)[1] == 1.0
    end
end

@testset "Test add_time_series! features on a supplemental attribute" begin
    sys, gens = _features_test_system(1)
    gen = gens[1]
    outage = GeometricDistributionForcedOutage(;
        mean_time_to_recovery = 1.0,
        outage_transition_probability = 0.5,
    )
    add_supplemental_attribute!(sys, gen, outage)

    name = "outage_rate"
    # Feature values may also be numeric.
    key_2030 = add_time_series!(sys, outage, _features_sts(name, collect(1.0:24.0));
        features = Dict("year" => 2030))
    key_2040 = add_time_series!(sys, outage, _features_sts(name, collect(25.0:48.0));
        features = Dict("year" => 2040))

    @test _features_for(outage, key_2030) == Dict{String, Any}("year" => 2030)
    @test _features_for(outage, key_2040) == Dict{String, Any}("year" => 2040)
    @test get_time_series_values(SingleTimeSeries, outage, name;
        features = Dict("year" => 2030))[1] == 1.0
    @test get_time_series_values(SingleTimeSeries, outage, name;
        features = Dict("year" => 2040))[1] == 25.0
    @test_throws ArgumentError get_time_series(SingleTimeSeries, outage, name)
end

@testset "Test build_forecast_reader features filter" begin
    sys, gens = _features_test_system(2)
    name = "max_active_power"
    horizon = 24
    high = Dict("scenario" => "high")
    low = Dict("scenario" => "low")

    # "high" is shared by both generators; "low" belongs to the first alone.
    add_time_series!(sys, gens, _features_forecast(name, collect(1.0:horizon));
        features = high)
    add_time_series!(sys, gens[1],
        _features_forecast(name, collect(101.0:(100 + horizon))); features = low)

    reader_all = build_forecast_reader(sys, Deterministic;
        resolution = _FEATURES_RESOLUTION)
    @test length(reader_all) == 3

    reader_high = build_forecast_reader(sys, Deterministic;
        resolution = _FEATURES_RESOLUTION, features = high)
    @test length(reader_high) == 2
    @test Set(get_name(e.owner) for e in get_forecast_reader_entries(reader_high)) ==
          Set(["1", "2"])
    # Both entries resolve to the one shared array.
    @test get_num_forecast_slots(reader_high) == 1

    reader_low = build_forecast_reader(sys, Deterministic;
        resolution = _FEATURES_RESOLUTION, features = low)
    @test length(reader_low) == 1
    @test only(get_name(e.owner) for e in get_forecast_reader_entries(reader_low)) == "1"

    read_forecast_window!(reader_low, _FEATURES_INITIAL_TIME)
    @test get_forecast_window(reader_low, 1) == collect(101.0:(100 + horizon))

    read_forecast_window!(reader_high, _FEATURES_INITIAL_TIME)
    @test get_forecast_window(reader_high, 1) == collect(1.0:horizon)

    # `name` and `features` narrow together.
    @test length(
        build_forecast_reader(sys, Deterministic;
            resolution = _FEATURES_RESOLUTION, name = name, features = low),
    ) == 1
    # A filter that matches nothing is an error in the store, not an empty reader.
    @test_throws Exception build_forecast_reader(sys, Deterministic;
        resolution = _FEATURES_RESOLUTION, name = "no_such_name", features = low)
end

@testset "Test build_static_time_series_reader features filter" begin
    sys, gens = _features_test_system(2)
    name = "max_active_power"
    high = Dict("scenario" => "high")
    low = Dict("scenario" => "low")

    high_values = collect(1.0:24.0)
    low_values = collect(101.0:124.0)
    add_time_series!(sys, gens, _features_sts(name, high_values); features = high)
    add_time_series!(sys, gens[1], _features_sts(name, low_values); features = low)

    reader_all = build_static_time_series_reader(sys; resolution = _FEATURES_RESOLUTION)
    @test length(reader_all) == 3

    reader_high = build_static_time_series_reader(sys;
        resolution = _FEATURES_RESOLUTION, features = high)
    @test length(reader_high) == 2
    @test Set(
        get_name(e.owner) for e in get_static_time_series_reader_entries(
            reader_high,
        )
    ) == Set(["1", "2"])
    @test get_num_static_time_series_groups(reader_high) == 1

    reader_low = build_static_time_series_reader(sys;
        resolution = _FEATURES_RESOLUTION, features = low)
    @test length(reader_low) == 1

    timestamps = collect(
        range(
            _FEATURES_INITIAL_TIME;
            step = _FEATURES_RESOLUTION,
            length = _FEATURES_LENGTH,
        ),
    )
    for (k, timestamp) in enumerate(timestamps)
        read_static_time_series_values!(reader_low, timestamp)
        @test get_static_time_series_value(reader_low, 1) == low_values[k]
        read_static_time_series_values!(reader_high, timestamp)
        @test get_static_time_series_value(reader_high, 1) == high_values[k]
    end

    @test_throws Exception build_static_time_series_reader(sys;
        resolution = _FEATURES_RESOLUTION, name = "no_such_name", features = high)
end

@testset "Test remove_time_series! features filter" begin
    sys, gens = _features_test_system(2)
    name = "max_active_power"
    high = Dict("scenario" => "high")
    low = Dict("scenario" => "low")

    add_time_series!(sys, gens, _features_forecast(name, collect(1.0:24.0));
        features = high)
    add_time_series!(sys, gens[1], _features_forecast(name, collect(101.0:124.0));
        features = low)
    @test length(list_time_series_metadata(gens[1])) == 2

    remove_time_series!(sys, Deterministic, gens[1], name; features = low)
    @test !has_time_series(gens[1], Deterministic, name; features = low)
    @test has_time_series(gens[1], Deterministic, name; features = high)
    # The other owner of the shared array is untouched.
    @test length(list_time_series_metadata(gens[2])) == 1

    # Omitting `features` removes every variant matching the type and name.
    add_time_series!(sys, gens[1], _features_forecast(name, collect(201.0:224.0));
        features = low)
    @test length(list_time_series_metadata(gens[1])) == 2
    remove_time_series!(sys, Deterministic, gens[1], name)
    @test isempty(list_time_series_metadata(gens[1]))
    @test length(list_time_series_metadata(gens[2])) == 1
end
