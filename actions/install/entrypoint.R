#!/usr/bin/env Rscript

message("Installing package ...")

loadNamespace(package = "devtools", lib.loc = Sys.getenv("R_LIBS_ACTION"))
devtools::install()
