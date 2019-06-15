#!/usr/bin/env Rscript

source(file = "/loadNamespace3.R")
loadNamespace3(package = "rcmdcheck")
message("Checking package ...")
rcmdcheck::rcmdcheck(error_on = "warning")
