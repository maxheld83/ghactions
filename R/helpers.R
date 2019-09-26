#' Test whether runtime is GitHub actions
#'
#' @export
#'
#' @family setup
is_github_actions <- function() {
  fs::file_exists("/github/workflow/event.json")
}
