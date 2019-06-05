#' Check `git status` for a clean working tree
#'
#' Check whether some code will cause changes to `git status` in the working directory.
#'
#' @param code The code to execute.
#'
#' @param dir The directory *in* which to execute the code.
#' Defaults to [getwd()].
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
check_clean_tree <- function(code, dir = getwd()){
  # input validation
  # TODO might want to check whether code works
  checkmate::assert_directory_exists(dir)
  assert_deps(pkgs = c("gert", "withr"))

  temp_dir <- fs::dir_copy(path = dir, new_path = tempfile())
  withr::local_dir(new = temp_dir)

  # when run locally, there will a git repo already
  # when on github actions, probably not
  # happily git_init only creates a repo when there is none
  gert::git_init()
  # add and commit everything there currently is
  gert::git_add(files = ".")
  gert::git_commit_all(message = "commit status quo")
  # alter the head (or not)
  code

  # TODO actual diffs would be nicer
  # happily this should respect any `.gitignore`
  # TODO might be better to just system call git here, wrapper is limited
  git_status <- gert::git_status()

  if (nrow(git_status) == 0) {
    return(TRUE)
  }

  glue::glue_collapse(
    glue::glue(
      "The following files were added or modified:\n",
      glue::glue_collapse(
        glue::glue("- {git_status$file}"),
        sep = "\n"
      ),
    ),
    sep = "\n"
  )
}
