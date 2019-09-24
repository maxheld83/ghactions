context("steps")

test_that("example rsync step is correct", {
  expect_known_output(
    object = write_workflow(
      # convenient example known to work
      rsync_fau()
    ),
    file = "workflows/rsync.yml"
  )
})
