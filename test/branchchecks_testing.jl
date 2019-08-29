import TimeSeries: TimeArray

@testset "Time resolution" begin
    twomins = TimeArray([DateTime(today()) + Dates.Minute(i * 2) for i in 1:5], ones(5))
    oneday = TimeArray([DateTime(today()) + Dates.Day(i) for i in 1:5], ones(5))
    onesec = TimeArray([DateTime(today()) + Dates.Second(i) for i in 1:5], ones(5))
    onehour = TimeArray([DateTime(today()) + Dates.Hour(i) for i in 1:5], ones(5))

    @test PowerSystems.getresolution(twomins) == Dates.Minute(2)
    @test PowerSystems.getresolution(oneday) == Dates.Day(1)
    @test PowerSystems.getresolution(onesec) == Dates.Second(1)
    @test PowerSystems.getresolution(onehour) == Dates.Hour(1)
end

@testset "Angle limits" begin
    nodes5 = [
        Bus(1, "nodeA", PowerSystems.PV::BusType, 0, 1.0, (min = 0.9, max=1.05), 230),
        Bus(2, "nodeB", PowerSystems.PQ::BusType, 0, 1.0, (min = 0.9, max=1.05), 230),
        Bus(3, "nodeC", PowerSystems.PV::BusType, 0, 1.0, (min = 0.9, max=1.05), 230),
        Bus(4, "nodeD", PowerSystems.REF::BusType, 0, 1.0, (min = 0.9, max=1.05), 230),
        Bus(5, "nodeE", PowerSystems.PV::BusType, 0, 1.0, (min = 0.9, max=1.05), 230),
    ]

    branches_test = [
        Line("1", true, 0.0, 0.0, Arc(from=nodes5[1], to=nodes5[2]), 0.00281, 0.0281,
             (from=0.00356, to=0.00356), 400.0, (min=-360.0, max=360.0)),
        Line("2", true, 0.0, 0.0, Arc(from=nodes5[1], to=nodes5[4]), 0.00304, 0.0304,
             (from=0.00329, to=0.00329), 3960.0, (min=-360.0, max=75.0)),
        Line("3", true, 0.0, 0.0, Arc(from=nodes5[1], to=nodes5[5]), 0.00064, 0.0064,
             (from=0.01563, to=0.01563), 18812.0, (min=-75.0, max=360.0)),
        Line("4", true, 0.0, 0.0, Arc(from=nodes5[2], to=nodes5[3]), 0.00108, 0.0108,
             (from=0.00926, to=0.00926), 11148.0, (min=0.0, max=0.0)),
        Line("5", true, 0.0, 0.0, Arc(from=nodes5[3], to=nodes5[4]), 0.00297, 0.0297,
             (from=0.00337, to=0.00337), 4053.0, (min=-1.2, max=60.0)),
        Line("6", true, 0.0, 0.0, Arc(from=nodes5[4], to=nodes5[5]), 0.00297, 0.0297,
             (from=0.00337, to=00.00337), 240.0, (min=-1.17, max=1.17))
    ]

    PowerSystems.check_angle_limits!(branches_test)
    @test branches_test[1].anglelimits == (min=-pi/2, max=pi/2)
    @test branches_test[2].anglelimits == (min=-pi/2, max=75.0 * (π / 180))
    @test branches_test[3].anglelimits == (min=-75.0 * (π / 180), max=pi/2)
    @test branches_test[4].anglelimits == (min=-pi/2, max=pi/2)
    @test branches_test[5].anglelimits == (min=-1.2, max=60.0 * (π / 180))
    @test branches_test[6].anglelimits == (min=-1.17, max=1.17)

    bad_angle_limits = [
        Line("1", true, 0.0, 0.0, Arc(from=nodes5[1], to=nodes5[2]), 0.00281, 0.0281,
             (from=0.00356, to=0.00356), 400.0, (min=360.0, max=-360.0))
    ]

    @test_throws(PowerSystems.DataFormatError,
                 PowerSystems.check_angle_limits!(bad_angle_limits))
end
