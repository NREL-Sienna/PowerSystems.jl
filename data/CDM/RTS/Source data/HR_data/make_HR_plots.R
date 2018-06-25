

setwd('//plexossql/Data/bmcbenne/RTS-GMLC/RTS_Data/SourceData')


# -------------------------------------------------------------------------|
## HR analysis - average
# -------------------------------------------------------------------------|

library('data.table')
library(ggplot2)

gen = fread('gen.csv')

hr = gen[,.SD,.SDcols = c(names(gen)[grep('HR_',names(gen))],names(gen)[grep('Output_pct',names(gen))],'Unit Group','GEN UID',
                          'Category','PMax MW')]

hr = hr[grepl('Oil|Coal|Gas|Nuclear',Category)]

hr[,Output_pct_3:=as.numeric(Output_pct_3)]

hr[,Band_0:=Output_pct_0*`PMax MW`]
hr[,Band_1:=Output_pct_1*`PMax MW`]
hr[,Band_2:=Output_pct_2*`PMax MW`]
hr[,Band_3:=Output_pct_3*`PMax MW`]

hr[,Avrg_0:=as.numeric(HR_avg_0)]
hr[,Avrg_1:=(Band_0 * Avrg_0 + (Band_1 - Band_0)*(HR_incr_1))/Band_1]
hr[,Avrg_2:=(Band_1 * Avrg_1 + (Band_2 - Band_1)*(HR_incr_2))/Band_2]
hr[,Avrg_3:=(Band_2 * Avrg_2 + (Band_3 - Band_2)*(HR_incr_3))/Band_3]

# average
hr.avg = data.table(melt(hr, id.vars = c('Unit Group','PMax MW','GEN UID','Category'),
                                   measure.vars = c(names(hr)[grep('Avrg_',names(hr))],
                                                    names(hr)[grep('Output_pct_',names(hr))]
                                                    )))


hr.avg.HR = hr.avg[grepl('Avrg',variable),.(`Unit Group`,`PMax MW`,`GEN UID`,
                                Category,variable,
                                HR_value = value)]

hr.avg.HR[,variable:=gsub('.*_([0-9]+).*','\\1',variable)]

hr.avg.Band = hr.avg[grepl('Output',variable),.(`Unit Group`,`PMax MW`,`GEN UID`,
                                          Category,variable,
                                          Output_value = value)]

hr.avg.Band[,variable:=gsub('.*_([0-9]+).*','\\1',variable)]

hr.avg = merge(hr.avg.HR,hr.avg.Band,by=c('Unit Group','PMax MW','GEN UID','Category','variable'))

setnames(hr.avg,c('variable'),c('Band'))


p <- ggplot(hr.avg,aes(x = 100*Output_value,y = HR_value)) + geom_path(aes(color = `GEN UID`)) + 
    facet_wrap(~Category,scales = 'free') + labs(x = 'Output percent',y = 'BTU / kWh') + 
  theme(legend.position = 'none')


ggsave('RTS_average_HR.png',p,height = 4, width = 6.5)

# -------------------------------------------------------------------------|
## HR analysis - marginal
# -------------------------------------------------------------------------|

library('data.table')
library(ggplot2)

gen = fread('gen.csv')

hr = gen[,.SD,.SDcols = c(names(gen)[grep('HR_',names(gen))],names(gen)[grep('Output_pct',names(gen))],'Unit Group','GEN UID',
                          'Category','PMax MW')]

hr = hr[grepl('Oil|Coal|Gas|Nuclear',Category)]

hr[,Output_pct_3:=as.numeric(Output_pct_3)]

hr[,Output_pct_1:=(Output_pct_0 + Output_pct_1)/2]
hr[,Output_pct_2:= (Output_pct_1 + Output_pct_2)/2]
hr[,Output_pct_3:= (Output_pct_2 + Output_pct_3)/2]
hr[,Output_pct_0:=NULL]
hr[,HR_incr_1:=as.numeric(HR_incr_1)]
hr[,HR_incr_2:=as.numeric(HR_incr_2)]
hr[,HR_incr_3:=as.numeric(HR_incr_3)]


hr.incr = data.table(melt(hr, id.vars = c('Unit Group','PMax MW','GEN UID','Category'),
                         measure.vars = c(names(hr)[grep('HR_incr_',names(hr))],
                                          names(hr)[grep('Output_pct_',names(hr))]
                         )))

hr.incr.HR = hr.incr[grepl('incr',variable),.(`Unit Group`,`PMax MW`,`GEN UID`,
                                            Category,variable,
                                            HR_value = value)]

hr.incr.HR[,variable:=gsub('.*_([0-9]+).*','\\1',variable)]

hr.incr.Band = hr.incr[grepl('Output',variable),.(`Unit Group`,`PMax MW`,`GEN UID`,
                                                Category,variable,
                                                Output_value = value)]

hr.incr.Band[,variable:=gsub('.*_([0-9]+).*','\\1',variable)]

hr.incr = merge(hr.incr.HR,hr.incr.Band,by=c('Unit Group','PMax MW','GEN UID','Category','variable'))

setnames(hr.incr,c('variable'),c('Band'))

p <- ggplot(hr.incr,aes(x = 100*Output_value,y = HR_value)) + geom_path(aes(color = `GEN UID`)) + 
  facet_wrap(~Category,scales = 'free') + labs(x = 'Output percent',y = 'BTU / kWh') + 
  theme(legend.position = 'none')


ggsave('RTS_incremental_HR.png',p,height = 4, width = 6.5)

#####



hr = melt(hr, id.vars = c('Unit Group','PMax MW','GEN UID','Category'))
hr[,Band:= gsub('.*_([0-9]+).*','\\1',variable)]
hr[,variable:= gsub('(.*)_[0-9]+.*','\\1',variable)]
hr[variable=='Output_pct', value:=value*`PMax MW`]
hr = unique(hr)

hr =dcast.data.table(hr, `Unit Group`+Band~variable,fun.aggregate = mean)

ggplot(hr)+ geom_path(aes(x=Output_pct,y=Inc_Heat_Rate,color=`Unit Group`))+ xlab('Output MW')

ggplot(hr[`Unit Group` %in% c('U55','U355')])+ geom_path(aes(x=Output_pct,y=Inc_Heat_Rate,color=`Unit Group`)) + xlab('Output MW')


nhr = gen[,.SD,.SDcols = c(names(gen)[grep('Net_Heat_Rate',names(gen))],names(gen)[grep('Output_pct',names(gen))],'Unit Group','PMax MW')]
nhr = melt(nhr, id.vars = c('Unit Group','PMax MW'))
nhr[,Band:= gsub('.*_([0-9]+).*','\\1',variable)]
nhr[,variable:= gsub('(.*)_[0-9]+.*','\\1',variable)]
nhr[variable=='Output_pct', value:=value*`PMax MW`]
nhr = unique(nhr)

nhr =dcast.data.table(nhr, `Unit Group`+Band~variable,fun.aggregate = mean)

ggplot(nhr)+ geom_path(aes(x=Output_pct,y=Net_Heat_Rate,color=`Unit Group`))

ggplot(nhr[`Unit Group` != 'U50'])+ geom_path(aes(x=Output_pct,y=Net_Heat_Rate,color=`Unit Group`)) + xlab('Output MW')

ahr = gen[,.SD,.SDcols = c(names(gen)[grep('HR_incr',names(gen))],names(gen)[grep('Output_pct',names(gen))],'Unit Group','PMax MW')]
ahr = melt(ahr, id.vars = c('Unit Group','PMax MW'))
ahr[,Band:= gsub('.*_([0-9]+).*','\\1',variable)]
ahr[,variable:= gsub('(.*)_[0-9]+.*','\\1',variable)]
ahr[variable=='Output_pct', value:=value*`PMax MW`]
ahr = unique(ahr)

ahr =dcast.data.table(ahr, `Unit Group`+Band~variable,fun.aggregate = mean)

ggplot(ahr)+ geom_path(aes(x=Output_pct,y=Net_Heat_Rate,color=`Unit Group`))

ggplot(nhr[`Unit Group` != 'U50'])+ geom_path(aes(x=Output_pct,y=Net_Heat_Rate,color=`Unit Group`)) + xlab('Output MW')
gc = fread('../FormattedData/MATPOWER/tmp_Gc.csv',header = F)
gc = gc[,.(Output_MW_0 = V5, Cost_0=V6,Output_MW_1 = V7, Cost_1=V8,Output_MW_2 = V9, Cost_2=V10)]
gc = unique(gc)
gc[,gennum:=as.numeric(row.names(gc))]
gc = melt(gc,id.vars = 'gennum')
gc[,Band:= gsub('.*_([0-9]+).*','\\1',variable)]
gc[,variable:= gsub('(.*)_[0-9]+.*','\\1',variable)]
gc =dcast.data.table(gc, gennum+Band~variable,fun.aggregate = mean)
gc[,Cost:=Cost/Output_MW]
gc= gc[gennum %in% gc[Band==2 & Cost>0,]$gennum,]

ggplot(gc) + geom_path(aes(x=Output_MW,y=Cost,color=as.character(gennum))) + ylab('$/MWh')