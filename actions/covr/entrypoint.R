#!/usr/bin/env Rscript

message("Running test coverage ...")
loadNamespace(package = "covr", lib.loc = Sys.getenv("R_LIBS_ACTION"))
covr::codecov(quiet = FALSE, commit = "$GITHUB_SHA", branch = "$GITHUB_REF")
