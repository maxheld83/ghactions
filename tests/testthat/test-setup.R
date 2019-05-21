test_that("browse works", {
  expect_identical(
    object = browse_github_actions("ghactions"),
    expected = "https://github.com/r-lib/ghactions/actions"
  )
})
