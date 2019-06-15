#!/usr/bin/env Rscript

source(file = "/loadNamespace2.R")
loadNamespace2(package = "pkgbuild")
message("Building package ...")
pkgbuild::build(dest_path = ".")
