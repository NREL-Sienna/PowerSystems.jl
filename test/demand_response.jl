using Dates
using PowerSystems
using Setfield
using Test
using TimeSeries


const EVIPRO_DATA = abspath(joinpath(dirname(Base.find_package("PowerSystems")), "..", "data", "evi-pro", "FlexibleDemand_1000.mat"))

macro trytotest(f)
    if isfile(EVIPRO_DATA)
        f
    else
        @warn string("Demand-response tests not run because file '", EVIPRO_DATA, "' is missing.")
    end
end


@testset "Reading EVIpro dataset" begin
    @trytotest begin
        @test begin
           bevs = populate_BEV_demand(EVIPRO_DATA)
           length(bevs) == 1000
        end
    end
end


function augment(bev)
    bev = @set bev.power     = update(bev.power    , Time(23,59,59,999), NaN                       )
    bev = @set bev.locations = update(bev.locations, Time(23,59,59,999), ("", (ac = NaN, dc = NaN)))
    bev
end


function checkcharging(f)
    bevs = populate_BEV_demand(EVIPRO_DATA)
    i = 0
    for bev in bevs
        i += 1
        bev = augment(bev)
        @test begin
            charging = f(bev)
            (balance, rates, battery) = verify(bev, charging, message=string("BEV ", i, " in '", EVIPRO_DATA, "'"))
            battery |= bev.capacity.max < 30. # FIXME: Exclude vehicles with small batteries.
            balance && rates && battery
        end
    end
end


@testset "Earliest demands on EVIpro dataset" begin
    @trytotest begin
        checkcharging(earliestdemands)
    end
end

@testset "Latest demands on EVIpro dataset" begin
    @trytotest begin
        checkcharging(latestdemands)
    end
end


@testset "Greedy demands on EVIpro dataset" begin
    @error "`PowerSystems.greedycharging` fails some tests."
#   @trytotest begin
#       checkcharging(x -> greedydemands(x, map(v -> 1., x.power)) |> locateddemand)
#   end
end
