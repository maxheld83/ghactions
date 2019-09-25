# script ====

#' Create a step to run [utils::Rscript]
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


# deployment ====

#' Create an action step to deploy via [Rsync](https://rsync.samba.org) over SSH
#'
#' Wraps the external [rsync action](https://github.com/maxheld83/rsync/).
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
#' @param src `[character(1)]`
#' giving the source directory, relative path *from* `/github/workspace` **without trailing slash**.
#'
#' @param user `[character(1)]`
#' giving the user at the target `HOST_NAME`.
#'
#' @param dest `[character(1)]`
#' giving the directory from the root of the `HOST_NAME` target to write to.
#'
#' @description
#' **Remember to provide `SSH_PRIVATE_KEY` and `SSH_PUBLIC_KEY` as secrets to the GitHub UI.**.
#'
#' @inheritDotParams step -run -uses
#'
#' @family steps actions
#'
#' @export
rsync <- function(HOST_NAME,
                  HOST_IP,
                  HOST_FINGERPRINT,
                  src,
                  user,
                  dest,
                  `if` = "github.ref == 'refs/heads/master'",
                  env = NULL,
                  with = NULL,
                  ...) {
  # input validation
  purrr::map(
    .x = list(HOST_NAME, HOST_IP, HOST_FINGERPRINT, src, user, dest),
    .f = checkmate::assert_string,
    na.ok = FALSE,
    null.ok = FALSE
  )

  args <- glue::glue(
    "$GITHUB_WORKSPACE/{src}/",  # source
    "{user}@{HOST_NAME}:{dest}",  # target and destination
    .sep = " "
  )

  step(
    uses = "maxheld83/rsync@v0.1.1",
    `if` = `if`,
    env = c(
      env,
      list(
        HOST_NAME = HOST_NAME,
        HOST_IP = HOST_IP,
        HOST_FINGERPRINT = HOST_FINGERPRINT,
        SSH_PRIVATE_KEY = "${{ secrets.SSH_PRIVATE_KEY }}",
        SSH_PUBLIC_KEY = "${{ secrets.SSH_PUBLIC_KEY }}"
      )
    ),
    with = c(
      with,
      list(args = args)
    ),
    ...
  )
}


rsync_fau <- function(src = "_site",
                      dest = "/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource/denkzeug",
                      user = "pfs400wm",
                      ...) {
  rsync(
    HOST_NAME = "karli.rrze.uni-erlangen.de",
    HOST_IP = "131.188.16.138",
    HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4=",
    user = user,
    src = src,
    dest = dest,
    name = "Deploy Website",
    ...
  )
}


#' Create an action step to deploy via [GitHub Pages](https://pages.github.com)
#'
#' Wraps the external [ghpages action](https://github.com/maxheld83/ghpages/).
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
#' @param BUILD_DIR `[character(1)]`
#' giving the path relative from your `/github/workspace` to the directory to be published.
#'
#' @inheritDotParams step -run -uses
#'
#' @family steps actions
#'
#' @export
ghpages <- function(`if` = "github.ref == 'refs/heads/master'",
                    name = "Deploy to GitHub Pages",
                    BUILD_DIR = "_site",
                    ...) {
  checkmate::assert_string(x = BUILD_DIR, na.ok = FALSE, null.ok = FALSE)
  step(
    name = name,
    `if` = `if`,
    uses = "maxheld83/ghpages@v0.2.0",
    env = list(
      BUILD_DIR = BUILD_DIR,
      GH_PAT = "${{ secrets.GH_PAT }}"
    ),
    ...
  )
}


#' Create an action step to deploy to [Netlify](https://www.netlify.com)
#'
#' Wraps the external [netlify cli action](https://github.com/netlify/actions).
#'
#' @description
#' **Remember to provide `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` (optional) as secrets to the GitHub UI.**
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
#'
#' @inheritDotParams step -run -uses
#'
#' @family steps actions
#'
#' @export
netlify <- function(name = "Deploy to Netlify",
                    `if` = "github.ref == 'refs/heads/master'",
                    dir = "_site",
                    prod = TRUE,
                    with = NULL,
                    env = NULL,
                    site,
                    ...) {
  checkmate::assert_string(x = dir, na.ok = FALSE, null.ok = FALSE)
  checkmate::assert_string(x = site, na.ok = FALSE, null.ok = FALSE)
  checkmate::assert_flag(x = prod, na.ok = FALSE, null.ok = FALSE)

  # prepare args
  args <- c(
    glue::glue('--dir {dir}'),
    if (prod) "prod" else NULL,
    glue::glue('--site {site}')
  )

  step(
    name = name,
    `if` = `if`,
    uses = "netlify/actions/cli@645ae7398cf5b912a3fa1eb0b88618301aaa85d0",
    env = c(
      env,
      list(
        NETLIFY_AUTH_TOKEN = "${{ secrets.NETLIFY_AUTH_TOKEN }}",
        NETLIFY_SITE_ID = "${{ secrets.NETLIFY_SITE_ID }}"
      )
    ),
    with = c(
      with,
      list(args = args)
    ),
    ...
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
