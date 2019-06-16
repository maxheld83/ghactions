#!/usr/bin/env Rscript

message("Running test coverage ...")
loadNamespace(package = "withr", lib.loc = Sys.getenv("R_LIBS_ACTION"))
withr::with_libpaths(
  new = Sys.getenv("R_LIBS_ACTION"),
  code = covr::codecov(
    quiet = FALSE, 
    commit = "$GITHUB_SHA", 
    branch = "$GITHUB_REF"
  ),
  action = "suffix"
)
