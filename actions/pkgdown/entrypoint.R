#!/usr/bin/env Rscript

source(file = "/loadNamespace2.R")
loadNamespace2(package = "pkgdown")
message("Building package website...")
pkgdown::build_site(override = list(devel = FALSE, external = FALSE))
