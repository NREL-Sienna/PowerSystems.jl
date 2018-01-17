FiveBus = SystemParam(5, 3, 5, 230, 100, 1);

Branches_full = [Line(1, true, (nodes_ac[1],nodes_ac[2]), 230.0, 0.00281, 0.0281, 0.00712, 400.0),
            Line(2, true, (nodes_ac[1],nodes_ac[4]), 230, 0.00304, 0.0304, 0.00658, Inf),
            Line(3, true, (nodes_ac[1],nodes_ac[5]), 230, 0.00064, 0.0064, 0.03126, Inf),
            Line(4, true, (nodes_ac[2],nodes_ac[3]), 230, 0.00108, 0.0108, 0.01852, Inf),     
            Line(5, true, (nodes_ac[3],nodes_ac[4]), 230, 0.00297, 0.0297, 0.00674, Inf),
            Line(6, true, (nodes_ac[4],nodes_ac[5]), 230, 0.00297, 0.0297, 0.00674, 240)
];    

Net1 = Network(FiveBus, Branches_full, nodes_ac) 

Branches_incomplete = [Line(1, true, (nodes_nn[1],nodes_nn[2]), 230.0, 0.00281, 0.0281, 0.00712, 400.0),
            Line(2, true, (nodes_nn[1],nodes_nn[4]), 230, 0.00304, 0.0304, 0.00658, Inf),
            Line(3, true, (nodes_nn[1],nodes_nn[5]), 230, 0.00064, 0.0064, 0.03126, Inf),
            Line(4, true, (nodes_nn[2],nodes_nn[3]), 230, 0.00108, 0.0108, 0.01852, Inf),     
            Line(5, true, (nodes_nn[3],nodes_nn[4]), 230, 0.00297, 0.0297, 0.00674, Inf),
            Line(6, true, (nodes_nn[4],nodes_nn[5]), 230, 0.00297, 0.0297, 0.00674, 240)
];    

Net2 = Network(FiveBus, Branches_incomplete, nodes_ac) 

true

