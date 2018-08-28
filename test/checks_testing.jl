using PowerSystems

branches5 = [Line("1", true,  (from=nodes5[1],to=nodes5[2]), 0.00281, 0.0281,  (from=0.00356, to=0.00356), 400.0,  (min = -360.0,max = 360.0)),
             Line("2", true,  (from=nodes5[1],to=nodes5[4]), 0.00304, 0.0304,  (from=0.00329, to=0.00329), 3960.0,  (min = -360.0,max = 75.0)),
             Line("3", true,  (from=nodes5[1],to=nodes5[5]), 0.00064, 0.0064,  (from=0.01563, to=0.01563), 18812.0,  (min = -75.0,max = 360.0)),
             Line("4", true,  (from=nodes5[2],to=nodes5[3]), 0.00108, 0.0108,  (from=0.00926, to=0.00926), 11148.0,  (min = 0.0,max = 0.0)),
             Line("5", true,  (from=nodes5[3],to=nodes5[4]), 0.00297, 0.0297,  (from=0.00337, to=0.00337), 4053.0,  (min = -60.0,max = 60.0)),
             Line("6", true,  (from=nodes5[4],to=nodes5[5]), 0.00297, 0.0297,  (from=0.00337, to=00.00337), 240.0,  (min = -60.0,max = 60.0))
             ];



@test try PowerSystems.checkanglelimits!(branches5); true finally end

@test try @assert (branches5[1].anglelimits) == (min = -90.0,max = 90.0); true finally end
@test try @assert (branches5[2].anglelimits) == (min = -90.0,max = 75.0); true finally end
@test try @assert (branches5[3].anglelimits) == (min = -75.0,max = 90.0); true finally end
@test try @assert (branches5[4].anglelimits) == (min = -90.0,max = 90.0); true finally end

