# I/O ====

#' Reading and writing GitHub Actions workflow files
#'
#' @param x `[list()]`
#' as created by the workflow functions.
#'
#' @family syntax
#'
#' @return `[list()]` of lists from yaml.
#'
#' @details
#' It is not necessary to escape characters with special meaning in yaml; the underlying [yaml::write_yaml()] does this automatically.
#'
#' @name io
NULL


#' @describeIn io Write *one* GitHub Actions workflow to file.
#'
#' @inheritParams yaml::write_yaml
write_workflow <- function(x, file = stdout(), ...) {
  yaml::write_yaml(
    x = x,
    file = file,
    # cosmetic change, but github docs are intended
    indent.mapping.sequence = TRUE,
    ...
  )
}


#' @describeIn io Read in *one or more* GitHub Actions workflows from file(s)
#'
#' @param path `[character()]` giving the directory from the repository root where to find GitHub Actions workflows.
#' Defaults to `".github/workflows"`.
#'
#' @export
read_workflows <- function(path = ".github/workflows") {
  usethis::local_project()  # make sure we are in the project dir
  checkmate::assert_directory_exists(x = path)
  # files are relative from root, but oddly, that is what github actions uses as default names
  # so we'll also use the full rel path here at least until https://github.com/r-lib/ghactions/issues/346
  files <- fs::dir_ls(
    path = path,
    recurse = FALSE,
    regexp = ".*\\.(yml|yaml)$"  # can be both!
  )
  if (length(files) == 0) {
    stop(
      "There are no yaml files at ",
      path,
      ". Perhaps GitHub Actions has not been set up?"
    )
  }

  purrr::map(.x = files, .f = read_workflow)
}

#' @describeIn io Read in *one* GitHub Actions workflow from a file.
#'
#' @inheritParams yaml::read_yaml
#'
#' @details
#' If a workflow is *not* `name:`d, the file name will be used as a `name: `, as per the [GitHub Actions documentation](https://help.github.com/en/articles/workflow-syntax-for-github-actions#name).
#'
#' @export
read_workflow <- function(file, ...) {
  x <- yaml::read_yaml(file = file, ...)
  if (is.null(x$name)) {
    x$name <- file
  }
  x
}


# Workflows ====
#' Create nested list for a workflow block.
#'
#' @param name `[character(1)]`
#' giving the [name](https://help.github.com/en/articles/workflow-syntax-for-github-actions#name) of the workflow.
#' Defaults to `NULL`, for no name, in which case GitHub will use the file name.
#'
#' @param on `[character()]`
#' giving the [GitHub Event](https://help.github.com/en/articles/events-that-trigger-workflows) on which to trigger the workflow.
#' Must be a subset of [ghactions_events].
#' Defaults to `"push"`, in which case the workflow is triggered on every push event.
#' Can also be a named list as returned by [on()] for additional filters.
#'
#' @param jobs `[list()]`
#' giving a list of jobs.
#'
#' @examples
#' workflow(
#'   name = "Render",
#'   on = "push",
#'   jobs = NULL
#' )
#'
#' @family syntax
#'
#' @export
workflow <- function(name = NULL, on = "push", jobs = NULL) {
  checkmate::assert_string(x = name, null.ok = TRUE, na.ok = FALSE)
  if (is.character(on)) {
    checkmate::assert_subset(
      x = on,
      choices = ghactions_events,
      empty.ok = FALSE
    )
  } else {
    checkmate::assert_list(
      x = on,
      any.missing = FALSE,
      names = "named"
    )
  }
  checkmate::assert_list(
    x = jobs,
    any.missing = FALSE,
    null.ok = TRUE
  )

  purrr::compact(as.list(environment()))
}


#' Create nested list for an `on:` field.
#'
#' @param event `[character(1)]`
#' giving the event on which to filter.
#' Must be *one* of `c("push", "pull_request", "schedule")`.
#'
#' @param ... `[character()]`
#' giving the filters on which to run
#' Must correspond to the filters allowed by `event`.
#'
#' @details
#' See the [GitHub Actions workflow syntax](https://help.github.com/en/articles/workflow-syntax-for-github-actions) for details.
#'
#' @export
#'
#' @family syntax
#'
#' @examples
#' on(
#'   event = "push",
#'   branches = c("master", "releases/*")
#' )
on <- function(event, ...) {
  checkmate::assert_choice(
    x = event,
    choices = c("push", "pull_request", "schedule")
  )
  rlang::set_names(x = list(purrr::compact(list(...))), nm = event)
}

#' @describeIn filter on push event
#'
#' @param tags,branches,paths `[character()]`
#' giving the [tags, branches](https://help.github.com/en/articles/workflow-syntax-for-github-actions#onpushpull_requesttagsbranches) or [modified paths](https://help.github.com/en/articles/workflow-syntax-for-github-actions#onpushpull_requestpaths) on which to run the workflow.
#' Defaults to `NULL` for no additional filters.
#'
#' @export
on_push <- function(tags = NULL, branches = NULL, paths = NULL) {
  on(event = "push", tags = tags, branches = branches, paths = paths)
}

#' @describeIn filter on pull request
#'
#' @export
on_pull_request <- function(tags = NULL, branches = NULL, paths = NULL) {
  on(event = "pull_request", tags = tags, branches = branches, paths = paths)
}

#' @describeIn filter on schedule
#'
#' @export
on_schedule <- function(cron = NULL) {
  on(event = "schedule", cron = cron)
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
  "check_suite",
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
  "schedule",
  "status",
  "watch"
)


# Actions ====

#' Create GitHub Actions syntax for *one action*
#'
#' Thin wrapper around GitHub actions.
#'
#' @param IDENTIFIER `[character(1)]`
#' Giving the name of the action.
#'
#' Used:
#' - as an informative label on GitHub.com,
#' - in the `needs` fields of other *action blocks* to model the workflow graph,
#' - in the `resolves` fields of other *workflow blocks* to model the workflow graph.
#'
#' @param needs `[character()]`
#' giving the actions (by their `IDENTIFIER`s) that must complete successfully before this action will be invoked.
#' Defaults to `NULL` for no upstream dependencies.
#'
#' @param uses `[character(1)]`
#' giving the Docker image that will run the action.
#'
#' @param runs `[character()]`
#' giving the command to run in the docker image.
#' Overrides the `Dockerfile` `ENTRYPOINT`.
#' Defaults to `NULL` for the default `ENTRYPOINT` (recommended).
#'
#' @param args `[character()]`
#' giving the arguments to pass to the action.
#' Arguments get appended to the last command in `ENTRYPOINT`.
#' Defaults to `NULL` for no arguments.
#'
#' @param env `[list(character(1)]`
#' giving the environment variables to set in the action's runtime environment.
#' Defaults to `NULL` for no environment variables (in addition to the defaults set by GitHub Actions).
#'
#' @param secrets `[character()]`
#' giving the *names* of the secret variables to set in the runtime enviornment, which the action can access as an environment variable.
#' The *values* of secrets must be set in your repository's "Settings" tab.
#' **Do not store secrets in your repository.**
#' GitHub advises against using GitHub actions for production secrets during the public beta period.
#' Defaults to `NULL` for no secrets.
#'
#' @details
#' For details on the syntax and arguments, see [here](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/)
#'
#' These functions are for **advanced users** knowledgeable about GitHub actions.
#' Novice users may be better served by the complete templates in workflows.
#'
#' These functions provide very thin wrappers around existing GitHub actions, including actions from other repositories.
#' Essentially, they just create lists ready to be ingested by [action2hcl()], which then turns these R lists into valid GitHub actions syntax blocks.
#'
#' For documentation on these actions, consult their respective `README.md`s linked in the below.
#' Some variants of these action wrappers include sensible defaults for frequent uses in R.
#'
#' The `uses` field is *always* hardcoded to a particular commit or tag of the underlying github action to ensure compatibility.
#'
#' To render an action block completely from scratch, you can always use the templating function [action()].
#'
#' @examples
#' # many R projects will need this block to first build an image from a DOCKERFILE
#' l <- action(
#'   IDENTIFIER = "Add two numbers",
#'   uses = "rocker/r-ver:3.6.1",
#'   args = "Rscript -e '1+1'"
#' )
#' action2hcl(l = l)
#'
#' @return `[list()]` list of action attributes.
#'
#' @family syntax actions
#'
#' @export
action <- function(IDENTIFIER,
                   needs = NULL,
                   uses,
                   runs = NULL,
                   args = NULL,
                   env = NULL,
                   secrets = NULL) {
  # this might become an S3 constructor helper at some point (hence the name), but OO seems unecessary for now.
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
  checkmate::assert_character(
    x = runs,
    any.missing = FALSE,
    unique = FALSE,
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
  # match.call would be somewhat shorter, but might mess up order and requires eval call
  list(
    IDENTIFIER = IDENTIFIER,
    needs = needs,
    uses = uses,
    runs = runs,
    args = args,
    env = env,
    secrets = secrets
  )
}


#' @describeIn action Convert action to HCL
#'
#' @inherit make_template
#'
#' @export
action2hcl <- function(l) {
  make_template(
    l = list(
      IDENTIFIER = l$IDENTIFIER,
      # some parts of above HCL are just JSON arrays, so we can just use that
      # below function, sadly, will *not* include linebreaks, so long vectors may not be easily readable
      # but they are valid json
      needs = toTOML(l$needs),
      uses = l$uses,
      runs = toTOML(l$runs),
      args = toTOML(l$args),
      env = toTOML(l$env),
      secrets = toTOML(l$secrets)
    ),
    template = "action"
  )
}


#' @describeIn action Construct corresponding `docker run` command for an action.
#' @inherit make_template

#' @inheritDotParams processx::run -command -args
#'
#' @inherit processx::run return
action2docker <- function(l, ...) {
  # prep runtime
  assert_sysdep("docker")
  volumes <- NULL
  if (is_docker() & !(is_github_actions())) {
    # when we're in docker, we don't need a daemon, we can just use the socket of the parent
    # except on github actions, which disallows passing on the socket
    volumes <- c(
      volumes,
      "--volume",
      "/var/run/docker.sock:/var/run/docker.sock"
    )
  } else if (!(is_github_actions())) {
    # weirdly, `is_dockerd()` fails inside GitHub actions
    # but the docker calls still work, unclear why/how
    # maybe github actually *does* pass on the socket already
    if (!is_dockerd()) {
      stop("Docker daemon does not seem to be running.")
    }
  }

  # prepare environment variables
  envs <- NULL
  if (!is.null(l$env)) {
    envs <- c(envs, rbind("--env", paste0(names(l$env), "=", l$env)))
  }
  if (!is.null(l$secrets)) {
    # secrets are propagated as per https://docs.docker.com/engine/reference/run/#env-environment-variables
    envs <- c(envs, rbind("--env ", l$secrets))
  }

  # we're NOT using IDENTIFIER as a container name because that just leads to thorny naming conflicts
  message("Running action: ", l$IDENTIFIER, " ...")

  processx::run(
    command = "docker",
    args = c(
      "run",
      volumes,
      envs,
      l$uses,
      l$runs,
      l$args
    ),
    echo_cmd = TRUE,
    echo = TRUE,
    ...
  )
}


# Conversion workers ====

#' Fill in template
#'
#' @param l `[list()]`
#' giving the named list of HCL fields as returned by [action()] and [workflow()].
#'
#' @param template `[character(1)]`
#' giving the name of the template file.
#'
#' @return `[character()]`
#' of class [glue::glue], giving the syntax for one workflow or action block.
#'
#' @keywords internal
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


#' Serialise objects into TOMLish
#'
#' @param x `[list()]` or `[character()]`
#' giving the objects to be converted to TOML.
#' Named lists become name = value pairs.
#' Vectors (named or unnamed) become comma-separated arrays
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
