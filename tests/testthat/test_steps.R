context("scripts")

test_that("rscript works", {
  expect_known_output(
    object = write_workflow(
      rscript(expr = c("1+1", "2+2"))
    ),
    file = "workflows/rscript_string.yml"
  )
})


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


context("installation")

test_that("install_deps step is correct", {
  expect_known_output(
    object = write_workflow(
      # convenient example known to work
      install_deps()
    ),
    file = "workflows/install_deps.yml"
  )
})
