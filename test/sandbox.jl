const LOCAL_PACKAGES = expanduser("~/Dropbox/Remote Code Rep/PowerSchema/src")
push!(LOAD_PATH, LOCAL_PACKAGES)
using PowerSchema

FiveBus = SystemParam(5, 3, 5, 230, 100, 1);

nodes_ac = [Bus(1,"nodeA", "PV", 1.0, 1.1, 0.0, 0, 230),
            Bus(2,"nodeB", "PQ", 1.0, 1.1, 0.0, 0, 230),
            Bus(3,"nodeC", "PV", 1.0, 1.1, 0.0, 0, 230),
            Bus(4,"nodeD", "PV", 1.0, 1.1, 0.0, 0, 230),
            Bus(5,"nodeE", "SF", 1.0, 1.1, 0.0, 0, 230),
        ];

nodes_dc = [Bus(1,"nodeA", "PV", 1.0),
            Bus(2,"nodeB", "PQ", 1.0),
            Bus(3,"nodeC", "PV", 1.0),
            Bus(4,"nodeD", "PV", 1.0),
            Bus(5,"nodeE", "SF", 1.0),
       ];

nodes_nn = [Bus(1,"nodeA"),
            Bus(2,"nodeB"),
            Bus(3,"nodeC"),
            Bus(4,"nodeD"),
            Bus(5,"nodeE"),
      ];       

Branches = [Line(1, true, (nodes_ac[1],nodes_ac[2]), 230.0, 0.00281, 0.0281, 0.00712, 400.0),
            Line(2, true, (nodes_ac[1],nodes_ac[4]), 230, 0.00304, 0.0304, 0.00658, Inf),
            Line(3, true, (nodes_ac[1],nodes_ac[5]), 230, 0.00064, 0.0064, 0.03126, Inf),
            Line(4, true, (nodes_ac[2],nodes_ac[3]), 230, 0.00108, 0.0108, 0.01852, Inf),     
            Line(5, true, (nodes_ac[3],nodes_ac[4]), 230, 0.00297, 0.0297, 0.00674, Inf),
            Line(6, true, (nodes_ac[4],nodes_ac[5]), 230, 0.00297, 0.0297, 0.00674, 240)
];    

Net = Network(FiveBus, Branches, nodes_ac) 