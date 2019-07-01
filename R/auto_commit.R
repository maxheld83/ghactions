#' Automatically commit changes
#'
#' Automatically commit any changes made be development helper packages.
#'
#' @param after_code `[character(1)]` Giving what happens when the working tree is *unclean after*  `code` is evaluated:
#' - `NULL` to throw an error or
#' - `"commit"` to commit the changes.
#' Defaults to `NULL`, which just thinly wraps [check_clean_tree()].
#'
#' @inheritDotParams check_clean_tree
#'
#' @export
#'
#' @return `[list()]` of lists of git command feedback or `[NULL]` when there were no changes (invisible).
#'
#' @details
#' This function will commit all changes caused by `code` to the repository.
#' Running this in CI/CD can save some time, but can also cause unexpected behavior and pollute the commit history with derivative changes.
auto_commit <- function(after_code = NULL, ...) {
  # input validation
  checkmate::assert_choice(
    x = after_code,
    choices = c("commit"),
    null.ok = TRUE
  )
  if (is.null(after_code)) {
    after_code <- "stop"
  }

  status_after_code <- check_clean_tree(...)
  res <- NULL
  if (isTRUE(status_after_code)) {
    return(invisible(res))
  }

  if (is_push_allowed()) {
    message("Pushing is allowed.")
    # this is nicer than the LAST sha in case there are several programmatic commits
    # all the separate programmatic commits actually fix up the GITHUB_SHA, which is the last "human" commit
    last_SHA <- Sys.getenv("GITHUB_SHA")
  } else {
    message("Pushing is not allowed.")
    # cannot use GITHUB_SHA under these circumstances
    last_SHA <- processx::run(
      command = "git",
      args = c("rev-parse", "HEAD")
    )
    # would be nicer to get this back without trailing newline
    last_SHA <- gsub("[\r\n]", "", last_SHA$stdout)
  }
  message("Fixing up commit", last_SHA)
  switch(
    EXPR = after_code,
    "stop" = {
      stop(status_after_code)
    },
    "commit" = {
      res$add <- processx::run(
        command = "git",
        args = c(
          "add",
          "."
        )
      )
      # bot author would be nice
      user.name <- Sys.getenv("GITHUB_ACTOR")
      user.email <- paste0(user.name, "@users.noreply.github.com")
      res$config <- NULL
      res$config$user.name <- processx::run(
        command = "git",
        args = c(
          "config",
          "user.name",
          user.name
        )
      )
      res$config$user.email <- processx::run(
        command = "git",
        args = c(
          "config",
          "user.email",
          user.email
        )
      )

      res$commit <- processx::run(
        command = "git",
        args = c(
          "commit",
          paste0("--fixup=", last_SHA)
        ),
        echo_cmd = TRUE,
        echo = TRUE
      )
      if (is_push_allowed()) {
        res$push <- processx::run(
          command = "git",
          args = c(
            "push",
            "--set-upstream",
            "origin",
            "HEAD"
          ),
          echo_cmd = TRUE,
          echo = TRUE
        )
      }
    }
  )

  invisible(res)
}

# TODO currently unused, but might still be a good idea to test for this
assert_github_token <- function() {
  if (!has_github_token()) {
    stop("Action needs `GITHUB_TOKEN` as a secret.")
  }
}

is_push_allowed <- function() {
  !testthat::is_testing() & !is_act() & has_github_token()
}

has_github_token <- function() {
  Sys.getenv("GITHUB_TOKEN") != ""
}

#' Check `git status` for a clean working tree
#'
#' Check whether some code will cause changes to `git status` in the working directory.
#'
#' @param code The code to execute.
#' Defaults to `NULL`.
#'
#' @param path The directory in which to execute the code.
#' Defaults to [getwd()].
#'
#' @param before_code `[character(1)]` Giving what happens when the working tree is *already unclean* before `code` is evaluated:
#' - `NULL` (*recommended* default), in which case if `is.act()`, then `"commit"`, otherwise throw an error.
#' - `"stash"` to `git stash push` all changes before, and `git stash pop` them after `code` is run (*not recommended*).
#' - `"commit"` to `git add .; git commit -m "commit to cleanup"` all changes before `code`is run and ` git reset HEAD` them after `code` is run (*not recommended*).
#'
#' @return `[character(1)]` The `git status` results or `TRUE` if no diffs.
#'
#' @details
#' The contents of `path` will be copied to a temporary directory, where a git repository will be initiated and the `code` will be executed.
#' There will never be any changes to `path`.
#' If `path` or its subdirectories contain a `.gitignore`, it will be respected.
#'
#' This function is modelled [checkmate](https://mllg.github.io/checkmate/articles/checkmate.html).
#'
#' @export
#'
#' @keywords internal
#'
#' @rdname auto_commit
check_clean_tree <- function(code = NULL, path = getwd(), before_code = NULL){
  # input validation
  # TODO might want to check whether `code` argument works
  checkmate::assert_directory_exists(path)
  # cannot run without git repo; both act and github actions provision one
  if (!fs::dir_exists(path = fs::path(path, ".git"))) {
    stop("There is no `.git` repository at `path`.")
  }

  # check dependencies
  check_suggested(package = "withr")
  check_suggested(package = "processx")
  assert_sysdep(x = "git")

  withr::local_dir(new = path)

  # before-code =====
  # we might *already* have an unclean tree because of artefacts in `github/workspace` from other actions etc.
  enforce_clean_before(before_code)

  # do work ====
  code

  # after code ====
  status_after_code <- get_git_status()
  if (is_clean(status_after_code)) {
    return(TRUE)
  }
  report_git_status(status_after_code)
}

get_git_status <- function() {
  # happily this should respect any `.gitignore`
  res <- processx::run(
    command = "git",
    args = c(
      "status",
      "--porcelain" # avoid chatty boilerplate from status
    )
  )
  res$stdout
}

is_clean <- function(git_status) {
  # TODO this test feels precarious, find sth better
  if (git_status == "") {
    return(TRUE)
  }
  FALSE
}

report_git_status <- function(git_status) {
  glue::glue_collapse(
    glue::glue(
      "The following files were added or modified:\n",
      glue::glue("{git_status}")
    ),
    sep = "\n"
  )
}

enforce_clean_before <- function(before_code) {
  # input validation
  checkmate::assert_choice(
    x = before_code,
    choices = c("stash", "commit"),
    null.ok = TRUE
  )

  # impute default
  if (is.null(before_code)) {
    if (is_act()) {
      before_code <- "commit"
    } else {
      before_code <- "stop"
    }
  }

  status_before_code <- get_git_status()
  if (is_clean(status_before_code)) {
    return(NULL)
  }
  switch(
    EXPR = before_code,
    "stop" = {
      stop(
        "The working tree was already unclean before running `code`.\n",
        report_git_status(status_before_code)
      )
    },
    "stash" = {
      processx::run(
        command = "git",
        args = c(
          "stash",
          "push",
          "--include-untracked"
        )
      )
      # on.exit needs to happen in parent, not here
      # hack from https://yihui.name/en/2017/12/on-exit-parent/
      do.call(
        what = on.exit,
        args = list(
          substitute(expr = {
            processx::run(
              command = "git",
              args = c(
                "stash",
                "pop"
              )
            )
          }),
          add = TRUE,
          # needs to be run *before* above withr is reversed
          after = FALSE
        ),
        envir = parent.frame()
      )
    },
    "commit" = {
      # gitignoring this stuff does NOT work, because it is possible that one of the changed files would *again* be changed by `code`
      processx::run(
        command = "git",
        args = c(
          "add",
          "."
        )
      )
      # there were some irreproducible/intermittend issues with this
      # maybe try sleep(s)
      processx::run(
        command = "git",
        args = c(
          "commit",
          "-m 'commit to cleanup'"
        )
      )
      # on.exit needs to happen in parent, not here
      # hack from https://yihui.name/en/2017/12/on-exit-parent/
      do.call(
        what = on.exit,
        args = list(
          substitute(expr = {
            processx::run(
              command = "git",
              args = c(
                "reset",
                "HEAD^1"
              )
            )
          }),
          add = TRUE,
          # needs to be run *before* above withr is reversed
          after = FALSE
        ),
        envir = parent.frame()
      )
    }
  )
}
