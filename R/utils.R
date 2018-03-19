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

year = function(...){
  UseMethod('year')
}

year.default = data.table::year

year.RasterBrick = function(x) {
  hasDate(x)
  year(x@z[[1]])
}

monmean = function(x){
  
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



