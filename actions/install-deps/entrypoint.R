#!/usr/bin/env Rscript

message("Starting dependency installation ...")
message("Loading development helper packages from 'R_LIBS_ACTION'.")
loadNamespace(package = "remotes", lib.loc = Sys.getenv("R_LIBS_ACTION"))
loadNamespace(package = "curl", lib.loc = Sys.getenv("R_LIBS_ACTION"))
loadNamespace(package = "git2r", lib.loc = Sys.getenv("R_LIBS_ACTION"))
loadNamespace(package = "pkgbuild", lib.loc = Sys.getenv("R_LIBS_ACTION"))

message("Installing dependencies ...")
remotes::install_deps(
  dependencies = TRUE,
  verbose = TRUE
)

message("Checking for unneeded dependencies (might come from old cache) ...")
deps_exp <- remotes::dev_package_deps(dependencies = TRUE)$package
deps_present <- installed.packages(lib.loc = Sys.getenv("R_LIBS_WORKFLOW"))[, "Package"]
deps_uneeded <- setdiff(deps_present, deps_exp)
if (length(deps_uneeded > 0)) {
  remove.packages(deps_uneeded)
  message(
    "Removed one or more package dependencies no longer needed:",
    paste(deps_uneeded, collapse = ", ")
  )
}

# TODO ideally, this would be checked by using r-lib/pak or similar inside of install_deps in the above
# NOTE this is a very incomplete check of success
# this only compares pkgs, not version numbers or SHAs
message("Checking installation success (a little bit)...")
deps_missing <- setdiff(deps_exp, deps_present)
if (length(deps_missing) == 0) {
  message("All package dependencies were successfully installed.")
} else {
  stop(
    "One or more package dependencies could not be installed: ",
    paste(deps_missing, collapse = ", ")
  )
}
