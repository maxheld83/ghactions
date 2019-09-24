context("deployment")

test_that("example rsync step is correct", {
  expect_known_output(
    object = write_workflow(
      # convenient example known to work
      rsync_fau()
    ),
    file = "workflows/rsync.yml"
  )
})

test_that("example github pages is correct", {
  expect_known_output(
    object = write_workflow(
      # convenient example known to work
      ghpages()
    ),
    file = "workflows/ghpages.yml"
  )
})
