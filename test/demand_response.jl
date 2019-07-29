using Dates
using PowerSystems
using Setfield
using Test
using TimeSeries


const EVIPRO_DATA = abspath(joinpath(dirname(Base.find_package("PowerSystems")), "..", "data", "evi-pro", "FlexibleDemand_1000.mat"))


@testset "Reading EVIpro dataset" begin
    @test begin
       bevs = populate_BEV_demand(EVIPRO_DATA)
       length(bevs) == 1000
    end
end


function augment(bev)
    bev = @set bev.power     = update(bev.power    , Time(23,59,59,999), NaN                       )
    bev = @set bev.locations = update(bev.locations, Time(23,59,59,999), ("", (ac = NaN, dc = NaN)))
    bev
end


function checkcharging(f)
    bevs = populate_BEV_demand(EVIPRO_DATA)
    deltamax = 0
    i = 0
    for bev in bevs
        i += 1
        bev = augment(bev)
        @test begin
            charging = f(bev)
            delta = shortfall(bev, charging)
            deltamax = max(deltamax, abs(delta))
            energyresult = abs(delta) <= 1e-5
            if !energyresult
                @warn string("BEV ", i, " in '", EVIPRO_DATA, "' has charging shortfall of ", delta, " kWh.")
            end
            limitresult = verifylimits(bev, charging)
            if !limitresult
                @warn string("BEV ", i, " in '", EVIPRO_DATA, "' violates charging limits.")
            end
            batteryresult = verifybattery(bev, charging)
            batteryresult |= bev.capacity.max < 30. # FIXME: Exclude vehicles with small batteries.
            if !batteryresult
                @warn string("BEV ", i, " in '", EVIPRO_DATA, "' violates battery limits.")
            end
            energyresult && limitresult && batteryresult
        end
    end
    @debug string("Maximum charging discrepancy: ", deltamax, " kWh.")
end


@testset "Earliest demands on EVIpro dataset" begin
    checkcharging(earliestdemands)
end

@testset "Latest demands on EVIpro dataset" begin
    checkcharging(latestdemands)
end
