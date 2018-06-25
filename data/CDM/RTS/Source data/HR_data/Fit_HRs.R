
library(data.table)
setwd(dirname(parent.frame(2)$ofile))

set.seed(2716) # Keep at 2716. Or else HRs will be different every time. 
# ---------------------------------------------------------------------------------|
# make new heat rates
# ---------------------------------------------------------------------------------|

final.fits = fread('Final_Fits.csv')

# calculate average heat rate at min stable level and three marginal heat rate points thereafter
final.fits[,load_33:=load_min + (1/3)*(load_max-load_min)]
final.fits[,load_66:=load_min + (2/3)*(load_max-load_min)]

final.fits[,HR_avg_0:=a0+a1*load_min+a2*load_min^2+a3*load_min^3+a4*load_min^4]

final.fits[,HR_incr_1:=(load_33*(a0+a1*load_33+a2*load_33^2+a3*load_33^3+a4*load_33^4)-
                               load_min*(a0+a1*load_min+a2*load_min^2+a3*load_min^3+a4*load_min^4))/
             (load_33-load_min)]

final.fits[,HR_incr_2:=(load_66*(a0+a1*load_66+a2*load_66^2+a3*load_66^3+a4*load_66^4)-
                               load_33*(a0+a1*load_33+a2*load_33^2+a3*load_33^3+a4*load_33^4))/
             (load_66-load_33)]

final.fits[,HR_incr_3:=(load_max*(a0+a1*load_max+a2*load_max^2+a3*load_max^3+a4*load_max^4)-
                               load_66*(a0+a1*load_66+a2*load_66^2+a3*load_66^3+a4*load_66^4))/
             (load_max-load_66)]

# remove data which is not fitted or not convex
final.fits.filter = final.fits[!is.na(a0)]
final.fits.filter = final.fits.filter[source == 'Fit']
final.fits.filter = final.fits.filter[HR_incr_1 <= HR_incr_2 & 
                                        HR_incr_2 <= HR_incr_3 &
                                        HR_incr_1 > 0]


# define category column to match RTS generators to heat rate curves
final.fits.filter[group_type == 'Boiler (Coal)',category:='Coal Steam']
final.fits.filter[group_type == 'Boiler (Diesel Oil)',category:='Oil Steam']
final.fits.filter[group_type == 'Combustion turbine (Diesel Oil)',category:='Oil CT']
final.fits.filter[group_type == 'Combined cycle (Natural Gas)',category:='NG CC']
final.fits.filter[group_type == 'Combustion turbine (Natural Gas)',category:='NG CT']
final.fits.filter = final.fits.filter[!is.na(category)]

gen = fread('../gen.csv')
HR.cols = c('HR_avg_0','HR_incr_1','HR_incr_2','HR_incr_3')
gen[,c(HR.cols):=0]
gen[,c(HR.cols):=NULL]

gen.noHR = gen[!grepl('Coal|Oil|Gas',Category)]

gen = gen[grepl('Coal|Oil|Gas',Category)]
gen[Fuel == 'Oil'&`Unit Type`=='STEAM',category:= 'Oil Steam']
gen[Fuel == 'Oil'&`Unit Type`=='CT',category:= 'Oil CT']
gen[Fuel == 'NG'&`Unit Type`=='CT',category:= 'NG CT']
gen[Fuel == 'NG'&`Unit Type`=='CC',category:= 'NG CC']
gen[Fuel == 'Coal'&`Unit Type`=='STEAM',category:= 'Coal Steam']

# HR-specific generator groups
HR.sampler = unique(gen[,.(`Bus ID`,`Unit Group`,category)])

HR.sampler = merge(HR.sampler,final.fits.filter[,.(category,HR_avg_0,HR_incr_1,HR_incr_2,HR_incr_3)],
                   by=c('category'),all = TRUE,allow.cartesian = TRUE)

# take random sample
HR.sampler[,random:=runif(.N,-1,1)]
HR.sampler[,max.random:=max(random),by=c('Bus ID','Unit Group','category')]
HR.sampler = HR.sampler[random == max.random]
HR.sampler[,c('random','max.random'):=NULL]

# merge back into gen
gen = merge(gen,HR.sampler,by=c('Bus ID','Unit Group','category'))

# adjust load bands
gen[,Output_pct_0:= `PMin MW`/`PMax MW`]
gen[,Output_pct_1:= (`PMin MW` + (1/3)*(`PMax MW`-`PMin MW`)) / `PMax MW`]
gen[,Output_pct_2:= (`PMin MW` + (2/3)*(`PMax MW`-`PMin MW`)) / `PMax MW`]
gen[,Output_pct_3:= 1]

# cols.to.delete = names(gen)[grepl('Inc_Heat_Rate|Net_Heat_Rate',names(gen))]
# gen[,c(cols.to.delete,'category'):=NULL]
gen[,category:=NULL]

# take care of wind, solar, CSP, hydro, Nuclear and Sync_Cond

gen.noHR[Category == 'Nuclear',Output_pct_0:= `PMin MW`/`PMax MW`]
gen.noHR[Category == 'Nuclear',Output_pct_1:= (`PMin MW` + (1/3)*(`PMax MW`-`PMin MW`))/`PMax MW`]
gen.noHR[Category == 'Nuclear',Output_pct_2:= (`PMin MW` + (2/3)*(`PMax MW`-`PMin MW`))/`PMax MW`]
gen.noHR[Category == 'Nuclear',Output_pct_3:= 1]
gen.noHR[Category == 'Nuclear',c(HR.cols):=10000] # hard coded

gen.noHR[Category == 'Wind'|Category == 'Solar'|Category == 'Sync_Cond'|Category == 'CSP'|Category == 'Storage',
          c(HR.cols):=0]

gen.noHR[Category == 'Hydro',
          c(HR.cols):=0]
gen.noHR[Category == 'Hydro',HR_avg_0:=3412] # hard coded

# gen.noHR[,c(cols.to.delete):=NULL]

# combine modified and non-modified heat rates
gen.newHR = rbind(gen,gen.noHR)

# change units to mmBTU / kWh
gen.newHR = gen.newHR[grepl('Coal|Oil|NG',Fuel),c(HR.cols):=lapply(.SD,function(x) x*1000),
                      .SDcols = c(HR.cols)]
gen.newHR = gen.newHR[!grepl('Coal|Oil|NG',Fuel),c(HR.cols):=lapply(.SD,function(x) x),
                      .SDcols = c(HR.cols)]

# round
output.cols = c('Output_pct_0','Output_pct_1','Output_pct_2','Output_pct_3')

# gen.newHR = gen.newHR[,c(output.cols):=lapply(.SD,function(x) round(x,3)),.SDcols = c(output.cols)]
gen.newHR = gen.newHR[,c(HR.cols):=lapply(.SD,function(x) round(x)),.SDcols = c(HR.cols)]

# return to old column order
col.order = c('GEN UID','Bus ID','Gen ID','Unit Group','Unit Type','Category','Fuel')
setcolorder(gen.newHR,c(col.order,
                        names(gen.newHR)[!names(gen.newHR)%in%col.order]))

write.csv(gen.newHR,'../gen.csv',row.names = FALSE)
