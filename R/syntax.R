#' @title Create GitHub Actions syntax blocks
#'
#' @description
#' Creates the syntax building blocks for GitHub actions: workflows and actions.
#' For details on the syntax and arguments, see [here](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/).
#'
#' @param IDENTIFIER `[character(1)]`
#' giving the name of the action or workflow block.
#' Used:
#' - as informative label on GitHub.com,
#' - in the `needs` fields of other *action blocks* to express dependencies.
#' - in the `resolves` fields of other *workflow blocks* to express dependencies.
#'
#' @return `[character(1)]`
#'
#' @family syntax
#'
#' @name make_blocks
NULL

#' @describeIn make_blocks Create GitHub Actions syntax for *one* workflow block.
#'
#' @param on `[character(1)]`
#' giving the [GitHub Event](https://developer.github.com/webhooks/#events) on which to trigger the workflow.
#' Must be one of [ghactions_events].
#' Defaults to `"push"`, in which case the workflow is triggered on every push event.
#'
#' @param resolves `[character()]`
#' giving the action(s) to invoke.
#'
#' @examples
#' make_workflow_block(
#'   IDENTIFIER = "Run calculation",
#'   on = "push",
#'   resolves = "Simple Addition"
#' )
#'
#' @family syntax
#'
#' @export
make_workflow_block <- function(IDENTIFIER, on = "push", resolves) {
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

  # body ====
  make_template(
    l = list(
      IDENTIFIER = IDENTIFIER,
      on = on,
      resolves = toTOML(resolves)
    ),
    template = "workflow"
  )
}


#' @title Supported events to trigger GitHub actions
#'
#' @description
#' You can trigger GitHub actions from these events.
#' List is taken from [official spec](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/#events-supported-in-workflow-files).
#'
#' @family syntax
#'
#' @examples
#' ghactions_events
#'
#' @export
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


#' @describeIn make_blocks Create GitHub Actions syntax for *one* action block.
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
#' @examples
#' # many R projects will need this block to first build an image from a DOCKERFILE
#' make_action_block(
#'   IDENTIFIER = "Build Image",
#'   uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6",
#'   # this is an external github action, referenced tightly by sha
#'   args = "build --tag=repo:latest ."
#' )
#'
#' make_action_block(
#'   IDENTIFIER = "Simple Addition",
#'   uses = "maxheld83/ghactions/Rscript-byod@master",
#'   needs = "Build Image",
#'   args = "-e '1+1'"
#' )
#'
#' # pasted together, these three blocks make a simple, valid main.workflow file.
#'
#' @family syntax
#'
#' @export
make_action_block <- function(IDENTIFIER,
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

  # body ====
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

#' @title Fill in template
#'
#' @param l `[list()]`
#' giving the named list of HCL fields.
#'
#' @param template `[character(1)]`
#' giving the name of the template file.
#'
#' @return `[character()]`
#' of class [glue::glue], giving the syntax for one workflow or action block.
#'
#' @keywords internal
#'
#' @noRd
make_template <- function(l, template) {
  # find path to template, which changes depending on compilation vs source
  # TODO might use usethis::render_template() here, but that is not exported
  path <- system.file("templates", template, package = "ghactions")
  template <- readr::read_file(file = path)
  res <- whisker::whisker.render(
    template = template,
    data = l
  )
  glue::as_glue(res)
}

#' @title Serialise objects into TOMLish
#'
#' @param x `[list()]` or `[character()]`
#' giving the objects to be converted to TOML.
#' Named lists become name = value pairs.
#' Vectors (named or unnamed) become comma-separated arrays
#'
#'
#' @details
#' Below function *do not do all TOML*, only this specific subset of features.
#' It would be nice to use an actual r2toml pkg here, but that seems not to exist, as per [this issue](https://github.com/maxheld83/ghactions/issues/13).
#'
#' @keywords internal
#'
#' @noRd
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
