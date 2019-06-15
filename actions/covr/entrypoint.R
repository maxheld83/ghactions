#!/usr/bin/env Rscript

source(file = "/loadNamespace3.R")
loadNamespace3(package = "covr")
message("Running test coverage ...")
covr::codecov(quiet = FALSE, commit = "$GITHUB_SHA", branch = "$GITHUB_REF")
