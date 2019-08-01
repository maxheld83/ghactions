context("actions")

test_that("can override entrypoint", {
  expect_equal(
    object = {
      action2docker(
        l = action(
          IDENTIFIER = "Test",
          uses = "alpine:3.10.1",
          runs = "echo",
          args = "foo"
        ),
      )$stdout
    },
    expected = "foo\n"
  )
})

test_that("fail on error", {
  expect_error(
    action2docker(
      l = action(
        IDENTIFIER = "Test",
        uses = "alpine:3.10.1",
        runs = "sh",
        args = c("-c", "exit 1")
      )
    )
  )
})

test_that("pass on environment arguments", {
  expect_equal(
    object = {
      action2docker(
        l = action(
          IDENTIFIER = "Test",
          uses = "alpine:3.10.1",
          runs = "sh",
          args = c("-c", "echo $BAR"),
          env = list(BAR = "foo", ZAP = "zong")
        ),
      )$stdout
    },
    expected = "foo\n"
  )
})
