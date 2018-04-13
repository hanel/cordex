library(cordex)
require(magrittr)

data(rcm_list)

setwd(file.path(.datadir, 'mon'))

ctr = list('1975' = 1961:1990, '1985' = 1971:2000, '1990' = 1980:2005)

scen = list()

for (s in seq(2035, 2085, by = 10)){
  scen[[as.character(s)]] = seq(s - 14, s + 15)
}

ct = '1975'
sc = '2035'
i = 1

for (ct in names(ctr)){

  dir.create(file.path(.datadir, ct))
  
  for (sc in names(scen)){
    
    dir.create(file.path(.datadir, ct, sc))

    for (i in rcm_list[, unique(I)]){

      cat(rcm_list[I==i, SID[1]], '\n')
      setwd(file.path(.datadir, ct, sc))
      if (file.exists(rcm_list[I==i & VAR == 'pr' & SCEN != 'historical', fn]) & file.exists(rcm_list[I==i & VAR == 'tas' & SCEN != 'historical', fn])) next ()
      
      setwd(file.path(.datadir, 'mon'))
      
      pr_hist = brick(rcm_list[I==i & VAR == 'pr' & SCEN == 'historical', fn]) %>% selper(ctr[[ct]]) %>% monmean()
      pr_scen = brick(rcm_list[I==i & VAR == 'pr' & SCEN != 'historical', fn]) %>% selper(scen[[sc]]) %>% monmean()
      tas_hist = brick(rcm_list[I==i & VAR == 'tas' & SCEN == 'historical', fn]) %>% selper(ctr[[ct]]) %>% monmean()
      tas_scen = brick(rcm_list[I==i & VAR == 'tas' & SCEN != 'historical', fn]) %>% selper(scen[[sc]]) %>% monmean()
    
      if (any(is.null(pr_hist), is.null(pr_scen), is.null(tas_hist), is.null(tas_scen))) next()
      
      del_pr = pr_scen/pr_hist
      del_tas = tas_scen - tas_hist
      
      setwd(file.path(.datadir, ct, sc))
      
      writeRaster(del_pr, rcm_list[I==i & VAR == 'pr' & SCEN != 'historical', fn], overwrite = TRUE)
      writeRaster(del_tas, rcm_list[I==i & VAR == 'tas' & SCEN != 'historical', fn], overwrite = TRUE)
      
    }
    
  }
    
}


setwd('/home/owc/CORDEX/data/1975/2085/')
rcm_list[, FULL21 := fn %in% dir()]
rcm_list[, FULL21 := any(FULL21), by = SID]

setwd('/home/hanel/r-packages/cordex/data/')
save(rcm_list, file = 'rcm_list.rda')
