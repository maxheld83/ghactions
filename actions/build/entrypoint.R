#!/usr/bin/env Rscript

source(file = "/loadNamespace3.R")
loadNamespace3(package = "pkgbuild")
message("Building package ...")
pkgbuild::build(dest_path = ".")
