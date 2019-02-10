#' @title Render and deploy a website
#'
#' @description
#' This workflow renders some Rmarkdown via its (custom) site generator and deploys the result.
#' Suitable for:
#' - [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' - [Bookdown websites](https://bookdown.org)
#' - [Blogdown websites](https://bookdown.org/yihui/blogdown/) (**experimental**)
#' - any other custom site generators that can be called via `rmarkdown::render_site()` (**experimental**)
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
website <- function(IDENTIFIER = "Render and Deploy RMarkdown Website",
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
      fun = "rmarkdown::render_site(encoding = 'UTF-8')"
    ),
    filter_branch(
      needs = "Render",
      branch = names(deploy)
    ),
    deploy[[1]]
  )
  res
}

fau <- purrr::partial(
  .f = website,
  deploy = list(
    master = rsync_fau(
      needs = "Filter master",
      SRC = "_site",
      DEST = fs::path(
        "/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource",
        gh::gh_tree_remote()$repo
      )
    )
  )
)
