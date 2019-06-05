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
  avail <- purrr::imap_lgl(
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
