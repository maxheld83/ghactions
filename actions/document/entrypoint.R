#!/usr/bin/env Rscript

source(file = "/loadNamespace3.R")
loadNamespace3(package = "roxygen2")
loadNamespace3(package = "ghactions")
message("Checking for consistency of roxygen2 with `man` ...")
ghactions::document()
