context("install-deps")
# TODO duplication write this out to function
if (file.exists("/.dockerenv")) {
  cmd_path <- "/entrypoint.R"
} else {
  cmd_path <- paste0(getwd(), "/", "entrypoint.R")
}
test_that(desc = "package from good DESCRIPTION is installed", code = {
  setwd("good")
  system2(command = cmd_path, stdout = FALSE, stderr = FALSE)
  expect_equal(
    object = dir(Sys.getenv("R_LIBS_WORKFLOW")),
    expected = "mnormt"
  )
  expect_silent(object = library(mnormt, lib.loc = Sys.getenv("R_LIBS_WORKFLOW")))
  setwd("..")
})
