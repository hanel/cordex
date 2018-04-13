hasDate = function(x){
  if (!inherits(x, 'Raster') ) stop(parse(text = x), ' is not a raster object.')
  if (is.null(x@z)) stop(parse(text = x), 'does not have z dimension.')
}

month = function(...){
  UseMethod('month')
}

month.default = data.table::month

month.RasterBrick = function(x) {
  hasDate(x)
  month(x@z[[1]])
}

month.RasterStack = month.RasterBrick

year = function(...){
  UseMethod('year')
}

year.default = data.table::year

year.RasterBrick = function(x) {
  hasDate(x)
  year(x@z[[1]])
}

monmean = function(x){
  
  if (is.null(x)) return(NULL)
  
  hasDate(x)
  mon = month(x)
  
  R = list()
  for (i in 1:12){
    rr = x[[which(mon == i)]]
    R[[i]] = mean(rr)
  }
  R = brick(R)
  R@z = list(1:12)
  names(R) = month.abb
  R
}

selper = function(x, per){
  
  y = year(x)
  if (length(which(y %in% per)) == 0) return(NULL)
  px = x[[which(y %in% per)]]
  px@z = list(Date = x@z[[1]][(y %in% per)])
 # names(px) = as.character(y[(y %in% per)])
  px
  
}
