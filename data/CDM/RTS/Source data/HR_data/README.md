# SourceData/HR_data contents

Final_Fits.csv - source of mined heat rates

Fit_HRs.R - script which extracts heat rates from Final_Fits.csv and adds them to model

# Procedure

1) Random number seed ensures that heat rates are reproducible

2) Uses Final_Fits.csv coefficients a0 - a4 to get following for all generators
    a) an average heat rate at min stable level
    b) an incremental heat rate at MSL + 33%, MSL + 66% and max capacity

3) Filters out non-convex heat rates

4) Creates 'category' column in gen.csv and Final_Fits.csv to match generators

5) Matches heat rates to RTS generators using random number seed by c('Bus ID','Unit Group','category')

6) Adjust gen.csv load points to MSL, MSL + 33%, MSL + 66% and max capacity

7) Manually sets solar, wind, CSP, hydro, nuclear (10,000 BTU / kWh) heat rates

8) Rounds new heat rates 