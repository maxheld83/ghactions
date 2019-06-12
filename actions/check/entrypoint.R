#!/usr/bin/env Rscript
message("Checking package ...")

loadNamespace(package = "rcmdcheck", lib.loc = Sys.getenv("R_LIBS_ACTION"))
rcmdcheck::rcmdcheck(error_on = "warning")
