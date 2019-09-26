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
#' @inherit workflow
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

  # bad hack-fix for https://github.com/r-lib/ghactions/issues/288
  attr(res, 'byod') <- TRUE
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

#' @title Fix documentation
#'
#' @description
#' This GitHub action creates `man/` documentation from [*roxygen*](https://github.com/klutometis/roxygen/) comments in `R/` scripts at the repository root using [*devtools*](https://devtools.r-lib.org).
#'
#' @inherit workflow
#'
#' @inheritParams auto_commit
#'
#' @details
#' If you set `after_code = 'commit'` this action will automatically commit and push changes to your repository for you.
#' This will pollute your commit history and may cause unintended interruptions, such as merge conflicts *with yourself*.
#' The programmatic commit will not trigger another action run, but may trigger other workflow automations (such as Travis and AppVeyor).
#'
#' GitHub actions are currently available only in repos who belong to organisations or personal accounts who are on the beta.
#' GitHub actions always runs against the repo to which the push was made, and does not currently support pull requests.
#'
#' For more caveats, see [auto_commit()].
#'
#' @export
fix_docs <- function(IDENTIFIER = "Fix Documentation",
                     after_code = NULL) {
  # Input validation

  # TODO this is a stupid roundtrip of R argument to bash to R to wherever
  if (isTRUE(after_code == "commit")) {
    after_code <- "--after-code=commit"
  }

  rlang::exec(.fn = list, !!!list(
    IDENTIFIER = IDENTIFIER,
    on = "push",
    resolves = c("Document Package"),
    actions = list(
      install_deps(),
      document(needs = "Install Dependencies", args = after_code)
    )
  ))
}
