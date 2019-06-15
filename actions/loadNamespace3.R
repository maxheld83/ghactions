# this helper is from r-ci, but we want a different location as default
# different name to avoid confusion
source("/loadNamespace2.R")
loadNamespace3 <- function(package, lib.loc = Sys.getenv("R_LIBS_ACTION")) {
  loadNamespace2(package = package, lib.loc = lib.loc)
}
