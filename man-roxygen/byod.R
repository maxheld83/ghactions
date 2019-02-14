#' @section Docker:
#' This action **requires a Docker image called *literally* `repo:latest` in `github/workspace`.**
#' See [vignette](https://www.maxheld.de/ghactions/articles/ghactions.html) for details.
#' Use [build_image()] to create one in a prior action.
#'
#' This action or workflow requires that you *bring-your-own-dockerfile* (byod).
#' There has to be a `Dockerfile` at the root of your repository.
#' It's easy to set one up using [use_dockerfile()].
#' To learn more, consider the [vignette](https://www.maxheld.de/ghactions/articles/ghactions.html).
#'
#' @family byod
