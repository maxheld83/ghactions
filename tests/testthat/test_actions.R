context("actions: document")

test_that(desc = "good docs pass", code = {
  with_blp_repo(
    code = expect_null(document()),
    path = "test_actions/document/good"
  )
})
test_that(desc = "missing docs fail", code = {
  with_blp_repo(
    code = expect_error(document()),
    path = "test_actions/document/bad"
  )
})
