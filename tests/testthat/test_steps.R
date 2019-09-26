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
      rsync_fau(
        dest = "/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource/denkzeug"
      )
    ),
    file = "workflows/rsync.yml"
  )
})

test_that("example github pages is correct", {
  expect_known_output(
    object = write_workflow(
      ghpages()
    ),
    file = "workflows/ghpages.yml"
  )
})


context("installation")

test_that("install_deps step is correct", {
  expect_known_output(
    object = write_workflow(
      install_deps()
    ),
    file = "workflows/install_deps.yml"
  )
})


context("pkg dev")

test_that("rcmd check step is correct", {
  expect_known_output(
    object = write_workflow(
      x = rcmd_check()
    ),
    file = "workflows/rcmdcheck.yml"
  )
})

test_that("covr step is correct", {
  expect_known_output(
    object = write_workflow(
      x = covr()
    ),
    file = "workflows/covr.yml"
  )
})
