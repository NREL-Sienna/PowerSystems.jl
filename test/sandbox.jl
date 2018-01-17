const LOCAL_PACKAGES = expanduser("~/Dropbox/Remote Code Rep/PowerSchema/src")
push!(LOAD_PATH, LOCAL_PACKAGES)
using PowerSchema

FiveBus = SystemParam(230, 100, 0.0, 1);

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