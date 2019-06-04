#!/usr/bin/env Rscript

message("Starting dependency installation ...")
message("Loading development helper packages from 'R_LIBS_ACTION'.")
loadNamespace(package = "withr", lib.loc = Sys.getenv("R_LIBS_ACTION"))
withr::with_libpaths(
  new = Sys.getenv("R_LIBS_ACTION"),
  action = "prefix",
  code = {
    loadNamespace(package = "remotes")
    loadNamespace(package = "curl")
    loadNamespace(package = "git2r")
    loadNamespace(package = "pkgbuild")
  }
)
unloadNamespace(ns = "withr")  # no longer needed

message("Recording already installed dependencies ...")
deps_exp <- remotes::dev_package_deps(dependencies = TRUE)$package
message("Installing dependencies ...")
remotes::install_deps(
  dependencies = TRUE,
  verbose = TRUE,
  lib = Sys.getenv("R_LIBS_WORKFLOW")
)
# TODO ideally, this would be checked by using r-lib/pak or similar inside of install_deps in the above
# NOTE this is a very incomplete check of success
# this only compares pkgs, not version numbers or SHAs
message("Checking installation success ...")
deps_present <- installed.packages()[, "Package"]
deps_missing <- setdiff(deps_exp, deps_present)
if (length(deps_missing) == 0) {
  message("All package dependencies were successfully installed.")
} else {
  stop(
    "One or more package dependencies could not be installed: ",
    paste(deps_missing, collapse = ", ")
  )
}
