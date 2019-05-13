# largely copied from the travis ruby script: https://github.com/travis-ci/travis-build/blob/22a3b1fbdb59170b6c302b2a6a28c8c9cb54b159/lib/travis/build/script/r.rb#L380-L384
message("Recording already installed dependencies ...")
deps_exp <- remotes::dev_package_deps(dependencies = TRUE)
message("Installing dependencies ...")
remotes::install_deps(dependencies = TRUE)
message("Checking installation success ...")
deps_present <- installed.packages(lib.loc = Sys.getenv("R_LIBS_USER"))
deps_missing <- setdiff(deps_exp, deps_present)
if (length(deps_missing) == 0) {
  message("All package dependencies were successfully installed.")
} else {
  stop(
    "One or more package depedencies could not be installed: ",
    paste(deps_missing, collapse = ", ")
  )
}
