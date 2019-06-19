context("document")

test_that(desc = "equality", code = {
  expect_equal(1, 1)
})


#
# test_that(desc = "good docs pass", code = {
#   with_blp_repo(
#     code = expect_null(hush(document())),
#     path = "test_actions/document/good"
#   )
# })
# test_that(desc = "bad docs fail", code = {
#   with_blp_repo(
#     code = expect_error(hush(document())),
#     path = "test_actions/document/bad"
#   )
# })
