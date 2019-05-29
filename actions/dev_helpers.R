install.packages(
  pkgs = c(
    "pkgbuild",
    "devtools",
    "pkgdown",
    "roxygen2",
    "testthat",
    "rcmdcheck"
  ),
  lib = Sys.getenv("R_LIBS_ACTION"),  # install to isolated dir
  verbose = TRUE
)
