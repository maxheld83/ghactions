#!/usr/bin/env Rscript

source(file = "/loadNamespace2.R")
loadNamespace2(package = "roxygen2")
loadNamespace2(package = "ghactions")
message("Checking for consistency of roxygen2 with `man` ...")
ghactions::document()
