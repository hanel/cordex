require(cordex)

setwd(file.path(.datadir, 'mon'))

r = brick('pr_EUR-11_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_CLMcom-CCLM4-8-17.nc')

ctrl = selper(r, per = 1971:2000)
mm = monmean(ctrl)
