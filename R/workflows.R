#' @title Render and deploy R projects to static hosting.
#'
#' @description
#' This function generates workflows suitable for R `website` projects, such as:
#' - [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' - [Bookdown websites](http://bookdown.org)
#' - [Blogdown websites](https://bookdown.org/yihui/blogdown/)
#' - and other similar projects with an R static site generator.
#'
#' @family workflows
#'
#' @inheritParams make_workflow_block
#'
#' @param .f `[character(1)]`
#' giving the render function, typically something like `rmarkdown::render_site()`.
#'
#' @param static_dir `[character(1)]``
#' giving the path to the generated static assets from the repository root.
#' Typically something like `_site/` for `rmarkdown::render_site()`.
# TODO infer this automagically?
#'
#' @param deploy `[list()]`
#' giving the name of the branch to deploy *from*, and the function to deploy *with*.
#'
#' @return A list as specified in the `workflow` argument to [use_ghactions()].
#'
#' @export
website <- function(IDENTIFIER = "Render and Deploy",
                    .f = "rmarkdown::render_site()",
                    # TODO need to accept this as a function call, then deparse
                    static_dir = "_site",
                    deploy = list(master = NULL)) {
  # Input validation
  # TODO somehow check .f
  checkmate::assert_list(
    x = deploy,
    types = "function",
    any.missing = FALSE,
    len = 1,
    null.ok = FALSE
  )
  # TODO check whether name is a real branch

  # make workflow block
  # can only be one per workflow, obviously
  res <- rlang::exec(.fn = list, !!!list(
    IDENTIFIER = IDENTIFIER,
    on = "push",
    resolves = c("Render", "Deploy"),
    actions = NULL
  ))

  res$actions <- list(
    `Build image` = docker_cli(),
    # TODO this is awkward; docker_cli has hardcoded build defaults
    Render = rscript_byod(
      needs = "Build image",
      args = glue::glue_collapse(x = c("-e", .f))
    ),
    # TODO use actual branch name
    # TODO factor this all out
    Master = ghactions::filter(
      needs = "Render",
      args = "branch master"
      # TODO need to actually use the chosen branch here
    ),
    Deploy = ghpages(
      needs = "Master"
    )
  )
  glue::as_glue(res)
}

fau <- function(IDENTIFIER = "Render and Deploy",
                          on = "push",
                          resolves = c("Render", "Deploy")) {
  # make workflow block
  # can only be one per workflow, obviously
  res <- rlang::exec(.fn = list, !!!list(
    IDENTIFIER = IDENTIFIER,
    on = on,
    resolves = resolves,
    actions = NULL
  ))
  res$actions <- list(
    `Build image` = docker_cli(),
    Render = rscript_byod(args = "-e 'rmarkdown::render_site()'"),
    Deploy = rsync(
      env = list(
        HOST_NAME = "karli.rrze.uni-erlangen.de",
        HOST_IP = "131.188.16.138",
        HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4="
      ),
      args = c(
        "$GITHUB_WORKSPACE/_site/",
        fs::path(
          "pfs400wm@$HOST_NAME:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource",
          # unexported function; gh::gh_tree_remote() might help
          usethis:::github_repo()
        )
      )
    )
  )
  res
}
