


# one action ====
#' @title Create GitHub Actions syntax for one action.
#'
#' @description
#' Creates the syntax for *one* GitHub action as a string.
#' For details on the arguments, see [here](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/).-
#'
#' @param IDENTIFIER `[character(1)]`
#' giving the name of the action.
#' Shown on github.com and used in the `needs` fields of other actions.
#'
#' @param needs `[character()]`
#' giving the actions (by their `IDENTIFIER`s) that must complete successfully before this action will be invoked.
#' Defaults to `NULL` for no upstream dependencies.
#'
#' @param uses `[character(1)]`
#' giving the Docker image that will run the action.
#'
#' @param runs `[character(1)]`
#' giving the command to run in the docker image.
#' Overrides the `Dockerfile` `ENTRYPOINT`.
#' Defaults to `NULL` for no commands (recommended).
#'
#' @param args `[character()]`
#' giving the arguments to pass to the action.
#' Arguments get appended to the last command in `ENTRYPOINT`.
#' Defaults to `NULL` for no arguments.
#'
#' @param env `[list(character(1)]`
#' giving the environment variables to set in the action's runtime environment.
#' Defaults to `NULL` for no environment variables.
#'
#' @param secrets `[character()]`
#' giving the *names* of the secret variables to set in the runtime enviornment, which the action can access as an environment variable.
#' The *values* of secrets must be set in your repository's "Settings" tab.
#' **Do not store secrets in your repository.**
#' GitHub advises against using GitHub actions for production secrets during the public beta period.
#' Defaults to `NULL` for no secrets.
#'
#' @details
#' The `main.workflow` files used in [GitHub Actions](http://github.com/features/actions) is comprised of several actions.
#'
#' @examples
#' make_action(
#'   IDENTIFIER = "Simple Addition",
#'   uses = "maxheld83/ghactions/Rscript-byod@master",
#'   needs = "Build Image",
#'   args = "-e '1+1'"
#' )
#'
#' @keywords internal
#'
#' @return `[character(1)]`
#'
#' @export
make_action <- function(IDENTIFIER,
                        needs = NULL,
                        uses,
                        runs = NULL,
                        args = NULL,
                        env = NULL,
                        secrets = NULL) {
  # input validation ====
  # all of this is as per the gh action spec https://developer.github.com/actions/creating-workflows/workflow-configuration-options/
  checkmate::assert_string(
    x = IDENTIFIER,
    null.ok = FALSE
  )
  checkmate::assert_character(
    x = needs,
    any.missing = FALSE,
    unique = TRUE,  # cannot have two identical dependencies
    null.ok = TRUE
  )
  checkmate::assert_string(
    x = uses,
    null.ok = FALSE
    # we don't run extra checks here; that's a job for the ghaction parser
  )
  checkmate::assert_string(
    x = runs,
    null.ok = TRUE
  )
  checkmate::assert_character(
    x = args,
    any.missing = FALSE,
    unique = FALSE,
    null.ok = TRUE
  )
  checkmate::assert_list(
    x = env,
    types = "character",
    # TODO env can only be scalars, not sure whether anything else is possible
    any.missing = FALSE,
    names = "named",
    null.ok = TRUE
  )
  checkmate::assert_character(
    x = secrets,
    any.missing = FALSE,
    unique = TRUE,
    null.ok = TRUE
  )

  make_template(
    l = list(
      IDENTIFIER = IDENTIFIER,
      # some parts of above HCL are just JSON arrays, so we can just use that
      # below function, sadly, will *not* include linebreaks, so long vectors may not be easily readable
      # but they are valid json
      needs = toTOML(needs),
      uses = uses,
      runs = runs,
      args = toTOML(args),
      env = toTOML(env),
      secrets = toTOML(secrets)
    ),
    template = "action"
  )
}

# make template string from template and list
make_template <- function(l, template) {
  # find path to template, which changes depending on compilation vs source
  path <- system.file("templates", template, package = "ghactions")
  template <- readr::read_file(file = path)
  res <- whisker::whisker.render(
    template = template,
    data = l
  )
  glue::as_glue(res)
}

# little helper to serialise objects into TOML
# below function DOES NOT DO ALL TOML, only this specific subset
# would be nice to use an actual r2toml pkg here, but that seems not to exist
# see https://github.com/maxheld83/ghactions/issues/13
# named lists become name = value pairs
# vectors (named or unnamed) become comma-separated arrays
toTOML <- function(x) {
  res <- glue::double_quote(x)
  if (is.list(x)) {
    res <- purrr::imap(.x = res, .f = function(x, y) {
      glue::glue_collapse(x = c(y, x), sep = " = ")
    })
  } else {
    # below is an ugly hack to avoid trailing comas
    n_with_comas <- length(res) - 1
    if (n_with_comas > 0) {
      res[1:n_with_comas] <- glue::glue('{res[1:n_with_comas]}, ')
    }
  }
  glue::glue_collapse(
    x = res,
    # ugly hack to fix indentation in resulting file
    sep = "\n    "
  )
}


# one workflow ====

# all supported events to trigger gh action from https://developer.github.com/actions/creating-workflows/workflow-configuration-options/#events-supported-in-workflow-files
ghactions_events <- c(
  "check_run",
  "check-suite",
  "commit_comment",
  "create",
  "delete",
  "deployment",
  "deployment_status",
  "fork",
  "gollum",
  "issue_comment",
  "issues",
  "label",
  "member",
  "milestone",
  "page_build",
  "project",
  "project_card",
  "project_column",
  "public",
  "pull_request",
  "pull_request_review_comment",
  "pull_request_review",
  "push",
  "repository_dispatch",
  "release",
  "status",
  "watch"
)

#' @describeIn make_action Create GitHub Actions syntax for one workflow heading.
#'
#' @param on `[character(1)]`
#' giving the [GitHub Event](https://developer.github.com/webhooks/#events) on which to trigger the workflow.
#' Defaults to `"push"`, in which case the workflow is triggered on every push event.
#'
#' @param resolves `[character()]`
#' giving the action(s) to invoke.
#'
#' @export
make_workflow <- function(IDENTIFIER, on = "push", resolves) {
  # input validation ====
  checkmate::assert_string(
    x = IDENTIFIER,
    null.ok = FALSE
  )
  rlang::arg_match(arg = on, values = ghactions_events)
  checkmate::assert_character(
    x = resolves,
    any.missing = FALSE,
    unique = TRUE,  # cannot have two identical dependencies
    null.ok = TRUE
  )

  make_template(
    l = list(
      IDENTIFIER = IDENTIFIER,
      on = on,
      resolves = toTOML(resolves)
    ),
    template = "workflow"
  )
}

make_workflow(IDENTIFIER = "Run calculation", on = "push", resolves = "Simple Addition")
