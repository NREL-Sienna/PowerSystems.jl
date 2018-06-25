# sets wd if sourced
pacman::p_load(data.table,ggplot2)
SourceData = normalizePath(file.path('../../SourceData/'))
output.dir = normalizePath(file.path('../../FormattedData/PLEXOS/Create_PLEXOS_database/1-parse-matpower/outputs/'))
source('../../FormattedData/PLEXOS/Create_PLEXOS_database/1-parse-matpower/parse_rts.R')


# read in DA files
da.reg1 <- data.table(melt(fread("origin/APS_Promod_2020.csv",header = T),id.vars=c('Year','Month','Day'),variable.name = 'Period',variable.factor = F))
da.reg1[,Period:=as.integer(Period)]
da.reg2 <- data.table(melt(fread("origin/NEVP_Promod_2020.csv",header = T),id.vars=c('Year','Month','Day'),variable.name = 'Period',variable.factor = F))
da.reg2[,Period:=as.integer(Period)]
da.reg3 <- data.table(melt(fread("origin/LDWP_Promod_2020.csv",header = T),id.vars=c('Year','Month','Day'),variable.name = 'Period',variable.factor = F))
da.reg3[,Period:=as.integer(Period)]

# read in RT files
rt.reg1 <- data.table(melt(fread("origin/RT_APS_Promod_2020.csv",header = T),id.vars=c('Year','Month','Day'),variable.name = 'Period',variable.factor = F))
rt.reg1[,Period:=as.integer(Period)]
rt.reg2 <- data.table(melt(fread("origin/RT_NEVP_Promod_2020.csv",header = T),id.vars=c('Year','Month','Day'),variable.name = 'Period',variable.factor = F))
rt.reg2[,Period:=as.integer(Period)]
rt.reg3 <- data.table(melt(fread("origin/RT_LDWP_Promod_2020.csv",header = T),id.vars=c('Year','Month','Day'),variable.name = 'Period',variable.factor = F))
rt.reg3[,Period:=as.integer(Period)]

region.load = merge(node.data,node.lpf,by='Node')[,.(Load = sum(as.numeric(Load))),by=.(Region)]

# DA: fix columns
da.reg1[,c("Hour", "Minutes") := NULL]
da.reg1[,Period := 1:24, by = .(Year, Month, Day)]
setnames(da.reg1, "value", "1")

da.reg2[,c("Hour", "Minutes") := NULL]
da.reg2[,Period := 1:24, by = .(Year, Month, Day)]
setnames(da.reg2, "value", "2")

da.reg3[,c("Hour", "Minutes") := NULL]
da.reg3[,Period := 1:24, by = .(Year, Month, Day)]
setnames(da.reg3, "value", "3")

# DA: combine
da.load <- Reduce(function(...) merge(..., all = TRUE), 
                  list(da.reg1, da.reg2, da.reg3))

da.load[,`1`:=`1`/max(`1`)*region.load[Region==1]$Load-110] # for some reason the APS load profile seems to be shifted through some normalization... shifting back 
da.load[,`2`:=`2`/max(`2`)*region.load[Region==2]$Load]
da.load[,`3`:=`3`/max(`3`)*region.load[Region==3]$Load]



# RT: fix columns and combin
rt.reg1[,c("Hour", "Minutes") := NULL]
rt.reg1[,Period := 1:288, by = .(Year, Month, Day)]
setnames(rt.reg1, "value", "1")

rt.reg2[,c("Hour", "Minutes") := NULL]
rt.reg2[,Period := 1:288, by = .(Year, Month, Day)]
setnames(rt.reg2, "value", "2")

rt.reg3[,c("Hour", "Minutes") := NULL]
rt.reg3[,Period := 1:288, by = .(Year, Month, Day)]
setnames(rt.reg3, "value", "3")

# RT: combine
rt.load <- Reduce(function(...) merge(..., all = TRUE), 
                  list(rt.reg1, rt.reg2, rt.reg3))

rt.load[,`1`:=`1`/max(`1`)*region.load[Region==1]$Load]
rt.load[,`2`:=`2`/max(`2`)*region.load[Region==2]$Load]
rt.load[,`3`:=`3`/max(`3`)*region.load[Region==3]$Load]

# write out
write.csv(da.load, 
          "DA_hourly.csv", 
          row.names = FALSE, 
          quote = FALSE)

write.csv(rt.load, 
          "RT_5min.csv", 
          row.names = FALSE, 
          quote = FALSE)

da.load[,time:=as.POSIXct(sprintf("%4d-%2d-%2d %2d:00:00", Year, Month, Day, Period),format='%Y-%m-%d %H:%M:%S')]
da.load = melt(da.load[,.(time,`1`,`2`,`3`)],id.vars = 'time',variable.name = 'Region')
rt.load[,time:=as.POSIXct(sprintf("%4d-%2d-%2d 00:00:00", Year, Month, Day),format='%Y-%m-%d %H:%M:%S')+300*Period]
rt.load = melt(rt.load[,.(time,`1`,`2`,`3`)],id.vars = 'time',variable.name = 'Region')

p = ggplot() + geom_line(data=da.load, aes(x=time,y=value),color='blue',alpha=0.6) +
  geom_line(data=rt.load, aes(x=time,y=value),color='red',alpha = 0.6) + 
  facet_grid('Region~.')
ggsave(file='DA_RT_regional_load.png',p)
