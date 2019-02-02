make_ghaction <- function(IDENTIFIER,
                          needs = NULL,
                          uses,
                          runs = NULL,
                          args = NULL,
                          env = NULL,
                          secrets = NULL) {
  # input validation ====
  # all of this is as per the gh action spec https://developer.github.com/actions/creating-workflows/workflow-configuration-options/
  checkmate::assert_string(
    x = IDENTIFIER,
    null.ok = FALSE
  )
  checkmate::assert_character(
    x = needs,
    any.missing = FALSE,
    unique = TRUE,  # cannot have two identical dependencies
    null.ok = TRUE
  )
  checkmate::assert_string(
    x = uses,
    null.ok = FALSE
    # we don't run extra checks here; that's a job for the ghaction parser
  )
  checkmate::assert_string(
    x = runs,
    null.ok = TRUE
  )
  checkmate::assert_character(
    x = args,
    any.missing = FALSE,
    unique = FALSE,
    null.ok = TRUE
  )
  checkmate::assert_list(
    x = env,
    types = "character",
    # TODO env can only be scalars, not sure whether anything else is possible
    any.missing = FALSE,
    names = "named",
    null.ok = TRUE
  )
  checkmate::assert_character(
    x = secrets,
    any.missing = FALSE,
    unique = TRUE,
    null.ok = TRUE
  )

  template <- readr::read_file(file = "inst/templates/action")
  whisker::whisker.render(
    template = template,
    data = list(
      IDENTIFIER = IDENTIFIER,
      # some parts of above HCL are just JSON arrays, so we can just use that
      # below function, sadly, will *not* include linebreaks, so long vectors may not be easily readable
      # but they are valid json
      needs = toTOML(needs),
      uses = uses,
      runs = runs,
      args = toTOML(args),
      env = toTOML(env),
      secrets = toTOML(secrets)
    )
  )
}

# little helper to serialise objects into TOML
# below function DOES NOT DO ALL TOML, only this specific subset
# would be nice to use an actual r2toml pkg here, but that seems not to exist
# see https://github.com/maxheld83/ghactions/issues/13
# named lists become name = value pairs
# vectors (named or unnamed) become comma-separated arrays
toTOML <- function(x) {
  res <- glue::double_quote(x)
  if (is.list(x)) {
    res <- purrr::imap(.x = res, .f = function(x, y) {
      glue::glue_collapse(x = c(y, x), sep = " = ")
    })
  } else {
    # below is an ugly hack to avoid trailing comas
    n_with_comas <- length(res) - 1
    if (n_with_comas > 0) {
      res[1:n_with_comas] <- glue::glue('{res[1:n_with_comas]}, ')
    }
  }
  glue::glue_collapse(
    x = res,
    # ugly hack to fix indentation in resulting file
    sep = "\n    "
  )
}

# test case
make_ghaction(
  IDENTIFIER = "Deploy with rsync",
  uses = "./",
  needs = "Write sha",
  secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
  env = list(
    HOST_NAME = "karli.rrze.uni-erlangen.de",
    HOST_IP = "131.188.16.138",
    HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4="
  ),
  runs = "zap",
  args = c(
    "$GITHUB_WORKSPACE/index.html",
    "pfs400wm@$HOST_NAME:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource/ghaction-rsync")
)
