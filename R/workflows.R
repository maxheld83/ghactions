#' Render and deploy an [rmarkdown](https://rmarkdown.rstudio.com) project
#'
#' This workflow renders some Rmarkdown via its (custom) site generator and deploys the result.
#' Suitable for:
#' - [RMarkdown websites](https://rmarkdown.rstudio.com/lesson-13.html)
#' - [Bookdown websites](https://bookdown.org)
#' - [Blogdown websites](https://bookdown.org/yihui/blogdown/) (**experimental**)
#'
#' @details
#' [rmarkdown::render_site()] returns the directory to which outputs have been rendered.
#' This workflow saves that directory in the environment variable `DEPLOY_PATH`, which is the default expected by [ghpages()] and other deployment methods.
#'
#' @param deploy `[list(1)]`
#' giving a list of deploy functions.
#'
#' @inheritParams workflow
#'
#' @family workflows
#'
#' @export
website <- function(name = "Render and Deploy RMarkdown Website",
                    deploy = list(ghpages()),
                    on = c("push", "pull_request")) {
  workflow(
    name = name,
    jobs = job(
      id = "build",
      runs_on = "ubuntu-18.04",
      container = "rocker/verse:latest",
      steps = c(
        list(
          checkout(),
          install_deps(),
          rscript(
            expr = c(
            "deploy_path <- rmarkdown::render_site(encoding = 'UTF-8')",
            "Sys.setenv(DEPLOY_PATH = deploy_path)"
            )
          )
        ),
        deploy
      )
    )
  )
}
