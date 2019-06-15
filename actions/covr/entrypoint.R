#!/usr/bin/env Rscript

source(file = "/loadNamespace2.R")
loadNamespace2(package = "covr")
message("Running test coverage ...")
covr::codecov(quiet = FALSE, commit = "$GITHUB_SHA", branch = "$GITHUB_REF")
