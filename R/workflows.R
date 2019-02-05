workflows <- NULL
#' @title Workflow templates for R projects.
#'
#' @description
#' Builds workflow templates with sensible defaults for R projects.
#' - [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' - [Bookdown websites](http://bookdown.org)
#' - [Blogdown websites](https://bookdown.org/yihui/blogdown/)
#' - and other similar projects with an R static site generator.
#'
#' @inheritParams make_workflow_block
#'
#' @family workflows
#'
#' @return A list as specified in the `workflow` argument to [use_ghactions()].
#'
#' @export
NULL

workflows$website <- function(IDENTIFIER = "Render and Deploy",
                              on = "push",
                              resolves = c("Render", "Deploy"),
                              deploy = list(master = NULL)) {
  # make workflow block
  # can only be one per workflow, obviously
  res <- rlang::exec(.fn = list, !!!list(
    IDENTIFIER = IDENTIFIER,
    on = on,
    resolves = resolves,
    actions = NULL
  ))
}


workflows$fau <- function(IDENTIFIER = "Render and Deploy",
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
