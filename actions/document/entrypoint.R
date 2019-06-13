#!/usr/bin/env Rscript

message("Checking for consistency of roxygen2 with `man` ...")
# TODO don't understand why brew needs to be loaded, but it has to.
# see https://github.com/r-lib/ghactions/issues/254
loadNamespace(package = "brew", lib.loc = Sys.getenv("R_LIBS_ACTION"))
loadNamespace(package = "roxygen2", lib.loc = Sys.getenv("R_LIBS_ACTION"))
loadNamespace(package = "ghactions", lib.loc = Sys.getenv("R_LIBS_ACTION"))
ghactions::document()
