#' Check whether system dependency is available
#' @noRd
# TODO use something like this from another package (this is duplicated from pensieve)
check_sysdep <- function(x) {
  sys_test <- checkmate::test_character(
    x = Sys.which(x),
    min.chars = 2,
    any.missing = FALSE,
    all.missing = FALSE,
    len = 1,
    null.ok = FALSE
  )
  if (sys_test) {
    return(TRUE)
  } else {
    return(
      glue::glue(
        "Could not find",
        x,
        "system dependency. Try installing it",
        .sep = " "
      )
    )
  }
}
assert_sysdep <- checkmate::makeAssertionFunction(check.fun = check_sysdep)

#' @importFrom pkgload check_suggested
# This is just check_suggested from pkgload with a different default path
check_suggested <- function(package, version = NULL, compare = NA) {
  path <- pkgload::inst("ghactions")
  pkgload::check_suggested(package = package, version = version, compare = compare, path = path)
}


#' Test whether runtime is act
#'
#' Actions run inside of [act](https://github.com/nektos/act) sometimes need to run in slightly different ways.
#'
#' @noRd
is_act <- function() {
  Sys.getenv("GITHUB_ACTOR") == "nektos/act"
}


#' Test whether runtime is docker
#'
#' @noRd
is_docker <- function() {
  cgroup <- fs::path("/", "proc", "1", "cgroup")
  if (fs::file_exists(cgroup)) {
    # cgroup is not a real flat file, but an interface to the kernel
    # cannot easily be read into R, because it does not have a size
    # so we do this with grep
    docker_processes <- processx::run(
      command = "grep",
      args = c("docker\\|lxc", cgroup),
      error_on_status = FALSE
    )$status
    if (docker_processes == 0) {
      return(TRUE)
    }
  }
  FALSE
}
