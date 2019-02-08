#' @title Render and deploy R projects to static hosting.
#'
#' @description
#' These functions generate workflows suitable for R `website` projects, such as:
#' - [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' - [Bookdown websites](http://bookdown.org)
#' - [Blogdown websites](https://bookdown.org/yihui/blogdown/)
#' - and other similar projects with an R static site generator.
#'
#' @inheritParams make_workflow_block
#'
#' @param .f `[character(1)]`
#' giving the render function, typically something like `rmarkdown::render_site()`.
#'
#' @param static_dir `[character(1)]`
#' giving the path to the generated static assets from the repository root.
#' Typically something like `_site/` for `rmarkdown::render_site()`.
# TODO infer this automagically?
#'
#' @param deploy `[list()]`
#' giving the name of the branch to deploy *from*, and the function to deploy *with*.
#'
#' @return A list as specified in the `workflow` argument to [use_ghactions()].
#'
#' @family workflows
#'
#' @export
website <- function(IDENTIFIER = "Render and Deploy",
                    .f = "rmarkdown::render_site()",
                    # TODO need to accept this as a function call, then deparse
                    static_dir = "_site",
                    deploy = NULL) {
  # Input validation
  # TODO somehow check .f
  checkmate::assert_list(
    x = deploy,
    # types = "function",
    # not really, it's a function call, not the same
    any.missing = FALSE,
    len = 1,
    null.ok = TRUE
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
    )
  )
  res$actions <- c(res$actions, filter_then_deploy())
  res
}

#' @title Quick setup for projects at FAU.
#'
#' @description
#' For internal use at FAU only.
#'
#' @inheritParams website
#'
#' @family workflows
#'
#' @noRd
fau <- function(IDENTIFIER = "Render and Deploy",
                .f = "rmarkdown::render_site()",
                static_dir = "_site") {
  website(
    IDENTIFIER = IDENTIFIER,
    .f = .f,
    static_dir = static_dir,
    deploy = list(master = deploy_fau(needs = "Master"))
  )
}

filter_then_deploy <- function(master = deploy_ghpages(needs = "Master"), needs = "Render") {
  #TODO needs argument in master above is kinda stupid
  list(
    Master = filter(
      needs = needs,
      args = "branch master"
      # TODO need to actually use the chosen branch here
    ),
    Deploy = master
  )
}

deploy_ghpages <- function(static_dir = "_site", needs) {
  ghpages(
    env = list(
      BUILD_DIR = static_dir
    ),
    needs = needs
  )
}

deploy_fau <- function(static_dir = "_site", needs) {
  rsync(
    needs = needs,
    env = list(
      HOST_NAME = "karli.rrze.uni-erlangen.de",
      HOST_IP = "131.188.16.138",
      HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4="
    ),
    args = c(
      fs::path("$GITHUB_WORKSPACE", static_dir),
      fs::path(
        "pfs400wm@$HOST_NAME:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource",
        # unexported function; gh::gh_tree_remote() might help
        usethis:::github_repo()
      )
    )
  )
}
