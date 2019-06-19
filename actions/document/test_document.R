context("document")

test_that(desc = "good docs pass", code = {
  with_blp_repo(
    code = expect_list(hush(source('/entrypoint.R'))),
    path = "good"
  )
})
test_that(desc = "bad docs fail", code = {
  with_blp_repo(
    code = expect_error(hush(source('/entrypoint.R'))),
    path = "bad"
  )
})
