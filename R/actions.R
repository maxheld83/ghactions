#' @title R wrappers around GitHub actions
#'
#' @description
#' These functions are for **advanced users** knowledgeable about GitHub actions.
#' Novice users may be better served by the complete templates in workflows.
#'
#' These functions provide very thin wrappers around existing GitHub actions, including actions from other repositories.
#' For documentation on these actions, consult their respective `README.md`s linked in the below.
#' Some of these action wrappers include sensible defaults for most uses in R.
#' You can always create action blocks entirely from scratch using [make_action_block()].
#'
#' The `uses` field is always hardcoded to a particular commit or tag of the underlying github action to ensure.
#'
#' @inheritParams make_action_block
#'
#' @family actions
#'
#' @name actions
NULL

#' @describeIn actions [Docker CLI](https://github.com/actions/docker/tree/aea64bb1b97c42fa69b90523667fef56b90d7cff)
#' @export
docker_cli <- function(IDENTIFIER = "Build Image",
                       args = "build --tag=repo:latest .") {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "actions/docker/cli@aea64bb1b97c42fa69b90523667fef56b90d7cff",
    args = args
  )
}

#' @describeIn actions [Rscript-byod](https://github.com/maxheld83/ghactions/tree/master/Rscript-byod)
#' @export
rscript_byod <- function(IDENTIFIER = "Arbitrary Rscript",
                         needs,
                         args) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "maxheld83/ghactions/Rscript-byod@master",
    # this actually does *not* need a harder dependency, because it is versioned in this repo
    needs = needs,
    args = args)
}

#' @describeIn actions [filter](https://github.com/actions/bin/tree/a9036ccda9df39c6ca7e1057bc4ef93709adca5f/filter)
#' @export
filter <- function(IDENTIFIER = "Filter",
                   needs,
                   args = "branch master") {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "actions/bin/filter@a9036ccda9df39c6ca7e1057bc4ef93709adca5f",
    needs = needs,
    args = args
  )
}

#' @describeIn actions [rsync](https://github.com/maxheld83/rsync/tree/v0.1.1)
#' @export
rsync <- function(IDENTIFIER = "Rsync",
                  needs,
                  env,
                  args) {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "maxheld83/rsync@v0.1.1",
    needs = needs,
    secrets = c("SSH_PRIVATE_KEY", "SSH_PUBLIC_KEY"),
    env = env,
    args = args
  )
}

#' @describeIn actions [ghpages](https://github.com/maxheld83/ghpages/tree/v0.1.2)
#' @export
ghpages <- function(IDENTIFIER = "Deploy to GitHub Pages",
                    needs,
                    env = "BUILD_DIR = 'public/'") {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "maxheld83/ghpages@v0.1.2",
    needs = needs,
    secrets = "GH_PAT",
    env = env
  )
}

#' @describeIn actions [netlify](https://github.com/netlify/actions/tree/645ae7398cf5b912a3fa1eb0b88618301aaa85d0/cli/)
#' @export
netlify <- function(IDENTIFIER = "Deploy to Netlify",
                    needs,
                    args = "deploy --dir=site --functions=functions") {
  list(
    IDENTIFIER = IDENTIFIER,
    uses = "netlify/actions/cli@645ae7398cf5b912a3fa1eb0b88618301aaa85d0",
    needs = needs,
    secrets = c("NETLIFY_AUTH_TOKEN", "NETLIFY_SITE_ID")
  )
}
