test_that("package from DESCRIPTION is installed", {
  expect_silent(object = library(glue))
  expect_equal(
    object = system2(command = "ls", args = "/githubs/home/lib/R/library", stdout = TRUE),
    expected = "glue"
  )
})
