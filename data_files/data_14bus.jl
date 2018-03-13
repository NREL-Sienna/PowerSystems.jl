using PowerSystems
using TimeSeries


dates  = collect(DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime("1/1/2024  23:00:00", "d/m/y  H:M:S"))

FourteenBus = SystemParam(14, 230, 100, length(dates));

nodes14= [
                Bus(1 , "Bus 1"  , "SF" ,      0 , 1.06  , (1.06,0.94), 69),
                Bus(2 , "Bus 2"  , "PV" ,  -4.98 , 1.045 , (1.06,0.94), 69),
                Bus(3 , "Bus 3"  , "PV" , -12.72 , 1.01  , (1.06,0.94), 69),
                Bus(4 , "Bus 4"  , "PQ" ,  -10.33, 1.019 , (1.06,0.94), 69),
                Bus(5 , "Bus 5"  , "PQ" , -8.78  , 1.02  , (1.06,0.94), 69),
                Bus(6 , "Bus 6"  , "PV" , -14.22 , 1.07  , (1.06,0.94), 13.8),
                Bus(7 , "Bus 7"  , "PQ" ,  -13.37, 1.062 , (1.06,0.94), 13.8),
                Bus(8 , "Bus 8"  , "PV" , -13.36 , 1.09  , (1.06,0.94), 18),
                Bus(9 , "Bus 9"  , "PQ" ,  -14.94, 1.056 , (1.06,0.94), 13.8),
                Bus(10, "Bus 10" , "PQ" ,  -15.1 , 1.051 , (1.06,0.94), 13.8),
                Bus(11, "Bus 11" , "PQ" ,  -14.79, 1.057 , (1.06,0.94), 13.8),
                Bus(12, "Bus 12" , "PQ" ,  -15.07, 1.055 , (1.06,0.94), 13.8),
                Bus(13, "Bus 13" , "PQ" , -15.16 , 1.05  , (1.06,0.94), 13.8),
                Bus(14, "Bus 14" , "PQ" ,  -16.04, 1.036 , (1.06,0.94), 13.8)
            ]

branches14 = [
                Line("Line1",  true, (nodes14[1],nodes14[2]),   0.01938, 0.05917,  0.0528, Inf, nothing),
                Line("Line2",  true, (nodes14[1],nodes14[5]),   0.05403, 0.22304,  0.0492, Inf, nothing),
                Line("Line3",  true, (nodes14[2],nodes14[3]),   0.04699, 0.19797,  0.0438, Inf, nothing),
                Line("Line4",  true, (nodes14[2],nodes14[4]),   0.05811, 0.17632,  0.0340, Inf, nothing),
                Line("Line5",  true, (nodes14[2],nodes14[5]),   0.05695, 0.17388,  0.0346, Inf, nothing),
                Line("Line6",  true, (nodes14[3],nodes14[4]),   0.06701, 0.17103,  0.0128, Inf, nothing),
                Line("Line7",  true, (nodes14[4],nodes14[5]),   0.01335, 0.04211,  0.0   , Inf, nothing),
                Transformer2W("Trans3", true, (nodes14[4],nodes14[7]),  0.0    , 0.20912,  0.0    , 0.978, 0.0, Inf),
                Transformer2W("Trans1", true, (nodes14[4],nodes14[9]),  0.0    , 0.55618,  0.0     , 0.969, 0.0, Inf),
                Transformer2W("Trans2", true, (nodes14[5],nodes14[6]),  0.0    , 0.25202,  0.0     , 0.932, 0.0, Inf),
                Line("Line8",  true, (nodes14[6],nodes14[11]),  0.09498, 0.19890,  0.0   , Inf, nothing),   
                Line("Line9",  true, (nodes14[6],nodes14[12]),  0.12291, 0.25581,  0.0   , Inf, nothing),    
                Line("Line10", true, (nodes14[6],nodes14[13]),  0.06615, 0.13027,  0.0   , Inf, nothing), 
                Transformer2W("Trans4", true, (nodes14[7],nodes14[8]),  0.0      , 0.17615,  0.0     , 1.0,   0.0, Inf),
                Line("Line16", true, (nodes14[7],nodes14[9]),   0.0,     0.11001,  0.0   , Inf, nothing),   
                Line("Line11", true, (nodes14[9],nodes14[10]),  0.03181, 0.08450,  0.0   , Inf, nothing),    
                Line("Line12", true, (nodes14[9],nodes14[14]),  0.12711, 0.27038,  0.0   , Inf, nothing),    
                Line("Line13", true, (nodes14[10],nodes14[11]), 0.08205, 0.19207,  0.0   , Inf, nothing),    
                Line("Line14", true, (nodes14[12],nodes14[13]), 0.22092, 0.19988,  0.0   , Inf, nothing),    
                Line("Line15", true, (nodes14[13],nodes14[14]), 0.17093, 0.34802,  0.0   , Inf, nothing)
            ]   

Net14 = Network(FourteenBus, branches14, nodes14) 

generators14 = [ThermalGen("Bus1", true, nodes14[1],
                TechGen(200, (0, 200), -16.9, (-990, 990), nothing, nothing),
                EconGen(40, x -> 0.04303*x^2 + 20*x, 0.0, 0.0, 0.0, nothing)
                ), 
                ThermalGen("Bus2", true, nodes14[2],
                TechGen(40, (0, 140), 42.4, (-40, 50), nothing, nothing),
                EconGen(140, x -> 0.25*x^2 + 20*x, 0.0, 0.0, 0.0, nothing)
                ), 
                ThermalGen("Bus3", true, nodes14[3],
                TechGen(50, (0, 100), 23.4, (0, 40), nothing, nothing),
                EconGen(100, x -> 0.01*x^2 + 40*x, 0.0, 0.0, 0.0, nothing)
                ),                
                ThermalGen("Bus6", true, nodes14[6],
                TechGen(0, (0, 100), 12.2, (-6, 24), nothing, nothing),
                (EconGen(100, x -> 0.01*x^2 + 40*x, 0.0, 0.0, 0.0, nothing))
                ),    
                ThermalGen("Bus8", true, nodes14[8],
                TechGen(0, (0, 100), 17.4, (-6, 24), nothing, nothing),
                EconGen(100, x -> 0.01*x^2 + 40*x, 0.0, 0.0, 0.0, nothing)
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
            
loads14 = [ StaticLoad("Bus2", true, nodes14[2], "P", 21.7, 12.7, TimeArray(dates, loadz1_ts)),
          StaticLoad("Bus3", true, nodes14[3], "P", 94.2, 19, TimeArray(dates, loadz1_ts)),
          StaticLoad("Bus4", true, nodes14[4], "P", 47.8, -3.9, TimeArray(dates, loadz3_ts)),
          StaticLoad("Bus5", true, nodes14[5], "P", 7.6, 1.6, TimeArray(dates, loadz1_ts)),
          StaticLoad("Bus6", true, nodes14[6], "P", 11.2, 7.5, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus9", true, nodes14[9], "P", 29.5, 16.6, TimeArray(dates, loadz3_ts)),
          StaticLoad("Bus10", true, nodes14[10], "P", 9, 5.8, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus11", true, nodes14[11], "P", 3.5, 1.8, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus12", true, nodes14[12], "P", 6.1, 1.6, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus13", true, nodes14[13], "P", 13.5, 5.8, TimeArray(dates, loadz2_ts)),
          StaticLoad("Bus14", true, nodes14[14], "P", 14.9, 5, TimeArray(dates, loadz2_ts))
          ]
