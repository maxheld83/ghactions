# Workflows ====
#' Create nested list for a [workflow block](https://help.github.com/en/articles/workflow-syntax-for-github-actions)
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
#' giving a *named* list of jobs, with each list element as returned by [job()].
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
    null.ok = TRUE,
    names = "unique"
  )

  purrr::compact(as.list(environment()))
}


#' Create nested list for an `on:` field
#'
#' @param event `[character(1)]`
#' giving the event on which to filter.
#' Must be *one* of `c("push", "pull_request", "schedule")`.
#'
#' @param ... `[character()]`
#' giving the filters on which to run.
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

#' @describeIn on filter on push event
#'
#' @param tags,branches,paths `[character()]`
#' giving the [tags, branches](https://help.github.com/en/articles/workflow-syntax-for-github-actions#onpushpull_requesttagsbranches) or [modified paths](https://help.github.com/en/articles/workflow-syntax-for-github-actions#onpushpull_requestpaths) on which to run the workflow.
#' Defaults to `NULL` for no additional filters.
#'
#' @export
on_push <- function(tags = NULL, branches = NULL, paths = NULL) {
  on(event = "push", tags = tags, branches = branches, paths = paths)
}

#' @describeIn on filter on pull request
#'
#' @export
on_pull_request <- function(tags = NULL, branches = NULL, paths = NULL) {
  on(event = "pull_request", tags = tags, branches = branches, paths = paths)
}

#' @describeIn on filter on schedule
#'
#' @param cron `[character(1)]`
#' giving UTC times using [POSIX cron syntax](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07).
#'
#' @export
on_schedule <- function(cron = NULL) {
  on(event = "schedule", cron = cron)
}


#' Supported events to trigger GitHub actions
#'
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


# Jobs ====

#' Create nested list for *one* [job](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobs)
#'
#' @param id,name `[character(1)]`
#' giving additional options for the job.
#' Defaults to `NULL`.
#'
#' @param needs `[character()]`
#' giving the jobs that must complete successfully before this job is run.
#' Defaults to `NULL` for no dependencies.
#'
#' @param runs_on `[character(1)]`
#' giving the type of virtual host machine to run the job on.
#' Defaults to `"ubuntu-18.04"`.
#' Must be one of [ghactions_vms].
#'
#' @param steps `[list()]`
#' giving an *unnamed* list of steps, with each element as returned by [step()].
#' Defaults to `NULL`.
#'
#' @param timeout_minutes `[integer(1)]`
#' giving the maximum number of minutes to let a workflow run before GitHub automatically cancels it.
#' Defaults to `NULL`.
#'
#' @param strategy `[list()]`
#' giving a named list as returned by [strategy()].
#' Defaults to `NULL`.
#'
#' @param container `[character(1)]`/`[list()]`
#' giving a published container image.
#' For advanced options, use [container()].
#' Defaults to `NULL`.
#'
#' @param services `[list()]`
#' giving additional containers to host services for a job in a workflow in a *named* list.
#' Use [container()] to construct the list elements.
#' Defaults to `NULL`.
#'
#' @family syntax
#'
#' @export
job <- function(id,
                name = NULL,
                needs = NULL,
                runs_on = "ubuntu-18.04",
                steps = NULL,
                timeout_minutes = NULL,
                strategy = NULL,
                container = NULL,
                services = NULL) {
  checkmate::assert_string(x = id, na.ok = FALSE)
  checkmate::assert_string(x = name, na.ok = FALSE, null.ok = TRUE)
  checkmate::assert_character(
    x = needs,
    any.missing = FALSE,
    unique = TRUE,
    null.ok = TRUE
  )
  checkmate::assert_choice(
    x = runs_on,
    choices = ghactions_vms,
    null.ok = FALSE
  )
  checkmate::assert_list(
    x = steps,
    null.ok = TRUE,
    names = "unnamed"
  )
  checkmate::assert_scalar(
    x = timeout_minutes,
    na.ok = FALSE,
    null.ok = TRUE
  )
  checkmate::assert_list(
    x = strategy,
    any.missing = FALSE,
    names = "unique",
    null.ok = TRUE
  )
  if (is.character(container)) {
    checkmate::assert_string(x = container, na.ok = FALSE, null.ok = TRUE)
  } else {
    checkmate::assert_list(
      x = container,
      any.missing = FALSE,
      null.ok = TRUE,
      names = "unique"
    )
  }
  checkmate::assert_list(
    x = services,
    any.missing = FALSE,
    null.ok = TRUE,
    names = "unique"
  )

  res <- as.list(environment())
  res$id <- NULL  # that's the name of the list, not *in* the list
  res <- purrr::compact(res)
  rlang::set_names(x = list(res), nm = id)
}


#' Create nested list for the [strategy](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobsjob_idstrategy) field in [job()]
#'
#' @param matrix `[list(list(c()))]`
#' giving the values for each variable for the matrix build.
#' See [gh_matrix()] for additional options.
#' Defaults to `NULL`.
#'
#' @param fail-fast `[logical()]`
#' giving whether GitHub should cancel all in-progress jobs if any matrix job fails.
#' Defaults to `NULL`.
#'
#' @param max-parallel `[integer(1)]`
#' giving the maximum number of jobs to run simultaneously when using a matrix job strategy.
#'
#' @family syntax
#'
#' @export
strategy <- function(matrix = NULL, `fail-fast` = NULL, `max-parallel` = NULL) {
  checkmate::assert_list(
    x = matrix,
    types = "atomicvector",
    any.missing = FALSE,
    names = "unique",
    null.ok = TRUE
  )
  checkmate::assert_flag(
    x = `fail-fast`,
    na.ok = FALSE,
    null.ok = TRUE
  )
  checkmate::assert_scalar(
    x = `max-parallel`,
    na.ok = FALSE,
    null.ok = TRUE
  )

  purrr::compact(as.list(environment()))
}


#' Create nested list for the [matrix](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobsjob_idstrategy) field in [strategy()]
#'
#' @param ... `[character()]`
#' giving values for variable for the matrix build.
#'
#' @param exclude,include `[list(list(character(1)))]`
#' giving unnamed lists of combinations of variables to ex- or include.
#' Defaults to `NULL`.
#'
#' @export
#'
#' @family syntax
gh_matrix <- function(..., exclude = NULL, include = NULL) {
  checkmate::assert_list(
    x = exclude,
    types = "character",
    any.missing = FALSE,
    names = "unnamed",
    null.ok = TRUE
  )

  purrr::compact(c(list(...), as.list(environment())))
}


#' Create nested list for the [container](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobsjob_idcontainer) field in [job()]
#'
#' @param image `[character(1)]`
#' giving the published docker image to use as the container to run the action.
#'

#' @param env `[list()]`
#' giving environment variables for the container as a *named* list.
#' Defaults to `NULL`.
#'
#' @param ports,volumes `[list()]`
#' giving ports to expose, and volumes for the container to use as an *unnamed* list.
#' Defaults to `NULL`.
#'
#' @param options `[character()]`
#' giving additional options.
#' Defaults to `NULL`.
#'
#' @family syntax
#'
#' @export
container <- function(image,
                      env = NULL,
                      ports = NULL,
                      volumes = NULL,
                      options = NULL) {
  checkmate::assert_string(x = image, na.ok = FALSE)
  checkmate::assert_list(
    x = env,
    types = "atomicvector",
    any.missing = FALSE,
    names = "unique",
    null.ok = TRUE
  )
  purrr::walk(
    .x = list(ports, volumes),
    .f = checkmate::assert_list,
    any.missing = FALSE,
    null.ok = TRUE,
    names = "unnamed"
  )
  checkmate::assert_character(x = options, null.ok = TRUE)

  purrr::compact(as.list(environment()))
}


#' @title Virtual machines [available](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobsjob_idruns-on) on GitHub Actions
#'
#' @family syntax
#'
#' @examples
#' ghactions_vms
#'
#' @export
ghactions_vms <- c(
  "ubuntu-latest",
  "ubuntu-18.04",
  "ubuntu-16.04",
  "windows-latest",
  "windows-2019",
  "windows-2016",
  "macOS-latest",
  "macOS-10.14"
)


# Steps ====

#' Create nested list for *one* [job](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobs)
#'
#' @param id,if,name,uses,shell `[character(1)]`
#' giving additional options for the step.
#' Multiline strings are not supported.
#' Defaults to `NULL`.
#'
#' @param run `[character()]`
#' giving commands to run.
#' Will be turned into a multiline string.
#' Defaults to `NULL`.
#'
#' @param with,env `[list()]`
#' giving a named list of additional parameters.
#' Defaults to `NULL`.
#'
#' @param working-directory `[character(1)]`
#' giving the default working directory.
#' Defaults to `NULL`.
#'
#' @param continue-on-error `[logical(1)]`
#' giving whether to allow a job to pass when this step fails.
#' Defaults to `NULL`.
#'
#' @param timeout-minutes `[integer(1)]`
#' giving the maximum number of minutes to run the step before killing the process.
#' Defaults to `NULL`.
#'
#' @family syntax
#'
#' @export
step <- function(name = NULL,
                 id = NULL,
                 `if` = NULL,
                 uses = NULL,
                 run = NULL,
                 shell = NULL,
                 with = NULL,
                 env = NULL,
                 `working-directory` = NULL,
                 `continue-on-error` = NULL,
                 `timeout-minutes` = NULL) {
  purrr::walk(
    .x = list(id, `if`, name, uses, shell, `working-directory`),
    .f = checkmate::assert_string,
    na.ok = FALSE,
    null.ok = TRUE
  )
  checkmate::assert_character(x = run, any.missing = FALSE, null.ok = TRUE)
  purrr::walk(
    .x = list(with, env),
    .f = checkmate::assert_list,
    any.missing = FALSE,
    null.ok = TRUE,
    names = "unique"
  )
  checkmate::assert_flag(x = `continue-on-error`, na.ok = FALSE, null.ok = TRUE)
  checkmate::assert_scalar(x = `timeout-minutes`, na.ok = FALSE, null.ok = TRUE)

  # linebreaks for run
  run <- glue::glue_collapse(x = run, sep = "\n", last = "\n")

  purrr::compact(as.list(environment()))
}
