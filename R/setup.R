#' @title Workflow automation with GitHub Actions
#'
#' @description
#' Sets up workflow automation, including continuous integration and deployment (CI/CD) for different kinds of R projects on GitHub actions.
#' This function
#' - Picks a set of sensible defaults for your project.
#' - Transforms a list of workflow and action blocks into the GitHub actions syntax.
#' - Adds a `.github/main.workflow` file to your repository.
#'
#' @param workflow `[list(list())]`
#' A named list of blocks nested as:
#' - **The workflow block**: arguments to [workflow()] as a named list *and*
#' - `$actions``, which in turn comprises of the
#'   - **Several action blocks** with arguments to [action()] as a named list.
#'
#' @inherit usethis::use_template return
#'
#' @family setup
#'
#' @examples
#' \dontrun{
#' use_ghactions(workflow = website())
#' }
#' @export
use_ghactions <- function(workflow = website()) {
  # input validation ====
  checkmate::assert_list(
    x = workflow,
    any.missing = FALSE,
    names = "named",
    null.ok = FALSE
  )

  # TODO infer project kind

  # check conditions ====
  #
  # TODO would be better to use usethis::check_uses_github, but currently not exported. see https://github.com/maxheld83/ghactions/issues/46
  tryCatch(
    expr = gh::gh_tree_remote(),
    error = function(cnd) {
      usethis::ui_stop(
        c("This project does not have a GitHub remote configured as {usethis::ui_value('origin')}.",
        "Do you need to run {usethis::ui_code('usethis::use_github()')}?"
        )
      )
    }
  )

  # TODO bad hackfix for https://github.com/r-lib/ghactions/issues/288
  needs_docker <- isTRUE(attr(workflow, 'byod'))
  if (needs_docker) {
    if (!fs::file_exists("DOCKERFILE")) {
      usethis::ui_warn(x = glue::glue(
        'Could not find a {usethis::ui_code("DOCKERFILE")} at your repository root.'
      ))
      use_dockerfile()
      usethis::ui_todo(x = glue::glue(
        'Please edit the {usethis::ui_code("DOCKERFILE")} if you need additional dependencies.'
      ))
    } else {
      usethis::ui_line(x = glue::glue(
        'Using the {usethis::ui_code("DOCKERFILE")} found at your repository root.'
      ))
    }
  }

  # body ====
  # make project-specific action blocks with leading workflow block
  res <- list2ghact(workflow = workflow)

  # write out to disc
  # this is modelled on use_template, but because we already have the full string in above res, we don't need to go through whisker/mustache again
  usethis::use_directory(path = ".github", ignore = TRUE)

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

#' @describeIn use_ghactions Helper to turn block lists into strings.
#' Useful when you want the result printed to console, not written to file.
#'
#' @examples
#' # this will print the result to the console for inspection
#' \dontrun{
#' list2ghact(workflow = website())
#' }
#'
#' @family setup
#'
#' @export
list2ghact <- function(workflow) {
  res <- workflow(
    IDENTIFIER = workflow$IDENTIFIER,
    on = workflow$on,
    resolves = workflow$resolves
  )
  res <- workflow2hcl(res)
  res <- c(
    res,
    purrr::map(
      .x = workflow$actions,
      .f = function(x) {
        l <- rlang::exec(.fn = action, !!!x)
        action2hcl(l)
      }
    )
  )
  # this makes it easier to read in debugging; above imap kills s3 attributes
  glue::as_glue(x = res)
}

#' @title Set up a simple `Dockerfile`
#'
#' @param FROM `[character(1)]`
#' giving the base docker image.
#' See details.
#'
#' @details
#' Every project to be run on GitHub actions needs a `Dockerfile` at the root of the repository.
#' For many projects, the popular [`verse`](https://hub.docker.com/r/rocker/verse) image, maintained by the [Rocker Project](http://rocker-project.org/) will suffice; it includes RStudio, the tidyverse, many frequently used packages and system dependencies.
#' If you need more (or want less), you can always edit your `Dockerfile` by hand.
#' Learn more about [extending images in the context of R](https://www.rocker-project.org/use/extending/) at the Rocker Project.
#'
#' @family setup
#'
#' @export
use_dockerfile <- function(FROM = "rocker/verse:3.5.2") {
  checkmate::assert_string(x = FROM, na.ok = FALSE, null.ok = FALSE)
  usethis::ui_done(glue::glue("Choosing {FROM} as your base docker image."))
  # TODO this should be ui_line, not ui_done, but that isn't exported yet
  new <- usethis::write_over(path = "Dockerfile", lines = "FROM rocker/verse:3.5.2")
  # return true/false for changed files as in original use_template
  usethis::use_build_ignore(files = "Dockerfile")
  invisible(new)
}


#' @title README badges
#'
#' @description Add markdown syntax for README badge, see [usethis::use_badge()].
#'
#' @inheritParams usethis::use_badge
#'
#' @param workflow_name `[character(1)]`
#' Giving the name of the workflow as given in the [`name:`](https://help.github.com/en/articles/workflow-syntax-for-github-actions#name) field of your `*.yml`.
#' Defaults to `".github/workflows/main.yml"`.
#'
#' @family setup
#'
#' @export
use_ghactions_badge <- function(workflow_name = NULL) {
  checkmate::assert_string(x = workflow_name, na.ok = FALSE, null.ok = TRUE)
  reposlug <- glue::glue('{gh::gh_tree_remote()$username}/{gh::gh_tree_remote()$repo}')
  usethis::use_badge(
    href = glue::glue('https://github.com/{reposlug}/actions'),
    src = glue::glue('https://github.com/{reposlug}/workflows/{workflow_name}/badge.svg'),
    badge_name = "Actions Status"
  )
}


#' @title Open configuration files
#'
#' @description Open `main.workflow` configuration file for GitHub actions.
#' See [usethis::edit()] for details.
#'
#' @family setup
#'
#' @export
edit_workflow <- function() {
  path <- usethis::proj_path(".github", "main.workflow")
  usethis::ui_todo("Commit and push for the changes to take effect.")
  invisible(usethis::edit_file(path))
}


#' @title Quickly browse to important package webpages
#'
#' @description Visits the GitHub actions page.
#' See [usethis::browse_github()] for details.
#'
#' @inheritParams usethis::browse_github
#'
#' @family setup
#'
#' @export
browse_github_actions <- function(package = NULL) {
  view_url(github_home(package), "actions")
}


# all of the below is lifted off of usethis
# usethis does not export this
# TODO this should be avoided https://github.com/r-lib/ghactions/issues/205
view_url <- function(..., open = interactive()) {
  url <- paste(..., sep = "/")
  if (open) {
    usethis::ui_done("Opening URL {usethis::ui_value(url)}")
    utils::browseURL(url)
  } else {
    usethis::ui_todo("Open URL {usethis::ui_value(url)}")
  }
  invisible(url)
}
## gets at most one GitHub link from the URL field of DESCRIPTION
## strips any trailing slash
## respects the URL given by maintainer, e.g.
## "https://github.com/simsem/semTools/wiki" <-- note the "wiki" part
## "https://github.com/r-lib/gh#readme" <-- note trailing "#readme"
github_link <- function(package = NULL) {
  if (is.null(package)) {
    desc <- desc::desc(usethis::proj_get())
  } else {
    desc <- desc::desc(package = package)
  }

  urls <- desc$get_urls()
  gh_links <- grep("^https?://github.com/", urls, value = TRUE)

  if (length(gh_links) == 0) {
    usethis::ui_warn("
      Package does not provide a GitHub URL.
      Falling back to GitHub CRAN mirror")
    return(glue::glue("https://github.com/cran/{package}"))
  }

  gsub("/$", "", gh_links[[1]])
}


github_url_rx <- function() {
  paste0(
    "^",
    "(?:https?://github.com/)",
    "(?<owner>[^/]+)/",
    "(?<repo>[^/#]+)",
    "/?",
    "(?<fragment>.*)",
    "$"
  )
}

## takes URL return by github_link() and strips it down to support
## appending path parts for issues or pull requests
##  input: "https://github.com/simsem/semTools/wiki"
## output: "https://github.com/simsem/semTools"
##  input: "https://github.com/r-lib/gh#readme"
## output: "https://github.com/r-lib/gh"
github_home <- function(package = NULL) {
  gh_link <- github_link(package)
  df <- re_match_inline(gh_link, github_url_rx())
  glue::glue("https://github.com/{df$owner}/{df$repo}")
}

## inline a simplified version of rematch2::re_match()
re_match_inline <- function(text, pattern) {
  match <- regexpr(pattern, text, perl = TRUE)
  start <- as.vector(match)
  length <- attr(match, "match.length")
  end <- start + length - 1L

  matchstr <- substring(text, start, end)
  matchstr[ start == -1 ] <- NA_character_

  res <- data.frame(
    stringsAsFactors = FALSE,
    .text = text,
    .match = matchstr
  )

  if (!is.null(attr(match, "capture.start"))) {
    gstart <- attr(match, "capture.start")
    glength <- attr(match, "capture.length")
    gend <- gstart + glength - 1L

    groupstr <- substring(text, gstart, gend)
    groupstr[ gstart == -1 ] <- NA_character_
    dim(groupstr) <- dim(gstart)

    res <- cbind(groupstr, res, stringsAsFactors = FALSE)
  }

  names(res) <- c(attr(match, "capture.names"), ".text", ".match")
  res
}
