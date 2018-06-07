using PowerSystems
using TimeSeries
using NamedTuples

DayAhead  = collect(DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime("1/1/2024  23:00:00", "d/m/y  H:M:S"))
#Dispatch_11am =  collect(DateTime("1/1/2024  0:11:00", "d/m/y  H:M:S"):Minute(15):DateTime("1/1/2024  12::00", "d/m/y  H:M:S"))

nodes5    = [Bus(1,"nodeA", "PV", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(2,"nodeB", "PQ", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(3,"nodeC", "PV", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(4,"nodeD", "PV", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
             Bus(5,"nodeE", "SF", 0, 1.0, @NT(min = 0.9, max=1.05), 230),
        ];

branches5 = [Line("1", true, @NT(from=nodes5[1],to=nodes5[2]), 0.00281, 0.0281, 0.00712, 400.0, nothing),
             Line("2", true, @NT(from=nodes5[1],to=nodes5[4]), 0.00304, 0.0304, 0.00658, Inf, nothing),
             Line("3", true, @NT(from=nodes5[1],to=nodes5[5]), 0.00064, 0.0064, 0.03126, Inf, nothing),
             Line("4", true, @NT(from=nodes5[2],to=nodes5[3]), 0.00108, 0.0108, 0.01852, Inf, nothing),
             Line("5", true, @NT(from=nodes5[3],to=nodes5[4]), 0.00297, 0.0297, 0.00674, Inf, nothing),
             Line("6", true, @NT(from=nodes5[4],to=nodes5[5]), 0.00297, 0.0297, 0.00674, 240, nothing)
];     to=

solar_ts_DA = [0
               0
               0
               0
               0
               0
               0
               0
               0
               0.351105684
               0.632536266
               0.99463925
               1
               0.944237283
               0.396681234
               0.366511428
               0.155125829
               0.040872694
               0
               0
               0
               0
               0
               0]

wind_ts_DA = [0.985205412
           0.991791369
           0.997654144
           1
           0.998663733
           0.995497149
           0.992414567
           0.98252418
           0.957203427
           0.927650911
           0.907181989
           0.889095913
           0.848186718
           0.766813846
           0.654052531
           0.525336131
           0.396098004
           0.281771509
           0.197790004
           0.153241012
           0.131355854
           0.113688144
           0.099302656
           0.069569628]

generators5 = [  ThermalGen("Alta", true, nodes5[1],
                    TechGen(40.0, @NT(min=0.0, max=40.0), 10.0, @NT(min = -30.0, max = 30.0), nothing, nothing),
                    EconGen(40.0, 14.0, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalGen("Park City", true, nodes5[1],
                    TechGen(170.0, @NT(min=0.0, max=170.0), 20.0, @NT(min =-127.5, max=127.5), nothing, nothing),
                    EconGen(170.0, 15.0, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalGen("Solitude", true, nodes5[3],
                    TechGen(520.0, @NT(min=0.0, max=520.0), 100.0, @NT(min =-390.0, max=390.0), nothing, nothing),
                    EconGen(520.0, 30.0, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalGen("Sundance", true, nodes5[4],
                    TechGen(200.0, @NT(min=0.0, max=200.0), 40.0, @NT(min =-150.0, max=150.0), nothing, nothing),
                    EconGen(200.0, 40.0, 0.0, 0.0, 0.0, nothing)
                ),
                ThermalGen("Brighton", true, nodes5[5],
                    TechGen(600.0, @NT(min=0.0, max=600.0), 150.0, @NT(min =-450.0, max=450.0), nothing, nothing),
                    EconGen(600.0, 10.0, 0.0, 0.0, 0.0, nothing)
                ),
                RenewableFix("SolarBusC", true, nodes5[3],
                    60.0,
                    TimeSeries.TimeArray(DayAhead,solar_ts_DA)
                ),
                RenewableCurtailment("WindBusA", true, nodes5[5],
                    120.0,
                    EconRenewable(22.0, nothing),
                    TimeSeries.TimeArray(DayAhead,wind_ts_DA)
                )
            ];

loadbus2_ts_DA = [ 0.792729978
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

loadbus3_ts_DA = [ 0.831093782
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

loadbus4_ts_DA = [ 0.871297342
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

loads5_DA = [ StaticLoad("Bus2", true, nodes5[2], "P", 300.0, 98.61, TimeArray(DayAhead, loadbus2_ts_DA)),
            StaticLoad("Bus3", true, nodes5[3], "P", 300.0, 98.61, TimeArray(DayAhead, loadbus3_ts_DA)),
            StaticLoad("Bus4", true, nodes5[4], "P", 400.0, 131.47, TimeArray(DayAhead, loadbus4_ts_DA)),
            InterruptibleLoad("IloadBus4", true, nodes5[4], "P",100.0, 0.0, 50.0, 2400.0, TimeArray(DayAhead, loadbus4_ts_DA))
        ]

sys5 = PowerSystem(nodes5, generators5, loads5_DA, branches5, 230.0, 1000.0)
