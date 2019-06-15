#!/usr/bin/env Rscript

source(file = "/loadNamespace3.R")
loadNamespace3(package = "pkgdown")
message("Building package website...")
pkgdown::build_site(override = list(devel = FALSE, external = FALSE))
