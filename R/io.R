#' Reading and writing GitHub Actions workflow files
#'
#' @param x `[list()]`
#' as created by the workflow functions.
#'
#' @family io
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

#' @describeIn io Convert R list to YAML string.
#'
#' @inheritParams write_workflow
r2yaml <- function(x) {
  # writing out and recapturing is a bit weird, but this way yaml is written exactly as in yaml pkg
  utils::capture.output(write_workflow(x))
}


#' @describeIn io Read in *one or more* GitHub Actions workflows from file(s).
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
