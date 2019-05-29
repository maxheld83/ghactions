install.packages(
  pkgs = c(
    "curl",
    # speeds up pkg installation as per docs https://remotes.r-lib.org/index.html
    "git2r",
    # speeds up pkg installation as per docs https://remotes.r-lib.org/index.html
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
