context("action2docker")

test_that("can override entrypoint", {
  expect_equal(
    object = {
      action2docker(
        l = list(
          IDENTIFIER = "Test",
          uses = "alpine:3.10.1",
          runs = c("echo", "foo")
        )
      )$status
    },
    expected = 0
  )
})
