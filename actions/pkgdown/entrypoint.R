#!/usr/bin/env Rscript

message("Building package website...")
loadNamespace(package = "withr", lib.loc = Sys.getenv("R_LIBS_ACTION"))
withr::with_libpaths(
  new = Sys.getenv("R_LIBS_ACTION"),
  code = pkgdown::build_site(override = list(devel = FALSE, external = FALSE)),
  action = "suffix"
)
