#!/usr/bin/env Rscript
path_action <- Sys.getenv("R_LIBS_ACTION")
path_workflow <- Sys.getenv("R_LIBS_WORKFLOW")

message("Starting dependency installation ...")
message("Loading development helper packages from 'R_LIBS_ACTION'.")
loadNamespace(package = "remotes", lib.loc = path_action)
loadNamespace(package = "curl", lib.loc = path_action)
loadNamespace(package = "git2r", lib.loc = path_action)
loadNamespace(package = "pkgbuild", lib.loc = path_action)

message("Installing dependencies ...")
# this needs to run with modified .libPaths() to recognize cache
withr::with_libpaths(new = path_workflow, action = "replace", code = {
  remotes::install_deps(
    dependencies = TRUE,
    verbose = TRUE,
    lib = path_workflow
  )
})

message("Checking for unneeded dependencies (might come from old cache) ...")
deps_exp <- remotes::dev_package_deps(dependencies = TRUE)$package
deps_present <- installed.packages(lib.loc = path_workflow)[, "Package"]
deps_uneeded <- setdiff(deps_present, deps_exp)
if (length(deps_uneeded > 0)) {
  remove.packages(deps_uneeded, lib = path_workflow)
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
