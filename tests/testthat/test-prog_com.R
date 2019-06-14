# setwd(dir = "tests/testthat/")  # for local testing
# find all test pkgs
test_pkgs <- fs::dir_ls("test_pkgs", type = "directory")
names(test_pkgs) <- fs::path_file(test_pkgs)  # easier names

setup(code = {
  # need to create .git repos in every test_pkgs
  purrr::walk(
    .x = test_pkgs,
    .f = function(x) {
      withr::local_dir(new = x)

      processx::run(
        command = "git",
        args = "init"
      )

      # to commit, we need git user name etc
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
    }
  )
})

context("Programmatic changes")

test_that(desc = "can be detected", code = {
  no_change <- check_clean_tree(
    code = NULL,
    dir = "test_pkgs/good_docs"
  )
  expect_true(object = no_change)
  some_changes <- check_clean_tree(
    code = {
      file.create("foo.bar")
    },
    dir = "test_pkgs/good_docs"
  )
  expect_equal(
    object = some_changes,
    expected = c(
      # TODO would be nicer to test directly for foo, not the message, but that's what the output is
      "The following files were added or modified:\n?? foo.bar"
    )
  )
})

test_that(desc = "unclean working tree before `code` is detected", code = {
  file.create("test_pkgs/before_code/dirt.txt")
  expect_error(
    object = ghactions::check_clean_tree(
      code = NULL,
      dir = "test_pkgs/before_code",
      before_code = "stop"
    )
  )
  expect_true(
    object = ghactions::check_clean_tree(
      code = NULL,
      dir = "test_pkgs/before_code",
      before_code = "stash"
    )
  )
})


test_that(desc = "from roxygen2 work", code = {
  expect_error(
    object = ghactions::document(dir = "test_pkgs/bad_docs/")
  )
  expect_null(
    object = ghactions::document(dir = "test_pkgs/good_docs/")
  )
})

teardown(code = {
  # delete .gits just to be sure
  purrr::walk(
    .x = fs::path(test_pkgs, ".git"),
    .f = fs::file_delete
  )
  file.remove("test_pkgs/before_code/dirt.txt")
})
