#' Načte globální cesty
#'
#' @description Načte proměnné \code{.datadir} (synchronizovaná owncloud složka "used_data" z BILAN_UPOV) a \code{.workdir} (zatím nevyužito) na základě jména počítače. Před použitím je nutné PC registrovat - buď úpravou kódu na githubu nebo emailem na \email{hanel@fzp.czu.cz} ve struktuře
#' \preformatted{
#' jmeno_PC = {
#'   .datadir = 'cesta do used_data'
#'   .workdir = 'pracovni cesta'
#' }
#' }
#'
#' @usage give_paths
#' @return Přiřadí do \code{.GlobalEnv} proměnné \code{.datadir}, \code{.workdir} a \code{.where}
#' @export give_paths
give_paths <- function(){
where <- if(.Platform[["OS.type"]] == 'unix') (Sys.info()['nodename']) else (Sys.getenv('COMPUTERNAME'))

switch(where,
         'match' = {
           .datadir = "/home/owc/CORDEX/data/"
           .workdir = ""
         }
)

  if (is.null(.datadir)) {
    .datadir = NA
    warning('Pocitac ', where, 'nenalezen v environment.R - data nedostupna!\n Uprav environment.R a push na github.com/hanel/cordex')
    }

  if (is.null(.workdir)) {
    .workdir = getwd()
    warning('Pocitac ', where, 'nenalezen v environment.R - pracovni adresar nastaven automaticky!')
  }

  assign('.datadir', .datadir, envir = .GlobalEnv)
  assign('.workdir', .workdir, envir = .GlobalEnv)
  assign('.where', where, envir = .GlobalEnv)
}



.onLoad <- function(libname, pkgname) {

  op <- options()
  op.cordex <- list(
    'ref_period' = as.Date(c('1981-01-01', '2010-12-31'))
  )
  toset <- !(names(op.cordex) %in% names(op))
  if(any(toset)) options(op.cordex[toset])

  give_paths()
  invisible()
}

