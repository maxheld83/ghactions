#' Check `git status` for a clean working tree
#'
#' Check whether some code will cause changes to `git status` in the working directory.
#'
#' @param code The code to execute.
#'
#' @param dir The directory *in* which to execute the code.
#' Defaults to [getwd()].
#'
#' @param stash `[logical(1)]`
#' Giving what happens when the working tree is *already unclean* before `code` is evaluated.
#' If `TRUE`, all stages are `git stash push`ed before, and `git stash apply`ed after the run; might fail in unexpected ways.
#' If `FALSE` (recommended default), an error is thrown when the working tree is unclean ex-ante.
#'
#' @return `[character(1)]` The `git status` results or `TRUE` if no diffs.
#'
#' @details
#' The contents of `dir` will be copied to a temporary directory, where a git repository will be initiated and the `code` will be executed.
#' There will never be any changes to `dir`.
#' If `dir` or its subdirectories contain a `.gitignore`, it will be respected.
#'
#' This function is modelled [checkmate](https://mllg.github.io/checkmate/articles/checkmate.html).
#'
#' @export
#'
#' @keywords internal
#' @family prog_com
check_clean_tree <- function(code, dir = getwd(), stash = FALSE){
  # input validation
  # TODO might want to check whether `code` argument works
  checkmate::assert_directory_exists(dir)
  check_suggested(package = "withr")
  check_suggested(package = "processx")
  assert_sysdep(x = "git")

  # hypothesis: there is always a git repo already
  # actions runs `git clone` to get the repo to `github/workspace`
  # local usage has a git repo anyway
  # hopefully act also does this
  # so let's check this
  if (!fs::dir_exists(path = fs::path(dir, ".git"))) {
    stop("There is no `.git` repository at `dir`.")
  }

  # move to temp_dr so as to never muck of the working directory
  temp_dir <- fs::dir_copy(path = dir, new_path = tempfile())
  withr::local_dir(new = temp_dir)

  # ex-ante =====
  # we might *already* have an unclean tree because of artefacts in `github/workspace` from other actions etc.

  # TODO this test feels precarious, find sth better
  status_ex_ante <- git_status()
  if (status_ex_ante == "") {
    changed <- FALSE
  } else {
    changed <- TRUE
  }

  if (stash & changed) {
    processx::run(
      command = "git",
      args = c(
        "stash",
        "push",
        "--include-untracked"
      )
    )
    # TODO would be nice to pop the stash again using on.exit, but that causes more complexity if there is NO stash
  } else {
    if (changed) {
      stop(
        "There is already an unclean working tree ex-ante.\n",
        report_git_status(status_ex_ante)
      )
    }
  }

  # do work ====
  # this will make the working tree unclean again (or not)
  code

  # ex-post ====
  # TODO this test feels precarious, find sth better
  status_ex_post <- git_status()
  if (status_ex_post == "") {
    return(TRUE)
  }

  report_git_status(status_ex_post)
}

git_status <- function() {
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

report_git_status <- function(git_status) {
  glue::glue_collapse(
    glue::glue(
      "The following files were added or modified:\n",
      glue::glue("{git_status}")
    ),
    sep = "\n"
  )
}

#' @rdname check_clean_tree
#' @inheritParams checkmate::makeAssertion
#' @export
assert_clean_tree <- checkmate::makeAssertionFunction(check.fun = check_clean_tree)

#' Roxygenize package and check for inconsistencies
#'
#' Runs [devtools::document()] and checks whether there are any differences to the working tree.
#'
#' @inheritParams check_clean_tree
#'
#' @export
#'
#' @keywords internal
#' @family prog_com
document <- function(dir = getwd()) {
  check_suggested(package = "devtools")
  assert_clean_tree(
    code = {
      devtools::document()
    },
    dir = dir
  )
}
