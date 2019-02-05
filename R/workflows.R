#' @title Workflow automation with GitHub Actions
#'
#' @description
#' Sets up workflow automation, including continuous integration and deployment (CI/CD) for a different kinds of R projects on GitHub actions.
#' This function
#' - Picks a set of sensible defaults for your project.
#' - Transforms a list of workflow and action blocks into the GitHub actions syntax.
#' - Adds a `.github/main.workflow` file to your repository.
#'
#' @param workflow `[list()]`
#' A named list of blocks nested as:
#' - arguments to `make_workflow_block` as a named list *and*
#' - `actions`, which in turn comprises the
#'   - arguments to `make_action_block` as a named list.
#' Defaults ti `NULL`, in which case one of the `workflows` functions is chosen based on the configuration files in your repository.
#'
#' @examples
#' \dontrun{
#' use_ghactions(workflow = workflows$website$rmarkdown)
#' }
#' @export
use_ghactions <- function(workflow = workflows$website$rmarkdown$fau()) {
  # input validation
  # TODO infer project kind

  # check for github
  usethis:::check_uses_github()

  # make project-specific action blocks with leading workflow block
  res <- list2ghact(x = workflow)

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

# helper to turn lists into strings
list2ghact <- function(x) {
  res <- make_workflow_block(
    IDENTIFIER = x$IDENTIFIER,
    on = x$on,
    resolves = x$resolves
  )
  res <- c(
    res,
    purrr::imap_chr(
      .x = x$actions,
      .f = function(x, y) {
        rlang::exec(.fn = make_action_block, !!!c(IDENTIFIER = y, x))
      }
    )
  )
  # this makes it easier to read in debugging; above imap kills s3 attributes
  res <- glue::as_glue(x = res)
  res
}

# Objects: workflow blocks ===

workflows <- NULL
workflows$website <- NULL
workflows$website$rmarkdown <- NULL
workflows$website$rmarkdown$fau <- function(IDENTIFIER = "Build and deploy",
                                            on = "push",
                                            resolves = c("Render RMarkdown", "Deploy with rsync"),
                                            reponame = NULL) {

  if (is.null(reponame)) {
    # unexported function; gh::gh_tree_remote() might help
    reponame <- usethis:::github_repo()
  }

  # make workflow block
  # can only be one per workflow, obviously
  res <- rlang::exec(.fn = list, !!!list(
    IDENTIFIER = IDENTIFIER,
    on = on,
    resolves = resolves,
    actions = NULL
  ))

  # make action blocks
  res$actions <- list(
    `Build image` = list(
      uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6",
      args = "build --tag=repo:latest ."
    ),
    `Render RMarkdown` = list(
      uses = "maxheld83/ghactions/Rscript-byod@master",
      needs = "Build image",
      args = "-e 'rmarkdown::render_site()'"
    ),
    Master = list(
      uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd",
      needs = "Render RMarkdown",
      args = "branch master"
    ),
    `Deploy with rsync` = list(
      uses = "maxheld83/rsync@v0.1.1",
      needs = "Master",
      secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
      env = list(
        HOST_NAME = "karli.rrze.uni-erlangen.de",
        HOST_IP = "131.188.16.138",
        HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4="
      ),
      args = c(
        "$GITHUB_WORKSPACE/_site/",
        fs::path("pfs400wm@$HOST_NAME:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource", reponame)
      )
    )
  )
  res
}
