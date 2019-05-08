test_that("package from DESCRIPTION is installed", {
  expect_equal(
    object = system2(command = "ls", args = "/github/home/lib/R/library", stdout = TRUE),
    expected = "glue"
  )
  expect_silent(object = library(glue))
})
