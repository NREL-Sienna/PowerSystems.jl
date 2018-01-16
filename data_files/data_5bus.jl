using TimeSeries

dates  = collect(DateTime(2015,1,1,12,00):Hour(1):DateTime(2015,1,1,17,00))

FiveBus = system_param(230, 100, 0.0, length(dates));

nodes = [bus(1,"nodeA", "PV", 1.0, 1.1, 0.0, 0, 230),
         bus(2,"nodeB", "PQ", 1.0, 1.1, 0.0, 0, 230),
         bus(3,"nodeC", "PV", 1.0, 1.1, 0.0, 0, 230),
         bus(4,"nodeD", "PV", 1.0, 1.1, 0.0, 0, 230),
         bus(5,"nodeE", "SF", 1.0, 1.1, 0.0, 0, 230),
        ];

Loads = [load("Load1", nodes[2], 
             load_tech("P",300, 98.61, 230),
             load_econ("interruptible", 1000, 999),
             TimeArray(dates, 0.3+rand(length(dates)))
            ),  
        load("Load2", nodes[3], 
             load_tech("P",400, 98.61, 230),
             load_econ("interruptible", 1000, 999),
             TimeArray(dates, 0.4+rand(length(dates)))
            ),  
        load("Load3", nodes[4], 
             load_tech("P",600, 131.47, 230),
             load_econ("interruptible", 1000, 999),
             TimeArray(dates, 0.2+rand(length(dates)))
            )                                                
        ];

Generators = [  ng_generator("Alta", nodes[1],
                generator_tech(40, 0, 40, 10, 30, -30, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}()),
                generator_econ(40, 14, 0, 0.90, "Base", "Gas")
                ), 
                ng_generator("Park City", nodes[1],
                generator_tech(170, 0, 170, 20, 127.5, -127.5, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}()),
                generator_econ(170, 15, 0, 0.90, "Base", "Coal")
                ), 
                ng_generator("Solitude", nodes[3],
                generator_tech(520, 0, 520, 100, 390, -390, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}()),
                generator_econ(520, 30, 0, 0.80, "Mid", "Gas")
                ),                
                ng_generator("Sundance", nodes[4],
                generator_tech(200, 0, 200, 40, 150, -150, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}()),
                generator_econ(200, 40, 0, 0.60, "Peak", "Gas")
                ),    
                ng_generator("Brighton", nodes[5],
                generator_tech(600, 0, 600, 150, 450, -450, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}()),
                generator_econ(600, 10, 0, 0.60, "Base", "Coal")
                )
            ];

PV = [solar_power("site1", nodes[1], 
        re_tech(100), 
        re_econ(500), 
        TimeArray(dates, rand(length(dates)))
        ),
        wind_power("site2", nodes[5], 
        re_tech(100), 
        re_econ(300),
        TimeArray(dates, rand(length(dates)))
        ),
    ];

Branches = [branch(1, 1, "line", (nodes[1],nodes[2]), 0.00281, 0.0281, 0.00712, 400, -400, 230),
            branch(2, 1, "line", (nodes[1],nodes[4]), 0.00304, 0.0304, 0.00658, Inf, -Inf, 230),
            branch(3, 1, "line", (nodes[1],nodes[5]), 0.00064, 0.0064, 0.03126, Inf, -Inf, 230),
            branch(4, 1, "line", (nodes[2],nodes[3]), 0.00108, 0.0108, 0.01852, Inf, -Inf, 230),     
            branch(5, 1, "line", (nodes[3],nodes[4]), 0.00297, 0.0297, 0.00674, Inf, -Inf, 230),
            branch(6, 1, "line", (nodes[4],nodes[5]), 0.00297, 0.0297, 0.00674, 240, -240, 230)
];     
