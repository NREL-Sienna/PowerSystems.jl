using PowerSystems
using TimeSeries
using NamedTuples


dates  = collect(DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime("1/1/2024  23:00:00", "d/m/y  H:M:S"))

nodes14= [
                Bus(1 , "Bus 1"  , "SF" ,      0 , 1.06  , @NT(min=0.94, max=1.06), 69),
                Bus(2 , "Bus 2"  , "PV" ,  -4.98 , 1.045 , @NT(min=0.94, max=1.06), 69),
                Bus(3 , "Bus 3"  , "PV" , -12.72 , 1.01  , @NT(min=0.94, max=1.06), 69),
                Bus(4 , "Bus 4"  , "PQ" ,  -10.33, 1.019 , @NT(min=0.94, max=1.06), 69),
                Bus(5 , "Bus 5"  , "PQ" , -8.78  , 1.02  , @NT(min=0.94, max=1.06), 69),
                Bus(6 , "Bus 6"  , "PV" , -14.22 , 1.07  , @NT(min=0.94, max=1.06), 13.8),
                Bus(7 , "Bus 7"  , "PQ" ,  -13.37, 1.062 , @NT(min=0.94, max=1.06), 13.8),
                Bus(8 , "Bus 8"  , "PV" , -13.36 , 1.09  , @NT(min=0.94, max=1.06), 18),
                Bus(9 , "Bus 9"  , "PQ" ,  -14.94, 1.056 , @NT(min=0.94, max=1.06), 13.8),
                Bus(10, "Bus 10" , "PQ" ,  -15.1 , 1.051 , @NT(min=0.94, max=1.06), 13.8),
                Bus(11, "Bus 11" , "PQ" ,  -14.79, 1.057 , @NT(min=0.94, max=1.06), 13.8),
                Bus(12, "Bus 12" , "PQ" ,  -15.07, 1.055 , @NT(min=0.94, max=1.06), 13.8),
                Bus(13, "Bus 13" , "PQ" , -15.16 , 1.05  , @NT(min=0.94, max=1.06), 13.8),
                Bus(14, "Bus 14" , "PQ" ,  -16.04, 1.036 , @NT(min=0.94, max=1.06), 13.8)
            ]

branches14 = [
                Line("Line1",  true, @NT(from=nodes14[1],to=nodes14[2]),   0.01938, 0.05917,  0.0528, 1804.6, @NT(max = 60.0, min = -60.0)),
                Line("Line2",  true, @NT(from=nodes14[1],to=nodes14[5]),   0.05403, 0.22304,  0.0492, 489.6, @NT(max = 60.0, min = -60.0)),
                Line("Line3",  true, @NT(from=nodes14[2],to=nodes14[3]),   0.04699, 0.19797,  0.0438, 552.2, @NT(max = 60.0, min = -60.0)),
                Line("Line4",  true, @NT(from=nodes14[2],to=nodes14[4]),   0.05811, 0.17632,  0.0340, 605.2, @NT(max = 60.0, min = -60.0)),
                Line("Line5",  true, @NT(from=nodes14[2],to=nodes14[5]),   0.05695, 0.17388,  0.0346, 614.0, @NT(max = 60.0, min = -60.0)),
                Line("Line6",  true, @NT(from=nodes14[3],to=nodes14[4]),   0.06701, 0.17103,  0.0128, 611.6, @NT(max = 60.0, min = -60.0)),
                Line("Line7",  true, @NT(from=nodes14[4],to=nodes14[5]),   0.01335, 0.04211,  0.0   , 2543.4, @NT(max = 60.0, min = -60.0)),
                Transformer2W("Trans3", true, @NT(from=nodes14[4],to=nodes14[7]),  0.0    , 0.20912,  0.0    , 0.978,  Inf),
                Transformer2W("Trans1", true, @NT(from=nodes14[4],to=nodes14[9]),  0.0    , 0.55618,  0.0     , 0.969,  Inf),
                Transformer2W("Trans2", true, @NT(from=nodes14[5],to=nodes14[6]),  0.0    , 0.25202,  0.0     , 0.932,  Inf),
                Line("Line8",  true, @NT(from=nodes14[6],to=nodes14[11]),  0.09498, 0.19890,  0.0   , 537.3, @NT(max = 60.0, min = -60.0)),
                Line("Line9",  true, @NT(from=nodes14[6],to=nodes14[12]),  0.12291, 0.25581,  0.0   , 202.0, @NT(max = 60.0, min = -60.0)),
                Line("Line10", true, @NT(from=nodes14[6],to=nodes14[13]),  0.06615, 0.13027,  0.0   , 445.8, @NT(max = 60.0, min = -60.0)),
                Transformer2W("Trans4", true, @NT(from=nodes14[7],to=nodes14[8]),  0.0      , 0.17615,  0.0     , 1.0,   Inf),
                Line("Line16", true, @NT(from=nodes14[7],to=nodes14[9]),   0.0,     0.11001,  0.0   , 1244.4, @NT(max = 60.0, min = -60.0)),
                Line("Line11", true, @NT(from=nodes14[9],to=nodes14[10]),  0.03181, 0.08450,  0.0   , 509.7, @NT(max = 60.0, min = -60.0)),
                Line("Line12", true, @NT(from=nodes14[9],to=nodes14[14]),  0.12711, 0.27038,  0.0   , 395.9, @NT(max = 60.0, min = -60.0)),
                Line("Line13", true, @NT(from=nodes14[10],to=nodes14[11]), 0.08205, 0.19207,  0.0   , 769.0, @NT(max = 60.0, min = -60.0)),
                Line("Line14", true, @NT(from=nodes14[12],to=nodes14[13]), 0.22092, 0.19988,  0.0   , 637.8, @NT(max = 60.0, min = -60.0)),
                Line("Line15", true, @NT(from=nodes14[13],to=nodes14[14]), 0.17093, 0.34802,  0.0   , 1021.3, @NT(max = 60.0, min = -60.0))
            ]

generators14 = [ThermalDispatch("Bus1", true, nodes14[1],
                TechThermal(200.0, @NT(min=0.0, max=200.0), -16.9, @NT(min=-990.0, max=990.0), nothing, nothing),
                EconThermal(40.0, x -> 0.04303*x^2 + 20*x, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalDispatch("Bus2", true, nodes14[2],
                TechThermal(40.0, @NT(min=0.0, max=140.0), 42.4, @NT(min=-40.0, max=50.0), nothing, nothing),
                EconThermal(140.0, x -> 0.25*x^2 + 20*x, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalDispatch("Bus3", true, nodes14[3],
                TechThermal(50.0, @NT(min=0.0, max=100.0), 23.4, @NT(min=0.0, max=40.0), nothing, nothing),
                EconThermal(100.0, x -> 0.01*x^2 + 40*x, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalDispatch("Bus6", true, nodes14[6],
                TechThermal(0.0, @NT(min=0.0, max=100.0), 12.2, @NT(min=-6.0, max=24.0), nothing, nothing),
                (EconThermal(100.0, x -> 0.01*x^2 + 40*x, 0.0, 0.0, 0.0, nothing))
                ),
                ThermalDispatch("Bus8", true, nodes14[8],
                TechThermal(0.0, @NT(min=0.0, max=100.0), 17.4, @NT(min=-6.0, max=4.0), nothing, nothing),
                EconThermal(100.0, x -> 0.01*x^2 + 40*x, 0.0, 0.0, 0.0, nothing)
                )
            ];


loadz1_ts = [ 0.792729978
            0.723201574
            0.710952098
            0.677672816
            0.668249175
            0.67166919
            0.687608809
            0.711821241
            0.756320618
            0.7984057
            0.827836527
            0.840362459
            0.84511032
            0.834592803
            0.822949221
            0.816941743
            0.824079963
            0.905735139
            0.989967048
            1
            0.991227765
            0.960842114
            0.921465115
            0.837001437 ]

loadz2_ts = [ 0.831093782
              0.689863228
              0.666058513
              0.627033103
              0.624901388
              0.62858924
              0.650734211
              0.683424321
              0.750876413
              0.828347191
              0.884248576
              0.888523615
              0.87752169
              0.847534405
              0.8227661
              0.803809323
              0.813282799
              0.907575962
              0.98679848
              1
              0.990489904
              0.952520972
              0.906611479
              0.824307054]

loadz3_ts = [ 0.871297342
              0.670489749
              0.642812243
              0.630092987
              0.652991383
              0.671971681
              0.716278493
              0.770885833
              0.810075243
              0.85562361
              0.892440566
              0.910660449
              0.922135467
              0.898416969
              0.879816542
              0.896390855
              0.978598576
              0.96523761
              1
              0.969626503
              0.901212601
              0.81894251
              0.771004923
              0.717847996]

loads14 = [StaticLoad("Bus2", true, nodes14[2], "P", 21.7, 12.7, TimeArray(dates, loadz1_ts)),
          StaticLoad("Bus3", true, nodes14[3], "P", 94.2, 19, TimeArray(dates, loadz1_ts)),
          StaticLoad("Bus4", true, nodes14[4], "P", 47.8, -3.9, TimeArray(dates, loadz3_ts)),
          StaticLoad("Bus5", true, nodes14[5], "P", 7.6, 1.6, TimeArray(dates, loadz1_ts)),
          StaticLoad("Bus6", true, nodes14[6], "P", 11.2, 7.5, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus9", true, nodes14[9], "P", 29.5, 16.6, TimeArray(dates, loadz3_ts)),
          StaticLoad("Bus10", true, nodes14[10], "P", 9, 5.8, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus11", true, nodes14[11], "P", 3.5, 1.8, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus12", true, nodes14[12], "P", 6.1, 1.6, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus13", true, nodes14[13], "P", 13.5, 5.8, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus14", true, nodes14[14], "P", 14.9, 5.0, TimeArray(dates, loadz2_ts))
          ]

#sys14 = PowerSystem(nodes14, generators14, loads14, branches14, 69.0, 1000.0)
