# Quick Start Guide

This section is still under development. Please visit [PowerSystems.jl Intro](https://nbviewer.jupyter.org/github/NREL-SIIP/SIIPExamples.jl/blob/master/notebook/PowerSystems_examples/PowerSystems_intro.ipynb) in the mean time.

## Definitions to work with Time Series Data

The bulk of the data in many power system models is time series data, in order to
organize the data the potential inherent complexity, `PowerSystems.jl` has a set of definitions
to enable consistent modeling.

- **Resolution**: The period of time between each discrete value in the data, all resolutions
are represented using `Dates.Period` types. For instance, a Day-ahead market data set usually
has a resolution of `Hour(1)`, a Real-Time market data set usually has a resolution of `Minute(5)`

- **Static data**: a single column of time series values for a component field
(such as active power) where each time period is represented by a single value.
This data commonly is obtained from historical information or the realization of
a time-varying quantity.

This cateogory of Time Series data usually comes in the following format:

| DateTime            | Value |
|---------------------|:-----:|
| 2020-09-01T00:00:00 | 100.0 |
| 2020-09-01T01:00:00 | 101.0 |
| 2020-09-01T02:00:00 |  99.0 |

Where a column (or several columns) represent the timestamp associated with the value and
a column stores the values of interest.

- **Forecasts**: Predicted values of a time-varying quantity that commonly features
a look-ahead and can have multiple data values representing each time period.
This data is used in simulation with receding horizons or data generated from
forecasting algorithms.

Forecast data usually comes in the following format:

| DateTime            |   0   | 1     | 2     | 3    | 4     | 5     | 6     | 7     |
|---------------------|:-----:|-------:|:-------:|:------:|:-------:|:-------:|:-------:|:-------|
| 2020-09-01T00:00:00 | 100.0 | 101.0 | 101.3 | 90.0 | 98.0  | 87.0  | 88.0  | 67.0  |
| 2020-09-01T01:00:00 | 101.0 | 101.3 | 99.0  | 98.0 | 88.9  | 88.3  | 67.1  | 89.4  |
| 2020-09-01T02:00:00 |  99.0 | 67.0  | 89.0  | 99.9 | 100.0 | 101.0 | 112.0 | 101.3 |

Where a column (or several columns) represent the time stamp associated with the initial
time of the forecast, and the columns represent the forecasted values.

- **Interval**: The period of time between forecasts initial times. In `PowerSystems.jl` all
intervals are represented using `Dates.Period` types. For instance, in a Day-Ahead market
simulation, the interval of the time series is usually `Hour(24)`, in the example above, the
interval is `Hour(1)`.

- **Horizon**: Is the count of discrete forecasted values, all horizons in `PowerSystems.jl`
are represented with `Int`. For instance, many Day-ahead markets will have a forecast with a
horizon 24.

- **Forecast window**: Represents the forecasted value starting at a particular initial time.

Currently `PowerSystems.jl` does not support Forecasts or SingleTimeSeries with disimilar
intervals or resolution.
