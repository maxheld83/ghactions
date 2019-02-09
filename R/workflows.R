#' @title Render and deploy R projects to static hosting
#'
#' @description
#' These functions generate workflows suitable for R `website` projects.
#' You can use some of the below defaults, or call an arbitrary R function that generates static assets.
#'
#' @inheritParams make_workflow_block
#'
#' @inheritParams rscript_byod
#'
#' @template workflows
#'
#' @param deploy `[list(1)]`
#' giving the name of the branch to deploy *from*, and the function to deploy *with*.
#'
#' @export
website <- function(IDENTIFIER,
                    fun,
                    deploy = list(master = ghpages())) {
  # Input validation
  # TODO somehow check .f
  checkmate::assert_list(
    x = deploy,
    types = "list",
    any.missing = FALSE,
    len = 1,
    null.ok = TRUE,
    names = "named"
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
    build_image(),
    rscript_byod(
      IDENTIFIER = "Render",
      needs = "Build image",
      fun = fun
    ),
    filter_branch(
      needs = "Render",
      branch = names(deploy)
    ),
    deploy[[1]]
  )
  res
}

#' @describeIn website [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' @export
website_rmarkdown <- purrr::partial(
  .f = website,
  IDENTIFIER = "Render and Deploy RMarkdown Website",
  fun = "rmarkdown::render_site()"
)

fau <- purrr::partial(
  .f = website_rmarkdown,
  deploy = list(
    master = rsync_fau(
      needs = "Filter master",
      SRC = "_site",
      DEST = paste0(
        "/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource",
        # unexported function; gh::gh_tree_remote() might help
        usethis:::github_repo()
      )
    )
  )
)
