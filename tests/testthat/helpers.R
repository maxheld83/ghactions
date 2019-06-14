#' Quickly set up test repos
#'
#' Helpful for testing
#'
#' @noRd
set_repo <- function(path = "test_repo") {
  fs::dir_create(path = path)
  setwd(path)

  processx::run(
    command = "git",
    args = "init"
  )

  processx::run(
    command = "git",
    args = c(
      "config",
      "--replace-all",
      "user.name",
      "ghactions test"
    )
  )
  processx::run(
    command = "git",
    args = c(
      "config",
      "--replace-all",
      "user.email",
      "test@8450984753847504asdasdasd.com"
    )
  )

  # git init is causes an unrealistic scenario of a 0-commit repo
  # in real life ,we will always already have commits
  fs::file_create(path = "touch")
  processx::run(
    command = "git",
    args = c("add", ".")
  )
  processx::run(
    command = "git",
    args = c(
      "commit",
      "-m 'initial commit'"
    )
  )

  invisible(path)
}

reset_repo <- function(path) {
  setwd("..")
  fs::dir_delete(path = path)
}

with_repo <- withr::with_(
  set = set_repo,
  reset = reset_repo,
  new = FALSE
)
