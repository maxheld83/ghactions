#' @title Workflow automation with GitHub Actions
#'
#' @description
#' Sets up workflow automation, including continuous integration and deployment (CI/CD) for a different kinds of R projects on GitHub actions.
#' This function
#' - Picks a set of sensible defaults for your project.
#' - Transforms a list of workflow and action blocks into the GitHub actions syntax.
#' - Adds a `.github/main.workflow` file to your repository.
#'
#' @param workflow `[list(list())]`
#' A named list of blocks nested as:
#' - **The workflow block**: arguments to [make_workflow_block()] as a named list *and*
#' - `$actions``, which in turn comprises of the
#'   - **Several action blocks** with arguments to [make_action_block()] as a named list.
#' Defaults to `NULL`, in which case one of the workflows functions is chosen based on the configuration files in your repository.
# TODO link workflows in the above to docs
#'
#' @inherit usethis::use_template return
#'
#' @examples
#' \dontrun{
#' use_ghactions(workflow = workflows$website$rmarkdown)
#' }
#' @export
use_ghactions <- function(workflow = NULL) {
  # input validation
  # TODO infer project kind

  # check for github
  usethis:::check_uses_github()

  # make project-specific action blocks with leading workflow block
  res <- list2ghact(workflow = workflow)

  # write out to disc
  # this is modelled on use_template, but because we already have the full string in above res, we don't need to go through whisker/mustache again
  usethis::use_directory(path = ".github", ignore = TRUE)

  # TODO not sure its kosher to use this function; it's exported but marked as internal
  new <- usethis::write_over(
    path = ".github/main.workflow",
    lines = res,
    quiet = TRUE
  )

  if (new) {
    usethis::ui_done(x = "GitHub actions is set up and ready to go.")
    usethis::ui_todo(x = "Commit and push the changes.")
    # TODO maybe automatically open webpage via browse_ghactions here
    usethis::ui_todo(
      x = "Visit the actions tab of your repository on github.com to check the results."
    )
  }

  # return true/false for changed files as in original use_template
  invisible(new)
}

#' @describeIn use_ghactions Helper to turn block lists into strings.
#' Useful when you want the result printed to console, not written to file.
#'
#' @examples
#' # this will print the result to the console for inspection
#' \dontrun{
#' list2ghact(workflow = workflows$website$rmarkdown$fau())
#' }
#'
#' @export
list2ghact <- function(workflow = NULL) {
  res <- make_workflow_block(
    IDENTIFIER = workflow$IDENTIFIER,
    on = workflow$on,
    resolves = workflow$resolves
  )
  res <- c(
    res,
    purrr::imap_chr(
      .x = workflow$actions,
      .f = function(x, y) {
        rlang::exec(.fn = make_action_block, !!!c(IDENTIFIER = y, x))
      }
    )
  )
  # this makes it easier to read in debugging; above imap kills s3 attributes
  res <- glue::as_glue(x = res)
  res
}
