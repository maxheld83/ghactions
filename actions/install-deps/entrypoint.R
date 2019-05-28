#!/usr/bin/env Rscript

message("Starting dependency installation ...")
message("Using 'remotes' from 'R_LIBS_ACTION'.")
unloadNamespace(ns = "remotes")  # just to be safe
requireNamespace(package = "remotes", lib.loc = Sys.getenv("R_LIBS_WORKFLOW"))
message("Recording already installed dependencies ...")
deps_exp <- remotes::dev_package_deps(dependencies = TRUE)$package
message("Installing dependencies ...")
remotes::install_deps(dependencies = TRUE, verbose = TRUE)
message("Unload 'remotes' from 'R_LIBS_ACTION'...")
unloadNamespace(ns = "remotes")  # just to be safe
message("Checking installation success ...")
deps_present <- installed.packages(lib.loc = Sys.getenv("R_LIBS_WORKFLOW"))[, "Package"]
# this only compares pkgs, not version numbers or SHAs
deps_missing <- setdiff(deps_exp, deps_present)
if (length(deps_missing) == 0) {
  message("All package dependencies were successfully installed.")
} else {
  stop(
    "One or more package dependencies could not be installed: ",
    paste(deps_missing, collapse = ", ")
  )
}
