#!/usr/bin/env Rscript

source(file = "/loadNamespace2.R")
loadNamespace2(package = "devtools")
message("Installing package ...")
devtools::install()
