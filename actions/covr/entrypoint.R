#!/usr/bin/env Rscript

message("Running test coverage ...")
covr::codecov(
  quiet = FALSE, 
  commit = "$GITHUB_SHA", 
  branch = "$GITHUB_REF"
)
