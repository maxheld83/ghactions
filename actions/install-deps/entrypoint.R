#!/usr/bin/env Rscript
path_workflow <- Sys.getenv("R_LIBS_WORKFLOW")
message(
  "Creating R package library for this workflow at ",
  path_workflow,
  " ..."
)
# cannot be created in dockerfile, because github actions overwrites /github/ see #275
dir.create(path = path_workflow, showWarnings = TRUE, recursive = TRUE)
path_devhelpers <- Sys.getenv("R_LIBS_DEV_HELPERS")

message("Starting dependency installation ...")

loadNamespace(package = "withr", lib.loc = path_devhelpers)
loadNamespace(package = "remotes", lib.loc = path_devhelpers)

message("Installing dependencies ...")
# this needs to run with modified .libPaths() to recognize cache
withr::with_libpaths(new = path_workflow, action = "prefix", code = {
  remotes::install_deps(
    dependencies = TRUE,
    verbose = TRUE,
    lib = path_workflow
  )
})

message("Checking for unneeded dependencies (might come from old cache) ...")
deps_exp <- remotes::dev_package_deps(dependencies = TRUE)$package
deps_present <- installed.packages()[, "Package"]
deps_uneeded <- setdiff(deps_present, deps_exp)
if (length(deps_uneeded > 0)) {
  remove.packages(deps_uneeded)
  message(
    "Removed one or more package dependencies no longer needed:",
    paste(deps_uneeded, collapse = ", ")
  )
}

message("Checking installation success...")
# TODO ideally, this would be checked by using r-lib/pak or similar inside of install_deps in the above
# this only compares pkgs, not version numbers or SHAs
message("(This is an incomplete check of success).")
deps_missing <- setdiff(deps_exp, deps_present)
if (length(deps_missing) == 0) {
  message("All package dependencies were successfully installed.")
} else {
  stop(
    "One or more package dependencies could not be installed: ",
    paste(deps_missing, collapse = ", ")
  )
}
