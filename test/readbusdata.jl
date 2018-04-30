FiveBus = SystemParam(5, 230, 100, 1);

#Buses for full ac analysis
nodes_ac = [Bus(1,"nodeA", "PV", 1.0, 1.1, 0.0, 0, 230),
            Bus(2,"nodeB", "PQ", 1.0, 1.1, 0.0, 0, 230),
            Bus(3,"nodeC", "PV", 1.0, 1.1, 0.0, 0, 230),
            Bus(4,"nodeD", "PV", 1.0, 1.1, 0.0, 0, 230),
            Bus(5,"nodeE", "SF", 1.0, 1.1, 0.0, 0, 230),
        ];

#Buses for full dc-opf analysis        
nodes_dc = [Bus(1,"nodeA", "PV", 1.0),
            Bus(2,"nodeB", "PQ", 1.0),
            Bus(3,"nodeC", "PV", 1.0),
            Bus(4,"nodeD", "PV", 1.0),
            Bus(5,"nodeE", "SF", 1.0),
       ];

#Buses for full basic analysis 
nodes_nn = [Bus(1,"nodeA"),
            Bus(2,"nodeB"),
            Bus(3,"nodeC"),
            Bus(4,"nodeD"),
            Bus(5,"nodeE"),
      ]; 

true 