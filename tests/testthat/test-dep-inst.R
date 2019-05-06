test_that("package from DESCRIPTION is installed", {
  expect_silent(object = library(glue))
})
