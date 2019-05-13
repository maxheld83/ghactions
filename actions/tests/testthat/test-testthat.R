test_that(
  desc = "testthat works",
  code = {
    succeed()
    expect_failure(expr = fail())
  }
)
