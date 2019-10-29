#' Test whether the runtime is GitHub actions
#'
#' @export
#'
#' @family helpers
is_github_actions <- function() {
  fs::file_exists("/github/workflow/event.json")
}
