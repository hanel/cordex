require(cordex)

setwd(file.path(.datadir, 'mon'))

r = brick('pr_EUR-11_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CLMcom-CCLM4-8-17.nc')

ctrl = selper(r, per = 1971:2000)
mm = monmean(ctrl)


###
setwd(file.path(.datadir, 'mon'))

d = dir()
getX = function(f, i, split = '_'){sapply(strsplit(f, split), function(x)x[i])}

d = data.table(fn = d)
d[, c('VAR', 'DOM', 'GCM', 'RCP', 'RUN', 'RCM') := .(getX(fn, 1), getX(fn, 2), getX(fn, 3), getX(fn, 4), getX(fn, 5), gsub('\\.nc', '', getX(fn, 6)))]
d[, I := 1:.N]

sez = d[RCP!='historical', .(SCEN = c('historical', RCP), fn = c(gsub(RCP, 'historical', fn) , fn), I), by = .(VAR, DOM, GCM, RCP, RUN, RCM)]

sez[, SID := paste(DOM, GCM, RCP, RUN, RCM, sep = '_')]

sez[, I:= I[1], by = SID]
sez[, I:= I - min(I) + 1]
setkey(sez, I)


setwd(file.path(.datadir))
rcm_list = fread('cordex_rcm_list.csv')

setwd('/home/hanel/r-packages/cordex/data/')
save(rcm_list, file = 'rcm_list.rda')


setwd('/home/owc/CORDEX/data/')
write.table(sez, 'cordex_rcm_list.csv', row.names = FALSE, sep = ';')
