const LOCAL_PACKAGES = expanduser("~/Dropbox/Remote Code Rep/PowerSchema/src")
push!(LOAD_PATH, LOCAL_PACKAGES)
using PowerSchema

FourteenBus = SystemParam(14, 230, 100, 1);

nodes_ac = [
                Bus(1 , "Bus 1"  , "SF" ,      0 , 1.06  , 1.06  ,  0.94, 69),
                Bus(2 , "Bus 2"  , "PV" ,  -4.98 , 1.045 , 1.06 ,   0.94, 69),
                Bus(3 , "Bus 3"  , "PV" , -12.72 , 1.01  , 1.06 ,   0.94, 69),
                Bus(4 , "Bus 4"  , "PQ" ,  -10.33, 1.019 , 1.06,    0.94, 69),
                Bus(5 , "Bus 5"  , "PQ" , -8.78  , 1.02  , 1.06  ,  0.94, 69),
                Bus(6 , "Bus 6"  , "PV" , -14.22 , 1.07  , 1.06 ,   0.94, 13.8),
                Bus(7 , "Bus 7"  , "PQ" ,  -13.37, 1.062 , 1.06,    0.94, 13.8),
                Bus(8 , "Bus 8"  , "PV" , -13.36 , 1.09  , 1.06 ,   0.94, 18),
                Bus(9 , "Bus 9"  , "PQ" ,  -14.94, 1.056 , 1.06,    0.94, 13.8),
                Bus(10, "Bus 10" , "PQ" ,  -15.1 , 1.051 , 1.06 ,   0.94, 13.8),
                Bus(11, "Bus 11" , "PQ" ,  -14.79, 1.057 , 1.06,    0.94, 13.8),
                Bus(12, "Bus 12" , "PQ" ,  -15.07, 1.055 , 1.06,    0.94, 13.8),
                Bus(13, "Bus 13" , "PQ" , -15.16 , 1.05  , 1.06 ,   0.94, 13.8),
                Bus(14, "Bus 14" , "PQ" ,  -16.04, 1.036 , 1.06,    0.94, 13.8)
            ]

Branches = [
                Line("Line1",  true, (nodes_ac[1],nodes_ac[2]),   0.01938, 0.05917,  0.0528, Inf),
                Line("Line2",  true, (nodes_ac[1],nodes_ac[5]),   0.05403, 0.22304,  0.0492, Inf),
                Line("Line3",  true, (nodes_ac[2],nodes_ac[3]),   0.04699, 0.19797,  0.0438, Inf),
                Line("Line4",  true, (nodes_ac[2],nodes_ac[4]),   0.05811, 0.17632,  0.0340, Inf),
                Line("Line5",  true, (nodes_ac[2],nodes_ac[5]),   0.05695, 0.17388,  0.0346, Inf),
                Line("Line6",  true, (nodes_ac[3],nodes_ac[4]),   0.06701, 0.17103,  0.0128, Inf),
                Line("Line7",  true, (nodes_ac[4],nodes_ac[5]),   0.01335, 0.04211,  0.0   , Inf),
                Transformer2W("Trans3", true, (nodes_ac[4],nodes_ac[7]),  0.0    , 0.20912,  0.0    , 0.978, 0.0, Inf),
                Transformer2W("Trans1", true, (nodes_ac[4],nodes_ac[9]),  0.0    , 0.55618,  0.0     , 0.969, 0.0, Inf),
                Transformer2W("Trans2", true, (nodes_ac[5],nodes_ac[6]),  0.0    , 0.25202,  0.0     , 0.932, 0.0, Inf),
                Line("Line8",  true, (nodes_ac[6],nodes_ac[11]),  0.09498, 0.19890,  0.0   , Inf),   
                Line("Line9",  true, (nodes_ac[6],nodes_ac[12]),  0.12291, 0.25581,  0.0   , Inf),    
                Line("Line10", true, (nodes_ac[6],nodes_ac[13]),  0.06615, 0.13027,  0.0   , Inf), 
                Transformer2W("Trans4", true, (nodes_ac[7],nodes_ac[8]),  0.0      , 0.17615,  0.0     , 1.0,   0.0, Inf),
                Line("Line16", true, (nodes_ac[7],nodes_ac[9]),   0.0,     0.11001,  0.0   , Inf),   
                Line("Line11", true, (nodes_ac[9],nodes_ac[10]),  0.03181, 0.08450,  0.0   , Inf),    
                Line("Line12", true, (nodes_ac[9],nodes_ac[14]),  0.12711, 0.27038,  0.0   , Inf),    
                Line("Line13", true, (nodes_ac[10],nodes_ac[11]), 0.08205, 0.19207,  0.0   , Inf),    
                Line("Line14", true, (nodes_ac[12],nodes_ac[13]), 0.22092, 0.19988,  0.0   , Inf),    
                Line("Line15", true, (nodes_ac[13],nodes_ac[14]), 0.17093, 0.34802,  0.0   , Inf)
            ]   

Net = Network(FourteenBus, Branches, nodes_ac) 
get(Net.ptdf)