#' Workflow automation with GitHub Actions
#'
#' Sets up workflow automation, including continuous integration and deployment (CI/CD) for different kinds of R projects on GitHub actions.
#' This function
#' - transforms a list into the GitHub actions syntax,
#' - writes it out to `.github/workflows/` in your repository.
#'
#' @param workflow `[list(list())]`
#' A named list as created by one of the [workflow()] functions.
#' Defaults to [website()].
#'
#' @inherit usethis::use_template return
#'
#' @family setup
#'
#' @examples
#' \dontrun{
#' use_ghactions(workflow = website())
#' }
#' @export
use_ghactions <- function(workflow = website()) {
  # input validation ====
  checkmate::assert_list(
    x = workflow,
    any.missing = FALSE,
    names = "named",
    null.ok = FALSE
  )

  # check conditions ====
  #
  # TODO would be better to use usethis::check_uses_github, but currently not exported. see https://github.com/maxheld83/ghactions/issues/46
  tryCatch(
    expr = gh::gh_tree_remote(),
    error = function(cnd) {
      usethis::ui_stop(
        c("This project does not have a GitHub remote configured as {usethis::ui_value('origin')}.",
        "Do you need to run {usethis::ui_code('usethis::use_github()')}?"
        )
      )
    }
  )

  # body ====

  # write out to disc
  # this is modelled on use_template, but because we already have the full string in above res, we don't need to go through whisker/mustache again
  usethis::use_directory(path = ".github/workflows", ignore = TRUE)

  new <- usethis::write_over(
    path = ".github/workflows/main.yml",
    lines = r2yaml(workflow),
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


#' README badges
#'
#' @inherit usethis::use_badge description
#' @inheritParams usethis::use_badge
#'
#' @param workflow_name `[character(1)]`
#' Giving the name of the workflow as specified in the [`name:`](https://help.github.com/en/articles/workflow-syntax-for-github-actions#name) field of your `*.yml`.
#' If no `name: ` is given, this is the file path of the `*.yml` from the repository root.
#' Defaults to `NULL`, in which case the first workflow in the first `*.yml` at `.github/workflows/` is used.
#'
#' @family setup
#'
#' @export
use_ghactions_badge <- function(workflow_name = NULL,
                                badge_name = "Actions Status") {
  # input validation
  workflows <- read_workflows()
  checkmate::assert_choice(
    x = workflow_name,
    choices = purrr::map_chr(.x = workflows, "name"),
    null.ok = TRUE
  )

  # compute inputs
  if (is.null(workflow_name)) {
    workflow_name <- workflows[[1]]$name
  }
  reposlug <- glue::glue(
    '{gh::gh_tree_remote()$username}/{gh::gh_tree_remote()$repo}'
  )

  # write out
  usethis::use_badge(
    href = glue::glue('https://github.com/{reposlug}/actions'),
    src = glue::glue('https://github.com/{reposlug}/workflows/{workflow_name}/badge.svg'),
    badge_name = badge_name
  )
}


#' Open configuration files
#'
#' @description Open `.github/workflows/main` configuration file for GitHub actions.
#' See [usethis::edit()] for details.
#'
#' @family setup
#'
#' @inherit usethis::edit return
#'
#' @export
edit_workflow <- function() {
  path <- usethis::proj_path(".github", "workflows", "main")
  usethis::ui_todo("Commit and push for the changes to take effect.")
  invisible(usethis::edit_file(path))
}
