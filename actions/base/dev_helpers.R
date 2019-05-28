install.packages(
  pkgs = c(
    "curl",
    # speeds up pkg installation as per docs https://remotes.r-lib.org/index.html
    "git2r",
    # speeds up pkg installation as per docs https://remotes.r-lib.org/index.html
    "pkgbuild",
    "devtools",
    "pkgdown",
    "remotes",
    "roxygen2",
    "testthat",
    "rcmdcheck"
  ),
  lib = Sys.getenv("R_LIBS_WORKFLOW"),  # install to isolated dir
  dependencies = TRUE,
  verbose = TRUE
)
