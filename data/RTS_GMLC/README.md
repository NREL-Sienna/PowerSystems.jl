# SourceData

This folder contains six CSV files wit all RTS-GMLC (non-timeseries) data and problem formulation parameters, the contents of each file follow. Timeseries data can be found [here](https://github.com/GridMod/RTS-GMLC/tree/master/RTS_Data/timeseries_data_files).


## `bus.csv`

| Column       | Description                       |
|--------------|-----------------------------------|
| Bus ID       | Numeric Bus ID                    |
| Bus Name     | Bus name from RTS-96              |
| BaseKV       | Bus voltage rating                |
| Bus Type     | Bus control type                  |
| MW Load      | Real power demand                 |
| MVAR Load    | Reactive power demand             |
| V Mag        | Voltage magnitude setpoint        |
| V Angle      | Voltage angle setpoint in degrees |
| MW Shunt G   | Shunt conductance                 |
| MVAR Shunt B | Shunt susceptance                 |
| Area         | Area membership                   |
| Sub Area     | Sub area membership               |
| Zone         | Zone membership                   |
| lat          | Bus latitude location             |
| lng          | Bus longitude location            |


## `branch.csv`

| Column       | Description                           |
|--------------|---------------------------------------|
| ID           | Unique branch ID                      |
| From Bus     | From Bus ID                           |
| To Bus       | To Bus ID                             |
| R            | Branch resistance p.u.                |
| X            | Branch reactance p.u.                 |
| B            | Branch line charging susceptance p.u. |
| Cont Rating  | Continuous MW flow limit              |
| LTE Rating   | Long term MW flow limit               |
| STE Rating   | Short term MW flow limit              |
| Perm OutRate | Outage rate                           |
| Duration     | Mean outage duration (hrs)            |
| Tr Ratio     | Transformer winding ratio             |
| Tran OutRate | Transformer outage rate               |
| Length       | Line length (mi)                      |


## `gen.csv`

| Column                   | Description                                                      |
|--------------------------|------------------------------------------------------------------|
| GEN UID                  | Unique generator ID: Concatenated from Bus ID_Unit Type_Gen ID   |
| Bus ID                   | Connection Bus ID                                                |
| Gen ID                   | Index of generator units at each bus                             |
| Unit Group               | RTS-96 unit group definition                                     |
| Unit Type                | Unit Type                                                        |
| Fuel                     | Unit Fuel                                                        |
| MW Inj                   | Real power injection setpoint                                    |
| MVAR Inj                 | Reactive power injection setpoint                                |
| V Setpoint p.u.          | Voltage magnitude setpoint                                       |
| PMax MW                  | Maximum real power injection (Unit Capacity)                     |
| PMin MW                  | Minimum real power injection (Unit minimum stable level)         |
| QMax MVAR                | Maximum reactive power injection                                 |
| QMin MVAR                | Minimum reactive power injection                                 |
| Min Down Time Hr         | Minimum off time required before unit restart                    |
| Min Up Time Hr           | Minimum on time required before unit shutdown                    |
| Ramp Rate MW/Min         | Maximum ramp up and ramp down rate                               |
| Start Time Cold Hr       | Time required to startup from cold                               |
| Start Time Hot Hr        | Time required to startup from hot                                |
| Start Time Warm Hr       | Time required to startup from warm                               |
| Start Heat Cold MBTU     | Heat required to startup from cold                               |
| Start Heat Hot MBTU      | Heat required to startup from hot                                |
| FOR                      | Forced outage rate                                               |
| MTTF Hr                  | Meant time to forced outage                                      |
| MTTR Hr                  | Mean time to repair forced outage                                |
| Scheduled Maint Weeks    | Scheduled outages per year                                       |
| Fuel Price $/MMBTU       | Fuel price                                                       |
| Output_pct_0             | Output point 0 on heat rate curve as a percentage of PMax        |
| Output_pct_1             | Output point 1 on heat rate curve as a percentage of PMax        |
| Output_pct_2             | Output point 2 on heat rate curve as a percentage of PMax        |
| Output_pct_3             | Output point 3 on heat rate curve as a percentage of PMax        |
| HR_Avg_0                 | Average heat rate between 0 and output point 0 in BTU/kWh        |
| HR_Incr_1                | Incremental heat rate between output points 0 and 1 in BTU/kWh   |
| HR_Incr_2                | Incremental heat rate between output points 1 and 2 in BTU/kWh   |
| HR_Incr_3                | Incremental heat rate between output points 2 and 3 (PMax) in BTU/kWh           |
| Fuel Sulfur Content %    | Fuel Sulfur Content                                              |
| Emissions SO2 Lbs/MMBTU  | SO2 Emissions Rate                                               |
| Emissions NOX Lbs/MMBTU  | NOX Emissions Rate                                               |
| Emissions Part Lbs/MMBTU | Particulate Matter Emissions Rate                                |
| Emissions CO2 Lbs/MMBTU  | CO2 Emissions Rate                                               |
| Emissions CH4 Lbs/MMBTU  | CH4 Emissions Rate                                               |
| Emissions N2O Lbs/MMBTU  | N2O Emissions Rate                                               |
| Emissions CO Lbs/MMBTU   | CO Emissions Rate                                                |
| Emissions VOCs Lbs/MMBTU | VOC Emissions Rate                                               |
| Damping Ratio            | Damping coefficient of swing equation                            |
| Inertia MJ/MW            | Unit rotor inertia                                               |
| Base MVA                 | Unit equivalent circuit BaseMVA                                  |
| Transformer X p.u.       | Unit transformer reactance p.u.                                  |
| Unit X p.u.              | Unit reactance p.u.                                              |


## `dc_branch.csv`

| Column   | Description        |
|----------|--------------------|
| Category | Data category      |
| Variable | Data variable name |
| Filter   | Data qualifier     |
| Value    | Value              |


## `simulation_objects.csv`

| Column                | Description               |
|-----------------------|---------------------------|
| Simulation_Parameters | Simulation parameter name |
| Description           | Description               |


## `timeseries_pointers.csv`

| Column     | Description                                                                                |
|------------|--------------------------------------------------------------------------------------------|
| Simulation | Simulation name                                                                            |
| Object     | Unique generator ID: Concatenated from Bus ID_Unit Type_Gen ID, or other object ID/name    |
| Parameter  | Parameter from gen.csv columns                                                             |
| Data File  | pointer to datafile with timeseries values (must be consistent with simulation resolution) |

## `storage.csv`
| Column          | Description                                     |
|-----------------|-------------------------------------------------|
| GEN UID         | Gen ID associated with storage                  |
| Storage         | Storage object name                             |
| Max Volume GWh  | Energy storage capacity                         |

## `reserves.csv`
| Column              | Description                                     |
|---------------------|-------------------------------------------------|
| Reserve Product     | Reserve product name                            |
| Timeframe (sec)     | Response time to satisfy reserve requirement    |
| Eligible Gen Types  | Parameter from gen.csv columns                  |
