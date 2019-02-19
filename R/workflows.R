#' @title Render and deploy a website
#'
#' @description
#' This workflow renders some Rmarkdown via its (custom) site generator and deploys the result.
#' Suitable for:
#' - [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' - [Bookdown websites](https://bookdown.org)
#' - [Blogdown websites](https://bookdown.org/yihui/blogdown/) (**experimental**)
#' - any other site generators that can be called via `rmarkdown::render_site()` and returns the path to the rendered assets (**experimental**).
#'
#' @inheritParams make_workflow_block
#'
#' @inheritParams rscript_byod
#'
#' @template workflows
#' @template byod
#'
#' @details
#' Rmarkdown site generators can write to arbitary directories, and these output directory can be set in a number of places.
#' Happily, `rmarkdown::render_site()` (invisibly) returns the path to the rendered assets.
#' The `website()` workflow automatically retrieves this path, and writes it to a special `.deploy_dir` text file.
#' Downstream deploy actions such as `ghpages()` default to deploying from the directory specified in such a `.deploy_dir`.
#' This isn't a terribly elegant way of doing this, but because each action runs it's own container, and *only* the `github/workspace` directory persists between them, it is currently the only way to pass the path to the deploy actions.
#'
#' Users will probably never see the `.deploy_dir` file, and need not worry about it.
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

  # these *may* appear locally should a user somehow run github actions locally
  usethis::use_build_ignore(files = ".deploy_dir", escape = FALSE)
  # usethis::use_git_ignore(ignores = ".deploy_dir")

  res$actions <- list(
    build_image(),
    rscript_byod(
      IDENTIFIER = "Render",
      needs = "Build image",
      expr = {
        deploy_dir <- rmarkdown::render_site(encoding = 'UTF-8')
        # there's no way to pass env vars between actions, so can only use disc
        readr::write_lines(x = deploy_dir, path = ".deploy_dir", append = FALSE)
      }
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
