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
      needs = jsonlite::toJSON(x = needs),
      uses = uses,
      runs = runs,
      args = jsonlite::toJSON(x = args),
      env = glue::glue_collapse(x = toTOML(l = env), sep = "\n    "),
      secrets = jsonlite::toJSON(x = secrets)
    )
  )
}

# little helper to serialise named lists into TOML
# below function DOES NOT DO ALL TOML, only this specific subset
# would be nice to use an actual r2toml pkg here, but that seems not to exist
toTOML <- function(l) {
  res <- glue::double_quote(l)
  res <- purrr::imap(.x = res, .f = function(x, y) {
    glue::glue_collapse(x = c(y, x), sep = " = ")
  })
  res
}

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
