# Timeseries Data Files
This folder contains the timeseries data required to run PCM simulations

## CSP
The [`DAY_AHEAD_Natural_Inflow.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/CSP/DAY_AHEAD_Natural_Inflow.csv) contains the solar power potential of the CSP plant by hour

## HYDRO
The [`DAY_AHEAD_hydro.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/HYDRO/DAY_AHEAD_hydro.csv) contains the hydro power output for each hydro plant by hour.

The [`REAL_TIME_hydro.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/HYDRO/REAL_TIME_hydro.csv) contains the hydro power output for each hydro plant by 5-minute interval.

*NOTE: the DAY-AHEAD and REAL-TIME hydro profiles are exactly the same, just with a different number of intervals defined*

## Load
The [`DAY_AHEAD_regional_Load.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/Load/DAY_AHEAD_regional_Load.csv) contains the forecasted power demand for each of the three regions by hour.

The [`REAL_TIME_regional_load.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/Load/REAL_TIME_regional_load.csv) contains the actual power demand for each of the three regions by 5-minute interval.

To get nodal load, multiply the regional load timeseries by the proportion of the total regional load consumed at each bus defined in the [`bus.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/SourceData/bus.csv)

## PV
The [`DAY_AHEAD_pv.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/PV/DAY_AHEAD_pv.csv) contains the forecasted available energy generation for each utility scale PV plant by hour.

The [`REAL_TIME_pv.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/PV/REAL_TIME_pv.csv) contains the actual available energy generation for each utility scale PV plant by 5-minute interval.

## RTPV
The [`DAY_AHEAD_rtpv.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/RTPV/DAY_AHEAD_rtpv.csv) contains the forecasted energy generation for each rooftop PV plant by hour.

The [`REAL_TIME_rtpv.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/RTPV/REAL_TIME_rtpv.csv) contains the actual  energy generation for each rooftop PV plant by 5-minute interval.

*note, RTPV is typically not dispatchable in PCMs*

## Reserves
Day-Ahead reserve requirements are defined for the Flex_Down, Reg_Down, Spin_Up_R1, Spin_Up_R3, Flex_Up, Reg_Up, Spin_Up_R2 reserve products by region for each hour.
Real-time reserve requirements are defined for the Reg_Down, Spin_Up_R1, Spin_Up_R3, Reg_Up, Spin_Up_R2 reserve products by region for each 5-minute interval. 

## WIND
The [`DAY_AHEAD_wind.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/WIND/DAY_AHEAD_wind.csv) contains the forecasted avialable energy generation for each wind plant by hour.

The [`REAL_TIME_wind.csv`](https://github.com/GridMod/RTS-GMLC/blob/master/RTS_Data/timeseries_data_files/WIND/REAL_TIME_wind.csv) contains the actual avialable energy generation for each wind plant by 5-minute interval.
