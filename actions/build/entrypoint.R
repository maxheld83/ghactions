#!/usr/bin/env Rscript

message("Building package ...")
loadNamespace(package = "pkgbuild", lib.loc = Sys.getenv("R_LIBS_ACTION"))
pkgbuild::build(dest_path = ".")
