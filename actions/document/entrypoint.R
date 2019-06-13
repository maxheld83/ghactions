#!/usr/bin/env Rscript

message("Checking for consistency of roxygen2 with `man` ...")
loadNamespace(package = "ghactions", lib.loc = Sys.getenv("R_LIBS_ACTION"))
loadNamespace(package = "roxygen2", lib.loc = Sys.getenv("R_LIBS_ACTION"))
ghactions::document()
