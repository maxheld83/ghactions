#' Recursively load packages from custom library locations
#'
#' [loadNamespace()] does not pass on `lib.loc` when loading the dependencies of `package`.
#' This version does.
#'
#' @inheritParams loadNamespace
#'
#' @noRd
loadNamespace2 <- function(package, lib.loc = Sys.getenv("R_LIBS_ACTION")) {
  message("Loading *withr* from ", lib.loc, " as a helper...")
  loadNamespace(package = "withr", lib.loc = lib.loc)
  message("Loading ", package, " from ", lib.loc, "...")
  withr::with_libpaths(
    new = lib.loc,
    code = loadNamespace(package = package),
    action = "prefix"
  )
}


