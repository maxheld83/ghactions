#!/usr/bin/env Rscript

source(file = "/loadNamespace2.R")
loadNamespace2(package = "rcmdcheck")
message("Checking package ...")
rcmdcheck::rcmdcheck(error_on = "warning")
