#' Assert function package dependencies
#'
#' Asserts that `Suggests` packages are available for function to run.
#'
#' @param pkgs `[character()]` giving the required packages.
#'
#' @noRd
assert_deps <- function(pkgs) {
  names(pkgs) <- pkgs
  avail <- purrr::imap_lgl(
    .x = pkgs,
    .f = requireNamespace,
    quietly = TRUE
  )
  missing <- avail[!avail]
  if (length(missing) == 0) {
    return(invisible(pkgs))
  }
  stop(
    "One or more packages needed for this function to work are missing: ",
    missing,
    call. = FALSE
  )
}
