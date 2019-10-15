# I/O ====
context("io")

test_that("workflows are read in", {
  workflows <- read_workflows(path = "workflows")
  expect_equal(
    object = workflows$`workflows/named.yml`$name,
    expected = "foo"
  )
  expect_equal(
    object = workflows$`workflows/unnamed.yaml`$name,
    expected = "workflows/unnamed.yaml"
  )
})
