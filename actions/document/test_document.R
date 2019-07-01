context("document")
if (file.exists("/.dockerenv")) {
  cmd_path <- "/ghactions-source/actions/document/document.R"
} else {
  cmd_path <- paste0(getwd(), "/", "document.R")
}
test_that(desc = "good docs pass", code = {
  with_blp_repo(
    code = expect_equal(
      object = system2(command = cmd_path, stdout = FALSE, stderr = FALSE),
      expected = 0L
    ),
    path = "good"
  )
})
test_that(desc = "bad docs fail", code = {
  with_blp_repo(
    code = expect_equal(
      object = system2(command = cmd_path, stderr = FALSE, stdout = FALSE),
      expected = 1L
    ),
    path = "bad"
  )
})
test_that(desc = "bad docs can be commited", code = {
  with_blp_repo(
    code = {
      system2(
        command = cmd_path,
        args = "--after-code=commit",
        stderr = FALSE,
        stdout = FALSE
      )
      expect_true(object = ghactions:::is_clean(ghactions:::get_git_status()))
      expect_file_exists("man/foo.Rd", info = ghactions:::get_git_status())
    },
    path = "bad"
  )
})
