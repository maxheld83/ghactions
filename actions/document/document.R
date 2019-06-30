#!/usr/bin/env Rscript

source_root <- NULL
# bad hack to make local debugging easier #269
if (getwd() == "/Users/max/GitHub/ghactions/actions/document") {
  source_root <- "../../"
} else if (getwd() != "/Users/max/GitHub/ghactions") {
  source_root <- "/ghactions-source/"

  source(file = "/loadNamespace3.R")
  loadNamespace3(package = "brew")
  loadNamespace3(package = "roxygen2")
  loadNamespace3(package = "ghactions")
  loadNamespace3(package = "checkmate")
  loadNamespace3(package = "withr")
  loadNamespace3(package = "fs")
  loadNamespace3(package = "devtools")

  loadNamespace3(package = "docopt")
  loadNamespace3(package = "readr")
}

arguments <- docopt::docopt(
  doc = readr::read_file(paste0(source_root, "actions/document/man")),
  help = TRUE,
  strip_names = TRUE
)

message("Checking for consistency of roxygen2 with `man` ...")

res <- ghactions::auto_commit(
  after_code = arguments$`--after-code`,
  code = {
    devtools::document()
  },
  path = ".",
  before_code = arguments$`--before-code`
)
print(res)
