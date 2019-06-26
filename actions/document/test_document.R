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
