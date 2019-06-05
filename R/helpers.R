#' Assert function package dependencies
#'
#' Asserts that `Suggests` packages are available for function to run.
#'
#' @param pkgs `[character()]` giving the required packages.
#'
#' @noRd
assert_deps <- function(pkgs) {
  # TODO there should be a better function out there for this already
  names(pkgs) <- pkgs
  avail <- purrr::map_lgl(
    .x = pkgs,
    .f = requireNamespace,
    quietly = TRUE
  )
  miss <- avail[!avail]
  if (length(miss) == 0) {
    return(invisible(pkgs))
  }
  stop(
    "One or more packages needed for this function to work are missing: ",
    names(miss),
    call. = FALSE
  )
}


#' Check whether system dependency is available
#' @noRd
# TODO use something like this from another package (this is duplicated from pensieve)
check_sysdep <- function(x) {
  sys_test <- checkmate::test_character(
    x = Sys.which(x),
    min.chars = 2,
    any.missing = FALSE,
    all.missing = FALSE,
    len = 1,
    null.ok = FALSE
  )
  if (sys_test) {
    return(TRUE)
  } else {
    return(
      glue::glue(
        "Could not find",
        x,
        "system dependency. Try installing it",
        .sep = " "
      )
    )
  }
}
assert_sysdep <- checkmate::makeAssertionFunction(check.fun = check_sysdep)
