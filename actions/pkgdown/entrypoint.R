#!/usr/bin/env Rscript

message("Building package website...")
pkgdown::build_site(override = list(devel = FALSE, external = FALSE))
