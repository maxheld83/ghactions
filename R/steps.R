#' Run [utils::Rscript] in a GitHub Actions step
#'
#' Writes the appropriate syntax for a step.
#'
#' @inheritDotParams step -run
#'
#' @inherit utils::Rscript
#'
#' @family steps
#'
#' @export
rscript <- function(options = "--help",
                    expr = NULL,
                    file = NULL,
                    args = NULL,
                    ...) {
  # input validation ====
  checkmate::assert_character(
    x = options,
    pattern = "^[--]",  # options must always start with -- as per RScript docs
    any.missing = FALSE,
    null.ok = TRUE
  )
  if (is.null(file)) {
    checkmate::assert_character(x = expr, any.missing = FALSE, null.ok = TRUE)
  } else {
    checkmate::assert_null(x = expr)  # there can only be expr OR file
    checkmate::assert_file_exists(
      x = file,
      extension = c("r", "R")
    )
  }
  checkmate::assert_character(
    x = args,
    any.missing = FALSE,
    null.ok = TRUE
  )

  # create step ====
  step(
    run = paste(
      "Rscript",
      options,
      glue::glue('-e "{expr}"'),  # becomes empty string when NULL
      file,
      args
    ),
    ...
  )
}


#' @title Create [rsync action](https://github.com/maxheld83/rsync/tree/v0.1.1) to deploy via [Rsync](https://rsync.samba.org) over SSH
#'
#' @param HOST_NAME `[character(1)]`
#' giving the name of the server you wish to deploy to, such as `foo.example.com`.
#'
#' @param HOST_IP `[character(1)]`
#' giving the IP of the server you wish to deploy to, such as `111.111.11.111`.
#'
#' @param HOST_FINGERPRINT `[character(1)]`
#' giving the fingerprint of the server you wish to deploy to, can have different formats.
#'
#' @param SRC `[character(1)]`
#' giving the source directory, relative path *from* `/github/workspace` **without trailing slash**.
#'
#' @param USER `[character(1)]`
#' giving the user at the target `HOST_NAME`.
#'
#' @param DEST `[character(1)]`
#' giving the directory from the root of the `HOST_NAME` target to write to.
#'
#' @description
#' **Remember to provide `SSH_PRIVATE_KEY` and `SSH_PUBLIC_KEY` as secrets to the GitHub UI.**.
#'
#' @inherit action
#'
#' @export
rsync <- function(IDENTIFIER,
                  needs,
                  HOST_NAME,
                  HOST_IP,
                  HOST_FINGERPRINT,
                  SRC,
                  USER,
                  DEST,
                  env = NULL,
                  args = NULL) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "maxheld83/rsync@v0.1.1",
    needs = needs,
    secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
    env = c(
      env, # more envs
      list(
        HOST_NAME = HOST_NAME,
        HOST_IP = HOST_IP,
        HOST_FINGERPRINT = HOST_FINGERPRINT
      )
    ),
    args = c(
      paste0("$GITHUB_WORKSPACE", "/", SRC, "/"),  # source
      glue::glue('{USER}@{HOST_NAME}:{DEST}'),  # target and destination
      args # more args
    )
  )
}

rsync_fau <- purrr::partial(
  IDENTIFIER = "Deploy",
  .f = rsync,
  HOST_NAME = "karli.rrze.uni-erlangen.de",
  HOST_IP = "131.188.16.138",
  HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4=",
  USER = "pfs400wm"
)


#' @title Create [ghpages action](https://github.com/maxheld83/ghpages/tree/v0.2.0) to deploy to [GitHub Pages](https://pages.github.com)
#'
#' @description
#' **Remember to provide a GitHub personal access token secret named `GH_PAT` to the GitHub UI.**
#' 1. Set up a new PAT.
#'    You can use [usethis::browse_github_pat()] to get to the right page.
#'    Remember that this PAT is *not* for your local machine, but for GitHub actions.
#' 2. Copy the PAT to your clipboard.
#' 3. Go to the settings of your repository, and paste the PAT as a secret.
#'    The secret must be called `GH_PAT`.
#'
#' For details, see docs of the [ghpages action](https://github.com/maxheld83/ghpages/tree/v0.2.0).
#'
#' @param BUILD_DIR `[character(1)]`
#' giving the path relative from your `/github/workspace` to the directory to be published.
#'
#' @inherit action
#'
#' @export
ghpages <- function(IDENTIFIER = "Deploy",
                    needs = "Filter master",
                    BUILD_DIR = "_site",
                    env = NULL) {
  usethis::ui_todo(c(
    "Remember to provide `GH_PAT` as a secret to the GitHub UI.",
    "For more information about Personal Access Token (PAT) for ghpages go to {usethis::ui_path('https://github.com/maxheld83/ghpages')}.",
    "See {usethis::ui_code('usethis::browse_github_pat()')} for help setting this up."
  ))
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "maxheld83/ghpages@v0.2.0",
    needs = needs,
    secrets = "GH_PAT",
    env = c(
      env,
      list(
        BUILD_DIR = BUILD_DIR
      )
    )
  )
}

#' @title Create [netlify cli action](https://github.com/netlify/actions/tree/645ae7398cf5b912a3fa1eb0b88618301aaa85d0/cli/) to use the [Netlify CLI](https://www.netlify.com)
#'
#' @description
#' **Remember to provide `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` (optional) as secrets to the GitHub UI.**
#'
#' @inherit action
#'
#' @export
netlify <- function(IDENTIFIER,
                    needs,
                    args) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "netlify/actions/cli@645ae7398cf5b912a3fa1eb0b88618301aaa85d0",
    needs = needs,
    args = args,
    secrets = c("NETLIFY_AUTH_TOKEN", "NETLIFY_SITE_ID")
  )
}

#' @describeIn netlify Deploy to netlify
#'
#' @param dir `[character(1)]`
#' giving the path relative from your `/github/workspace` to the directory to be published.
#'
#' @param prod `[logical(1)]`
#' giving whether the deploy should be to production.
#'
#' @param site `[character(1)]`
#' giving a site ID to deploy to.
#'
#' @export
netlify_deploy <- function(IDENTIFIER = "Deploy",
                           needs,
                           dir,
                           prod = TRUE,
                           site = NULL) {
  netlify(
    IDENTIFIER = IDENTIFIER,
    needs = needs,
    args = c(
      glue::glue('--dir {dir}'),
      if (prod) "prod" else NULL,
      glue::glue('--site {site}')
    )
  )
}

#' @title Create [Google Firebase CLI action](https://github.com/w9jds/firebase-action) to use [Firebase](http://firebase.google.com)
#'
#' @description
#' **Remember to provide `FIREBASE_TOKEN` as a secret to the GitHub UI.**
#'
#' @inherit action
#'
#' @param PROJECT_ID `[character(1)]`
#' giving a specific project to use for all commands, not required if you specify a project in your `.firebaserc`` file.
#'
#' @export
firebase <- function(IDENTIFIER,
                     needs,
                     args,
                     PROJECT_ID = NULL) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "w9jds/firebase-action@v1.0.1",
    needs = needs,
    args = args,
    secrets = c("FIREBASE_TOKEN"),
    env = list(
      PROJECT_ID = PROJECT_ID
    )
  )
}

#' @describeIn firebase Deploy static assets to Firebase Hosting
#'
#' @description
#' Configuration details other than `PROJECT_ID` are read from the `firebase.json` at the root of your repository.
#'
#' @details
#' Because firebase gets the deploy directory from a `firebase.json` file, it cannot automatically find the appropriate path.
#' Manually edit your `firebase.json` to provide the deploy path.
# tracked in https://github.com/maxheld83/ghactions/issues/80
#'
#' @export
firebase_deploy <- function(IDENTIFIER = "Deploy",
                            needs,
                            PROJECT_ID = NULL) {
  firebase(
    IDENTIFIER = IDENTIFIER,
    needs = needs,
    args = "deploy --only hosting",
    PROJECT_ID = PROJECT_ID
  )
}

# TODO this duplicates material from the README.md and man of the action https://github.com/r-lib/ghactions/issues/180
#' @title Install Dependencies
#'
#' @description
#' This GitHub action installs R package dependencies from a `DESCRIPTION` at the repository root.
#'
#' @inherit action
#'
#' @export
install_deps <- function(IDENTIFIER = "Install Dependencies",
                         needs = NULL) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "r-lib/ghactions/actions/install-deps@v0.4.1",
    needs = needs
  )
}

#' @title Document Package
#'
#' @description
#' This GitHub action installs R package dependencies from a `DESCRIPTION` at the repository root.
#'
#' @inherit action
#'
#' @export
document <- function(IDENTIFIER = "Document Package",
                     needs = NULL,
                     args = NULL) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "r-lib/ghactions/actions/document@v0.4.1",
    needs = needs,
    args = args,
    secrets = "GITHUB_TOKEN"
  )
}
