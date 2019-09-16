#' Quickly set up test repos
#'
#' Helpful for testing
#'
#' @noRd
set_blank_repo <- function(path = "test_repo") {
  fs::dir_create(path = path)
  setwd(path)
  init_repo()
  invisible(path)
}
reset_blank_repo <- function(path) {
  setwd("..")
  fs::dir_delete(path = path)
}
with_blank_repo <- withr::with_(
  set = set_blank_repo,
  reset = reset_blank_repo,
  new = FALSE
)
# blp = boilerplate, such as the existing "bad"/"good" folders
set_blp_repo <- function(path) {
  old <- NULL
  old$path <- path
  old$wd <- getwd()
  temp <- fs::path_temp(path)
  # avoid reusing old temp
  if (fs::dir_exists(temp)) {
    fs::dir_delete(temp)
  }
  fs::dir_copy(path = path, new_path = temp, overwrite = TRUE)
  old$content <- temp
  setwd(path)
  init_repo()
  invisible(old)
}
reset_blp_repo <- function(old) {
  setwd(old$wd)
  fs::dir_delete(old$path)
  fs::dir_copy(path = old$content, new_path = old$path)
}
with_blp_repo <- withr::with_(
  set = set_blp_repo,
  reset = reset_blp_repo,
  new = FALSE
)


init_repo <- function() {
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
  processx::run(
    command = "git",
    args = c(
      "config",
      "commit.gpgsign",
      "false"
    )
  )
  # git init causes an unrealistic scenario of a 0-commit repo
  # in real life, we will always already have commits
  if (length(fs::dir_ls()) == 0) {
    # if there are no files, make some
    fs::file_create(path = "touch")
  }
  processx::run(
    command = "git",
    args = c("add", ".")
  )
  processx::run(
    command = "git",
    args = c(
      "commit",
      "-m 'initial commit'"
    ),
    echo = TRUE
  )
}

hush <- function(code) {
  withr::with_output_sink(
    new = "/dev/null",
    code = code
  )
}
